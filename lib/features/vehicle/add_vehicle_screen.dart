import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/fuel_types.dart';
import '../../core/constants/vehicle_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/custom_card.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();

  String? _selectedBrand;
  String? _selectedModel;
  int? _selectedYear;
  FuelType _selectedFuelType = FuelType.benzin95;
  bool _isLoading = false;

  List<String> _availableModels = [];

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  void _onBrandChanged(String? brand) {
    setState(() {
      _selectedBrand = brand;
      _selectedModel = null;
      _availableModels = brand != null ? VehicleDatabase.getModelsForBrand(brand) : [];
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBrand == null || _selectedModel == null || _selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm zorunlu alanları doldurun'),
          backgroundColor: AppColors.accentRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final vehicle = await ref.read(vehiclesProvider.notifier).createDefaultVehicle(
        brand: _selectedBrand!,
        model: _selectedModel!,
        year: _selectedYear!,
        fuelType: _selectedFuelType.name,
      );

      // Set as selected vehicle
      ref.read(selectedVehicleIdProvider.notifier).state = vehicle.id;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Araç başarıyla eklendi'),
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
        title: const Text('Araç Ekle'),
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
                    'Araç Bilgileri',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildBrandDropdown(),
                  const SizedBox(height: 16),
                  _buildModelDropdown(),
                  const SizedBox(height: 16),
                  _buildYearDropdown(),
                  const SizedBox(height: 16),
                  _buildFuelTypeDropdown(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _plateController,
                    label: 'Plaka (Opsiyonel)',
                    hint: '34 ABC 123',
                    icon: Icons.pin,
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
    );
  }

  Widget _buildBrandDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBrand,
      decoration: const InputDecoration(
        labelText: 'Marka',
        hintText: 'Araç markası seçin',
        prefixIcon: Icon(Icons.directions_car, color: AppColors.primaryDark),
      ),
      items: VehicleDatabase.allBrands.map((brand) {
        return DropdownMenuItem(
          value: brand,
          child: Text(brand),
        );
      }).toList(),
      onChanged: _onBrandChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Marka seçimi zorunludur';
        }
        return null;
      },
    );
  }

  Widget _buildModelDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedModel,
      decoration: InputDecoration(
        labelText: 'Model',
        hintText: _selectedBrand == null ? 'Önce marka seçin' : 'Model seçin',
        prefixIcon: const Icon(Icons.directions_car_outlined, color: AppColors.primaryDark),
      ),
      items: _availableModels.map((model) {
        return DropdownMenuItem(
          value: model,
          child: Text(model),
        );
      }).toList(),
      onChanged: _selectedBrand == null
          ? null
          : (value) {
              setState(() => _selectedModel = value);
            },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Model seçimi zorunludur';
        }
        return null;
      },
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedYear,
      decoration: const InputDecoration(
        labelText: 'Yıl',
        hintText: 'Üretim yılı seçin',
        prefixIcon: Icon(Icons.calendar_today, color: AppColors.primaryDark),
      ),
      items: VehicleDatabase.years.map((year) {
        return DropdownMenuItem(
          value: year,
          child: Text(year.toString()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedYear = value);
      },
      validator: (value) {
        if (value == null) {
          return 'Yıl seçimi zorunludur';
        }
        return null;
      },
    );
  }

  Widget _buildFuelTypeDropdown() {
    return DropdownButtonFormField<FuelType>(
      value: _selectedFuelType,
      decoration: const InputDecoration(
        labelText: 'Yakıt Türü',
        prefixIcon: Icon(Icons.local_gas_station, color: AppColors.primaryDark),
      ),
      items: FuelType.values.map((fuelType) {
        return DropdownMenuItem(
          value: fuelType,
          child: Row(
            children: [
              Text(fuelType.icon),
              const SizedBox(width: 8),
              Text(fuelType.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedFuelType = value);
        }
      },
    );
  }
}
