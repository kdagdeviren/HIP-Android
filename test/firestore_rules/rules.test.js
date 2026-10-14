/**
 * Security rule tests for firestore.rules.
 *
 * These run against the Firestore emulator, never a real project:
 *   cd test/firestore_rules
 *   npm install
 *   npm run test:emulator
 *
 * Each test states an access decision the rules are supposed to make. A failure
 * here means the deployed rules would let data through, or block legitimate use.
 */

'use strict';

const fs = require('fs');
const path = require('path');
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const {
  doc,
  getDoc,
  setDoc,
  updateDoc,
  deleteDoc,
  collection,
  query,
  where,
  getDocs,
  writeBatch,
  arrayUnion,
} = require('firebase/firestore');

const PROJECT_ID = 'demo-medical-app';

const OWNER = 'doctor-owner';
const EDITOR = 'doctor-editor';
const OUTSIDER = 'doctor-outsider';
const UNVERIFIED = 'doctor-unverified';
const ADMIN = 'platform-admin';
const PATIENT = 'patient-1';

let testEnv;

/** Writes fixture data with rules turned off, so setup cannot be blocked. */
async function seed() {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();

    for (const uid of [OWNER, EDITOR, OUTSIDER]) {
      await setDoc(doc(db, 'users', uid), {
        docID: uid,
        ad: 'Test',
        soyad: 'Doctor',
        isVerified: true,
      });
    }

    await setDoc(doc(db, 'users', UNVERIFIED), {
      docID: UNVERIFIED,
      ad: 'Pending',
      soyad: 'Doctor',
      isVerified: false,
    });

    await setDoc(doc(db, 'patients', PATIENT), {
      firstName: 'Ada',
      lastName: 'Lovelace',
      protocolNo: '1001',
      mainDoctorId: OWNER,
      authorizedUserIds: [OWNER, EDITOR],
    });

    await setDoc(doc(db, 'patient_connections', 'conn-owner'), {
      patientId: PATIENT,
      userId: OWNER,
      role: 'owner',
    });
    await setDoc(doc(db, 'patient_connections', 'conn-editor'), {
      patientId: PATIENT,
      userId: EDITOR,
      role: 'editor',
    });
  });
}

const asUser = (uid) => testEnv.authenticatedContext(uid).firestore();
const asAdmin = () =>
  testEnv.authenticatedContext(ADMIN, { admin: true }).firestore();
const asAnon = () => testEnv.unauthenticatedContext().firestore();

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: fs.readFileSync(
        path.resolve(__dirname, '../../firestore.rules'),
        'utf8'
      ),
    },
  });
});

after(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await seed();
});

describe('unauthenticated access', () => {
  it('cannot read a patient', async () => {
    await assertFails(getDoc(doc(asAnon(), 'patients', PATIENT)));
  });

  it('cannot read a user profile', async () => {
    await assertFails(getDoc(doc(asAnon(), 'users', OWNER)));
  });

  it('cannot write a patient', async () => {
    await assertFails(
      setDoc(doc(asAnon(), 'patients', 'forged'), { firstName: 'X' })
    );
  });
});

describe('unverified account', () => {
  it('cannot read a patient even when listed as authorized', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await updateDoc(doc(context.firestore(), 'patients', PATIENT), {
        authorizedUserIds: [OWNER, EDITOR, UNVERIFIED],
      });
    });

    await assertFails(getDoc(doc(asUser(UNVERIFIED), 'patients', PATIENT)));
  });

  it('cannot create a patient', async () => {
    await assertFails(
      setDoc(doc(asUser(UNVERIFIED), 'patients', 'new-patient'), {
        firstName: 'X',
        lastName: 'Y',
        protocolNo: '1',
        mainDoctorId: UNVERIFIED,
        authorizedUserIds: [UNVERIFIED],
      })
    );
  });
});

