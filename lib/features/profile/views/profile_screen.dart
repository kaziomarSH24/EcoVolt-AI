import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:ecovolt_ai/core/widgets/custom_bottom_nav.dart';
import 'package:ecovolt_ai/features/auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120), // Space for bottom nav
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 32),
                  _buildSettingsSection(context, ref),
                ],
              ),
            ),
          ),
          
          // Floating Bottom Navigation Bar
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(currentIndex: 3), // 3 corresponds to Profile
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Center(
              child: Text(
                'KO',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kazi Omar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'kazi.omar@ecovolt.ai',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Eco Member',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard('Active\nOrders', '3', Icons.local_shipping_outlined),
          _buildStatCard('Total\nSpent', '\$850', Icons.account_balance_wallet_outlined),
          _buildStatCard('Impact\nScore', '4.9', Icons.energy_savings_leaf_outlined, iconColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color? iconColor}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor ?? AppColors.primary, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildSettingsTile(icon: Icons.person_outline, title: 'Edit Profile'),
          _buildSettingsTile(
            icon: Icons.history_rounded, 
            title: 'Order History',
            onTap: () => context.push('/orders'),
          ),
          _buildSettingsTile(icon: Icons.location_on_outlined, title: 'Shipping Addresses'),
          _buildSettingsTile(icon: Icons.credit_card_outlined, title: 'Payment Methods'),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 24),
          ),
          
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: Text(
              'App Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildSettingsTile(icon: Icons.notifications_none_outlined, title: 'Notifications', hasToggle: true, toggleValue: true),
          _buildSettingsTile(icon: Icons.dark_mode_outlined, title: 'Dark Mode', hasToggle: true, toggleValue: false),
          _buildSettingsTile(icon: Icons.help_outline, title: 'Help & Support'),
          
          const SizedBox(height: 12),
          
          InkWell(
            onTap: () async {
              // Sign out logic
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout_rounded, color: Colors.red),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    bool hasToggle = false,
    bool toggleValue = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: hasToggle ? null : (onTap ?? () {}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (hasToggle)
              Switch(
                value: toggleValue,
                onChanged: (val) {},
                activeColor: AppColors.primary,
              )
            else
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
