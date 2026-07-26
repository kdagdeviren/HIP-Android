# Güvenlik Sıkılaştırma ve Yayın Hazırlığı Planı

**Tarih:** 2026-07-26
**Depo:** `github.com/kdagdeviren/HIP-Android` (branch: `main`, 20 commit)
**Bağlam:** Uygulama gerçek hasta verisi topluyor ve akademik bir makaleye konu oluyor. Makale "mahremiyet-korumalı sistem" iddiasında; bu planın amacı bu iddiayı denetlenebilir hale getirmek.

---

## Mevcut Durum Tespiti

Kod tabanı ve git geçmişi üzerinde yapılan tarama sonuçları:

| # | Bulgu | Kanıt | Şiddet |
|---|---|---|---|
| 1 | Firebase Admin SDK **service account private key** git geçmişinde | `10e1d10 "First release"` → `lib/core/services/notification_service.dart` | Kritik |
| 2 | Aynı anahtarın gövdesi **çalışma ağacında hâlâ duruyor** (yarım temizlik: ilk satırlar `REMOVED_PRIVATE_KEY`, gerisi ve `-----END PRIVATE KEY-----` yerinde) | `notification_service.dart` HEAD | Kritik |
| 3 | Firestore **güvenlik kuralı yok**; README "test modu" talimatı veriyor — kimlik doğrulaması olmadan herkese açık okuma/yazma | `README.md`, `firestore.rules` mevcut değil | Kritik |
| 4 | **Admin yetkisi veri modelinde tanımsız**; `admin_service` herhangi bir yetki kontrolü olmadan tüm `users` koleksiyonunu okuyup `isVerified` yazıyor ve kullanıcı siliyor | `features/admin/data/admin_service.dart` | Kritik |
| 5 | `patient_connections` **auto-ID** kullanıyor → güvenlik kuralları sorgu çalıştıramadığı için "bu kullanıcı bu hastaya yetkili mi?" sorusu mevcut şemayla kural içinde cevaplanamıyor | `patient_connection_remote_data_source.dart` | Yüksek |
| 6 | `firebase.json` `.gitignore`'da → kural/indeks deploy konfigürasyonu versiyonlanmıyor | `.gitignore` | Orta |
| 7 | `LICENSE` dosyası depoda yok | kök dizin | Orta |
| 8 | `firebase_options.dart` içinde `apiKey: 'REMOVED_API_KEY'` — depodaki hâliyle uygulama derlenip çalışmaz | `lib/firebase_options.dart` | Orta (doğrulanacak) |
| 9 | Arayüz tamamen Türkçe, i18n altyapısı yok (~63 kullanıcıya görünür string, 97 dart dosyası) | `lib/l10n` mevcut değil | Düşük (koşullu) |

**Not:** `.env` ve `.env.example` durumu doğru — `.env` takip edilmiyor, `.env.example` yalnızca anahtar isimlerini içeriyor.

---

## Alınan Kararlar

| Konu | Karar |
|---|---|
| Sızan anahtar | Önce Firebase konsolundan **iptal/rotasyon**, sonra `git-filter-repo` ile geçmişten temizlik + force-push |
| Admin yetkisi | **Firebase Auth custom claim** (`admin: true`) |
| Hasta erişimi | `patients` dokümanına **`authorizedUserIds`** dizisi denormalizasyonu |
| FCM bildirimleri | Bu planın **kapsamı dışında**; yalnızca kalıntı credential temizlenecek, Cloud Function'a taşıma ayrı iş olarak TODO |

---

## Faz 0 — Anahtar Rotasyonu (ÖNCE BU, ertelenemez)

Geçmiş temizliği anahtarı güvenli hale getirmez; anahtar zaten ifşa olmuş durumda ve depo public ise otomatik tarayıcılar tarafından toplanmış olabilir.

1. Firebase Console → Project Settings → Service accounts → `firebase-adminsdk-fbsvc@medical-app-2c545.iam.gserviceaccount.com` için **mevcut anahtarı sil**, yeni anahtar üret.
2. Google Cloud Console → IAM → bu service account'un son 30 günlük kullanım logunu kontrol et (yetkisiz kullanım var mı).
3. Yeni anahtar **hiçbir koşulda repoya girmez** — yalnızca lokal `.env`'de, ileride Cloud Function ortam değişkeninde.
4. `firebase_options.dart` içindeki Android API key'i de Google Cloud Console'dan **kısıtla** (package name + SHA-1 imza kısıtı). Bu anahtar teknik olarak gizli değildir ama kısıtsız bırakılması kota suistimaline açıktır — README'de bu ayrım açıkça yazılacak.