describe('patient reads', () => {
  it('lets an authorized doctor read', async () => {
    await assertSucceeds(getDoc(doc(asUser(EDITOR), 'patients', PATIENT)));
  });

  it('blocks a verified doctor who is not authorized', async () => {
    await assertFails(getDoc(doc(asUser(OUTSIDER), 'patients', PATIENT)));
  });

  it('blocks an unfiltered collection query', async () => {
    const db = asUser(EDITOR);
    await assertFails(getDocs(query(collection(db, 'patients'))));
  });

  it('allows a query filtered by authorizedUserIds', async () => {
    const db = asUser(EDITOR);
    await assertSucceeds(
      getDocs(
        query(
          collection(db, 'patients'),
          where('authorizedUserIds', 'array-contains', EDITOR)
        )
      )
    );
  });
});

describe('patient writes', () => {
  it('lets an authorized doctor update clinical data', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        'demography.age': 42,
      })
    );
  });

  it('blocks an editor from changing the access list', async () => {
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        authorizedUserIds: [OWNER, EDITOR, OUTSIDER],
      })
    );
  });

  it('lets the owner change the access list', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(OWNER), 'patients', PATIENT), {
        authorizedUserIds: [OWNER, EDITOR, OUTSIDER],
      })
    );
  });

  it('lets an outsider add only themselves (shared link flow)', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(OUTSIDER), 'patients', PATIENT), {
        authorizedUserIds: [OWNER, EDITOR, OUTSIDER],
      })
    );
  });

  it('blocks an outsider from adding a third party alongside themselves', async () => {
    await assertFails(
      updateDoc(doc(asUser(OUTSIDER), 'patients', PATIENT), {
        authorizedUserIds: [OWNER, EDITOR, OUTSIDER, 'smuggled-uid'],
      })
    );
  });

  it('blocks an outsider from editing clinical data while joining', async () => {
    await assertFails(
      updateDoc(doc(asUser(OUTSIDER), 'patients', PATIENT), {
        authorizedUserIds: [OWNER, EDITOR, OUTSIDER],
        firstName: 'Rewritten',
      })
    );
  });

  it('lets an editor remove themselves', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        authorizedUserIds: [OWNER],
      })
    );
  });

  it('requires the creator to authorize themselves', async () => {
    await assertFails(
      setDoc(doc(asUser(OWNER), 'patients', 'orphan'), {
        firstName: 'X',
        lastName: 'Y',
        protocolNo: '2',
        mainDoctorId: OWNER,
        authorizedUserIds: [],
      })
    );
  });

  it('blocks creating a patient owned by someone else', async () => {
    await assertFails(
      setDoc(doc(asUser(OWNER), 'patients', 'not-mine'), {
        firstName: 'X',
        lastName: 'Y',
        protocolNo: '3',
        mainDoctorId: OUTSIDER,
        authorizedUserIds: [OWNER],
      })
    );
  });

  it('blocks an editor from deleting the patient', async () => {
    await assertFails(deleteDoc(doc(asUser(EDITOR), 'patients', PATIENT)));
  });

  it('lets the owner delete the patient', async () => {
    await assertSucceeds(deleteDoc(doc(asUser(OWNER), 'patients', PATIENT)));
  });
});

describe('user profiles', () => {
  it('lets a user read their own profile', async () => {
    await assertSucceeds(getDoc(doc(asUser(OWNER), 'users', OWNER)));
  });

  it('blocks reading someone else profile', async () => {
    await assertFails(getDoc(doc(asUser(OWNER), 'users', EDITOR)));
  });

  it('blocks a user from approving themselves', async () => {
    await assertFails(
      updateDoc(doc(asUser(UNVERIFIED), 'users', UNVERIFIED), {
        isVerified: true,
      })
    );
  });

  it('lets a user edit their own name', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(OWNER), 'users', OWNER), { ad: 'Yeni' })
    );
  });

  it('blocks registering an already-approved profile', async () => {
    await assertFails(
      setDoc(doc(asUser('fresh-uid'), 'users', 'fresh-uid'), {
        docID: 'fresh-uid',
        ad: 'Fresh',
        soyad: 'Doctor',
        isVerified: true,
      })
    );
  });

  it('allows registering a pending profile', async () => {
    await assertSucceeds(
      setDoc(doc(asUser('fresh-uid'), 'users', 'fresh-uid'), {
        docID: 'fresh-uid',
        ad: 'Fresh',
        soyad: 'Doctor',
        isVerified: false,
      })
    );
  });

  it('blocks a non-admin from listing users', async () => {
    await assertFails(getDocs(query(collection(asUser(OWNER), 'users'))));
  });
});

