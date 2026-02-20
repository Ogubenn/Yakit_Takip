# Yakıt Takip Backend API (Laravel)

## Kurulum (Kebirhost Sunucu)

### 1. Laravel Kurulumu
```bash
composer create-project laravel/laravel yakit-takip-api
cd yakit-takip-api
```

### 2. Database Ayarları (.env)
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=yakit_takip
DB_USERNAME=your_username
DB_PASSWORD=your_password

JWT_SECRET=generated_secret_key
```

### 3. JWT Paketi Yükle
```bash
composer require tymon/jwt-auth
php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
php artisan jwt:secret
```

### 4. Migration'ları Çalıştır
```bash
php artisan migrate
```

### 5. EPDK Cron Job
Task Scheduler'a ekle (crontab -e):
```bash
* * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1
```

## API Endpoints

### Authentication
- POST `/api/register` - Kullanıcı kaydı
- POST `/api/login` - Giriş yap
- POST `/api/logout` - Çıkış yap
- GET `/api/user` - Profil bilgileri
- PUT `/api/user` - Profil güncelle

### Vehicles
- GET `/api/vehicles` - Tüm araçları listele
- POST `/api/vehicles` - Yeni araç ekle
- GET `/api/vehicles/{id}` - Araç detayı
- PUT `/api/vehicles/{id}` - Araç güncelle
- DELETE `/api/vehicles/{id}` - Araç sil

### Fuel Records
- GET `/api/fuel-records` - Tüm kayıtları listele
- POST `/api/fuel-records` - Yeni kayıt ekle
- GET `/api/fuel-records/{id}` - Kayıt detayı
- PUT `/api/fuel-records/{id}` - Kayıt güncelle
- DELETE `/api/fuel-records/{id}` - Kayıt sil
- GET `/api/fuel-records/vehicle/{vehicleId}` - Araca göre kayıtlar

### Fuel Prices
- GET `/api/fuel-prices` - Güncel fiyatlar
- GET `/api/fuel-prices/city/{city}` - Şehre göre fiyatlar
- GET `/api/fuel-prices/history` - Fiyat geçmişi

### Sync
- POST `/api/sync/upload` - Toplu veri yükleme
- GET `/api/sync/download` - Tüm verileri indir
- GET `/api/sync/changes` - Son değişiklikleri al

## Test
```bash
# API Test
curl -X POST http://your-domain.com/api/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@test.com","password":"password123","city":"Istanbul"}'
```

## Güvenlik
- JWT token authentication
- CORS ayarları yapılandırılmış
- Rate limiting aktif (60 request/dakika)
- SQL injection koruması (Eloquent ORM)
- XSS koruması (Laravel Sanctum)
