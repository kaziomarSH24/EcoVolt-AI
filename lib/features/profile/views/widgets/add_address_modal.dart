import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import '../../models/address_model.dart';
import '../../providers/address_provider.dart';

class AddAddressModal extends ConsumerStatefulWidget {
  final AddressModel? addressToEdit;

  const AddAddressModal({super.key, this.addressToEdit});

  @override
  ConsumerState<AddAddressModal> createState() => _AddAddressModalState();
}

class _AddAddressModalState extends ConsumerState<AddAddressModal> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _addressLineController;
  late TextEditingController _cityController;
  late TextEditingController _zipCodeController;
  late TextEditingController _phoneController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.addressToEdit?.title ?? '');
    _addressLineController = TextEditingController(text: widget.addressToEdit?.addressLine ?? '');
    _cityController = TextEditingController(text: widget.addressToEdit?.city ?? '');
    _zipCodeController = TextEditingController(text: widget.addressToEdit?.zipCode ?? '');
    _phoneController = TextEditingController(text: widget.addressToEdit?.phone ?? '');
    _isDefault = widget.addressToEdit?.isDefault ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final newAddress = AddressModel(
        id: widget.addressToEdit?.id ?? '',
        userId: widget.addressToEdit?.userId ?? '',
        title: _titleController.text.trim(),
        addressLine: _addressLineController.text.trim(),
        city: _cityController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        phone: _phoneController.text.trim(),
        isDefault: _isDefault,
        createdAt: widget.addressToEdit?.createdAt ?? DateTime.now(),
      );

      if (widget.addressToEdit == null) {
        await ref.read(addressesProvider.notifier).addAddress(newAddress);
      } else {
        await ref.read(addressesProvider.notifier).updateAddress(newAddress);
      }
      
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the bottom padding for keyboard
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: bottomPadding + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.addressToEdit == null ? 'Add New Address' : 'Edit Address',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              
              _buildTextField(
                controller: _titleController,
                label: 'Title (e.g. Home, Office)',
                icon: Icons.label_outline,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _addressLineController,
                label: 'Address Line',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      icon: Icons.location_city_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _zipCodeController,
                      label: 'Zip Code',
                      icon: Icons.local_post_office_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Set as Default Address', style: TextStyle(color: AppColors.textPrimary)),
                value: _isDefault,
                activeTrackColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() {
                    _isDefault = val;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (val) {
        if (val == null || val.trim().isEmpty) return 'Required';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
