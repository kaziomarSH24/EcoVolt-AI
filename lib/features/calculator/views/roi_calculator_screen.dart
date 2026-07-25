import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:ecovolt_ai/core/widgets/bouncy_button.dart';

class RoiCalculatorScreen extends StatefulWidget {
  const RoiCalculatorScreen({super.key});

  @override
  State<RoiCalculatorScreen> createState() => _RoiCalculatorScreenState();
}

class _RoiCalculatorScreenState extends State<RoiCalculatorScreen> {
  final TextEditingController _billController = TextEditingController();
  bool _isCalculated = false;
  String _selectedRoofSize = 'Medium';
  
  // Results
  String _systemSize = '0 KW';
  String _estimatedCost = '\$0';
  String _yearlySavings = '\$0';
  String _roiYears = '0 Years';

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  void _calculateROI() {
    final billText = _billController.text.trim();
    if (billText.isEmpty) return;

    final billAmount = double.tryParse(billText) ?? 0.0;
    if (billAmount <= 0) return;

    // Dummy Calculation Logic
    // Assuming $1 = 5 KWh, $50 bill = 250 KWh/month
    // Rough estimate: System size in KW = (billAmount / 30) 
    double size = (billAmount / 25).clamp(1.0, 20.0);
    double cost = size * 1000; // $1000 per KW approx
    double savings = billAmount * 12; // Yearly savings
    double roi = cost / savings;

    setState(() {
      _systemSize = '${size.toStringAsFixed(1)} KW';
      _estimatedCost = '\$${cost.toStringAsFixed(0)}';
      _yearlySavings = '\$${savings.toStringAsFixed(0)}';
      _roiYears = '${roi.toStringAsFixed(1)} Years';
      _isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Solar ROI Calculator',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estimate Your Savings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'See how much you can save by switching to EcoVolt Solar.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildInputSection(),
            const SizedBox(height: 24),
            BouncyButton(
              onTap: _calculateROI,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Calculate ROI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (_isCalculated) ...[
              const SizedBox(height: 32),
              _buildResultsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Average Monthly Bill',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _billController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 150',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Available Roof Size',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRoofSizePill('Small'),
              const SizedBox(width: 12),
              _buildRoofSizePill('Medium'),
              const SizedBox(width: 12),
              _buildRoofSizePill('Large'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoofSizePill(String size) {
    final isSelected = _selectedRoofSize == size;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRoofSize = size),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            size,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Solar Estimate',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildResultItem('System Size', _systemSize, Icons.solar_power_rounded),
              const SizedBox(width: 24),
              _buildResultItem('Estimated Cost', _estimatedCost, Icons.monetization_on_rounded),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildResultItem('Yearly Savings', _yearlySavings, Icons.savings_rounded),
              const SizedBox(width: 24),
              _buildResultItem('Payback (ROI)', _roiYears, Icons.update_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
