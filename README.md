# HIP — Patient Information Platform

[🇹🇷 Türkçe](README.tr.md)

A Flutter application built for physicians to collect structured patient clinical
data, share it with colleagues under controlled access, and export it for analysis.

Accounts go through admin approval, access to patient data is authorized per patient,
and that authorization is enforced server-side by Firestore security rules.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Data Model](#data-model)
- [Security Model](#security-model)
- [Setup](#setup)
- [Testing the Security Rules](#testing-the-security-rules)
- [Assigning an Admin](#assigning-an-admin)
- [Known Limitations](#known-limitations)
- [License](#license)

---

## Features

- Email/password authentication
- Admin-approved account onboarding — an unapproved account cannot access any patient data
- Structured data entry across six clinical categories: demographics, comorbidity,
  pathology, radiology, biochemistry, oncology
- Patient sharing via deep link; the receiving physician is added as an editor
- Exporting and sharing patient data as Excel (`.xlsx`)
- Turkish and English UI, with automatic locale selection on first launch

---

## Architecture

A layered Clean Architecture is used; dependencies flow in one direction
(`presentation` → `domain` → `data`). The presentation layer follows MVVM, with
`ChangeNotifier`-based ViewModels distributed via `provider`.

```
lib/
├── core/                  # Cross-cutting concerns
│   ├── constants/         # Provider registrations, theme constants
│   ├── services/          # AuthGuard, deep link, notifications, navigation
│   ├── theme/
│   └── utils/             # Logging, error mapping, validation
└── features/
    ├── admin/             # Account approval flow
    ├── auth/               # Login, registration, pending approval
    ├── home/
    └── patient/
        ├── data/          # Firestore data sources, models, repositories
        ├── domain/        # Clinical category entities (pure Dart)
        └── presentation/  # Pages, ViewModels, widgets
```

**Routing.** The `home:` in `main.dart` is an `AuthGuard`. It listens to
`authStateChanges`, reads the admin claim from the token, and routes the user to the
login screen, the pending-approval screen, the admin panel, or the home page. Other
navigation uses the named routes in `core/routes.dart`.

**Sharing flow.** Sharing a patient record produces a `myapp://addPatient?id=...` link
(or its HTTPS equivalent). The physician who opens the link creates their own record in
the `patient_connections` collection, and the patient document's authorization list is
updated in the same batched write.

---

## Data Model

Three collections are used.

### `users/{uid}`

| Field | Type | Description |
|---|---|---|
| `docID` | string | Same as the Firebase Auth UID |
| `ad`, `soyad` | string | First and last name |
| `isVerified` | bool | Admin approval. Cannot be self-changed by the user |
| `fcmToken` | string | Notification target |

### `patients/{patientId}`

| Field | Type | Description |
|---|---|---|
| `firstName`, `lastName`, `protocolNo` | string | |
| `mainDoctorId` | string | The physician who created the record; owns the access list |
| `authorizedUserIds` | string[] | UIDs authorized to access this patient |
| `addedCategories` | map | Which categories have been filled in |
| `demography`, `comorbidity`, `pathology`, `radiology`, `biochemistry`, `oncology` | map | Clinical data |

### `patient_connections/{connectionId}`

| Field | Type | Description |
|---|---|---|
| `patientId`, `userId` | string | |
| `role` | string | `owner` or `editor` |

### Why `authorizedUserIds` exists

Firestore security rules cannot run queries. Asking "does this user have a connection
to this patient?" against `patient_connections` from within a rule isn't possible. So
authorization is denormalized onto the patient document; a rule can decide with a
single document read, and list queries work too.

`patient_connections` remains the single source of truth for role information. The two
structures stay in sync because both connection creation and deletion write to them in
the same `WriteBatch`.

---

## Security Model

Rules are versioned in `firestore.rules` and published with `firebase deploy`. The
default behavior is deny: any path that isn't explicitly matched is closed.

**Roles**

| Role | How it's determined |
|---|---|
| `admin` | Firebase Auth custom claim (`admin: true`). Only assigned via `tool/set_admin_claim.js`; the client cannot change it |
| `verified` | Signed in **and** `users/{uid}.isVerified == true`. Only these users can access patient data |
| `owner` | `patients/{id}.mainDoctorId`. The party that can change the access list |

**Access matrix**

| Collection | Read | Create | Update | Delete |
|---|---|---|---|---|
| `users` | Own document or admin. Listing is admin-only | Only their own UID, `isVerified` must be `false` | Own document (`isVerified` and `docID` are immutable) or admin | Admin only |
| `patients` | `uid ∈ authorizedUserIds` or admin | Verified user; must write themselves as `mainDoctorId` and into `authorizedUserIds` | An authorized user can edit clinical data; only the `owner` can change the access list. A user may add or remove themselves | `owner` or admin |
| `patient_connections` | Own connections, or connections on a patient the caller may access | Only on their own behalf | Role assignment is `owner`-only | Own connection or `owner` |
| all other paths | ✗ | ✗ | ✗ | ✗ |

A user setting their own `isVerified` to `true` is blocked by the update rule verifying
the field hasn't changed.

**About the Firebase API key.** The `apiKey` value in `lib/firebase_options.dart` and
`android/app/google-services.json` is not a secret; it ships inside every client app,
and Google documents it as such. What protects the data is not the secrecy of this key
but the security rules above. Restricting the key to your package name and SHA-1
signature via Google Cloud Console is recommended as a quota-abuse safeguard.

---

## Setup

**Prerequisites:** Flutter SDK (matching the `sdk` constraint in `pubspec.yaml`),
Firebase CLI, Node.js 18+ (only needed for rule tests and the `tool/` scripts).

1. Create a new project in the Firebase Console.

2. Enable **Authentication** and turn on the **Email/Password** provider.

3. Create the **Firestore Database**. This repository already ships production-ready
   security rules (`firestore.rules`); you'll publish them in step 6 below.

4. Enable **Cloud Messaging**.

5. Install the FlutterFire CLI and generate the configuration:
   ```bash
   dart pub global activate flutterfire_cli
   ```
   ```bash
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` and `android/app/google-services.json`
   for your own project. Neither file is committed to the repo.

6. Publish the security rules and indexes:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```

7. Install dependencies and run the app:
   ```bash
   flutter pub get
   ```
   ```bash
   flutter run
   ```

8. Register your first account, then follow [Assigning an Admin](#assigning-an-admin)
   to approve it.

**SHA fingerprints.** To restrict the API key to your own app and to validate deep
links (`assetlinks.json`), add the **SHA-1** and **SHA-256** fingerprints under
**Project Settings → Your apps** in the Firebase Console:

```bash
cd android && ./gradlew signingReport
```

---

## Testing the Security Rules

The rules are verified by 38 scenarios running against the Firestore emulator. The
tests never connect to a real project.

```bash
cd test/firestore_rules && npm install && npm run test:emulator
```

Covered cases: unauthenticated access, an unapproved account, an unauthorized
physician, the access difference between an editor and an owner, joining via a share
link, an attempt to sneak a third party onto the access list, a user trying to approve
themselves, and admin authority being unforgeable via a plain Firestore field.

---

## Assigning an Admin

Admin authority is a custom claim on the Auth token, not a Firestore field, so the
client cannot change it. Assignment is done with a one-off script that requires an
Admin SDK credential.

```bash
cd tool && npm install
```

```bash
set GOOGLE_APPLICATION_CREDENTIALS=C:\path\to\service-account.json
```

```bash
node tool/set_admin_claim.js --email admin@example.com
```

Use `--list` to list current admins, `--revoke` to remove the claim. The claim doesn't
take effect until the user's token refreshes; the "Retry" action in the app forces
that refresh.

> The service account JSON file must never be committed to the repository.

If existing patient records are missing `authorizedUserIds`,
`tool/migrate_authorized_user_ids.js` backfills them from `patient_connections`.
Run it with `--dry-run` first to review a summary.

---

## Known Limitations

- **Notification sending is disabled.** Calling the FCM v1 API requires a service
  account credential, which cannot be kept safely inside a client app. The sending
  path was removed; token registration and receiving notifications still work.
  Moving sending to a Cloud Function is planned.
- The English translation was produced quickly for testing purposes; clinical
  terminology has not gone through medical review. Treat the English UI as
  provisional until a domain expert validates it.

---

## License

MIT — see [LICENSE](LICENSE) for details.

Copyright © 2025-2026 Yusuf Kağan Dağdeviren, Özgür Demir
