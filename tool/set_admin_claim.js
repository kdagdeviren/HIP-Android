/**
 * Grants or revokes the `admin` custom claim on a Firebase Auth user.
 *
 * Admin authority lives in the auth token, not in a client-side string
 * comparison and not in a Firestore field a user could write to. Security rules
 * read it as `request.auth.token.admin` with no extra document read.
 *
 * The claim only reaches the app after the ID token refreshes. The client
 * forces a refresh on its retry path; otherwise it can take up to an hour.
 *
 * Usage:
 *   cd tool && npm install
 *   set GOOGLE_APPLICATION_CREDENTIALS=C:\path\to\service-account.json
 *
 * Run from the repository root:
 *   node tool/set_admin_claim.js --email doctor@example.com
 *   node tool/set_admin_claim.js --uid abc123 --revoke
 *   node tool/set_admin_claim.js --list
 */

'use strict';

const admin = require('firebase-admin');

const CREDENTIALS_ENV = 'GOOGLE_APPLICATION_CREDENTIALS';
const CLAIM = 'admin';

function parseArgs(argv) {
  const args = { revoke: false, list: false };
  for (let i = 2; i < argv.length; i++) {
    switch (argv[i]) {
      case '--email':
        args.email = argv[++i];
        break;
      case '--uid':
        args.uid = argv[++i];
        break;
      case '--revoke':
        args.revoke = true;
        break;
      case '--list':
        args.list = true;
        break;
      default:
        console.error(`Unknown argument: ${argv[i]}`);
        process.exit(1);
    }
  }
  return args;
}

function usage() {
  console.error(
    'Usage:\n' +
      '  node tool/set_admin_claim.js --email <email> [--revoke]\n' +
      '  node tool/set_admin_claim.js --uid <uid> [--revoke]\n' +
      '  node tool/set_admin_claim.js --list'
  );
  process.exit(1);
}

function assertCredentials() {
  if (!process.env[CREDENTIALS_ENV]) {
    console.error(
      `${CREDENTIALS_ENV} is not set. Point it at the service account JSON ` +
        'downloaded from the Firebase console. Never commit that file.'
    );
    process.exit(1);
  }
}

/** Walks every Auth user and prints the ones currently holding the claim. */
async function listAdmins(auth) {
  const admins = [];
  let pageToken;

  do {
    const page = await auth.listUsers(1000, pageToken);
    for (const user of page.users) {
      if (user.customClaims && user.customClaims[CLAIM]) {
        admins.push(`${user.uid}  ${user.email || '(no email)'}`);
      }
    }
    pageToken = page.pageToken;
  } while (pageToken);

  if (admins.length === 0) {
    console.log('No users currently hold the admin claim.');
    return;
  }
  console.log(`Admins (${admins.length}):`);
  admins.forEach((line) => console.log(`  ${line}`));
}

async function main() {
  const args = parseArgs(process.argv);
  if (!args.list && !args.email && !args.uid) usage();

  assertCredentials();
  admin.initializeApp({ credential: admin.credential.applicationDefault() });
  const auth = admin.auth();

  if (args.list) {
    await listAdmins(auth);
    return;
  }

  const user = args.uid
    ? await auth.getUser(args.uid)
    : await auth.getUserByEmail(args.email);

  // Merge rather than replace: overwriting customClaims would silently drop
  // any other claim the project starts using later.
  const claims = { ...(user.customClaims || {}) };
  if (args.revoke) {
    delete claims[CLAIM];
  } else {
    claims[CLAIM] = true;
  }

  await auth.setCustomUserClaims(user.uid, claims);

  console.log(
    `${args.revoke ? 'Revoked' : 'Granted'} admin for ` +
      `${user.email || user.uid} (uid: ${user.uid})`
  );
  console.log(
    'The user must sign out and back in, or trigger a token refresh, ' +
      'before the change takes effect.'
  );
}

main().catch((error) => {
  console.error('Failed:', error.message || error);
  process.exit(1);
});