describe('admin claim', () => {
  it('can list users awaiting approval', async () => {
    await assertSucceeds(
      getDocs(
        query(collection(asAdmin(), 'users'), where('isVerified', '==', false))
      )
    );
  });

  it('can approve a user', async () => {
    await assertSucceeds(
      updateDoc(doc(asAdmin(), 'users', UNVERIFIED), { isVerified: true })
    );
  });

  it('can read any patient', async () => {
    await assertSucceeds(getDoc(doc(asAdmin(), 'patients', PATIENT)));
  });

  it('is not granted by a Firestore field', async () => {
    // A user who writes isAdmin into their own profile gains nothing: the rules
    // read the claim from the auth token, which the client cannot set.
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await updateDoc(doc(context.firestore(), 'users', OUTSIDER), {
        isAdmin: true,
      });
    });

    await assertFails(getDoc(doc(asUser(OUTSIDER), 'patients', PATIENT)));
  });
});

describe('patient connections', () => {
  it('lets a doctor query their own connections', async () => {
    await assertSucceeds(
      getDocs(
        query(
          collection(asUser(EDITOR), 'patient_connections'),
          where('userId', '==', EDITOR)
        )
      )
    );
  });

  it('blocks querying another doctor connections', async () => {
    await assertFails(
      getDocs(
        query(
          collection(asUser(OUTSIDER), 'patient_connections'),
          where('userId', '==', EDITOR)
        )
      )
    );
  });

  it('lets an authorized doctor list connections for that patient', async () => {
    await assertSucceeds(
      getDocs(
        query(
          collection(asUser(EDITOR), 'patient_connections'),
          where('patientId', '==', PATIENT)
        )
      )
    );
  });

  it('blocks creating a connection on behalf of someone else', async () => {
    await assertFails(
      setDoc(doc(asUser(OUTSIDER), 'patient_connections', 'forged'), {
        patientId: PATIENT,
        userId: EDITOR,
        role: 'editor',
      })
    );
  });

  it('lets a doctor drop their own connection', async () => {
    await assertSucceeds(
      deleteDoc(doc(asUser(EDITOR), 'patient_connections', 'conn-editor'))
    );
  });

  it('blocks an editor from reassigning roles', async () => {
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patient_connections', 'conn-editor'), {
        role: 'owner',
      })
    );
  });

  it('lets the owning doctor reassign roles', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(OWNER), 'patient_connections', 'conn-editor'), {
        role: 'owner',
      })
    );
  });
});

// ---------------------------------------------------------------------------
// Added after the October 2026 review. The block above tests that an editor
// cannot change the access list; it did not test the field the editor could
// change instead. mainDoctorId decides isOwner(), and isOwner() unlocks both
// the access list and deletion, so leaving that field writable handed every
// contributor a path to ownership. These tests pin that path shut and guard
// the legitimate contributor flow against over-correction.
// ---------------------------------------------------------------------------

describe('ownership integrity', () => {
  it('blocks an editor from claiming ownership', async () => {
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        mainDoctorId: EDITOR,
      })
    );
  });

  it('blocks an editor from claiming ownership while the access list stays put', async () => {
    // The pre-fix rule allowed exactly this: the access list is untouched, so
    // the old `newAccessList() == accessList()` branch was satisfied.
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        mainDoctorId: EDITOR,
        authorizedUserIds: [OWNER, EDITOR],
      })
    );
  });

  it('blocks the escalation chain: an editor cannot take ownership and then delete', async () => {
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        mainDoctorId: EDITOR,
      })
    );
    // Ownership never moved, so the delete is still refused.
    await assertFails(
      deleteDoc(doc(asUser(EDITOR), 'patients', PATIENT))
    );
  });

  it('blocks an editor from hiding an ownership change inside a clinical write', async () => {
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        'pathology.grade': 2,
        mainDoctorId: EDITOR,
      })
    );
  });

  it('blocks an outsider from claiming ownership while joining', async () => {
    await assertFails(
      updateDoc(doc(asUser(OUTSIDER), 'patients', PATIENT), {
        authorizedUserIds: [OWNER, EDITOR, OUTSIDER],
        mainDoctorId: OUTSIDER,
      })
    );
  });

  it('lets the owner hand ownership to a colleague who already has access', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(OWNER), 'patients', PATIENT), {
        mainDoctorId: EDITOR,
      })
    );
  });

  it('blocks the owner from handing ownership to someone with no access', async () => {
    await assertFails(
      updateDoc(doc(asUser(OWNER), 'patients', PATIENT), {
        mainDoctorId: OUTSIDER,
      })
    );
  });
});

