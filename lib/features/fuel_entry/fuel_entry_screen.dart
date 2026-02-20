import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/fuel_types.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../services/fuel_price_service.dart';
import '../../widgets/custom_card.dart';

class FuelEntryScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const FuelEntryScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<FuelEntryScreen> createState() => _FuelEntryScreenState();
}

class _FuelEntryScreenState extends ConsumerState<FuelEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _litersController = TextEditingController();
  final _priceController = TextEditingController();
  final _odometerController = TextEditingController();
  final _notesController = TextEditingController();

  FuelStation? _selectedStation;
  String? _selectedCity;
  bool _isFullTank = true;
  bool _isLoading = false;
  bool _isFetchingPrice = false;

  @override
  void initState() {
    super.initState();
    _fetchAutomaticPrice();
  }

  Future<void> _fetchAutomaticPrice() async {
    setState(() => _isFetchingPrice = true);

    try {
      // Araç bilgisini al
      final vehicle = ref.read(currentVehicleProvider);
      if (vehicle == null) return;

      // Konum + EPDK verisinden otomatik fiyat çek
      final result = await FuelPriceService.getAutomaticFuelPrice(vehicle.fuelType);

      if (result['success'] == true && mounted) {
        setState(() {
          _priceController.text = result['price'].toStringAsFixed(2);
          _selectedCity = result['city'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result['city']} için güncel fiyat: ${result['price']} ₺/L'),
            backgroundColor: AppColors.accentGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Fiyat bilgisi alınamadı'),
            backgroundColor: AppColors.accentOrange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingPrice = false);
      }
    }
  }

  @override
  void dispose() {
    _litersController.dispose();
    _priceController.dispose();
    _odometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final liters = double.parse(_litersController.text.replaceAll(',', '.'));
      final pricePerLiter = double.parse(_priceController.text.replaceAll(',', '.'));
      final odometer = _odometerController.text.isNotEmpty
          ? double.parse(_odometerController.text.replaceAll(',', ''))
          : null;

      await ref.read(fuelRecordsProvider.notifier).createRecord(
            vehicleId: widget.vehicleId,
            liters: liters,
            pricePerLiter: pricePerLiter,
            odometer: odometer,
            station: _selectedStation?.name,
            city: _selectedCity,
            isFullTank: _isFullTank,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yakıt kaydı başarıyla eklendi'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yakıt Ekle'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zorunlu Bilgiler',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _litersController,
                    label: 'Litre',
                    hint: '45.50',
                    icon: Icons.local_gas_station,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Litre zorunludur';
                      }
                      final number = double.tryParse(value.replaceAll(',', '.'));
                      if (number == null || number <= 0) {
                        return 'Geçerli bir litre girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPriceFieldWithAutoFetch(),
                  const SizedBox(height: 16),
                  _buildTotalCostDisplay(),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Opsiyonel Bilgiler',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _odometerController,
                    label: 'Kilometre (Opsiyonel)',
                    hint: '45000',
                    icon: Icons.speed,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildStationDropdown(),
                  const SizedBox(height: 16),
                  _buildCityDropdown(),
                  const SizedBox(height: 16),
                  _buildFullTankSwitch(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _notesController,
                    label: 'Notlar',
                    hint: 'Ek bilgiler...',
                    icon: Icons.note,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Kaydet'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryDark),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
    );
  }

  Widget _buildTotalCostDisplay() {
    return ListenableBuilder(
      listenable: Listenable.merge([_litersController, _priceController]),
      builder: (context, _) {
        final liters = double.tryParse(_litersController.text.replaceAll(',', '.')) ?? 0;
        final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0;
        final total = liters * price;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryDark.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Toplam Tutar',
                style: AppTextStyles.titleMedium,
              ),
              Text(
                '${total.toStringAsFixed(2)} ₺',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStationDropdown() {
    return DropdownButtonFormField<FuelStation>(
      initialValue: _selectedStation,
      decoration: const InputDecoration(
        labelText: 'Yakıt İstasyonu (Opsiyonel)',
        prefixIcon: Icon(Icons.local_gas_station, color: AppColors.primaryDark),
      ),
      items: FuelStation.values.map((station) {
        return DropdownMenuItem(
          value: station,
          child: Text(station.displayName),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedStation = value),
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCity,
      decoration: const InputDecoration(
        labelText: 'Şehir (Opsiyonel)',
        prefixIcon: Icon(Icons.location_city, color: AppColors.primaryDark),
      ),
      items: TurkishCities.cities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCity = value),
    );
  }

  Widget _buildPriceFieldWithAutoFetch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Litre Fiyatı (₺)',
                  hintText: '42.50',
                  prefixIcon: const Icon(Icons.attach_money, color: AppColors.primaryDark),
                  suffixIcon: _isFetchingPrice
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.refresh, color: AppColors.primaryDark),
                          onPressed: _fetchAutomaticPrice,
                          tooltip: 'Otomatik Fiyat Getir',
                        ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fiyat zorunludur';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null || number <= 0) {
                    return 'Geçerli bir fiyat girin';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.accentGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Fiyat otomatik olarak konumunuz ve EPDK verilerine göre getirildi',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accentGreen,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullTankSwitch() {
    return SwitchListTile(
      value: _isFullTank,
      onChanged: (value) => setState(() => _isFullTank = value),
      title: Text(
        'Depo Dolu',
        style: AppTextStyles.titleMedium,
      ),
      subtitle: Text(
        'Depoyu tamamen doldurdunuz mu?',
        style: AppTextStyles.bodySmall,
      ),
      activeThumbColor: AppColors.primaryDark,
      contentPadding: EdgeInsets.zero,
    );
  }
}
