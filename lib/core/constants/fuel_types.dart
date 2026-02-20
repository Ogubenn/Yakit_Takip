enum FuelType {
  benzin95('Benzin 95'),
  benzin97('Benzin 97'),
  dizel('Dizel'),
  lpg('LPG'),
  motorin('Motorin');

  const FuelType(this.displayName);
  final String displayName;

  String get icon {
    switch (this) {
      case FuelType.benzin95:
      case FuelType.benzin97:
        return '⛽';
      case FuelType.dizel:
      case FuelType.motorin:
        return '🚗';
      case FuelType.lpg:
        return '💨';
    }
  }
}

enum FuelStation {
  shell('Shell'),
  opet('Opet'),
  bp('BP'),
  total('Total'),
  petrolOfisi('Petrol Ofisi'),
  po('PO'),
  aytemiz('Aytemiz'),
  turkPetrol('Türk Petrol'),
  diger('Diğer');

  const FuelStation(this.displayName);
  final String displayName;
}

class TurkishCities {
  static const List<String> cities = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Aksaray',
    'Amasya',
    'Ankara',
    'Antalya',
    'Ardahan',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bartın',
    'Batman',
    'Bayburt',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Düzce',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Iğdır',
    'Isparta',
    'İstanbul',
    'İzmir',
    'Kahramanmaraş',
    'Karabük',
    'Karaman',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırıkkale',
    'Kırklareli',
    'Kırşehir',
    'Kilis',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Osmaniye',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Şanlıurfa',
    'Şırnak',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Uşak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak',
  ];
}
