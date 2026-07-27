# Hardcoded UI String'lerini l10n'a Ayırma — Uygulama Planı

**Tarih:** 2026-07-27
**Durum:** Onay bekliyor — uygulama başka bir session'da yapılacak
**Önceki plan:** [2026-07-27-kalan-isler.md](2026-07-27-kalan-isler.md) (tamamlandı)

---

## Amaç

Kod içindeki tüm kullanıcıya görünür metinleri tek bir dil dosyasına (`app_tr.arb`)
taşımak. **Çeviri yapılmayacak** — mevcut Türkçe metinler olduğu gibi ARB'ye
aktarılacak, uygulama yine tamamen Türkçe çalışacak.

Kazanım: İleride İngilizce (veya başka dil) eklemek istendiğinde tek yapılacak iş
`app_en.arb` dosyasını doldurmak olacak. Kod tarafında hiçbir değişiklik gerekmeyecek.
Dergi/hakem İngilizce arayüz talep ederse iş yükü haftalardan günlere iner.

**Bu plan bir çeviri planı değildir.** Klinik terminolojinin İngilizceye çevrilmesi
ayrı bir iş ve tıbbi doğrulama gerektiriyor — kapsam dışı.

---

## Kararlar

Aşağıdaki kararlar alınmış kabul edilir. Uygulama session'ında yeniden tartışılmasına
gerek yok; değiştirmek istenirse **Karar 1** tek başına planın şeklini değiştirir,
diğerleri yereldir.

