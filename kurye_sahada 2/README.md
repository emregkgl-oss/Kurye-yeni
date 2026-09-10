# Kurye Sahada 🚚

**"Bu durumla karşılaşsaydın ne yapardın?"**

Saha kuryelerinin gerçek müşteri/operasyon vakalarına yazılı cevap vererek
iletişim becerilerini geliştirdiği, offline çalışan bir Flutter eğitim uygulaması.

---

## ⚠️ Bu paket hakkında önemli not

Bu klasör **`lib/`, `assets/` ve `pubspec.yaml`** içeren tam, çalışır bir Dart/Flutter
kaynak kodudur — ancak Android'e özgü `android/` klasörü (Gradle yapılandırması vb.)
**dahil değildir**, çünkü bu klasör normalde `flutter create` komutuyla,
Flutter SDK kurulu bir makinede otomatik üretilir. Aşağıdaki adımları izleyerek
bunu 2 dakikada kendi bilgisayarınızda tamamlayabilirsiniz.

---

## 1) Flutter SDK Kurulumu (bir kere)

- https://docs.flutter.dev/get-started/install adresinden işletim sisteminize
  uygun Flutter SDK'yı indirin.
- Kurulumu doğrulayın:

```bash
flutter doctor
```

Android Studio veya en azından Android SDK / komut satırı araçlarının kurulu
olduğundan emin olun (`flutter doctor` size eksikleri gösterir).

---

## 2) Projeyi Hazırlama

Bu klasörün İÇİNDE, yani `kurye_sahada/` dizininde:

```bash
# 1. Android/iOS platform klasörlerini otomatik oluştur
flutter create --org com.kuryesahada --project-name kurye_sahada .

# ⚠️ Bu komut lib/main.dart ve pubspec.yaml'ın üzerine kendi şablonunu
# yazabilir. Bu yüzden komuttan ÖNCE lib/, assets/ ve pubspec.yaml'ı
# yedekleyin, komuttan SONRA geri kopyalayın. Örnek:

cp -r lib lib_backup
cp -r assets assets_backup
cp pubspec.yaml pubspec_backup.yaml

flutter create --org com.kuryesahada --project-name kurye_sahada .

rm -rf lib assets pubspec.yaml
mv lib_backup lib
mv assets_backup assets
mv pubspec_backup.yaml pubspec.yaml
```

```bash
# 2. Bağımlılıkları indir
flutter pub get
```

---

## 3) Çalıştırma (geliştirme / test)

Bir Android telefon (USB hata ayıklama açık) veya emülatör bağlayın:

```bash
flutter devices      # bağlı cihazları listeler
flutter run
```

---

## 4) APK Oluşturma

### Debug APK (hızlı test için)

```bash
flutter build apk --debug
```

Çıktı: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (yayın/dağıtım için, daha küçük ve optimize)

```bash
flutter build apk --release
```

Çıktı: `build/app/outputs/flutter-apk/app-release.apk`

> Not: Release APK'yı Play Store'a yüklemeyi planlıyorsanız,
> `android/app/build.gradle` içine kendi imzalama (signing) anahtarınızı
> eklemeniz gerekir (Flutter belgelerinde "Sign the app" bölümü).

### Bölünmüş APK (daha küçük dosya boyutu, cihaz mimarisine göre)

```bash
flutter build apk --split-per-abi
```

---

## ☁️ Bulut Üzerinden Otomatik APK Alma (GitHub Actions) — Flutter kurmadan

Bu proje `.github/workflows/build.yml` dosyasıyla birlikte gelir. Bu dosya,
GitHub'a her kod push ettiğinizde **otomatik olarak Flutter'ı kurar,
projeyi derler ve size indirilebilir bir Release APK üretir** — bilgisayarınıza
hiçbir şey kurmadan.

### Adım adım kurulum

1. **GitHub hesabı açın** (yoksa): https://github.com/signup

2. **Yeni bir repo oluşturun**: sağ üstteki `+` → *New repository* →
   isim verin (örn. `kurye-sahada`) → *Create repository*.

