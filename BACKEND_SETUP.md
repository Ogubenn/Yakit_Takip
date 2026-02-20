# Yakıt Takip - Backend Kurulum Rehberi

## 🚀 Kebirhost Sunucuda Laravel API Kurulumu

### 1. Sunucuya Dosyaları Yükle

FTP/SFTP ile `backend` klasöründeki tüm dosyaları sunucunuza yükleyin:
```
/home/your_username/yakit-takip-api/
```

### 2. SSH ile Sunucuya Bağlan

```bash
ssh your_username@your_server.com
cd yakit-takip-api
```

### 3. Composer ile Bağımlılıkları Yükle

```bash
# Composer yüklü değilse
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Bağımlılıkları yükle
composer install --no-dev --optimize-autoloader
```

### 4. .env Dosyasını Oluştur

```bash
cp .env.example .env
nano .env
```

`.env` içeriği:
```env
APP_NAME="Yakıt Takip API"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://your-domain.com

LOG_CHANNEL=stack
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_database_password

JWT_SECRET=
JWT_TTL=60480  # 6 weeks
```

### 5. Application Key ve JWT Secret Oluştur

```bash
php artisan key:generate
php artisan jwt:secret
```

### 6. Database Oluştur

cPanel > phpMyAdmin'den yeni database oluşturun veya:
```bash
mysql -u root -p
CREATE DATABASE yakit_takip CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON yakit_takip.* TO 'your_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 7. Migration'ları Çalıştır

```bash
php artisan migrate --force
```

### 8. Storage ve Cache İzinleri

```bash
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

### 9. .htaccess Ayarları (Apache)

`public/.htaccess` dosyası Laravel ile gelir. Eğer domain root'u `public` klasörüne yönlendiremediyseniz:

Web sunucu document root'u şu şekilde ayarlayın:
```
/home/your_username/yakit-takip-api/public
```

### 10. CORS Ayarları

`config/cors.php` kontrol edin:
```php
'paths' => ['api/*'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'],
'allowed_headers' => ['*'],
```

### 11. Cron Job Kurulumu (EPDK Fiyat Güncellemesi)

cPanel > Cron Jobs:
```
* * * * * cd /home/your_username/yakit-takip-api && php artisan schedule:run >> /dev/null 2>&1
```

### 12. Test

```bash
# Sunucu test
curl https://your-domain.com/api/fuel-prices

# Kayıt test
curl -X POST https://your-domain.com/api/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","city":"Istanbul","email":"test@test.com","password":"test123"}'
```

## 📱 Flutter App Ayarları

### 1. API URL Güncelle

`lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://your-domain.com/api';
```

### 2. Test Kullanıcısı Oluştur

Flutter uygulamadan kayıt ol veya:
```bash
php artisan tinker
```
```php
$user = new App\Models\User();
$user->name = 'Test User';
$user->email = 'test@test.com';
$user->password = Hash::make('test123');
$user->city = 'Istanbul';
$user->save();
```

## 🔧 Sorun Giderme

### 500 Hatası
```bash
# Log'ları kontrol et
tail -f storage/logs/laravel.log

# Cache temizle
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

### Database Bağlantı Hatası
- `.env` dosyasında DB bilgilerini kontrol edin
- MySQL servisinin çalıştığından emin olun
- Kullanıcı izinlerini kontrol edin

### JWT Hatası
```bash
# JWT secret yeniden oluştur
php artisan jwt:secret --force
```

### CORS Hatası
- `config/cors.php` ayarlarını kontrol edin
- Apache'de `mod_headers` aktif mi kontrol edin

## 📊 Database Yönetimi

### Backup
```bash
mysqldump -u username -p yakit_takip > backup_$(date +%Y%m%d).sql
```

### Restore
```bash
mysql -u username -p yakit_takip < backup_20240101.sql
```

## 🔒 Güvenlik

1. `.env` dosyasını `.gitignore`'a ekleyin
2. `APP_DEBUG=false` production'da
3. SSL sertifikası kullanın (Let's Encrypt ücretsiz)
4. Rate limiting aktif (Laravel varsayılan: 60/dakika)
5. Güçlü JWT secret kullanın

## 📞 İletişim

Sorun olursa:
- Backend log: `storage/logs/laravel.log`
- Flutter log: Android Studio / VS Code console
- API test: Postman collection'ı kullan
