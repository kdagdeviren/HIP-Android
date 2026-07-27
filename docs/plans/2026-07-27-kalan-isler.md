# Kalan İşler — Devir Notu

**Tarih:** 2026-07-27
**Önceki plan:** [2026-07-26-guvenlik-ve-yayin-hazirligi.md](2026-07-26-guvenlik-ve-yayin-hazirligi.md) — tasarım gerekçeleri ve erişim matrisi orada.

Bu dosya, çalışmaya sıfırdan devam edebilmek için gereken her şeyi içerir. Tasarım
kararlarını yeniden tartışmaya gerek yok; alınmış kararlar aşağıda "Kararlar" başlığında.

---

## Nerede kaldık

Uygulama çalışıyor: giriş, hasta oluşturma, veri girişi ve listeleme doğrulandı.
Güvenlik kuralları yazıldı ve emülatörde 38 senaryoyla test edildi ancak **henüz deploy
edilmedi** — yani veritabanı hâlâ test modunda, kimlik doğrulaması olmadan erişilebilir
durumda. Somut güvenlik kazanımı deploy ile başlıyor.

**Hiçbir şey commit edilmedi.** Tüm çalışma çalışma ağacında duruyor.

### Değişmiş dosyalar

```
 M .gitignore                                              firebase.json takibe alındı, node_modules eklendi
 M README.md                                               baştan yazıldı
 M lib/core/constants/providers.dart                       PatientViewModel tek bağımlılığa indi
 M lib/core/services/auth_guard.dart                       sonsuz döngü giderildi, custom claim okuyor
 M lib/core/services/notification_service.dart             service account kaldırıldı, gönderim no-op
 M lib/features/patient/data/datasources/patient_connection_remote_data_source.dart   batch senkronizasyon
 M lib/features/patient/data/datasources/patient_remote_data_source.dart              arrayContains sorgusu
 M lib/features/patient/data/models/patient_model.dart     authorizedUserIds alanı
 M lib/features/patient/data/repositories/patient_repository.dart
 M lib/features/patient/presentation/viewmodel/patient_view_model.dart                sayfalama sadeleşti
 M lib/features/patient/presentation/widgets/patient_list/patient_list_view.dart      hata/boş durum
 M lib/firebase_options.dart                               flutterfire configure ile yenilendi
 D lib/shared/admin_settings.dart                          hardcoded adminEmail silindi
 M pubspec.yaml                                            http, googleapis_auth kaldırıldı
?? LICENSE                                                 MIT
?? docs/                                                   planlar
?? firebase.json                                           firestore + emulators bölümleri eklendi
?? firestore.indexes.json
?? firestore.rules
?? test/firestore_rules/                                   38 kural testi
?? tool/                                                   set_admin_claim.js, migrate_authorized_user_ids.js
```

### Tamamlananlar

| Faz | Durum |
|---|---|
| 1 — Kalıntı credential temizliği | ✅ |
| 2 — Veri modeli (`authorizedUserIds`) | ✅ uygulamada doğrulandı |
| 3 — Admin custom claim | ✅ claim atandı ve `--list` ile doğrulandı |
| 4 — Kurallar + testler | ✅ yazıldı, 38/38 test geçiyor, **deploy edilmedi** |
| 6 — README + LICENSE | ✅ |

---

## Kalan işler

### 1. Kuralları deploy et — EN ÖNCELİKLİ

```bash
firebase deploy --only firestore:rules,firestore:indexes
```

Deploy sonrası sırayla doğrula:

1. Admin hesabıyla giriş → yönetici paneli açılmalı, onay bekleyenler listelenmeli.
   Açılmazsa çıkış yapıp tekrar gir (token'ın claim'i alması gerekiyor).
2. Hekim hesabıyla giriş → hasta listesi gelmeli. `authorizedUserIds` alanı olan yeni
   hastalar görünür, eskiler görünmez.
3. Yeni hesapla kayıt → "onay bekleniyor" ekranı, hata olmamalı.
4. Yeni hasta oluştur → geçmeli.

İndeks oluşumu birkaç dakika sürer; o sırada liste geçici olarak hata verebilir.
`permission-denied` alınırsa Firebase Console → Firestore → Rules Playground ile hangi
satırda reddedildiği görülebilir.

### 2. Eski service account anahtarını sil (Faz 0)

IAM → `firebase-adminsdk-fbsvc@<proje-id>.iam.gserviceaccount.com` → **Keys** →
eski anahtarı **Delete**. Yeni anahtar üretildi ve API key kısıtı (paket adı + SHA-1)
uygulandı; eksik olan tek adım silme.

Kod tabanında eski anahtara bağlı hiçbir şey kalmadı — `functions/` boş, CI yok, uygulama
Faz 1'de service account kullanımını bıraktı. Silmek çalışan sistemi bozmaz.

**Bu yapılmadan Faz 5'e başlanmaz.** Admin SDK anahtarı güvenlik kurallarını tamamen
bypass eder; anahtar canlıyken Faz 2/3/4'ün güvenlik değeri sıfırdır ve depo public.

### 3. Eski hasta verisi kararı

`authorizedUserIds` alanı olmayan kayıtlar deploy sonrası erişilemez olur. İki seçenek:

- **Migration:** `cd tool && npm install` (yapıldı), sonra
  ```bash
  node tool/migrate_authorized_user_ids.js --dry-run
  ```
  Özet doğruysa `--dry-run` olmadan tekrar çalıştır. `GOOGLE_APPLICATION_CREDENTIALS`
  yeni service account JSON'unu göstermeli.
- **Temizlik:** Test verisiyse koleksiyon boşaltılır, migration'a gerek kalmaz.
  Gerçek hasta verisi olup olmadığı **henüz teyit edilmedi** — silmeden önce doğrulanmalı.

### 4. Faz 5 — git geçmişi temizliği

Ön koşul: madde 2 tamamlanmış olmalı. Depo public, force-push yetkisi var.

1. `git clone --mirror` ile ayrı bir yedek al.
2. `git-filter-repo --replace-text` ile `10e1d10` commit'indeki credential bloğunu temizle.
   Dosyayı silmek yerine içerik değiştir — commit geçmişinin anlatısı bozulmasın.
3. Doğrula: `git log -p --all` üzerinde `private_key`, `client_email`,
   `BEGIN PRIVATE KEY` desenleri sıfır eşleşme vermeli.
4. `git push --force-with-lease`.
5. GitHub Support'a cache temizliği talebi aç (fork/PR üzerinden erişilebilir eski
   nesneler kalabilir).
6. Depoyu klonlayanlar yeniden klonlamalı.

### 5. Commit + PR

Faz 5 tüm commit SHA'larını değiştireceği için PR'ı geçmiş temizliğinden **sonra** açmak
en az iş çıkaran sıra. Aksi halde açık PR geçmişten kopar ve elle rebase gerekir.

### 6. Ertelenenler

- **i18n (Faz 7).** Kullanıcı açıkça "ben gelmeden başlama" dedi. Dergi talep ederse.
  Kapsam uyarısı: klinik kategori etiketleri (`radiology.dart` 732 satır,
  `pathology.dart` 473 satır) tıbbi terminoloji çevirisi gerektirir, ayrı değerlendirilmeli.
- **FCM'i Cloud Function'a taşıma.** Bildirim gönderimi şu an no-op. `functions/` dizini
  boş ve hazır. Blaze planı gerekiyor. `sendNotification` imzası korunduğu için yalnızca
  metot gövdesi değişecek, 4 çağrı noktası etkilenmeyecek.

### 7. Küçük, opsiyonel

- `google_sign_in` bağımlılığı `pubspec.yaml`'da ama kodda hiç kullanılmıyor. Google ile
  giriş uygulanmamış; README buna göre düzeltildi.
- `flutter analyze` 9 `info` veriyor: `withOpacity` (user_card, waiting_verify_page) ve
  `Share`/`shareXFiles` (patient_view_data_viewmodel) deprecated.
- `main.dart`: `MaterialApp`'i saran gereksiz `Center`, hardcoded `title: 'Medical App'`,
  `darkTheme` tanımsız.
- `TODO.md` gitignore'da olduğu için oraya yazılan FCM notu versiyonlanmıyor. Kod
  yorumundaki referans plan dosyasına yönlendirildi.

---

## Kararlar (yeniden tartışmaya gerek yok)

| Konu | Karar |
|---|---|
| Sızan anahtar | Rotasyon + `git-filter-repo` ile geçmiş temizliği + force-push |
| Admin yetkisi | Firebase Auth custom claim (`admin: true`) |
| Hasta erişimi | `patients.authorizedUserIds` dizisi; `patient_connections` rol için tek kaynak |
| Erişim listesini kim değiştirir | `patients.mainDoctorId`. Rol `patient_connections`'ta olduğu ve kurallar sorgu çalıştıramadığı için `role` okunamıyor |
| Paylaşım akışı | `joiningSelf()` / `leavingSelf()` istisnaları — yalnızca çağıran kendi UID'ini ekleyip çıkarabilir |
| FCM | Bu planın kapsamı dışında, ayrı iş |
| LICENSE | MIT, 2025-2026, Yusuf Kağan Dağdeviren ve Özgür Demir |
| `authorizedUserIds` yazımı | `toMap()`'e dahil değil; yalnızca `arrayUnion`/`arrayRemove` ile, bağlantı yazımıyla aynı `WriteBatch` içinde |

---

## Doğrulanmış varsayımlar

- Kayıt akışı `docID: user.uid` ve `isVerified: false` yazıyor → `create` kuralı geçer.
- `getPatients()` / `getPatientsPaginated()` hiçbir yerden çağrılmıyordu, silindi.
- Eski `fetchPatients` sayfalaması hatalıydı: imleç `whereIn` batch'leri arasında
  paylaşıldığı için ikinci sayfada kayıt atlanabiliyordu. Tek sorguya inince kapandı.
- `AuthGuard` sonsuz döngüsü: profil yüklemesi başarısız olunca `_userModel` null kalıyor,
  build aynı çağrıyı tekrar planlıyordu. `_loadedUid` ile kapatıldı.

## Açık riskler

- Deploy sonrası `isVerified` alanı olmayan veya `false` olan hesaplar hasta verisine
  erişemez. Mevcut hesapların durumu kontrol edilmeli.
- Firestore Console'dan elle oluşturulmuş hesapların (`admin@mediapp.com` gibi)
  `users/{uid}` dokümanı yok; admin claim'i olmayan böyle bir hesapla giriş yapılırsa
  "Hesabınıza ait kullanıcı kaydı bulunamadı" ekranı gelir.