**Çıktı:** Eski anahtar iptal edilmiş, yeni anahtar repo dışında.
**Doğrulama:** Eski anahtarla atılan bir test isteğinin `401/403` dönmesi.

---

## Faz 1 — Kod Tabanındaki Kalıntı Credential Temizliği

1. `lib/core/services/notification_service.dart` içindeki `_serviceAccountJson` sabitini tamamen kaldır.
2. Bildirim gönderimini devre dışı bırak: servis initialize olmaya devam etsin (FCM token kaydı `users/{uid}.fcmToken` için gerekli), ancak gönderim yolu credential yokluğunda sessizce no-op olsun ve debug seviyesinde log düşsün.
3. Dosyanın başına, Cloud Function'a taşıma işini işaret eden tek satırlık bir TODO bırak; ayrıntısı `TODO.md`'ye yazılır.
4. `_projectId` dahil tüm Firebase tanımlayıcıları `firebase_options.dart`'tan okunsun — dosyada hardcoded değer kalmasın.

**Çıktı:** `git grep -iE "private_key|client_email|BEGIN PRIVATE KEY"` HEAD üzerinde sıfır sonuç.

---

## Faz 2 — Veri Modeli Değişikliği (kuralların ön koşulu)

Güvenlik kuralları sorgu çalıştıramaz; yetki kontrolünün tek doküman okumasıyla yapılabilmesi için hasta dokümanına yetkili kullanıcı listesi denormalize edilir.

### 2.1 Model
- `Patient` entity'sine `List<String> authorizedUserIds` alanı eklenir (`toJson`/`fromJson`/`copyWith` dahil).
- `patient_connections` koleksiyonu **korunur** — rol bilgisi (`owner`/`editor`) ve bağlantı geçmişi için tek kaynak olmaya devam eder. Dizi yalnızca kural değerlendirmesi için türetilmiş bir indekstir.

### 2.2 Yazma yollarının senkronizasyonu
Diziyi güncelleyen her nokta tek bir yerde toplanır — bağlantı ekleme/silme mantığı `PatientConnectionRepository` içine çekilir ve hem connection dokümanını hem `authorizedUserIds` dizisini **tek `WriteBatch` içinde** günceller. Böylece iki kaynak arasında tutarsızlık oluşamaz.

Dokunulacak çağrı noktaları:
- `patient_add_viewmodel` — hasta oluştururken `owner` bağlantısı + dizi ilk değeri
- `patient_all_list_viewmodel` — mevcut hastalar için `editor` ataması
- `patient_connection_viewmodel` — deep link ile bağlanma akışı
- `patient_connection_remote_data_source` — bağlantı silme/rol güncelleme

### 2.3 Migration
Mevcut kayıtlar için tek seferlik script (`tool/migrate_authorized_users.dart` veya Node): tüm `patient_connections` dokümanlarını gez, her `patientId` için `userId` kümesini topla, `patients/{id}.authorizedUserIds` alanını yaz. Script idempotent olmalı (tekrar çalıştırılabilir), `--dry-run` bayrağı desteklemeli.

**Doğrulama:** Migration sonrası `authorizedUserIds` boş olan hasta sayısı = 0; her hastanın dizi uzunluğu, o hastaya ait connection sayısına eşit.

---

## Faz 3 — Admin Custom Claim

1. `tool/set_admin_claim.js` — Admin SDK ile verilen UID'ye `{admin: true}` claim'i atayan tek seferlik script. Repoda kalır, çalıştırmak için yeni service account anahtarı gerekir (repoda tutulmaz).
2. Client tarafında claim okuma: `auth_guard` içinde `user.getIdTokenResult()` ile `admin` claim'i kontrol edilir; admin ekranına yönlendirme buna bağlanır. Claim atandıktan sonra token'ın tazelenmesi için `getIdToken(true)` gerekir — akışta bu noktaya dikkat.
3. `admin_home_page`'e giden rota, claim yoksa erişilemez hale getirilir. **Bu yalnızca UI kolaylığıdır; asıl korumayı Faz 4'teki kurallar sağlar.**

---

