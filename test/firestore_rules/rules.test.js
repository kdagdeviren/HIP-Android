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
