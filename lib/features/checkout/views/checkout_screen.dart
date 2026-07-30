import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:ecovolt_ai/features/cart/providers/cart_provider.dart';
import 'package:ecovolt_ai/features/checkout/repositories/order_repository.dart';
import 'package:ecovolt_ai/features/orders/providers/order_history_provider.dart';
import '../../profile/providers/address_provider.dart';
import '../../profile/models/address_model.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String? sessionId;
  
  const CheckoutScreen({super.key, this.sessionId});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'Credit Card';
  bool isProcessing = false;
  
  AddressModel? _selectedAddress;
  
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    
    // Process deep link from GoRouter if present
    if (widget.sessionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processPaymentFromRouter(widget.sessionId!);
      });
    }
  }

  void _processPaymentFromRouter(String sessionId) async {
    try {
      if (mounted) setState(() { isProcessing = true; });
      await ref.read(orderRepositoryProvider).confirmPayment(sessionId);
      if (mounted) _showSuccessDialog();
    } catch (e) {
      if (mounted) {
        setState(() { isProcessing = false; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment verification failed: $e')));
      }
    }
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      if (uri.scheme == 'io.supabase.ecovoltai') {
        if (uri.host == 'payment-success') {
          final sessionId = uri.queryParameters['session_id'];
          if (sessionId != null) {
            try {
              if (mounted) setState(() { isProcessing = true; });
              await ref.read(orderRepositoryProvider).confirmPayment(sessionId);
              if (mounted) _showSuccessDialog();
            } catch (e) {
              if (mounted) {
                setState(() { isProcessing = false; });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment verification failed: $e')));
              }
            }
          }
        } else if (uri.host == 'payment-cancel') {
          if (mounted) {
            setState(() { isProcessing = false; });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment was cancelled')));
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _showAddressSelectionModal(List<AddressModel> addresses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Select Shipping Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 16),
              if (addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('No addresses found. Please add one in Profile.'),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    itemBuilder: (ctx, index) {
                      final address = addresses[index];
                      final isSelected = _selectedAddress?.id == address.id;
                      
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        tileColor: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
                        leading: const Icon(Icons.location_on, color: AppColors.primary),
                        title: Text(address.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${address.addressLine}\\n${address.city}, ${address.zipCode}'),
                        trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                        onTap: () {
                          setState(() {
                            _selectedAddress = address;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/addresses');
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Manage Addresses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _placeOrder() async {
    setState(() {
      isProcessing = true;
    });
    
    try {
      final cartItems = ref.read(cartProvider);
      final totalAmount = ref.read(cartProvider.notifier).totalPrice;
      
      final checkoutUrl = await ref.read(orderRepositoryProvider).createOrderAndPaymentSession(
        cartItems: cartItems,
        totalAmount: totalAmount,
        address: _selectedAddress != null 
            ? '${_selectedAddress!.addressLine}, ${_selectedAddress!.city}, ${_selectedAddress!.zipCode}'
            : 'No Address Selected',
      );
      
      if (!await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch payment URL');
      }
    } catch (e) {
      if (mounted) {
        setState(() { isProcessing = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    setState(() { isProcessing = false; });
    ref.read(cartProvider.notifier).clearCart();
    ref.invalidate(orderHistoryProvider);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Placed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your clean energy products are on their way.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close dialog
                    context.go('/home'); // Go back to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Back to Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressesState = ref.watch(addressesProvider);
    List<AddressModel> savedAddresses = [];
    
    addressesState.whenData((addresses) {
      savedAddresses = addresses;
      if (_selectedAddress == null && addresses.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _selectedAddress == null) {
            setState(() {
              _selectedAddress = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);
            });
          }
        });
      }
    });

    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.read(cartProvider.notifier).totalPrice;
    final shippingFee = 15.0;
    final finalTotal = totalPrice + shippingFee;

    // If cart is empty and not processing, user shouldn't be here
    if (cartItems.isEmpty && !isProcessing) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
        body: const Center(child: Text("Cart is empty")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shipping Address'),
            const SizedBox(height: 16),
            _buildShippingAddressCard(savedAddresses),
            
            const SizedBox(height: 32),
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: 16),
            _buildPaymentMethodCard(
              title: 'Credit Card',
              icon: Icons.credit_card_rounded,
              subtitle: '**** **** **** 4242',
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(
              title: 'Apple Pay',
              icon: Icons.apple_rounded,
              subtitle: 'Connected',
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(
              title: 'PayPal',
              icon: Icons.paypal_rounded,
              subtitle: 'user@example.com',
            ),

            const SizedBox(height: 32),
            _buildSectionTitle('Order Summary'),
            const SizedBox(height: 16),
            _buildOrderSummary(totalPrice, shippingFee, finalTotal),
            
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isProcessing ? null : _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isProcessing 
                  ? const SizedBox(
                      height: 20, width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : Text(
                      'Place Order - ৳${finalTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildShippingAddressCard(List<AddressModel> savedAddresses) {
    String displayTitle = 'No Address Selected';
    String displayDetails = 'Please add a shipping address';
    
    if (_selectedAddress != null) {
      displayTitle = _selectedAddress!.title;
      displayDetails = '${_selectedAddress!.addressLine}\n${_selectedAddress!.city}, ${_selectedAddress!.zipCode}\n${_selectedAddress!.phone}';
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  displayDetails,
                  style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), height: 1.4),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 20),
            onPressed: () => _showAddressSelectionModal(savedAddresses),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({required String title, required IconData icon, required String subtitle}) {
    final isSelected = selectedPaymentMethod == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.black.withValues(alpha: 0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double shipping, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '৳${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildSummaryRow('Shipping Fee', '৳${shipping.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                '৳${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