describe('patient identity fields', () => {
  it('blocks an editor from rewriting the patient name', async () => {
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        firstName: 'Grace',
      })
    );
  });

  it('blocks an editor from rewriting the protocol number', async () => {
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        protocolNo: '9999',
      })
    );
  });

  it('blocks an editor from overwriting the creation stamp', async () => {
    // The client used to send createdAt back on every update, which both
    // changed the field type and widened what an editor may write.
    await assertFails(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        createdAt: '2020-01-01T00:00:00.000',
      })
    );
  });

  it('lets the owner edit the patient name', async () => {
    await assertSucceeds(
      updateDoc(doc(asUser(OWNER), 'patients', PATIENT), {
        firstName: 'Grace',
      })
    );
  });
});

describe('contributor clinical writes still work', () => {
  // Regression guard: the field allow-list must not be so tight that the
  // app's own category-save path is refused.
  const categories = [
    'pathology', 'oncology', 'demography',
    'comorbidity', 'biochemistry', 'radiology',
  ];

  for (const category of categories) {
    it(`lets an editor save the ${category} category`, async () => {
      await assertSucceeds(
        updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
          [category]: { value: 'test' },
          [`addedCategories.${category}`]: true,
        })
      );
    });
  }

  it('lets an editor save a category together with the edit timestamp', async () => {
    // This is exactly what PatientRemoteDataSource.updatePatientCategory sends.
    await assertSucceeds(
      updateDoc(doc(asUser(EDITOR), 'patients', PATIENT), {
        pathology: { grade: 3 },
        'addedCategories.pathology': true,
        updatedAt: new Date(),
      })
    );
  });
});

describe('connection integrity', () => {
  it('blocks creating a connection for a patient the caller cannot access', async () => {
    await assertFails(
      setDoc(doc(asUser(OUTSIDER), 'patient_connections', 'conn-outsider'), {
        patientId: PATIENT,
        userId: OUTSIDER,
        role: 'editor',
      })
    );
  });

  it('blocks creating a connection for a patient that does not exist', async () => {
    await assertFails(
      setDoc(doc(asUser(EDITOR), 'patient_connections', 'conn-ghost'), {
        patientId: 'no-such-patient',
        userId: EDITOR,
        role: 'editor',
      })
    );
  });

  it('lets an authorized doctor create their own connection', async () => {
    await assertSucceeds(
      setDoc(doc(asUser(EDITOR), 'patient_connections', 'conn-editor-2'), {
        patientId: PATIENT,
        userId: EDITOR,
        role: 'editor',
      })
    );
  });

  it('lets a doctor join through the app batch (connection + arrayUnion)', async () => {
    const db = asUser(OUTSIDER);
    const batch = writeBatch(db);
    batch.set(doc(db, 'patient_connections', 'conn-join'), {
      patientId: PATIENT,
      userId: OUTSIDER,
      role: 'editor',
    });
    batch.update(doc(db, 'patients', PATIENT), {
      authorizedUserIds: arrayUnion(OUTSIDER),
    });
    await assertSucceeds(batch.commit());
  });

  it('blocks re-pointing a connection at another patient', async () => {
    await assertFails(
      updateDoc(doc(asUser(OWNER), 'patient_connections', 'conn-editor'), {
        patientId: 'another-patient',
      })
    );
  });

  it('blocks re-pointing a connection at another user', async () => {
    await assertFails(
      updateDoc(doc(asUser(OWNER), 'patient_connections', 'conn-editor'), {
        userId: OUTSIDER,
      })
    );
  });
});
