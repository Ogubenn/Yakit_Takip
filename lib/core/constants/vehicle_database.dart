class VehicleDatabase {
  static const Map<String, List<String>> turkishMarketVehicles = {
    'Audi': [
      'A1', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8',
      'Q2', 'Q3', 'Q5', 'Q7', 'Q8',
      'TT', 'e-tron'
    ],
    'BMW': [
      '1 Serisi', '2 Serisi', '3 Serisi', '4 Serisi', '5 Serisi', '6 Serisi', '7 Serisi', '8 Serisi',
      'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7',
      'Z4', 'i3', 'i4', 'iX3'
    ],
    'Chevrolet': ['Aveo', 'Cruze', 'Captiva', 'Spark', 'Trax'],
    'Citroën': ['C3', 'C3 Aircross', 'C4', 'C5 Aircross', 'Berlingo'],
    'Dacia': ['Duster', 'Sandero', 'Lodgy', 'Dokker', 'Logan'],
    'Fiat': [
      '500', '500L', '500X', 'Tipo', 'Egea', 'Panda', 'Doblo',
      'Ducato', 'Fiorino', 'Fullback'
    ],
    'Ford': [
      'Fiesta', 'Focus', 'Mondeo', 'Mustang',
      'Kuga', 'Puma', 'EcoSport',
      'Ranger', 'Transit', 'Transit Custom', 'Transit Connect'
    ],
    'Honda': ['Civic', 'CR-V', 'HR-V', 'Jazz', 'Accord'],
    'Hyundai': [
      'i10', 'i20', 'i30', 'i40',
      'Accent', 'Elantra', 'Tucson', 'Santa Fe', 'Kona', 'Bayon',
      'Ioniq', 'Ioniq 5'
    ],
    'Kia': [
      'Picanto', 'Rio', 'Ceed', 'Stonic', 'XCeed',
      'Sportage', 'Sorento', 'Niro', 'e-Niro', 'EV6'
    ],
    'Mazda': ['2', '3', '6', 'CX-3', 'CX-30', 'CX-5', 'CX-60', 'MX-5'],
    'Mercedes-Benz': [
      'A Serisi', 'B Serisi', 'C Serisi', 'CLA', 'CLS', 'E Serisi', 'S Serisi',
      'GLA', 'GLB', 'GLC', 'GLE', 'GLS',
      'EQA', 'EQB', 'EQC', 'EQE', 'EQS'
    ],
    'Nissan': ['Micra', 'Juke', 'Qashqai', 'X-Trail', 'Leaf', 'Navara'],
    'Opel': [
      'Corsa', 'Astra', 'Insignia',
      'Crossland', 'Grandland', 'Mokka',
      'Combo', 'Vivaro'
    ],
    'Peugeot': [
      '108', '208', '308', '508',
      '2008', '3008', '5008',
      'Rifter', 'Partner', 'Expert'
    ],
    'Renault': [
      'Clio', 'Megane', 'Taliant', 'Fluence',
      'Captur', 'Kadjar', 'Koleos', 'Austral',
      'Kangoo', 'Trafic', 'Master',
      'Zoe', 'Megane E-Tech'
    ],
    'Seat': ['Ibiza', 'Leon', 'Arona', 'Ateca', 'Tarraco'],
    'Skoda': [
      'Fabia', 'Scala', 'Octavia', 'Superb',
      'Kamiq', 'Karoq', 'Kodiaq', 'Enyaq'
    ],
    'Suzuki': ['Ignis', 'Swift', 'Vitara', 'S-Cross', 'Jimny'],
    'Toyota': [
      'Yaris', 'Corolla', 'Camry', 'Avensis',
      'C-HR', 'RAV4', 'Land Cruiser', 'Hilux',
      'Proace', 'Prius'
    ],
    'Volkswagen': [
      'Polo', 'Golf', 'Passat', 'Arteon', 'Jetta',
      'T-Cross', 'T-Roc', 'Tiguan', 'Touareg',
      'Caddy', 'Transporter', 'Crafter',
      'ID.3', 'ID.4', 'ID.5'
    ],
    'Volvo': [
      'S60', 'S90', 'V60', 'V90',
      'XC40', 'XC60', 'XC90',
      'C40 Recharge', 'XC40 Recharge'
    ],
  };

  static List<String> get allBrands {
    return turkishMarketVehicles.keys.toList()..sort();
  }

  static List<String> getModelsForBrand(String brand) {
    return turkishMarketVehicles[brand] ?? [];
  }

  static List<int> get years {
    final currentYear = DateTime.now().year;
    return List.generate(50, (index) => currentYear - index);
  }
}
