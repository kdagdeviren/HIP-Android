# HIP — Hasta Bilgi Platformu

Hekimlerin hasta klinik verilerini yapılandırılmış biçimde toplaması, meslektaşlarıyla
denetimli şekilde paylaşması ve analiz için dışa aktarması amacıyla geliştirilmiş bir
Flutter uygulamasıdır.

Hesaplar yönetici onayından geçer, hasta verisine erişim hasta bazında yetkilendirilir ve
bu yetkilendirme sunucu tarafındaki Firestore güvenlik kurallarıyla zorunlu kılınır.

---

## İçindekiler

- [Özellikler](#özellikler)
- [Mimari](#mimari)
- [Veri Modeli](#veri-modeli)
- [Güvenlik Modeli](#güvenlik-modeli)
- [Kurulum](#kurulum)
- [Güvenlik Kurallarının Test Edilmesi](#güvenlik-kurallarının-test-edilmesi)
- [Yönetici Atama](#yönetici-atama)
- [Bilinen Sınırlamalar](#bilinen-sınırlamalar)
- [Lisans](#lisans)

---

## Özellikler

- E-posta/şifre ile kimlik doğrulama
- Yönetici onaylı hesap açılışı — onaylanmamış hesap hiçbir hasta verisine erişemez
- Altı klinik kategoride yapılandırılmış veri girişi: demografi, komorbidite, patoloji,
  radyoloji, biyokimya, onkoloji
- Derin bağlantı (deep link) ile hasta paylaşımı; paylaşılan hekim düzenleyici olarak eklenir
- Hasta verisinin Excel (`.xlsx`) olarak dışa aktarılması ve paylaşılması

---

## Mimari

Katmanlı bir Clean Architecture uygulanır; bağımlılıklar tek yönlüdür
(`presentation` → `domain` → `data`). Sunum katmanında MVVM kullanılır, `ChangeNotifier`
tabanlı ViewModel'ler `provider` ile dağıtılır.

```
lib/
├── core/                  # Çapraz kesen bileşenler
│   ├── constants/         # Provider kayıtları, tema sabitleri
│   ├── services/          # AuthGuard, deep link, bildirim, navigasyon
│   ├── theme/
│   └── utils/             # Loglama, hata dönüşümü, doğrulama
└── features/
    ├── admin/             # Hesap onay akışı
    ├── auth/              # Giriş, kayıt, onay bekleme
    ├── home/
    └── patient/
        ├── data/          # Firestore veri kaynakları, modeller, repository'ler
        ├── domain/        # Klinik kategori varlıkları (saf Dart)
        └── presentation/  # Sayfalar, ViewModel'ler, widget'lar
```

**Yönlendirme.** `main.dart` içindeki `home:` bir `AuthGuard`'dır. Oturum durumunu
`authStateChanges` üzerinden dinler, yönetici yetkisini token'daki custom claim'den okur ve
kullanıcıyı giriş ekranına, onay bekleme ekranına, yönetici paneline veya ana sayfaya
yönlendirir. Diğer geçişler `core/routes.dart` içindeki adlandırılmış rotalarla yapılır.

**Paylaşım akışı.** Bir hasta kaydı paylaşıldığında `myapp://addPatient?id=...` veya
karşılığı olan HTTPS bağlantısı üretilir. Bağlantıyı açan hekim, `patient_connections`
koleksiyonunda kendisi için bir kayıt oluşturur ve aynı toplu yazma (batch) içinde ilgili
hasta dokümanının yetki listesine eklenir.

---

## Veri Modeli

Üç koleksiyon kullanılır.

### `users/{uid}`

| Alan | Tip | Açıklama |
|---|---|---|
| `docID` | string | Firebase Auth UID ile aynıdır |
| `ad`, `soyad` | string | |
| `isVerified` | bool | Yönetici onayı. Kullanıcı kendi kendine değiştiremez |
| `fcmToken` | string | Bildirim hedefi |

### `patients/{patientId}`

| Alan | Tip | Açıklama |
|---|---|---|
| `firstName`, `lastName`, `protocolNo` | string | |
| `mainDoctorId` | string | Kaydı oluşturan hekim; erişim listesinin sahibi |
| `authorizedUserIds` | string[] | Erişim yetkisi olan UID'ler |
| `addedCategories` | map | Hangi kategorilerin doldurulduğu |
| `demography`, `comorbidity`, `pathology`, `radiology`, `biochemistry`, `oncology` | map | Klinik veriler |

### `patient_connections/{connectionId}`

| Alan | Tip | Açıklama |
|---|---|---|
| `patientId`, `userId` | string | |
| `role` | string | `owner` veya `editor` |

### `authorizedUserIds` neden var?

Firestore güvenlik kuralları sorgu çalıştıramaz. "Bu kullanıcının bu hastaya bağlantısı var
mı?" sorusunu `patient_connections` üzerinden bir kural içinde sormak mümkün değildir. Bu
nedenle yetki bilgisi hasta dokümanına denormalize edilir; kural tek doküman okumasıyla karar
verir ve liste sorguları da çalışabilir.

`patient_connections` rol bilgisinin tek kaynağı olmaya devam eder. İki yapı arasındaki
tutarlılık, bağlantı oluşturan ve silen işlemlerin her ikisini de tek bir `WriteBatch` içinde
yazmasıyla korunur.

---

## Güvenlik Modeli

Kurallar `firestore.rules` dosyasında versiyonlanır ve `firebase deploy` ile yayınlanır.
Varsayılan davranış reddetmedir: açıkça eşleşmeyen her yol kapalıdır.

**Roller**

| Rol | Nasıl belirlenir |
|---|---|
| `admin` | Firebase Auth custom claim (`admin: true`). Yalnızca `tool/set_admin_claim.js` ile atanır, istemci değiştiremez |
| `verified` | Oturum açmış **ve** `users/{uid}.isVerified == true`. Hasta verisine yalnızca bu kullanıcılar erişebilir |
| `owner` | `patients/{id}.mainDoctorId`. Erişim listesini değiştirebilen taraf |

**Erişim matrisi**

| Koleksiyon | Okuma | Oluşturma | Güncelleme | Silme |
|---|---|---|---|---|
| `users` | Kendi dokümanı veya admin. Listeleme yalnızca admin | Yalnızca kendi UID'i, `isVerified` zorunlu `false` | Kendi dokümanı (`isVerified` ve `docID` değiştirilemez) veya admin | Yalnızca admin |
| `patients` | `uid ∈ authorizedUserIds` veya admin | Doğrulanmış kullanıcı; kendini `mainDoctorId` ve `authorizedUserIds` olarak yazmak zorunda | Yetkili kullanıcı klinik veriyi düzenler; erişim listesini yalnızca `owner` değiştirir. Kullanıcı kendini ekleyebilir veya çıkarabilir | `owner` veya admin |
| `patient_connections` | Kendi bağlantıları veya erişim yetkisi olunan hastanın bağlantıları | Yalnızca kendi adına | Rol ataması yalnızca `owner` | Kendi bağlantısı veya `owner` |
| diğer yollar | ✗ | ✗ | ✗ | ✗ |

Kullanıcının kendi `isVerified` alanını `true` yapması, güncelleme kuralında alanın
değişmediğinin doğrulanmasıyla engellenir.

**Firebase API anahtarı hakkında.** `lib/firebase_options.dart` ve
`android/app/google-services.json` içindeki `apiKey` değeri gizli bir bilgi değildir; her
istemci uygulamasının içinde dağıtılır ve Google tarafından da böyle belgelenir. Veriyi
koruyan şey bu anahtarın gizliliği değil, yukarıdaki güvenlik kurallarıdır. Anahtarın kota
suistimaline karşı Google Cloud Console üzerinden paket adı ve SHA-1 imza kısıtı ile
sınırlandırılması önerilir.

---

## Kurulum

**Ön koşullar:** Flutter SDK (`pubspec.yaml` içindeki `sdk` kısıtına uyan bir sürüm),
Firebase CLI, Node.js 18+ (yalnızca kural testleri ve `tool/` betikleri için).

1. Firebase Console'da yeni bir proje oluşturun.

2. **Authentication** bölümünü etkinleştirin ve **E-posta/Şifre** sağlayıcısını açın.

3. **Firestore Database**'i **üretim modunda** oluşturun. Test modu veritabanını kimlik
   doğrulaması olmadan herkese açık okuma-yazmaya açar; bu depodaki kurallar zaten
   yayınlanacağı için gerekli değildir.

4. **Cloud Messaging**'i etkinleştirin.

5. FlutterFire CLI'yı kurun ve yapılandırmayı üretin:
   ```bash
   dart pub global activate flutterfire_cli
   ```
   ```bash
   flutterfire configure
   ```
   Bu adım `lib/firebase_options.dart` ve `android/app/google-services.json` dosyalarını
   kendi projeniz için oluşturur. İkisi de depoya dahil edilmez.

6. Güvenlik kurallarını ve indeksleri yayınlayın:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```

7. Bağımlılıkları kurup uygulamayı çalıştırın:
   ```bash
   flutter pub get
   ```
   ```bash
   flutter run
   ```

8. İlk hesabınızla kayıt olun, ardından [Yönetici Atama](#yönetici-atama) adımını uygulayıp
   hesabınızı onaylayın.

**SHA anahtarları.** API anahtarını yalnızca kendi uygulamanızla sınırlamak ve derin
bağlantı doğrulaması (`assetlinks.json`) için Firebase Console'da
**Proje Ayarları → Uygulamalarınız** altına **SHA-1** ve **SHA-256** parmak izlerini ekleyin:

```bash
cd android && ./gradlew signingReport
```

---

## Güvenlik Kurallarının Test Edilmesi

Kurallar, Firestore emülatörü üzerinde çalışan 38 senaryoyla doğrulanır. Testler gerçek bir
projeye bağlanmaz.

```bash
cd test/firestore_rules && npm install && npm run test:emulator
```

Kapsanan durumlar: kimliği doğrulanmamış erişim, onaylanmamış hesap, yetkisiz hekim,
düzenleyici ile sahip arasındaki yetki farkı, paylaşım bağlantısıyla kendini ekleme,
üçüncü şahsı gizlice ekleme denemesi, kullanıcının kendini onaylama denemesi ve yönetici
yetkisinin Firestore alanıyla taklit edilememesi.

---

## Yönetici Atama

Yönetici yetkisi bir Firestore alanı değil, Auth token'ındaki custom claim'dir; bu nedenle
istemci tarafından değiştirilemez. Atama, Admin SDK kimlik bilgisi gerektiren tek seferlik
bir betikle yapılır.

```bash
cd tool && npm install
```

```bash
set GOOGLE_APPLICATION_CREDENTIALS=C:\yol\service-account.json
```

```bash
node tool/set_admin_claim.js --email yonetici@example.com
```

Mevcut yöneticileri listelemek için `--list`, yetkiyi geri almak için `--revoke` kullanılır.
Claim, kullanıcının token'ı yenilenene kadar etkili olmaz; uygulama içindeki "Tekrar dene"
yenilemeyi zorlar.

> Service account JSON dosyası hiçbir koşulda depoya eklenmemelidir.

Var olan hasta kayıtlarında `authorizedUserIds` alanı yoksa
`tool/migrate_authorized_user_ids.js` betiği bunları `patient_connections` üzerinden
doldurur. `--dry-run` ile önce özet alınması önerilir.

---

## Bilinen Sınırlamalar

- **Bildirim gönderimi devre dışıdır.** FCM v1 API'ye istek atmak service account kimlik
  bilgisi gerektirir ve bu bilgi istemci uygulamasında güvenli biçimde tutulamaz. Gönderim
  yolu kaldırılmıştır; token kaydı ve gelen bildirimlerin işlenmesi çalışmaya devam eder.
  Gönderimin bir Cloud Function'a taşınması planlanmaktadır.
- Arayüz yalnızca Türkçedir; uluslararasılaştırma altyapısı henüz kurulmamıştır.

---

## Lisans

MIT — ayrıntılar için [LICENSE](LICENSE) dosyasına bakınız.

Telif hakkı © 2025-2026 Yusuf Kağan Dağdeviren, Özgür Demir