| # | Konu | Karar | Gerekçe |
|---|---|---|---|
| 1 | l10n altyapısı | Flutter resmi `gen_l10n` + `.arb` | Üçüncü parti bağımlılık yok (depo akademik incelemeye girecek), `.arb` Flutter'ın native formatı, `pubspec.yaml`'da `generate: true` zaten açık. Alternatif `easy_localization` (JSON + context'siz `.tr()`) — bkz. "Reddedilen alternatif" |
| 2 | Dosya konumu | `lib/l10n/app_tr.arb` | `gen_l10n` varsayılanı; üretilen kod `.dart_tool/` altına gider, versiyonlanmaz |
| 3 | Anahtar şeması | `<alan>_<ekran>_<eleman>` — örn. `auth_login_emailHint` | Düz (nested değil), ARB standardına uygun, çakışma riski düşük |
| 4 | Domain katmanı | `categories/*.dart` **saf Dart kalacak** | CLAUDE.md: "domain katmanı Flutter'a bağımlı olmamalı". Enum'lar zaten `.name` ile stabil anahtara sahip; çözüm anahtarı sunmak, metni presentation'da çözmek |
| 5 | Context'siz erişim | Mevcut `NavigationService.instance.navigatorKey` üzerinden `L10n` yardımcısı | ViewModel'lerde ve `EnumDisplayUtil`'de `BuildContext` yok. 45 çağrı noktasına context taşımak yerine, projede zaten var olan navigator key'i kullanmak en az müdahale |
| 6 | Excel export başlıkları | **Lokalize edilmeyecek** | `'Değişken'`/`'Değer'` sütun adları bir veri dosyasına gidiyor; analiz hattı ve yayın için stabil kalmalı. Dil değişince sütun adının değişmesi veri bütünlüğünü bozar |
| 7 | Debug/log metinleri | Lokalize edilmeyecek | CLAUDE.md: "Hardcoded string yazmak yasak (debug log hariç)" |
| 8 | Faz B (klinik enum'lar) | Ayrı faz, opsiyonel | Faz A tek başına tam çalışır bir teslimat. Faz B'ye geçmeden Faz A commit'lenip doğrulanacak |

### Reddedilen alternatif: `easy_localization`

`'key'.tr()` sözdizimi context gerektirmez, bu da Karar 5'teki yardımcıyı gereksiz
kılardı. Buna rağmen seçilmedi çünkü: (a) yeni bir üçüncü parti bağımlılık ekliyor ve
depo hakem incelemesine giriyor, (b) varsayılan formatı JSON — `.arb` istendi,
(c) `pubspec.yaml`'daki `generate: true` boşa çıkardı. Karar 1 değiştirilirse Görev 1
ve Görev 2 baştan yazılmalı; Görev 3+ büyük ölçüde aynı kalır.

---

## Mevcut durum (ölçüldü)

```
Toplam Dart kodu           9.437 satır / 96 dosya
l10n altyapısı             YOK — l10n.yaml yok, .arb yok, flutter_localizations yok
pubspec.yaml               generate: true  ← açık ama kullanılmıyor (kalıntı)
                           intl: ^0.20.2   ← mevcut
```

**Çıkarılacak string sayısı:**

| Grup | Adet | Dosya | Faz |
|---|---|---|---|
| Genel UI (tek tırnak, Türkçe karakterli) | 196 | 26 | A |
| Genel UI (çift tırnak, Türkçe karakterli) | 61 | 20 | A |
| Türkçe karakter içermeyen UI (`"Tamam"`, `"Evet"`, `"Email"`, `"HASTA"` …) | ~40-60 | — | A |
| **Faz A toplamı** | **~300** | **~40** | **A** |
| Klinik enum `displayText` | 214 | 9 | B |
| Dropdown `'label'` girdileri | 65 | 9 | B |
| **Faz B toplamı** | **279** | **9** | **B** |

> ⚠️ **Grep'e güvenilmeyecek.** Türkçe karaktere göre arama `"Tamam"`, `"Evet"`,
> `"Email"`, `"HASTA"` gibi metinleri kaçırıyor (doğrulandı). Çıkarma işlemi
> **dosya dosya okuyarak** yapılacak, grep sadece kaba haritalama için.

**Faz A dosya dağılımı (yoğunluktan seyreğe):**

```
18  lib/core/utils/error_handler.dart
14  lib/core/constants/validation_constants.dart
13  lib/features/patient/data/datasources/patient_connection_remote_data_source.dart
12  lib/core/utils/validation_util.dart
10  lib/features/patient/data/datasources/patient_remote_data_source.dart
 8  lib/features/auth/presentation/viewmodel/register_viewmodel.dart
 6  lib/features/patient/presentation/view/patient_add_page.dart
 6  lib/features/home/presentation/pages/home_page.dart
 6  lib/features/auth/presentation/pages/register_page.dart
10  lib/features/admin/presentation/viewmodel/admin_viewmodel.dart
 5  lib/features/auth/presentation/pages/login_page.dart
 5  lib/shared/widgets/deep_link_test_helper.dart
 …  (kalan ~28 dosyada 1-4 arası)
```

---

## Mimari yaklaşım

### Neden basit bir "bul-değiştir" değil

Üç yerde string'i doğrudan `.arb`'ye taşıyıp `AppLocalizations.of(context)` yazmak
işe yaramıyor:

**1. `static const` sabitler.** `ValidationConstants` içindeki 14 mesaj derleme
zamanı sabiti. `AppLocalizations` çalışma zamanında çözülür — `const` konumda
kullanılamaz. Bu sınıf getter/method'a dönüşmek zorunda:

```dart
// ÖNCE — derleme zamanı sabiti
static const String passwordEmptyError = 'Şifre alanı boş olamaz';

// SONRA — çalışma zamanı çözümü
static String get passwordEmptyError => L10n.current.validation_passwordEmpty;
```

**2. Context'i olmayan çağrı noktaları.** `patient_view_data_viewmodel.dart` ve
`EnumDisplayUtil` `BuildContext` almıyor ama kullanıcıya metin üretiyor.
Karar 5'teki `L10n` yardımcısı bu boşluğu kapatıyor.

**3. Domain katmanı saflığı.** `categories/*.dart` dosyaları saf Dart olmalı
(CLAUDE.md). İçlerine `AppLocalizations` sokmak katman ihlali. Faz B'deki çözüm:
domain sadece `.name` (stabil anahtar) sunar, metni presentation çözer.

### `L10n` yardımcısı — nasıl çalışıyor

```dart
// lib/core/l10n/l10n.dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';

/// BuildContext'i olmayan katmanlar (ViewModel, util) için lokalizasyon erişimi.
///
/// Widget içindeysen bunu KULLANMA — doğrudan `AppLocalizations.of(context)`
/// çağır. Bu yardımcı yalnızca context'in bulunmadığı yerler için bir kaçış
/// kapısı; navigator henüz bağlanmamışsa hata fırlatır.
class L10n {
  const L10n._();

  static AppLocalizations get current {
    final context = NavigationService.instance.navigatorKey.currentContext;
    if (context == null) {
      throw StateError(
        'L10n.current navigator bağlanmadan çağrıldı. '
        'Widget ağacı içindeysen AppLocalizations.of(context) kullan.',
      );
    }
    return AppLocalizations.of(context)!;
  }
}
```

Bu bilinçli bir taviz: global state'e benziyor. Alternatifi, ViewModel'lerin metin
yerine hata **kodu** döndürmesi ve widget'ın kodu metne çevirmesi — mimari olarak
daha doğru ama 40 dosyada imza değişikliği demek. Bu planın kapsamı string çıkarma;
ViewModel API'lerini yeniden tasarlamak değil. Not olarak bırakılıyor.

---

## FAZ A — Genel UI string'leri

### Görev 1: l10n altyapısını kur

**Dosyalar:**
- Değiştir: `pubspec.yaml`
- Oluştur: `l10n.yaml`
- Oluştur: `lib/l10n/app_tr.arb`
- Değiştir: `lib/main.dart`

**1.1** `pubspec.yaml` → `dependencies` altına ekle (`flutter:` sdk girdisinin hemen altına):

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
```

`generate: true` zaten `flutter:` bölümünde mevcut — dokunma.

**1.2** Proje kökünde `l10n.yaml` oluştur:

```yaml
arb-dir: lib/l10n
template-arb-file: app_tr.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

**1.3** `lib/l10n/app_tr.arb` oluştur (başlangıç içeriği — ilk anahtar Görev 2'de gelecek):

```json
{
  "@@locale": "tr"
}
```

**1.4** `lib/main.dart` → `MaterialApp`'e lokalizasyon delegelerini ekle. Aynı
düzenlemede `main.dart`'taki üç kalıntı da temizlenecek: `MaterialApp`'i saran
gereksiz `Center`, hardcoded `title`, ve tanımsız `darkTheme` (önceki planın
7. maddesinden):

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ...

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.app_title,
          theme: AppTheme.lightTheme,
          navigatorKey: NavigationService.instance.navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('tr'),
          routes: appRoutes,
          home: const AuthGuard(),
        );
      },
    );
  }
}
```

`onGenerateTitle` kullanılıyor çünkü `title:` sabit string ister; `onGenerateTitle`
context alır ve locale değişince başlığı günceller.

**1.5** `app_title` anahtarını `app_tr.arb`'ye ekle:

```json
{
  "@@locale": "tr",
  "app_title": "HİP"
}
```

**1.6** Doğrula:

```bash
flutter pub get
```

```bash
flutter analyze
```

Beklenen: `flutter pub get` kod üretimini tetikler,
`.dart_tool/flutter_gen/gen_l10n/app_localizations.dart` oluşur. `flutter analyze`
mevcut 9 `info` dışında yeni hata vermemeli.

**1.7** Commit:

```bash
git add pubspec.yaml pubspec.lock l10n.yaml lib/l10n/ lib/main.dart && git commit -m "l10n altyapısını kur, main.dart kalıntılarını temizle"
```

---

### Görev 2: `L10n` yardımcısını ekle

**Dosyalar:**
- Oluştur: `lib/core/l10n/l10n.dart`

Yukarıdaki "Mimari yaklaşım" bölümündeki `L10n` sınıfını birebir yaz.

**Doğrula:** `flutter analyze` — yeni hata olmamalı (sınıf henüz kullanılmıyor,
`unused` uyarısı normal değil çünkü public).

**Commit:**

```bash
git add lib/core/l10n/l10n.dart && git commit -m "context'siz katmanlar için L10n erişimi ekle"
```

---

### Görev 3: Ortak/tekrar eden string'leri çıkar

Bu görev önce yapılıyor çünkü `"Tamam"`, `"Evet"`, `"Hayır"`, `"Başarılı"`, `"Hata"`
gibi metinler onlarca yerde tekrar ediyor. Önce bunlar tek anahtara indirilirse
sonraki görevlerde tekrar eden iş kalmıyor (DRY).

**Dosyalar:**
- Değiştir: `lib/core/services/popup_service.dart`
- Değiştir: `lib/core/utils/error_handler.dart`

**3.1** `app_tr.arb`'ye ortak anahtarları ekle:

```json
{
  "common_ok": "Tamam",
  "common_yes": "Evet",
  "common_no": "Hayır",
  "common_cancel": "İptal",
  "common_success": "Başarılı",
  "common_error": "Hata",
  "common_retry": "Tekrar dene",
  "common_noData": "Veri Yok-0",
  "common_unspecified": "Belirtilmemiş"
}
```

> `common_noData` değeri `"Veri Yok-0"` — sondaki `-0` kasıtlı, kategori
> enum'larındaki kodlama şemasının parçası. Değiştirme.

**3.2** `popup_service.dart`'ta 4 metodun her birindeki hardcoded buton metnini
değiştir. `PopupService` metodları zaten `BuildContext` alıyor, doğrudan
`AppLocalizations.of(context)!` kullan — `L10n` yardımcısına gerek yok:

```dart
void showSuccess(BuildContext context, String title, String message) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (context) => SmartPopup(
      title: title,
      subTitle: message,
      primaryButtonText: l10n.common_ok,
      popType: PopType.success,
      lottiePath: '',
    ),
  );
}
```

`showConfirmation` içinde `"Evet"` → `l10n.common_yes`, `"Hayır"` → `l10n.common_no`.

**3.3** `error_handler.dart`'taki `'Tamam'` (satır 87) ve diğer 18 Türkçe string'i
çıkar. Bu dosya hem widget hem util karışımı — `BuildContext` alan metotlarda
`AppLocalizations.of(context)!`, almayanlarda `L10n.current` kullan.

**3.4** Doğrula:

```bash
flutter analyze
```

**3.5** Commit:

```bash
git add lib/l10n/app_tr.arb lib/core/services/popup_service.dart lib/core/utils/error_handler.dart && git commit -m "ortak UI metinlerini l10n'a taşı"
```

---

### Görev 4: `ValidationConstants` ve `ValidationUtil`'i dönüştür

Bu ikisi birlikte yapılmalı — `ValidationUtil`, `ValidationConstants`'ın sabitlerini
kullanıyor, `const`'tan getter'a geçince ikisi de değişiyor.

**Dosyalar:**
- Değiştir: `lib/core/constants/validation_constants.dart`
- Değiştir: `lib/core/utils/validation_util.dart`

**4.1** Placeholder'lı anahtarları `app_tr.arb`'ye ekle. Sayı içeren mesajlar ARB
placeholder'ı kullanacak — böylece `passwordMinLength` değişince metin otomatik
güncellenir:

```json
{
  "validation_emailEmpty": "Email alanı boş olamaz",
  "validation_emailInvalid": "Geçerli bir email adresi giriniz",
  "validation_passwordEmpty": "Şifre alanı boş olamaz",
  "validation_passwordTooShort": "Şifre en az {min} karakter olmalıdır",
  "@validation_passwordTooShort": {
    "placeholders": { "min": { "type": "int" } }
  },
  "validation_passwordTooLong": "Şifre en fazla {max} karakter olabilir",
  "@validation_passwordTooLong": {
    "placeholders": { "max": { "type": "int" } }
  },
  "validation_nameEmpty": "Ad alanı boş olamaz",
  "validation_nameTooShort": "Ad en az {min} karakter olmalıdır",
  "@validation_nameTooShort": {
    "placeholders": { "min": { "type": "int" } }
  },
  "validation_nameTooLong": "Ad en fazla {max} karakter olabilir",
  "@validation_nameTooLong": {
    "placeholders": { "max": { "type": "int" } }
  },
  "validation_surnameEmpty": "Soyad alanı boş olamaz",
  "validation_surnameTooShort": "Soyad en az {min} karakter olmalıdır",
  "@validation_surnameTooShort": {
    "placeholders": { "min": { "type": "int" } }
  },
  "validation_surnameTooLong": "Soyad en fazla {max} karakter olabilir",
  "@validation_surnameTooLong": {
    "placeholders": { "max": { "type": "int" } }
  },
  "validation_protocolEmpty": "Protokol numarası boş olamaz",
  "validation_protocolTooShort": "Protokol numarası en az {min} karakter olmalıdır",
  "@validation_protocolTooShort": {
    "placeholders": { "min": { "type": "int" } }
  },
  "validation_protocolInvalid": "Protokol numarası sadece rakam içermelidir",
  "validation_passwordConfirmEmpty": "Şifre tekrarı boş olamaz",
  "validation_passwordMismatch": "Şifreler eşleşmiyor"
}
```

**4.2** `validation_constants.dart`'ı dönüştür. Sayısal sınırlar `const` kalır
(çevrilecek metin değiller), sadece mesajlar getter olur:

```dart
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';

