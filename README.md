# 🚗 Yakıt Takip - Premium Fuel Tracker

Modern, kullanıcı dostu ve premium hissiyatlı bir mobil yakıt takip ve masraf analiz uygulaması.

## 📱 Özellikler

### MVP Özellikleri
- ✅ **Hızlı Yakıt Ekleme** - 5 saniyede yakıt kaydı oluşturma
- ✅ **Akıllı Analizler** - Otomatik tüketim ve maliyet hesaplama
- ✅ **Offline Kullanım** - İnternet bağlantısı olmadan tam özellik
- ✅ **Dark Mode** - Modern ve göz dostu arayüz
- ✅ **Çoklu Araç** - Birden fazla araç takibi

### Analitik Özellikleri
- 📊 Aylık harcama analizi ve karşılaştırma
- ⛽ Ortalama yakıt tüketimi (L/100km)
- 💰 Litre başına ortalama maliyet
- 📈 Trend grafikleri
- 🏆 En çok kullanılan istasyon analizi

## 🛠️ Teknoloji Stack

- **Framework:** Flutter 3.11+
- **State Management:** Riverpod 2.6+
- **Local Storage:** Hive 2.2+ (Offline-first)
- **Charts:** FL Chart 0.69+
- **Design:** Material 3, Google Fonts

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK 3.11 veya üzeri
- Dart SDK 3.11 veya üzeri

### Adımlar

1. **Paketleri yükleyin:**
   ```bash
   flutter pub get
   ```

2. **Hive model dosyalarını oluşturun:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Uygulamayı çalıştırın:**
   
   **Web için:**
   ```bash
   flutter run -d chrome
   ```
   
   **Android için:**
   ```bash
   flutter run
   ```

## 🎯 Kullanım

### İlk Kullanım
1. Uygulamayı açın
2. "Araç Ekle" butonuna tıklayın
3. Aracınızın bilgilerini girin (Marka, Model, Yıl, Yakıt Türü)
4. Kaydete tıklayın

### Yakıt Ekleme
1. Ana ekranda "Hızlı Yakıt Ekle" kartına veya + butonuna tıklayın
2. Zorunlu alanları doldurun: Litre miktarı ve Litre fiyatı
3. Opsiyonel: Kilometre, İstasyon, Şehir, Notlar
4. "Kaydet" butonuna tıklayın

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── constants/      # Uygulama sabitleri ve enum'lar
│   ├── theme/          # Renk paleti, tema ve tipografi
│   └── utils/          # Formatters ve yardımcı fonksiyonlar
├── features/
│   ├── home/           # Ana ekran
│   ├── fuel_entry/     # Yakıt ekleme ekranı
│   └── vehicle/        # Araç yönetimi
├── models/             # Veri modelleri (Hive)
├── providers/          # State management (Riverpod)
├── services/           # Storage servisleri
└── widgets/            # Tekrar kullanılabilir UI bileşenleri
```

## 🔮 Gelecek Özellikler

### Faz 2 - Growth
- [ ] Gelişmiş grafikler ve görselleştirme
- [ ] PDF/CSV export
- [ ] Cloud backup
- [ ] Bildirimler ve fiyat uyarıları

### Faz 3 - Smart AI
- [ ] AI destekli tüketim tahmini
- [ ] Sürüş önerileri
- [ ] Anomali tespiti

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!

