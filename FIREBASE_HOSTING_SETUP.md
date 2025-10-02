# 🚀 Firebase Hosting ile Universal Links Kurulum Kılavuzu

Bu kılavuz, `myapp://` yerine **HTTPS linkleri** (`https://your-app.web.app/addPatient?id=XXX`) kullanmanızı sağlar.

## ✅ Avantajlar

- ✅ WhatsApp'ta link önizlemesi
- ✅ Profesyonel görünüm
- ✅ Ücretsiz Firebase Hosting
- ✅ HTTPS güvenliği
- ✅ Uygulama yoksa web sayfası açılır

---

## 📋 Kurulum Adımları

### 1. Firebase CLI Yükleyin (Eğer yoksa)

```powershell
npm install -g firebase-tools
```

### 2. Firebase'e Giriş Yapın

```powershell
firebase login
```

### 3. Firebase Projesini Başlatın

```powershell
cd C:\Projects\FlutterProjects\MedicalDataApp\flutter_medical_data_app
firebase init hosting
```

**Sorular:**
- ✅ Use an existing project → `medical-app-2c545` seçin
- ✅ What do you want to use as your public directory? → `public`
- ✅ Configure as a single-page app? → `No`
- ✅ Set up automatic builds? → `No`
- ⚠️ Overwrite index.html? → `No` (HAYIR! Bizim hazırladığımız var)

### 4. SHA-256 Fingerprint Alın

Android debug keystore için:

```powershell
cd $env:USERPROFILE\.android
keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Release keystore için** (Üretim):
```powershell
keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
```

**Çıktıda arayın:**
```
SHA256: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99
```

### 5. SHA-256'yı assetlinks.json'a Ekleyin

`public/.well-known/assetlinks.json` dosyasını açın:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.flutter_medical_data_app",
      "sha256_cert_fingerprints": [
        "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"
      ]
    }
  }
]
```

**Not:** Hem debug hem release için fingerprint ekleyebilirsiniz (virgülle ayırın)

### 6. Firebase'e Deploy Edin

```powershell
firebase deploy --only hosting
```

**Çıktı:**
```
✔  Deploy complete!

Hosting URL: https://medical-app-2c545.web.app
```

### 7. Firebase Domain'i AndroidManifest.xml'e Ekleyin

`android/app/src/main/AndroidManifest.xml` dosyasında:

```xml
<data 
    android:scheme="https" 
    android:host="medical-app-2c545.web.app"
    android:pathPrefix="/addPatient" />
```

**Not:** `medical-app-2c545.web.app` yerine **kendi domain'inizi** yazın!

---

## 🧪 Test Etme

### 1. Link Formatı

**Eski (Custom Scheme):**
```
myapp://addPatient?id=9DMLIqXVUesGdgrJLCb8
```

**Yeni (HTTPS Universal Link):**
```
https://medical-app-2c545.web.app/addPatient?id=9DMLIqXVUesGdgrJLCb8
```

### 2. WhatsApp'ta Test

1. WhatsApp'ı açın
2. Kendinize mesaj gönderin:
   ```
   https://medical-app-2c545.web.app/addPatient?id=TEST123
   ```
3. Link'e tıklayın
4. Android: "Medical Data App ile aç" seçeneği göreceksiniz ✅

### 3. Chrome'da Test

Android cihazınızda Chrome'u açın:
```
https://medical-app-2c545.web.app/addPatient?id=TEST456
```

### 4. ADB ile Test

```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://medical-app-2c545.web.app/addPatient?id=TEST789"
```

---

## 🔧 Sorun Giderme

### App Links çalışmıyor

1. **assetlinks.json kontrolü**
   ```
   https://medical-app-2c545.web.app/.well-known/assetlinks.json
   ```
   Bu link tarayıcıda açılmalı ve JSON görünmeli ✅

2. **SHA-256 doğrulama**
   ```powershell
   keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android
   ```
   Fingerprint, assetlinks.json'daki ile aynı mı?

3. **Package name kontrolü**
   - AndroidManifest.xml → `<manifest package="...">`
   - assetlinks.json → `"package_name": "..."`
   - İkisi aynı olmalı!

4. **Domain kontrolü**
   - AndroidManifest.xml → `android:host="..."`
   - Firebase Hosting URL ile aynı olmalı!

5. **Android cache temizle**
   ```bash
   adb shell pm clear com.example.flutter_medical_data_app
   ```

### Link web sayfası açıyor, uygulama açmıyor

**Sebep:** `autoVerify="true"` çalışmıyor

**Çözüm 1:** Manuel doğrulama
```bash
adb shell am start -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://medical-app-2c545.web.app/addPatient?id=TEST"
```

**Çözüm 2:** App Link testi
```bash
adb shell dumpsys package domain-preferred-apps
```

**Çözüm 3:** Varsayılan uygulama ayarla
- Android Ayarlar → Apps → Medical Data App
- Set as default → Supported web addresses

---

## 📊 Her İki Yöntemi Kullanma

**İyi haber:** Hem `myapp://` hem `https://` aynı anda çalışır!

```dart
// deep_link_service.dart zaten ikisini de destekliyor
if (uri.scheme == 'myapp' && uri.host == 'addPatient') {
  // Custom scheme
} else if (uri.scheme == 'https' && uri.path.contains('addPatient')) {
  // Universal link
}
```

**Kullanım:**
- Dahili paylaşım → `myapp://` (hızlı)
- WhatsApp/Harici → `https://` (profesyonel)

---

## 🎯 Özel Domain Kullanma (Opsiyonel)

Eğer `medical-app-2c545.web.app` yerine `medicalapp.com` kullanmak isterseniz:

### 1. Domain Satın Alın
- Örnek: GoDaddy, Namecheap

### 2. Firebase'e Ekleyin
```powershell
firebase hosting:channel:deploy production
```

Firebase Console → Hosting → Add custom domain

### 3. DNS Kayıtları Ekleyin
Firebase size A ve TXT kayıtları verecek

### 4. AndroidManifest.xml Güncelleyin
```xml
<data 
    android:scheme="https" 
    android:host="medicalapp.com"
    android:pathPrefix="/addPatient" />
```

### 5. assetlinks.json'ı yeniden deploy edin
```powershell
firebase deploy --only hosting
```

---

## 📱 Sonuç

Artık şu linkleri kullanabilirsiniz:

**Custom Scheme (Dahili):**
```
myapp://addPatient?id=ABC123
```

**Universal Link (Profesyonel):**
```
https://medical-app-2c545.web.app/addPatient?id=ABC123
```

**WhatsApp'ta:**
- ✅ Link önizlemesi gösterir
- ✅ "Medical Data App" başlığı
- ✅ Tıklanınca uygulama açılır
- ✅ Uygulama yoksa web sayfası açılır

**Ücretsiz:** Firebase Hosting spark planı 10GB/ay ücretsiz!

---

## 🚀 Hızlı Başlangıç (TL;DR)

```powershell
# 1. Firebase CLI
npm install -g firebase-tools

# 2. Login
firebase login

# 3. Init
firebase init hosting

# 4. SHA-256 al
keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

# 5. SHA-256'yı public/.well-known/assetlinks.json'a ekle

# 6. Deploy
firebase deploy --only hosting

# 7. Test
# WhatsApp'ta: https://YOUR-PROJECT.web.app/addPatient?id=TEST
```

**Done! ✅**