class ValidationConstants {
  const ValidationConstants._();

  // Sayısal sınırlar — çevrilmez, const kalır
  static const int passwordMinLength = 6;
  static const int passwordMaxLength = 128;
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;
  static const int surnameMinLength = 2;
  static const int surnameMaxLength = 50;
  static const int protocolNumberMinLength = 3;
  static const int protocolNumberMaxLength = 20;
  static const String emailRegexPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Hata mesajları — çalışma zamanında çözülür
  static String get emailEmptyError => L10n.current.validation_emailEmpty;
  static String get emailInvalidError => L10n.current.validation_emailInvalid;
  static String get passwordEmptyError => L10n.current.validation_passwordEmpty;
  static String get passwordTooShortError =>
      L10n.current.validation_passwordTooShort(passwordMinLength);
  static String get passwordTooLongError =>
      L10n.current.validation_passwordTooLong(passwordMaxLength);
  static String get nameEmptyError => L10n.current.validation_nameEmpty;
  static String get nameTooShortError =>
      L10n.current.validation_nameTooShort(nameMinLength);
  static String get nameTooLongError =>
      L10n.current.validation_nameTooLong(nameMaxLength);
  static String get surnameEmptyError => L10n.current.validation_surnameEmpty;
  static String get surnameTooShortError =>
      L10n.current.validation_surnameTooShort(surnameMinLength);
  static String get surnameTooLongError =>
      L10n.current.validation_surnameTooLong(surnameMaxLength);
  static String get protocolNumberEmptyError =>
      L10n.current.validation_protocolEmpty;
  static String get protocolNumberTooShortError =>
      L10n.current.validation_protocolTooShort(protocolNumberMinLength);
  static String get protocolNumberInvalidError =>
      L10n.current.validation_protocolInvalid;
  static String get passwordConfirmationEmptyError =>
      L10n.current.validation_passwordConfirmEmpty;
  static String get passwordMismatchError =>
      L10n.current.validation_passwordMismatch;
}
```

**4.3** `validation_util.dart`'ı düzelt. Bu dosyada hem `ValidationConstants`
kullanımı hem de kendi içinde 12 hardcoded Türkçe mesaj var (`'Şifre alanı boş
olamaz'` gibi — `ValidationConstants` ile aynı metinler tekrar yazılmış). Tekrarları
sil, `ValidationConstants` getter'larına yönlendir. Bu aynı zamanda CLAUDE.md'deki
"tekrar eden kod yazma" kuralını da düzeltiyor.

