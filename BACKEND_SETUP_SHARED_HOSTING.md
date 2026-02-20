# Laravel API Kurulumu - Shared Hosting (SSH Olmadan)

## Önemli Not
SSH erişimi olmayan shared hosting'de Laravel kurulumu karmaşık olabilir. İki seçeneğiniz var:

### ✅ ÖNERİLEN: Ücretsiz Alternatif Servisler

1. **Railway.app** (Ücretsiz)
   - Laravel için ideal
   - Otomatik deployment
   - Ücretsiz MySQL database
   - SSH erişimi var
   - URL: https://railway.app

2. **Render.com** (Ücretsiz)
   - Laravel desteği
   - Otomatik deployment
   - Ücretsiz PostgreSQL
   - URL: https://render.com

3. **Clever Cloud** (Ücretsiz)
   - PHP/Laravel desteği
   - MySQL dahil
   - URL: https://clever-cloud.com

---

## 🛠️ Shared Hosting'de Manuel Kurulum (Zor)

### Gereksinimler
- PHP 8.1+
- MySQL Database
- cPanel veya benzeri panel erişimi
- Composer (local bilgisayarınızda)

### Adım 1: Local'de Hazırlık

1. Proje klasöründe terminal açın:
```powershell
cd backend
composer install --optimize-autoloader --no-dev
```

2. `.env` dosyası oluşturun:
```powershell
Copy-Item .env.example .env
```

3. `.env` dosyasını düzenleyin:
```env
APP_NAME="Yakıt Takip API"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_database_password

JWT_SECRET=
```

4. App key ve JWT secret oluşturun:
```powershell
php artisan key:generate
php artisan jwt:secret
```

### Adım 2: cPanel'den Database Oluşturma

1. cPanel → MySQL Databases
2. Yeni database oluşturun (örn: `yakit_takip`)
3. Yeni user oluşturun
4. User'ı database'e ekleyin (ALL PRIVILEGES)
5. Bilgileri `.env` dosyasına kaydedin

### Adım 3: Dosyaları Yükleme

**FTP/File Manager ile:**
```
public_html/
  └── api/
      ├── public/          (Laravel public klasörü)
      │   └── index.php
      ├── app/
      ├── bootstrap/
      ├── config/
      ├── database/
      ├── routes/
      ├── storage/
      ├── vendor/          (composer install'dan sonra)
      ├── .env
      └── artisan
```

**ÖNEMLİ:** `public` klasörünün içeriğini `api` klasörünün kök dizinine taşıyın.

### Adım 4: Storage İzinleri

cPanel File Manager'da:
- `storage/` klasörüne → Permissions → 755
- `storage/framework/` → 755
- `storage/logs/` → 755
- `bootstrap/cache/` → 755

### Adım 5: Migration'ları Manuel Çalıştırma

**Seçenek A: phpMyAdmin**

1. cPanel → phpMyAdmin
2. Database'inizi seçin
3. SQL sekmesi
4. Her migration dosyasını açın ve CREATE TABLE komutlarını manuel çalıştırın

**users tablosu:**
```sql
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255),
    city VARCHAR(100),
    photo_url TEXT,
    auth_provider VARCHAR(50) DEFAULT 'manual',
    provider_id VARCHAR(255),
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);
```

**vehicles tablosu:**
```sql
CREATE TABLE vehicles (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    plate VARCHAR(20),
    fuel_type VARCHAR(50) NOT NULL,
    tank_capacity DECIMAL(10,2),
    avatar_color VARCHAR(20) DEFAULT '#1976D2',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);
```

**fuel_records tablosu:**
```sql
CREATE TABLE fuel_records (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    vehicle_id CHAR(36) NOT NULL,
    date TIMESTAMP NOT NULL,
    fuel_type VARCHAR(50) NOT NULL,
    liters DECIMAL(10,2) NOT NULL,
    price_per_liter DECIMAL(10,2) NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    odometer INT NOT NULL,
    is_full_tank BOOLEAN DEFAULT true,
    station_name VARCHAR(255),
    station_brand VARCHAR(100),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    notes TEXT,
    receipt_photo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_vehicle_id (vehicle_id),
    INDEX idx_date (date)
);
```

**fuel_prices tablosu:**
```sql
CREATE TABLE fuel_prices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fuel_type VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    city VARCHAR(100),
    date TIMESTAMP NOT NULL,
    source VARCHAR(100) DEFAULT 'EPDK',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_fuel_type (fuel_type),
    INDEX idx_city (city),
    INDEX idx_date (date)
);
```

**Seçenek B: Tinker ile (Eğer çalışırsa)**

cPanel → Terminal (varsa):
```bash
cd public_html/api
php artisan migrate --force
```

### Adım 6: .htaccess Ayarları

`public_html/api/.htaccess` dosyası oluşturun:
```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^(.*)$ public/$1 [L]
</IfModule>
```

`public_html/api/public/.htaccess`:
```apache
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews -Indexes
    </IfModule>

    RewriteEngine On

    # Handle Authorization Header
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Send Requests To Front Controller...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>
```

### Adım 7: Test

Tarayıcıda: `https://your-domain.com/api/health`

Beklenen cevap:
```json
{
    "status": "ok",
    "timestamp": "2024-02-20T12:00:00.000000Z"
}
```

---

## ⚠️ Shared Hosting Sorunları

1. **Composer güncellemeleri:** SSH olmadan composer güncellemesi yapılamaz
2. **Migrations:** Her değişiklikte manuel SQL çalıştırmanız gerekir
3. **Cron Jobs:** cPanel'den tek tek manuel ayarlamanız gerekir
4. **PHP Version:** cPanel'den PHP 8.1+ seçmelisiniz
5. **Memory Limit:** Shared hosting limitli olabilir

---

## 💡 Tavsiye

**Railway.app kullanmanızı şiddetle öneririm:**

### Railway.app Kurulum (5 dakika)

1. https://railway.app adresine gidin
2. GitHub ile login olun
3. "New Project" → "Deploy from GitHub repo"
4. Backend klasörünüzü GitHub'a push edin
5. Railway otomatik deploy eder
6. Ücretsiz MySQL database ekleyin
7. Environment variables'a `.env` bilgilerini ekleyin
8. Deploy!

**Avantajları:**
- ✅ Ücretsiz (500 saat/ay)
- ✅ Otomatik deployment
- ✅ SSH erişimi var
- ✅ Kolay database yönetimi
- ✅ HTTPS otomatik
- ✅ Cron job desteği

Hangisini tercih edersiniz?