## Faz 4 — Firestore Güvenlik Kuralları

`firestore.rules` dosyası depo köküne eklenir ve versiyonlanır.

### Erişim matrisi

| Koleksiyon | Okuma | Oluşturma | Güncelleme | Silme |
|---|---|---|---|---|
| `users/{uid}` | Kendi dokümanı **veya** admin | Yalnızca kendi UID'i, `isVerified` zorunlu `false` | Kendi dokümanı (`isVerified` ve `docID` **değiştirilemez**) veya admin | Yalnızca admin |
| `patients/{id}` | `uid ∈ authorizedUserIds` veya admin | Doğrulanmış kullanıcı, kendini `authorizedUserIds`'e ve `mainDoctorId`'ye yazmak zorunda | `uid ∈ authorizedUserIds`; `authorizedUserIds` yalnızca `owner` rolü tarafından değiştirilebilir | Yalnızca `mainDoctorId` sahibi veya admin |
| `patient_connections/{id}` | Yalnızca `userId == uid` olan bağlantılar veya admin | Doğrulanmış kullanıcı, `userId == uid` | Yalnızca `owner` rolündeki bağlantı sahibi | `owner` veya kendi bağlantısını bırakan kullanıcı |
| diğer tüm yollar | reddedilir | reddedilir | reddedilir | reddedilir |

### Kurala giren ilkeler
- Varsayılan `match /{document=**} { allow read, write: if false; }` — beyaz liste yaklaşımı.
- Her kural `request.auth != null` **ve** `isVerified == true` ön koşuluna bağlı. Admin onayından geçmemiş kullanıcı hiçbir hasta verisine erişemez — bu, makaledeki "doğrulanmış hekim" iddiasının teknik karşılığıdır.
- `isVerified` alanının kullanıcı tarafından kendi kendine `true` yapılması `request.resource.data.isVerified == resource.data.isVerified` kontrolüyle engellenir.
- Şema doğrulaması: `create` işlemlerinde zorunlu alanların varlığı ve tipi kontrol edilir (`hasAll`, `is string` vb.).

### Deploy konfigürasyonu
- `.gitignore`'dan `firebase.json` satırı **kaldırılır**; dosyaya `firestore.rules` ve `firestore.indexes.json` referansları eklenir.
- `firestore.indexes.json` depoya eklenir (`patient_connections` üzerindeki `patientId`+`userId` bileşik sorgusu için).

### Testler
`test/firestore_rules/` altında `@firebase/rules-unit-testing` ile emülatör testleri. Asgari senaryolar:
- Kimliği doğrulanmamış istek → tüm koleksiyonlarda reddedilir
- `isVerified: false` kullanıcı → hasta okuyamaz
- Yetkisiz doğrulanmış kullanıcı → başkasının hastasını okuyamaz/yazamaz
- `authorizedUserIds`'te olan `editor` → okur ve veri günceller, ancak diziyi değiştiremez
- `owner` → diziyi değiştirebilir
- Kullanıcı kendi `isVerified` alanını `true` yapamaz
- Admin claim'li kullanıcı → `users` üzerinde doğrulama işlemlerini yapabilir

**Doğrulama:** `firebase emulators:exec --only firestore "npm test"` tüm senaryolarda yeşil. Bu test çıktısı makalede "kurallar test edilmiştir" iddiasının dayanağı olur.

---

## Faz 5 — Git Geçmişi Temizliği

**Ön koşul:** Faz 0 tamamlanmış olmalı. Ayrıca remote `kdagdeviren` hesabı altında — force-push öncesi depo sahibiyle koordinasyon ve **tam yedek** şart.

1. Çalışma dizininin dışında bare yedek: `git clone --mirror` ile ayrı bir kopya al.
2. `git-filter-repo` ile `10e1d10` commit'indeki credential bloğunu içerik değiştirme (`--replace-text`) yöntemiyle temizle. Dosyanın tamamını silmek yerine içerik değiştirmek tercih edilir — böylece commit geçmişinin anlatısı bozulmaz.
3. Temizlik sonrası doğrulama: `git log -p --all` üzerinde `private_key`, `client_email`, `BEGIN PRIVATE KEY` desenlerinin sıfır eşleşmesi.
4. `git push --force-with-lease` ile remote'u güncelle.
5. GitHub tarafında: fork/PR üzerinden erişilebilir eski nesneler kalabileceği için GitHub Support'a **cache temizliği** talebi aç.
6. Deponun bir klonunu alan olduysa yeniden klonlamaları gerektiği not edilir.