**4.4** Doğrula — `const` hatası kalmamalı:

```bash
flutter analyze
```

Beklenen: `Invalid constant value` veya `Const variables must be initialized with a
constant value` hatası **olmamalı**. Varsa, o çağrı noktasında hâlâ `const` kullanımı
var demektir; `const` anahtar kelimesini kaldır.

**4.5** Commit:

```bash
git add lib/l10n/app_tr.arb lib/core/constants/validation_constants.dart lib/core/utils/validation_util.dart && git commit -m "validasyon mesajlarını l10n'a taşı, tekrarları temizle"
```

---

### Görev 5: Auth akışı

**Dosyalar:**
- `lib/features/auth/presentation/pages/login_page.dart`
- `lib/features/auth/presentation/pages/register_page.dart`
- `lib/features/auth/presentation/pages/waiting_verify_page.dart`
- `lib/features/auth/presentation/widgets/auth_verify_identity.dart`
- `lib/features/auth/presentation/viewmodel/login_viewmodel.dart`
- `lib/features/auth/presentation/viewmodel/register_viewmodel.dart`
- `lib/core/services/auth_guard.dart`

**Yöntem (bu görevden itibaren tüm görevler için aynı):**

1. Dosyayı **baştan sona oku** — grep'e güvenme.
2. Kullanıcıya görünen her string literal'i tespit et. Şu konumlar UI'dır:
   `Text(...)`, `title:`, `subTitle:`, `hintText:`, `labelText:`, `message:`,
   `primaryButtonText:`, `secondaryButtonText:`, `SnackBar` içerikleri,
   `PopupService` çağrılarındaki başlık/mesaj argümanları.
