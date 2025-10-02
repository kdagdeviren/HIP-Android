# Deep Link Kullanım Kılavuzu

Bu uygulama artık deep link (derin bağlantı) özelliğini desteklemektedir.

## 🔗 Deep Link Nedir ve Nasıl Çalışır?

**Custom URL Scheme**: `myapp://` sizin uygulamanıza özel bir protokoldür. İşletim sistemi bu protokolü gördüğünde, otomatik olarak uygulamanızı açar.

### WhatsApp'ta Paylaşım Örneği:

```
Kullanıcı 1 → "myapp://addPatient?id=ABC123" linkini gönderir
Kullanıcı 2 → Link'e tıklar
Telefon → "Medical Data App ile açılsın mı?" diye sorar
Kullanıcı → Onaylar
Uygulama → Açılır ve ID otomatik yüklenir ✅
```

**Önemli:** `myapp://` protokolü WhatsApp, SMS, E-posta, tarayıcı vb. her yerden çalışır!

## Deep Link Formatı

```
myapp://addPatient?id=HASTA_ID
```

Örnek:
```
myapp://addPatient?id=9DMLIqXVUesGdgrJLCb8
```

### Protokol Açıklaması:
- **myapp://** → Sizin uygulamanızın kayıtlı protokolü (AndroidManifest.xml'de tanımlı)
- **addPatient** → Hangi özelliğin açılacağı (host)
- **?id=XXX** → Parametre (hasta ID'si)

## Nasıl Çalışır?

1. **Link Oluşturma**: Yukarıdaki formatta bir link oluşturun
2. **Link Açma**: Link'e tıklandığında uygulama otomatik olarak açılır
3. **ID Doldurma**: Hasta ID otomatik olarak "Hasta Ekle" ekranındaki ID alanına yazılır
4. **Navigation**: Uygulama `/patient-all-list` sayfasına yönlendirilir

## Android'de Test Etme

### 1. ADB ile Test (Emulator veya Fiziksel Cihaz)

```bash
adb shell am start -W -a android.intent.action.VIEW -d "myapp://addPatient?id=9DMLIqXVUesGdgrJLCb8" com.example.flutter_medical_data_app
```

### 2. Chrome Browser'dan Test

Android cihazınızda Chrome'u açın ve adres çubuğuna yazın:
```
myapp://addPatient?id=9DMLIqXVUesGdgrJLCb8
```

### 3. SMS veya Mesaj Uygulamalarından

Link'i herhangi bir mesaj uygulamasına yapıştırın ve link'e tıklayın.

## Windows'ta Test Etme

Windows platformunda deep link'ler farklı çalışır. `app_links` paketi Windows için de destek sunar.

### Windows Registry Ayarları

Uygulamanız Windows'ta ilk çalıştırıldığında `myapp://` protokolü otomatik olarak kaydedilecektir.

## iOS'ta Test Etme (Gelecekte)

iOS için `ios/Runner/Info.plist` dosyasına eklenmesi gereken ayarlar:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>com.example.flutterMedicalDataApp</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>myapp</string>
    </array>
  </dict>
</array>
```

## Uygulama İçi Test Widget'ı

`DeepLinkTestHelper` widget'ını kullanarak uygulama içinden link oluşturabilir ve paylaşabilirsiniz:

```dart
import 'package:flutter_medical_data_app/shared/widgets/deep_link_test_helper.dart';

// AppBar'a ekleyin:
AppBar(
  actions: [
    DeepLinkTestHelper(),
  ],
)
```

## Sorun Giderme

### Link çalışmıyor
1. Uygulamanın yüklü olduğundan emin olun
2. AndroidManifest.xml'de intent-filter'ın doğru eklendiğini kontrol edin
3. Uygulama şemasının (`myapp://`) doğru olduğunu kontrol edin

### ID alanı dolmuyor
1. Debug console'da "Deep link received" mesajını kontrol edin
2. Navigation service'in düzgün başlatıldığından emin olun
3. PatientAllListPage'in mounted olduğundan emin olun

## Kod Yapısı

- `lib/core/services/deep_link_service.dart`: Deep link işleme servisi
- `lib/features/patient/presentation/view/patient_all_list_page.dart`: Link'ten gelen ID'yi alan sayfa
- `lib/shared/widgets/deep_link_test_helper.dart`: Test yardımcı widget'ı
- `android/app/src/main/AndroidManifest.xml`: Android deep link yapılandırması

## Package Bilgisi

- **app_links**: ^6.3.4 - Modern deep linking paketi (uni_links'in yerini aldı)

---

## 🎯 İleri Seviye: Universal Links (Opsiyonel)

Eğer `myapp://` yerine **gerçek bir domain** kullanmak isterseniz:

### Universal Link Örneği:
```
https://medicalapp.com/addPatient?id=9DMLIqXVUesGdgrJLCb8
```

### Avantajları:
- ✅ WhatsApp'ta link önizlemesi gösterir
- ✅ Daha profesyonel ve güvenilir görünür
- ✅ Uygulama yüklü değilse web sitesine yönlendirir
- ✅ SEO ve paylaşım için daha iyi

### Gereksinimleri:
- Kendi domain'iniz olmalı (örn: medicalapp.com)
- HTTPS desteği gerekli
- `.well-known/assetlinks.json` (Android) dosyası
- `.well-known/apple-app-site-association` (iOS) dosyası
- Server yapılandırması

### Şimdilik Neden Custom Scheme?
- ✅ Hızlı ve kolay kurulum
- ✅ Domain satın almaya gerek yok
- ✅ Server yapılandırması yok
- ✅ Dahili kullanım için yeterli
- ⚠️ Sadece uygulama yüklüyse çalışır

## 💡 Hangi Yöntemi Seçmeli?

| Özellik | Custom Scheme (myapp://) | Universal Link (https://) |
|---------|--------------------------|---------------------------|
| **Kurulum** | ✅ Çok Kolay | ⚠️ Karmaşık |
| **Maliyet** | ✅ Ücretsiz | ⚠️ Domain + Server |
| **WhatsApp Önizleme** | ❌ Yok | ✅ Var |
| **Profesyonellik** | ⚠️ Teknik görünür | ✅ Kullanıcı dostu |
| **Fallback (Web)** | ❌ Yok | ✅ Var |
| **Dahili Kullanım** | ✅ Mükemmel | ⚠️ Fazla karmaşık |

**Öneri:** Şimdilik `myapp://` kullanın. İlerleyen zamanlarda ihtiyaç olursa Universal Link'e geçiş yapabilirsiniz.