**Doğrulama:** Temiz klon üzerinde adım 3'teki taramanın sıfır sonuç vermesi.

---

## Faz 6 — README ve Lisans

### README yeniden yazımı
- **"Firestore'u test modunda oluşturun" talimatı kaldırılır.** Yerine: veritabanını *production modunda* oluştur, ardından `firebase deploy --only firestore:rules` ile depodaki kuralları uygula.
- **Kurulum bölümü:** ön koşullar (Flutter sürümü, Firebase CLI), `flutterfire configure` adımı, `.env.example` → `.env` kopyalama, emülatör ile lokal çalıştırma.
- **Mimari genel bakış:** Clean Architecture katmanları + MVVM/Provider, `features/` ağacı, üç koleksiyonlu Firestore şeması, deep link ile hasta paylaşımı akışı, Excel dışa aktarım. Makalenin atıf verebilmesi için bir de basit bileşen diyagramı.
- **Güvenlik modeli bölümü:** erişim matrisi (Faz 4), admin onay akışı, kural testlerinin nasıl çalıştırılacağı. Firebase API key'inin neden gizli bir bilgi olmadığı ve kısıtlamanın nasıl yapıldığı da burada açıklanır.
- **Lisans:** MIT olarak belirtilir.

### LICENSE
Depoda `LICENSE` dosyası **bulunmuyor** — eklendiği belirtilmişti ancak ne diskte ne git geçmişinde mevcut. Standart MIT metni, telif satırı doldurularak eklenecek (telif sahibi ismi teyit edilmeli).

### Ek madde (doğrulanacak) — `firebase_options.dart`
Dosyadaki `apiKey: 'REMOVED_API_KEY'` değeri nedeniyle depo hâliyle çalışmıyor olabilir. Lokalde nasıl çözüldüğü teyit edilecek; kalıcı çözüm `--dart-define` ile derleme zamanı enjeksiyonu ve README'de bunun belgelenmesi.

---

## Faz 7 — i18n (koşullu, dergi talep ederse)

Bu faz varsayılan olarak **uygulanmaz**, plana hazır olması için yazılmıştır.

1. `flutter_localizations` + `intl` ile `l10n.yaml` kurulumu, `lib/l10n/app_tr.arb` ve `app_en.arb`.
2. Mevcut ~63 kullanıcıya görünür string çıkarılır. **Kapsam uyarısı:** klinik kategori alan etiketleri (`radiology` 732 satır, `pathology` 473 satır) bu sayının dışında ve tıbbi terminoloji çevirisi gerektirir — dil bilgisi değil alan bilgisi işidir, ayrı değerlendirilmeli.
3. `MaterialApp`'e `localizationsDelegates`/`supportedLocales`, ayarlarda dil değiştirme, tercihin kalıcı saklanması.
4. `main.dart`'taki hardcoded `title: 'Medical App'` de bu kapsamda çözülür.

---

## Uygulama Sırası ve Bağımlılıklar

```
Faz 0 (rotasyon)  ──►  Faz 1 (kalıntı temizlik)  ──►  Faz 5 (geçmiş temizliği)
                                                          │
Faz 2 (veri modeli) ──► Faz 3 (custom claim) ──► Faz 4 (kurallar + testler)
                                                          │
                                                          ▼
                                                    Faz 6 (README + LICENSE)

Faz 7 (i18n) — bağımsız, koşullu
```

Faz 5, Faz 0 tamamlanmadan **başlatılmaz**. Faz 4, Faz 2 ve Faz 3 tamamlanmadan yazılamaz — kuralların dayandığı alanlar henüz mevcut olmaz.

---

## Kapsam Dışı (ayrı iş kalemleri)

- **FCM'in Cloud Function'a taşınması.** Boş `functions/` dizini mevcut. Bu yapılana kadar bildirim gönderimi çalışmaz; `TODO.md`'ye yazılacak.
- Firebase Hosting üzerindeki `addPatient.html` deep link sayfasının güvenlik incelemesi.
- Genel kod kalitesi refaktörü (`radiology.dart` 732 satır vb.).
- `main.dart`'taki gereksiz `Center` sarmalayıcısı ve eksik `darkTheme`.

---

## Açık Sorular