3. **Atla:** `LoggerUtil` argümanları, `debugPrint`, route adları, Firestore alan
   adları, asset yolları, `package:` importları, regex desenleri.
4. Her string için `app_tr.arb`'ye `auth_<ekran>_<eleman>` biçiminde anahtar ekle.
5. Widget'ta `AppLocalizations.of(context)!.<anahtar>`, ViewModel'de
   `L10n.current.<anahtar>` kullan.
6. `build()` metodunun başında `final l10n = AppLocalizations.of(context)!;` tanımla
   ve tekrar tekrar `AppLocalizations.of(context)!` yazma.

**Dikkat — `waiting_verify_page.dart`:** Bu dosyada önceki plandan kalan iki
`info` var (`withOpacity` deprecated, `SizedBox` yerine `Container`). Aynı
düzenlemede onları da geçerken düzelt.

**Örnek — `login_page.dart`:**

```json
{
  "auth_login_emailHint": "Email",
  "auth_login_passwordHint": "Şifre",
  "auth_login_submitButton": "Giriş Yap",
  "auth_login_registerPrompt": "Hesabın yok mu? Kayıt ol"
}
```

```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  // ...
  TextField(
    decoration: InputDecoration(hintText: l10n.auth_login_emailHint),
  ),
}
```

**Doğrula:**

```bash
flutter analyze
```

**Commit:**

```bash
git add lib/l10n/app_tr.arb lib/features/auth/ lib/core/services/auth_guard.dart && git commit -m "auth akışındaki metinleri l10n'a taşı"
```

---

### Görev 6: Admin paneli

**Dosyalar:**
- `lib/features/admin/presentation/pages/admin_home_page.dart`
- `lib/features/admin/presentation/widgets/user_card.dart`
- `lib/features/admin/presentation/viewmodel/admin_viewmodel.dart`

Görev 5'teki yöntemin aynısı, anahtar öneki `admin_`.

**Dikkat:** `user_card.dart`'ta iki `withOpacity` deprecated `info`'su var
(satır 91 ve 117). Aynı düzenlemede `.withValues(alpha: …)` olarak düzelt.