3. **Bu proje klasörünü o repoya yükleyin.** İki yol var:

   **A) Web arayüzünden (kod bilmeden, en kolay):**
   - Repo sayfasında *"uploading an existing file"* linkine tıklayın.
   - Bu zip'in İÇİNDEKİ tüm dosya ve klasörleri (lib/, assets/, .github/,
     pubspec.yaml, README.md — zip'in kendisini değil, açılmış içeriğini)
     sürükleyip bırakın.
   - *Commit changes* butonuna basın.

   **B) Git komut satırından (varsa git kurulu):**
   ```bash
   cd kurye_sahada
   git init
   git add .
   git commit -m "İlk yükleme"
   git branch -M main
   git remote add origin https://github.com/KULLANICI_ADINIZ/kurye-sahada.git
   git push -u origin main
   ```

4. **Derlemeyi izleyin:** Repo sayfasında üstteki **Actions** sekmesine
   girin. "Build APK" adında bir işlemin otomatik başladığını göreceksiniz
   (yaklaşık 5-8 dakika sürer, sarı nokta → yeşil tik olur).

5. **APK'yı indirin:** İşlem bittiğinde (yeşil tik), o işlemin sayfasına
   tıklayın, en altta **Artifacts** bölümünde `kurye-sahada-apk` adında bir
   zip göreceksiniz. İndirin, içinden `app-release.apk` çıkacak.

6. **Telefona kurun:** APK'yı telefonunuza aktarın (Google Drive, WhatsApp
   kendine gönderme, USB kablo vb.), dosya yöneticisinden açıp kurun.
   Telefonunuzda "Bilinmeyen kaynaklardan yükleme" izni istenirse onaylayın.

> İşlem her başarısız olduğunda Actions sekmesindeki kırmızı çarpıya
> tıklayarak hata loglarını görebilirsiniz — bir sorun olursa logu bana
> yapıştırmanız yeterli, birlikte çözeriz.

---

## Proje Yapısı

```
lib/
  main.dart                      # Giriş noktası, Hive init, tema
  models/                        # Veri modelleri (Case, Evaluation, Progress, Badge)
  services/
    case_service.dart            # assets/cases.json yükleme
    badge_service.dart           # Rozet açma mantığı
    evaluation/
      evaluation_engine.dart     # Soyut arayüz
      demo_keyword_engine.dart   # ✅ Şu anki: anahtar kelime bazlı demo motor
  repositories/
    progress_repository.dart     # Hive local storage (offline-first)
  providers/
    app_providers.dart           # Riverpod state yönetimi
  screens/                       # 8 ekran (Ana Sayfa, Vakalar, Detay, Sonuç,
                                  # Gelişimim, Başarılar, Liderlik, Profil)
  widgets/                       # Yeniden kullanılabilir bileşenler
  theme/
    app_theme.dart               # Yeşil/beyaz/gri, kart tabanlı tema
assets/
  cases.json                     # İlk 10 saha vakası
```

## Gelecekte Gerçek AI Entegrasyonu

Şu anki değerlendirme `DemoKeywordEvaluationEngine` ile anahtar kelime
bazlı çalışıyor. Gerçek bir AI API'sine geçmek için:

1. `lib/services/evaluation/` içine `remote_ai_engine.dart` adında yeni bir
   sınıf oluşturup `EvaluationEngine` arayüzünü implemente edin (API
   çağrısını **kendi backend proxy'niz** üzerinden yapın — API key'i asla
   istemci uygulamaya gömmeyin).
2. `lib/providers/app_providers.dart` içindeki `evaluationEngineProvider`
   satırını yeni sınıfı döndürecek şekilde değiştirin.
3. Uygulamanın geri kalanında **hiçbir değişiklik gerekmez**.

## Liderlik Tablosu (Leaderboard)

Şu an `lib/screens/leaderboard_screen.dart` demo/sabit veriyle çalışıyor.
Firebase/Supabase'e bağlamak için aynı dosyadaki listeyi gerçek zamanlı bir
veri kaynağıyla değiştirmeniz yeterli; mimari buna hazır.
