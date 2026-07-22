import 'package:flutter/material.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'All Categories',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildCategoryCard(
            context: context,
            title: 'Solar Panels',
            icon: Icons.solar_power_rounded,
            itemCount: '24 items',
            color: const Color(0xFFE8F5E9),
            iconColor: Colors.green,
          ),
          _buildCategoryCard(
            context: context,
            title: 'Batteries',
            icon: Icons.battery_charging_full_rounded,
            itemCount: '12 items',
            color: const Color(0xFFE3F2FD),
            iconColor: Colors.blue,
          ),
          _buildCategoryCard(
            context: context,
            title: 'Inverters',
            icon: Icons.power_rounded,
            itemCount: '8 items',
            color: const Color(0xFFFFF3E0),
            iconColor: Colors.orange,
          ),
          _buildCategoryCard(
            context: context,
            title: 'Wind Energy',
            icon: Icons.wind_power_rounded,
            itemCount: '5 items',
            color: const Color(0xFFF3E5F5),
            iconColor: Colors.purple,
          ),
          _buildCategoryCard(
            context: context,
            title: 'Accessories',
            icon: Icons.cable_rounded,
            itemCount: '45 items',
            color: const Color(0xFFECEFF1),
            iconColor: Colors.blueGrey,
          ),
          _buildCategoryCard(
            context: context,
            title: 'EV Chargers',
            icon: Icons.ev_station_rounded,
            itemCount: '6 items',
            color: const Color(0xFFFFEBEE),
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String itemCount,
    required Color color,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () => context.push('/catalog'),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              itemCount,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
