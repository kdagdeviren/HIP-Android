# Akademik İnceleme Düzeltmeleri — Uygulama Planı

**Tarih:** 2026-07-27
**Bağlam:** Depo, gönderilecek bir akademik makaleye (SPE/Wiley) konu. Başka bir YZ
modeli (Opus) depoyu klonlayıp makale iddiaları ile kod arasındaki tutarlılığı
incelemiş. Bu plan, o incelemede çıkan bulguların hangilerinin gerçek/kritik olduğunu
(bu oturumda koddan doğrulandı) ve nasıl kapatılacağını içerir.

**Önceki planlar:** [2026-07-26-guvenlik-ve-yayin-hazirligi.md](2026-07-26-guvenlik-ve-yayin-hazirligi.md),
[2026-07-27-kalan-isler.md](2026-07-27-kalan-isler.md) — güvenlik tarafı (anahtar iptali,
kural deploy'u, git geçmişi temizliği, migration) o planlarda tamamlanmış durumda,
burada tekrar edilmiyor.

---

## Önce yapılması gereken tek şey: push

Bu depoda 15 commit `origin/main`'in üstünde duruyor (l10n altyapısı, Faz A/B çevirisi,
İngilizce çeviri + dil değiştirme ekranı, `LoggerUtil` release-mode kapatma, README
TR/EN ayrımı). Opus'un incelediği GitHub kopyası bunları içermiyor — "çift dilli arayüz
iddiası yanlış" bulgusu bu yüzden çıktı, aslında artık doğru.

```bash
git push
```

Bunu yapmadan aşağıdaki maddelerin bir kısmı (özellikle Görev 4) zaten çözülmüş
görünecek ama GitHub'da görünmeyecek.

---

## Bulguların durumu (bu oturumda koddan doğrulandı)

| # | Bulgu | Durum | Kanıt |
|---|---|---|---|
| 1 | Hasta kimliği (`firstName`/`lastName`/`protocolNo`) klinik verilerle aynı dokümanda | **Gerçek** | `patient_model.dart` — `toMap()` üçünü de aynı yere yazıyor |
| 2 | "20 karakterlik benzersiz kod" = Firestore auto-ID | **Gerçek** | `patient_remote_data_source.dart:53` — `docRef.id` |
| 3 | AES-256/JWT kodda yok | **Gerçek** | `pubspec.yaml` + `lib/` genelinde kripto bağımlılığı sıfır |
| 4 | Çift dilli arayüz yok | **Artık yanlış** | TR/EN bu oturumda eklendi, push edilince kapanır |
| 5 | `docs/plans/` içinde service account e-postası + proje ID açık metin | **Gerçek** | 2 dosyada `firebase-adminsdk-fbsvc@medical-app-2c545...` geçiyor |
| 6 | Uygulama katmanında test yok | **Gerçek** | `test/` altında yalnızca 1 model testi + varsayılan widget testi |
| 7 | Güvenlik "Aktif/Uyumlu" ama Aralık 2025–Temmuz 2026 arası kurallar deploy değildi | **Gerçek, geri alınamaz** | `2026-07-27-kalan-isler.md` kendi devir notu |
| 8 | Gerçek hasta verisi toplanmış mı belirsizliği | **Kısmen çözüldü** | Kullanıcı: mevcut 43 kayıt test verisiydi. Makalenin ne iddia ettiği ayrı soru |
| 9 | Paket adı `flutter_medical_data_app` vs makaledeki "HİP" | **Gerçek, düşük öncelik** | ~100+ dosyada import değişikliği gerektirir |

---

## Kararlar (uygulama session'ında yeniden tartışılmasın diye)

| # | Konu | Karar | Gerekçe |
|---|---|---|---|
| 1 | Kimlik/klinik veri ayrımı | **Karar B** — `Patient` dokümanını olduğu gibi bırak, makaledeki "kimlik asla klinik kayıtla birlikte gömülmez" cümlesini "erişim denetimli, tek doküman içinde tutulan hasta kaydı" şeklinde düzelt | Gerçek ayrıştırma (Karar A) mimari değişiklik + migration + tüm okuma/yazma yollarının güncellenmesi demek; kapsamı bu planın çok üstünde. Metni gerçeğe uydurmak çok daha az riskli |
| 2 | AES-256/JWT iddiası | Metinden çıkar, yerine Firebase'in sağladığı gerçek garantileri yaz (aktarımda TLS, Firestore'un yönetilen at-rest şifrelemesi, Firebase Auth ID token) | Kod tarafında gerçek şifreleme eklemek (alan bazlı encrypt) ayrı, büyük bir iş; kısa vadede metni düzeltmek yeterli ve dürüst |
| 3 | "20 karakterlik benzersiz kod" | Metinde "Firestore'un otomatik ürettiği belge kimliği" olarak düzelt, "garanti benzersizlik" yerine "çarpışma olasılığı ihmal edilebilir düzeyde" yaz | Teknik doğruluk |
| 4 | Test verisi / etik beyan | Bu plan kapsamında **yalnızca** kod/repo tarafı ele alınır. Makalenin veri toplama cümlesinin gerçeğe uyup uymadığı yazarların kararı — bu plan bunu çözemez | Ben (asistan) makale metnini görmüyorum |
| 5 | Paket adı yeniden adlandırma | **Yapılmayacak** (bu plan kapsamında) | ~100+ dosyada import satırı değişir, risk/fayda oranı düşük. Ayrı bir iş kalemi olarak not düşülür |

