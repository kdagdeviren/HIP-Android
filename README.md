# Medikal App

# Firebase Kurulumu

1.  **Firebase Console**'a gidip yeni bir proje oluşturun.
2.  **Authentication** bölümünü etkinleştirin ve **E-posta/Şifre** Ve **Google Girişi** sağlayıcısını seçin.
3.  **Firestore Database**'i "test modu"nda oluşturun.
4.  **Firebase Messaging**'i aktif edin.
5.  FlutterFire CLI'yı yükleyin:
    ```bash
    dart pub global activate flutterfire_cli
    ```
6.  Proje dizininde `flutterfire configure` komutunu çalıştırın ve Firebase projenizi seçin.

---

## 🔒 Güvenlik Notları

* **SHA Anahtarları:** `flutterfire configure` komutunu çalıştırdıktan sonra Firebase konsolunuzda **Proje Ayarları > Uygulamalarınız** altında **SHA-1** ve **SHA-256** anahtarlarınızı eklemeyi unutmayın. Bu, Google ile Oturum Açma gibi hizmetler için gereklidir. Geliştirme anahtarlarınızı almak için:
    ```bash
    cd android && ./gradlew signingReport
    ```