1. ~~`LICENSE` telif satırında hangi isim/kurum yer alacak?~~ → Yusuf Kağan Dağdeviren, Özgür Demir (2025-2026). `LICENSE` eklendi; README'de atıf Faz 6'da.
2. ~~`kdagdeviren/HIP-Android` deposuna force-push yetkisi var mı; depo public mi?~~ → **Depo public**, force-push yetkisi var. Faz 5 uygulanabilir.
3. Firestore'daki `patients` koleksiyonunda gerçek hasta verisi mi var, test kaydı mı? Test kaydıysa koleksiyon temizlenip Faz 2 migration'ı atlanabilir.

## İlerleme (2026-07-26)

| Faz | Durum |
|---|---|
| 0 — Anahtar rotasyonu | ⏳ Yarım. Yeni anahtar üretildi, API key kısıtı uygulandı. **Eski anahtar silinmedi.** |
| 1 — Kalıntı credential temizliği | ✅ Tamam. `notification_service.dart` sadeleşti, `http`/`googleapis_auth` bağımlılıkları kaldırıldı. |
| 2 — Veri modeli | ✅ Tamam ve uygulamada doğrulandı. `authorizedUserIds`, batch senkronizasyon, tek sorgulu sayfalama. Migration betiği yazıldı, **çalıştırılmadı**. |
| 3 — Admin custom claim | ✅ Tamam. `tool/set_admin_claim.js`, `AuthGuard` claim okuyor, hardcoded `adminEmail` silindi. **Claim henüz kimseye atanmadı.** |
| 4 — Güvenlik kuralları | ✅ Tamam. `firestore.rules`, `firestore.indexes.json`, `firebase.json` versiyonlandı. 38 emülatör testi geçiyor. **Deploy edilmedi.** |
| 5 — Git geçmişi temizliği | ⛔ Faz 0'a bağlı, başlatılmadı. |
| 6 — README + LICENSE | ✅ Tamam. |
| 7 — i18n | ⏭️ Kapsam dışı bırakıldı. |

### Faz 4 uygulanırken alınan kararlar

- Erişim listesini yalnızca `owner` değiştirebilir. Plandaki "owner rolü" ifadesi
  `patient_connections.role` üzerinden düşünülmüştü; kurallar sorgu çalıştıramadığı için rol
  okunamıyor. Karşılığı olarak `patients.mainDoctorId` kullanıldı — aynı kişi, tek doküman
  okumasıyla doğrulanabiliyor.
- Paylaşım bağlantısıyla katılan hekim listeye kendini ekleyebilsin diye `joiningSelf()` ve
  `leavingSelf()` istisnaları tanımlandı. Her ikisi de yalnızca `authorizedUserIds` alanının
  değişmesine ve yalnızca çağıranın kendi UID'inin eklenip çıkarılmasına izin veriyor;
  testlerde üçüncü şahıs ekleme ve aynı istekte klinik veri değiştirme denemeleri reddediliyor.
- `getPatients()` / `getPatientsPaginated()` silindi. Hiçbir yerden çağrılmıyorlardı ve
  `patients` koleksiyonunu filtresiz okudukları için kurallar altında zaten çalışamazlardı.

## Durum Notu (2026-07-26)

**Faz 0 — anahtar rotasyonu yarım.** Yeni service account anahtarı üretildi ve API key kısıtı
(paket adı + SHA-1) uygulandı; **eski anahtar henüz silinmedi**.

Kod tabanı taraması eski anahtara bağlı kalan bir bağımlılık bulmadı: `functions/` boş, CI
workflow'u yok, uygulama kodu Faz 1'de service account kullanımını tamamen bıraktı. Referanslar
yalnızca `.env` (takip edilmiyor), `.env.example` (şablon) ve migration script'inde — script
`GOOGLE_APPLICATION_CREDENTIALS` üzerinden yeni anahtarı okuyor. Eski anahtarın silinmesi çalışan
sistemi bozmaz.

Anahtar canlı kaldığı sürece Faz 2/3/4'ün güvenlik değeri sıfırdır: Admin SDK güvenlik
kurallarına tabi değildir, kuralları tamamen bypass eder. Depo public olduğu için anahtarın
üçüncü şahıslarca ele geçirilmiş olduğu varsayılmalıdır. Faz 5 (geçmiş temizliği) bu adım
tamamlanmadan başlatılmaz.
