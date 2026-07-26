/**
 * Backfills `patients.authorizedUserIds` from the `patient_connections`
 * collection.
 *
 * Security rules cannot run queries, so authorization is denormalized onto the
 * patient document. Documents created before that change have no such field and
 * would become unreachable once the rules are deployed. This script closes that
 * gap.
 *
 * The script is idempotent: it computes the target set, compares it with what is
 * already stored, and writes only where they differ. Running it twice is a
 * no-op the second time.
 *
 * Usage:
 *   cd tool && npm install
 *   set GOOGLE_APPLICATION_CREDENTIALS=C:\path\to\service-account.json
 *   node tool/migrate_authorized_user_ids.js --dry-run
 *   node tool/migrate_authorized_user_ids.js
 *
 * Run --dry-run first and read the summary before committing to the write pass.
 */

'use strict';

const admin = require('firebase-admin');

const DRY_RUN = process.argv.includes('--dry-run');
const CREDENTIALS_ENV = 'GOOGLE_APPLICATION_CREDENTIALS';
const PATIENTS = 'patients';
const CONNECTIONS = 'patient_connections';
const FIELD = 'authorizedUserIds';
const BATCH_LIMIT = 500;

function assertCredentials() {
  if (!process.env[CREDENTIALS_ENV]) {
    console.error(
      `${CREDENTIALS_ENV} is not set. Point it at the service account JSON ` +
        'downloaded from the Firebase console. Never commit that file.'
    );
    process.exit(1);
  }
}

/** Maps patientId -> Set of user ids that hold a connection to it. */
async function buildAuthorizationIndex(db) {
  const snapshot = await db.collection(CONNECTIONS).get();
  const index = new Map();
  let skipped = 0;

  snapshot.forEach((doc) => {
    const { patientId, userId } = doc.data();
    if (!patientId || !userId) {
      skipped++;
      console.warn(`  connection ${doc.id}: missing patientId/userId, skipped`);
      return;
    }
    if (!index.has(patientId)) index.set(patientId, new Set());
    index.get(patientId).add(userId);
  });

  return { index, connectionCount: snapshot.size, skipped };
}

function sameMembers(a, b) {
  return a.length === b.length && a.every((value) => b.includes(value));
}

/** Commits writes in chunks, because a batch holds at most 500 operations. */
async function commitInChunks(db, writes) {
  for (let i = 0; i < writes.length; i += BATCH_LIMIT) {
    const batch = db.batch();
    for (const { ref, value } of writes.slice(i, i + BATCH_LIMIT)) {
      batch.update(ref, { [FIELD]: value });
    }
    await batch.commit();
    console.log(`  committed ${Math.min(i + BATCH_LIMIT, writes.length)}/${writes.length}`);
  }
}

async function main() {
  assertCredentials();
  admin.initializeApp({ credential: admin.credential.applicationDefault() });
  const db = admin.firestore();

  console.log(DRY_RUN ? 'DRY RUN - nothing will be written\n' : 'LIVE RUN\n');

  const { index, connectionCount, skipped } = await buildAuthorizationIndex(db);
  console.log(`connections read: ${connectionCount} (skipped: ${skipped})`);

  const patients = await db.collection(PATIENTS).get();
  console.log(`patients read:    ${patients.size}\n`);

  const writes = [];
  let alreadyCorrect = 0;
  let orphaned = 0;

  patients.forEach((doc) => {
    const data = doc.data();
    const target = new Set(index.get(doc.id) || []);

    // The creating doctor must always retain access, even if the connection
    // document was lost or never written.
    if (data.mainDoctorId) target.add(data.mainDoctorId);

    if (target.size === 0) {
      orphaned++;
      console.warn(
        `  patient ${doc.id}: no connections and no mainDoctorId - ` +
          'would become unreachable, needs manual review'
      );
      return;
    }

    const current = Array.isArray(data[FIELD]) ? data[FIELD] : [];
    const value = [...target];

    if (sameMembers(current, value)) {
      alreadyCorrect++;
      return;
    }

    writes.push({ ref: doc.ref, value });
  });

  console.log('\n--- summary ---');
  console.log(`already correct: ${alreadyCorrect}`);
  console.log(`to update:       ${writes.length}`);
  console.log(`needs review:    ${orphaned}`);

  if (writes.length === 0) {
    console.log('\nNothing to do.');
    return;
  }

  if (DRY_RUN) {
    console.log('\nSample of pending updates:');
    for (const { ref, value } of writes.slice(0, 10)) {
      console.log(`  ${ref.id} -> [${value.join(', ')}]`);
    }
    console.log('\nRe-run without --dry-run to apply.');
    return;
  }

  console.log('');
  await commitInChunks(db, writes);
  console.log('\nDone.');
}

main().catch((error) => {
  console.error('Migration failed:', error);
  process.exit(1);
});