---

## Görev 1: Commit'leri push et

```bash
git push
```

**Doğrula:** `git log origin/main..HEAD --oneline` boş dönmeli.

---

## Görev 2: `docs/plans/` içindeki gerçek bilgileri temizle

**Dosyalar:**
- `docs/plans/2026-07-26-guvenlik-ve-yayin-hazirligi.md`
- `docs/plans/2026-07-27-kalan-isler.md`

**2.1** Her iki dosyada da geçen
`firebase-adminsdk-fbsvc@medical-app-2c545.iam.gserviceaccount.com` ifadesini
`firebase-adminsdk-fbsvc@<proje-id>.iam.gserviceaccount.com` ile değiştir (placeholder).

**2.2** Aynı dosyalarda geçen `medical-app-2c545` proje ID'sinin diğer geçişlerini de
tara ve `<proje-id>` ile değiştir:

```bash
grep -rn "medical-app-2c545" docs/plans/
```

Çıkan her satırı elle kontrol edip placeholder'a çevir.

**2.3** Doğrula:

```bash
grep -rn "medical-app-2c545\|iam.gserviceaccount" docs/plans/
```

Sıfır sonuç dönmeli.

**2.4** Commit:

```bash
git add docs/plans/2026-07-26-guvenlik-ve-yayin-hazirligi.md docs/plans/2026-07-27-kalan-isler.md
git commit -m "plan dosyalarındaki proje kimlik bilgilerini placeholder ile değiştir"
```

---

## Görev 3: Makale metni düzeltmeleri (kod dışı, yazarlara devir notu)

Bu görev kodda değil, makale dosyasında yapılacak. Bu plana referans olması için
buraya net madde madde yazılıyor — makale dosyasının kendisi bu depoda değilse bu
görevü atla ve maddeleri doğrudan makale yazarına ilet.

- **§2.3 kimliksizleştirme cümlesi** → Karar 1'e göre yeniden yaz: hasta kimliği ile
  klinik verinin **erişim denetimli tek dokümanda** tutulduğu, ayrı depolanmadığı
  açıkça belirtilsin.
- **Tablo 1, "Benzersizlik: Garanti (%100)"** → Karar 3'e göre "Firestore otomatik
  belge kimliği, çarpışma olasılığı ihmal edilebilir düzeyde" olarak düzelt.
- **§2.7 / Tablo 4, AES-256 ve JWT satırları** → Karar 2'ye göre kaldır veya Firebase'in
  gerçekte sağladığı güvenceyle değiştir (TLS aktarım şifrelemesi, Firestore yönetilen
  at-rest şifreleme, Firebase Auth ID token doğrulaması).
- **Tablo 4, güvenlik durumu "Aktif/Uyumlu"** → Kuralların ne zamandan beri deploy
  olduğu (tarih) eklensin; Aralık 2025 lansmanı ile kural deploy tarihi arasındaki
  farkın makalede belirtilmesi önerilir.
- **Tablo 3, "yönetici incelemesi ortalama 1-3 iş günü"** → Bu rakamın kaynağı
  (gerçek ölçüm mü, tasarım hedefi mi) belirtilsin; kaynaksızsa "tasarım hedefi"
  olarak işaretlensin.
- **KVKK/GDPR "Uyumlu"** → DPIA, veri işleme envanteri, saklama/silme politikası ve
  veri sahibi hakları mekanizması yoksa "Uyumlu" yerine "uyum çalışması planlanıyor"
  gibi bir ifadeye çekilsin.
- **§2.8 çift dil iddiası** → Artık doğru (bu plan + önceki oturumdaki l10n işi
  sayesinde), değişiklik gerekmiyor — sadece push edildiğinden emin ol (Görev 1).