**Dikkat:** `admin_viewmodel.dart`'ta `PopupService().showSuccess(context,
"Başarılı", "Kullanıcı onaylandı.")` var. `"Başarılı"` → `l10n.common_success`
(Görev 3'te eklendi), mesaj → yeni `admin_userApproved` anahtarı.

**Doğrula + Commit:**

```bash
flutter analyze
```

```bash
git add lib/l10n/app_tr.arb lib/features/admin/ && git commit -m "admin panelindeki metinleri l10n'a taşı"
```

---

### Görev 7: Hasta akışı — sayfalar ve widget'lar

**Dosyalar:**
- `lib/features/home/presentation/pages/home_page.dart`
- `lib/features/patient/presentation/view/patient_add_page.dart`
- `lib/features/patient/presentation/view/patient_enter_data.dart`
- `lib/features/patient/presentation/view/patient_view_data.dart`
- `lib/features/patient/presentation/view/patient_all_list_page.dart`
- `lib/features/patient/presentation/view/patient_update_category_page.dart`
- `lib/features/patient/presentation/widgets/patient_info_box.dart`
- `lib/features/patient/presentation/widgets/information_box/information_box.dart`
- `lib/features/patient/presentation/widgets/patient_enter/data_list.dart`
- `lib/features/patient/presentation/widgets/patient_list/patient_list_view.dart`
- `lib/features/patient/presentation/widgets/patient_list/page_list_tile/medical_data_tile/patient_medical_data.dart`

**Dikkat — string interpolasyonu.** `patient_view_data.dart:102`'de
`title: "${cardData.name} Verileri"` var. Bu ARB placeholder'ı gerektiriyor:

```json
{
  "patient_viewData_title": "{categoryName} Verileri",
  "@patient_viewData_title": {
    "placeholders": { "categoryName": { "type": "String" } }
  }
}
```

```dart
title: l10n.patient_viewData_title(cardData.name),
```

Interpolasyonu string birleştirmeye çevirme (`l10n.x + name`) — kelime sırası
dilden dile değişir, placeholder şart.

**Dikkat — `patient_add_page.dart:86`:** `title: "Protokol\nNo"` içinde satır sonu
var. ARB'de `\n` korunur, sorun değil: `"patient_add_protocolLabel": "Protokol\nNo"`.

**Doğrula + Commit:**

```bash
flutter analyze
```

```bash
git add lib/l10n/app_tr.arb lib/features/patient/presentation/view/ lib/features/patient/presentation/widgets/ lib/features/home/ && git commit -m "hasta akışı sayfalarındaki metinleri l10n'a taşı"
```

---

### Görev 8: Hasta akışı — ViewModel'ler

**Dosyalar:**
- `lib/features/patient/presentation/viewmodel/patient_view_model.dart`
- `lib/features/patient/presentation/viewmodel/patient_add_viewmodel.dart`
- `lib/features/patient/presentation/viewmodel/patient_all_list_viewmodel.dart`
- `lib/features/patient/presentation/viewmodel/patient_enter_data_viewmodel.dart`
- `lib/features/patient/presentation/viewmodel/patient_connection_viewmodel.dart`
- `lib/features/patient/presentation/viewmodel/patient_update_category_viewmodel.dart`
- `lib/features/patient/presentation/viewmodel/patient_view_data_viewmodel.dart`

Bu dosyalarda `BuildContext` çoğunlukla yok → `L10n.current` kullan.

**Dikkat — `patient_view_data_viewmodel.dart` (Karar 6):** Bu dosya hem UI verisi
hem Excel export üretiyor. İki farklı muamele gerekiyor:

| Satır | İçerik | Ne yapılacak |
|---|---|---|
| 91 | `displayValue = "Veri Yok-0"` | **Lokalize et** → `L10n.current.common_noData` (ekranda görünüyor) |
| 134 | `sheet.cell(...).value = 'Değişken'` | **Dokunma** — Excel sütun başlığı, veri dosyasına gidiyor |
| 135 | `sheet.cell(...).value = 'Değer'` | **Dokunma** — aynı gerekçe |

Excel başlıklarının neden lokalize edilmediğini dosyaya kısa bir yorum olarak yaz ki
gelecekte biri "bu da hardcoded" diye değiştirmesin:

```dart
// Excel sütun başlıkları bilinçli olarak lokalize edilmiyor: üretilen dosya
// analiz hattına ve yayına gidiyor, sütun adları dile göre değişmemeli.
sheet.cell(CellIndex.indexByString('A1')).value = 'Değişken';
```

**Dikkat — `patient_view_data_viewmodel.dart:207`:** Bu satırda `Share` ve
`shareXFiles` deprecated `info`'su var. Aynı düzenlemede `SharePlus.instance.share()`
olarak güncelle.

**Doğrula + Commit:**

```bash
flutter analyze
```

```bash
git add lib/l10n/app_tr.arb lib/features/patient/presentation/viewmodel/ && git commit -m "hasta viewmodel'lerindeki metinleri l10n'a taşı"
```

---

### Görev 9: Data katmanı ve kalan dosyalar

**Dosyalar:**
- `lib/features/patient/data/datasources/patient_connection_remote_data_source.dart` (13)
- `lib/features/patient/data/datasources/patient_remote_data_source.dart` (10)
- `lib/features/patient/data/models/patient_connection_model.dart` (1)
- `lib/core/services/deep_link_service.dart` (1)
- `lib/shared/widgets/deep_link_test_helper.dart` (5)

**Kritik ayrım — data katmanındaki string'ler.** Bu dosyalardaki 23 Türkçe string'in
hepsi UI değil. Her birini şuna göre sınıflandır:

| Tür | Örnek | Ne yapılacak |
|---|---|---|
| Kullanıcıya gösterilen hata (`Exception` mesajı UI'a gidiyorsa) | `throw Exception('Hasta bulunamadı')` | Lokalize et |
| Sadece log'a giden | `LoggerUtil.d('Bağlantı kuruldu')` | **Dokunma** (CLAUDE.md: debug log hariç) |
| Firestore alan/koleksiyon adı | `'patient_connections'` | **Dokunma** — veri şeması |

Emin olmak için exception'ın nereye gittiğini takip et: `ErrorHandler` üzerinden
kullanıcıya gösteriliyorsa lokalize, sadece `LoggerUtil`'e gidiyorsa bırak.

**`deep_link_test_helper.dart` hakkında:** Bu bir geliştirici test aracı. Prodüksiyon
UI'ı değilse lokalize etmeye gerek yok — dosyanın başına bunu belirten bir yorum ekle
ve atla. Kullanıcıya görünen bir ekransa lokalize et. Dosyayı okuyup karar ver.

**Doğrula + Commit:**

```bash
flutter analyze
```

```bash
git add lib/l10n/app_tr.arb lib/features/patient/data/ lib/core/services/deep_link_service.dart lib/shared/ && git commit -m "data katmanındaki kullanıcıya dönük mesajları l10n'a taşı"
```

---

### Görev 10: Faz A doğrulaması

**10.1** Kalan hardcoded string taraması. Bu komut Faz A sonrası temiz çıkmalı
(sadece `categories/`, log satırları ve Excel başlıkları kalmalı):

```bash
grep -rEn "[\"'][^\"']*[çğıöşüÇĞİÖŞÜ][^\"']*[\"']" lib --include="*.dart" | grep -v "categories/" | grep -v "LoggerUtil\|debugPrint" | grep -v "l10n/"
```

Çıkan her satırı tek tek gözden geçir: ya lokalize et, ya neden atlandığını yoruma yaz.

**10.2** Statik analiz — Faz A öncesindeki 9 `info`'nun 5'i bu plan boyunca
düzeltildi (2× `withOpacity` user_card, 1× `SizedBox` waiting_verify,
2× `Share`/`shareXFiles`). Kalan 4 `info` `patient_view_data.dart` ve
`patient_update_category_page.dart` içindeki değişken adlandırma/tip sorunları:

```bash
flutter analyze
```

Beklenen: **0 error**, en fazla 4 `info`.

**10.3** Uygulamayı çalıştır ve elle doğrula. Otomatik test yok, ekran ekran gez:

```bash
flutter run
```

Sırayla kontrol et — her ekranda metinlerin **hâlâ Türkçe ve doğru** göründüğünü
doğrula (boş string veya anahtar adı görünüyorsa ARB'de eksik/yanlış anahtar var):

1. Giriş ekranı → hatalı şifreyle dene (validasyon mesajları)
2. Kayıt ekranı → boş alanlarla dene (validasyon mesajları)
3. Onay bekleme ekranı
4. Admin hesabıyla giriş → yönetici paneli, kullanıcı onay/red popup'ları
5. Hekim hesabıyla giriş → hasta listesi, boş durum, hata durumu
6. Yeni hasta ekle → başarı mesajı
7. Hasta verisi görüntüle → kategori ekranları
8. Excel dışa aktar → **sütun başlıkları `Değişken`/`Değer` kalmalı** (Karar 6)

**10.4** Faz A tamamlandı commit'i:

```bash
git add -A && git commit -m "Faz A tamamlandı: genel UI metinleri l10n'a taşındı"
```

---

## FAZ B — Klinik enum'lar (opsiyonel)

> **Faz A onaylanmadan başlama.** Faz A tek başına tam ve tutarlı bir teslimat;
> Faz B ayrı bir mimari değişiklik içeriyor ve geri alınması daha zor.

### Neden ayrı faz

Klinik etiketler (`categories/*.dart` içindeki 214 `displayText` + 65 `label`)
**domain katmanında** duruyor. CLAUDE.md domain'in saf Dart kalmasını şart koşuyor,
dolayısıyla bu dosyalara `AppLocalizations` sokulamaz. Çözüm katman değişikliği
gerektiriyor — Faz A'daki mekanik taşımadan farklı bir iş.

### Görev B1: Domain'den metni ayır

**Yaklaşım:** Enum'lar zaten `.name` ile stabil bir anahtara sahip
(`BiradsValue.c4c.name == "c4c"`). Domain sadece bu anahtarı sunar; metin
presentation'da çözülür.

**B1.1** `app_tr.arb`'ye enum değerlerini `<kategori>_<alan>_<enumAdı>` şemasıyla ekle:

```json
{
  "radiology_birads_c4c": "4C-6",
  "radiology_birads_zero": "0-1",
  "radiology_birads_five": "5-7",
  "radiology_birads_unknown": "Veri Yok-0"
}
```

**B1.2** `categories/*.dart` dosyalarındaki `displayText` extension'larını **sil**.
Domain saf Dart kalır, hiçbir import eklenmez.

**B1.3** `EnumDisplayUtil`'i anahtar tabanlı çözücüye dönüştür. 47 satırlık
`if (e is X) return e.displayText;` zinciri yerine tek bir anahtar üretimi:

```dart
static String getDisplayText(Enum e) {
  final key = '${_categoryPrefix(e)}_${e.name}';
  return _resolve(key) ?? e.name; // anahtar bulunamazsa enum adı fallback
}
```

`gen_l10n` dinamik anahtar aramayı desteklemez (her anahtar için tip güvenli getter
üretir). Bu yüzden B1.3 iki alt seçenekten birini gerektiriyor:

- **B1.3-a:** Elle yazılmış `Map<String, String Function(AppLocalizations)>` tablosu
  — tip güvenli ama 279 satırlık tablo.
- **B1.3-b:** Klinik terimler için ARB yerine ayrı bir `assets/clinical_tr.json`
  kullan ve dinamik anahtarla oku — tablo yok ama tip güvenliği yok.

**Bu seçim Faz B başlamadan yapılmalı.** Faz A'yı bitirdikten sonra tekrar değerlendir;
Faz A'nın sonuçları (ARB dosyasının boyutu, çalışma hissi) kararı kolaylaştıracak.

**B1.4** `patient_update_category_page.dart:142` ve
`patient_view_data_viewmodel.dart:94` çağrı noktalarını yeni imzaya uyarla.

**B1.5** Dropdown `'label'` girdilerini (65 adet) aynı şemayla taşı.

**Doğrulama:** Her kategori ekranını aç, tüm dropdown'ların dolu ve doğru geldiğini
kontrol et. Bir enum değeri anahtar adı olarak görünüyorsa (`c4c` gibi) ARB'de o
anahtar eksik.

---

## Kapsam dışı

| Konu | Neden |
|---|---|
| İngilizce çeviri | Ayrı iş; klinik terminoloji tıbbi doğrulama gerektiriyor |
| Dil değiştirme UI'ı | Tek dil varken anlamsız. `app_en.arb` eklendiğinde yapılacak |
| ViewModel'lerin hata kodu döndürmesi | Mimari olarak daha doğru ama 40 dosyada imza değişikliği; bu plan string çıkarma planı |
| Excel export başlıkları | Karar 6 — bilinçli olarak lokalize edilmiyor |
| `LoggerUtil` mesajları | CLAUDE.md: debug log hariç |
| Firestore alan/koleksiyon adları | Veri şeması, UI değil |

---

## Riskler

**1. `const` kırılmaları (yüksek olasılık, kolay çözüm).** `ValidationConstants`
getter'a dönünce onu `const` bağlamda kullanan her yer derleme hatası verir.
Görev 4.4'teki `flutter analyze` bunları yakalar; çözüm `const` anahtar kelimesini
kaldırmak.

**2. `L10n.current` navigator hazır olmadan çağrılırsa (düşük olasılık, net hata).**
Uygulama açılışında, `MaterialApp` build edilmeden bir ViewModel string isterse
`StateError` fırlar. Yardımcı sınıf bunu sessizce yutmak yerine açık hata veriyor —
kaçırılması zor. Böyle bir yer çıkarsa o çağrıyı widget'a taşı.

**3. Grep'in kaçırdığı string'ler (orta olasılık).** Türkçe karakter içermeyen
UI metinleri (`"Tamam"`, `"Evet"`, `"HASTA"`) grep'e takılmıyor — doğrulandı.
Azaltma: her görevde dosyayı baştan sona okumak, Görev 10.1'deki tarama, ve
Görev 10.3'teki elle ekran gezme.

**4. ARB anahtar çakışması (düşük olasılık).** İki farklı ekranda aynı anahtar
kullanılırsa `gen_l10n` sessizce sonuncuyu alır. Azaltma: `<alan>_<ekran>_<eleman>`
şeması (Karar 3) ve `flutter pub get` sonrası üretilen dosyada anahtar sayısının
ARB'deki ile eşleştiğini kontrol.

**5. Faz B'de tip güvenliği kaybı (orta).** B1.3-b seçilirse dinamik anahtar
aramada yazım hatası derleme zamanında yakalanmaz, çalışma zamanında fallback
olarak enum adı görünür. B1.3-a bunu önler ama 279 satır tablo maliyeti var.

---

## Tahmini süre

| Faz | Süre |
|---|---|
| Görev 1-2 (altyapı) | 20-30 dk |
| Görev 3-4 (ortak + validasyon) | 30-40 dk |
| Görev 5-9 (string çıkarma) | 70-90 dk |
| Görev 10 (doğrulama) | 20-30 dk |
| **Faz A toplam** | **2,5 - 3 saat** |
| Faz B | 1 - 1,5 saat |

---

## Uygulama session'ına devir notu

Bu planı uygulayacak session için:

1. `git status` temiz mi kontrol et. Değilse önce commit/stash.
2. Görevler **sırayla** yapılmalı — Görev 3'teki ortak anahtarlar sonraki
   görevlerde kullanılıyor.
3. Her görev sonunda `flutter analyze` çalıştır ve commit at. Bir görev bozulursa
   tek commit geri alınır.
4. **Karar 1'i (gen_l10n vs easy_localization) uygulamaya başlamadan teyit et.**
   Değişirse Görev 1-2 baştan yazılmalı.
5. **Faz B'ye Faz A onaylanmadan geçme.** B1.3'teki alt seçim (a mı b mi) Faz A
   bittikten sonra yapılacak.