- **Performans ölçümü ("< 2 saniye")** → Cihaz modeli, tekrar sayısı, ortalama/sapma
  eklenmeden bırakılırsa hakem itirazına açık; mümkünse ölçüm tekrarlanıp rapor edilsin.

---

## Görev 4: Test kapsamını genişlet (opsiyonel ama önerilir)

**Mevcut durum:** `test/features/patient/patient_model_test.dart` dışında uygulama
katmanında test yok. `test/firestore_rules/` altındaki 38 kural testi zaten var ve
iyi durumda — bu görev onlara dokunmuyor.

**4.1** En azından şu üç noktada birim testi ekle (öncelik sırasıyla):

- `lib/core/utils/validation_util.dart` — saf fonksiyonlar, test yazması en kolay ve
  en yüksek değerli yer. `ValidationUtil.isValidEmail`, `isValidPassword`,
  `isValidProtocolNumber`, `doPasswordsMatch` için pozitif/negatif senaryolar.
- `lib/core/utils/enum_display_util.dart` — `getDisplayText` için her enum tipinden
  en az bir örnek, `getFieldLabel` için bilinen bir `categoryKey`/`fieldKey` çifti ve
  bilinmeyen bir çift (fallback davranışı).
- `lib/features/patient/domain/entities/categories/*.dart` — her `toMap`/`fromMap`
  çiftinin round-trip testi (bir nesneyi `toMap()` yapıp `fromMap()` ile geri
  okuyunca aynı değerlerin çıktığını doğrula).

**4.2** Dosya konumu: `test/core/utils/validation_util_test.dart`,
`test/core/utils/enum_display_util_test.dart`,
`test/features/patient/domain/entities/categories/` altında kategori başına dosya.

**4.3** Doğrula:

```bash
flutter test
```

Tüm testler geçmeli, mevcut `patient_model_test.dart` da dahil.

**4.4** Commit — her test dosyası kendi commit'i olabilir ya da tek seferde:

```bash
git add test/
git commit -m "temel doğrulama ve enum yardımcıları için birim test ekle"
```

---

## Görev 5: Reprodüksiyon/versiyonlama (opsiyonel, makale "canlı repo linki" veriyorsa önerilir)

**5.1** Bir git tag at, gönderim anındaki hâli sabitlensin:

```bash
git tag -a v1.0.0-submission -m "Makale gönderimi anındaki durum"
git push origin v1.0.0-submission
```

**5.2** Kısa bir `CHANGELOG.md` ekle (kök dizine), en azından şu iki satırla başlasın:

```markdown
# Changelog

## v1.0.0-submission (2026-07-27)
- Güvenlik sıkılaştırması tamamlandı (kurallar, admin claim, anahtar rotasyonu)
- TR/EN çift dil desteği eklendi
```

**5.3** Commit:

```bash
git add CHANGELOG.md
git commit -m "CHANGELOG ekle, gönderim sürümünü etiketle"
```

**5.4** (Opsiyonel, Zenodo hesabın varsa) GitHub reposunu Zenodo'ya bağlayıp tag'den
otomatik DOI üret — bu adım depo dışında, Zenodo arayüzünden yapılır.

---

## Kapsam dışı (bu planda ele alınmıyor)

| Konu | Neden |
|---|---|
| Paket adının `flutter_medical_data_app`'ten değiştirilmesi | Karar 5 — maliyet/fayda düşük |
| Gerçek alan-bazlı şifreleme (AES) eklenmesi | Karar 2 — metni düzeltmek yeterli, kod değişikliği ayrı büyük iş |
| Kimlik/klinik veri ayrıştırması (ayrı koleksiyon) | Karar 1 — mimari değişiklik, ayrı plan gerektirir |
| FCM'in Cloud Function'a taşınması | Önceki planda zaten kapsam dışı bırakılmıştı |
| Makale metninin kendisinin düzenlenmesi | Bu depoda değilse asistan erişemez; Görev 3 yalnızca yazarlara devir notu |

---

## Uygulama sırası

```
Görev 1 (push)  ──►  Görev 2 (plan dosyalarını temizle)  ──►  Görev 3 (makale metni, yazarlara devir)
                                                                        │
                                                          Görev 4 (testler, opsiyonel)
                                                                        │
                                                          Görev 5 (versiyonlama, opsiyonel)
```

Görev 1 ve 2 birkaç dakika sürer ve ertelenemez — hakem/okuyucu depoyu şu an klonlarsa
Görev 2 yapılmadığı sürece proje kimlik bilgilerini görür. Görev 4 ve 5 opsiyonel,
zaman durumuna göre atlanabilir.
