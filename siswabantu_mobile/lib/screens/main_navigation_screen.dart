import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../services/security_service.dart';
import '../theme/app_theme.dart';
import '../widgets/fade_indexed_stack.dart';
import '../widgets/selangor_elements.dart';
import 'marketplace_screen.dart';
import 'sos_screen.dart';
import 'orders_screen.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final UserModel currentUser;
  final List<ServiceModel> services;
  final List<SOSModel> sosList;
  final List<OrderModel> orders;
  final Function(ServiceModel) onBookService;
  final Function(ServiceModel) onAddService;
  final Function(SOSModel) onPostSOS;
  final Function(SOSModel) onOfferHelp;
  final Function(String orderId, String nextStatus, {bool autoCancel}) onUpdateOrderStatus;
  final Function(String orderId, double amount, String reason) onRaiseDispute;
  final Function(double amount) onWithdraw;
  final Function(String newRole) onToggleRole;
  final Function(String matricNo) onVerifyKyc;
  final Function(UserModel updatedUser) onUpdateUser;
  final VoidCallback onLogout;

  const MainNavigationScreen({
    super.key,
    required this.currentUser,
    required this.services,
    required this.sosList,
    required this.orders,
    required this.onBookService,
    required this.onAddService,
    required this.onPostSOS,
    required this.onOfferHelp,
    required this.onUpdateOrderStatus,
    required this.onRaiseDispute,
    required this.onWithdraw,
    required this.onToggleRole,
    required this.onVerifyKyc,
    required this.onUpdateUser,
    required this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      MarketplaceScreen(
        currentUser: widget.currentUser,
        services: widget.services,
        onBookService: widget.onBookService,
        onAddService: widget.onAddService,
        onToggleRole: widget.onToggleRole,
      ),
      SOSScreen(
        currentUser: widget.currentUser,
        sosList: widget.sosList,
        onPostSOS: widget.onPostSOS,
        onOfferHelp: widget.onOfferHelp,
      ),
      OrdersScreen(
        currentUser: widget.currentUser,
        orders: widget.orders,
        onUpdateOrderStatus: widget.onUpdateOrderStatus,
        onRaiseDispute: widget.onRaiseDispute,
      ),
      WalletScreen(
        currentUser: widget.currentUser,
        onWithdraw: widget.onWithdraw,
      ),
      ProfileScreen(
        currentUser: widget.currentUser,
        onToggleRole: widget.onToggleRole,
        onVerifyKyc: widget.onVerifyKyc,
        onUpdateUser: widget.onUpdateUser,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _currentIndex == 0
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(88),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SelangorTopBarRibbon(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(color: AppTheme.primaryIndigo.withValues(alpha: 0.35), width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withValues(alpha: 0.15),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.5),
                                    child: Image.asset(
                                      'assets/logo.png',
                                      width: 26,
                                      height: 26,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 26,
                                        height: 26,
                                        color: AppTheme.primaryIndigo,
                                        child: const Center(
                                          child: Text('SB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                            Text(
                              _currentIndex == 1
                                  ? 'Pusat Bantuan SOS ⚡'
                                  : _currentIndex == 2
                                      ? 'Pengurusan Pesanan'
                                      : _currentIndex == 3
                                          ? 'Dompet SiswaBantu'
                                          : 'Profil Mahasiswa',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.slateDark,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        // Baki Dompet Ringkas (Tekan untuk ke Tab Dompet)
                        GestureDetector(
                          onTap: () => _selectTab(3),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFFECACA)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.account_balance_wallet_rounded, size: 12, color: AppTheme.primary),
                                const SizedBox(width: 4),
                                Text(
                                  SecurityService.formatRM(widget.currentUser.walletBalance),
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      body: FadeIndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: AppTheme.primaryIndigo.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.storefront_rounded, 'Katalog'),
            _buildNavItem(1, Icons.bolt_rounded, 'SOS', isSpecial: true),
            _buildNavItem(2, Icons.receipt_long_rounded, 'Pesanan', badgeCount: widget.orders.length),
            _buildNavItem(3, Icons.account_balance_wallet_rounded, 'Dompet'),
            _buildNavItem(4, Icons.person_rounded, 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isSpecial = false, int badgeCount = 0}) {
    final isSelected = _currentIndex == index;

    if (isSpecial) {
      // Tombol SOS Khas
      return GestureDetector(
        onTap: () => _selectTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  )
                : LinearGradient(
                    colors: [
                      const Color(0xFFEF4444).withValues(alpha: 0.12),
                      const Color(0xFFF97316).withValues(alpha: 0.12),
                    ],
                  ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFFEF4444),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                'SOS',
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFEF4444),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _selectTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryIndigo.withValues(alpha: 0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected ? AppTheme.primaryIndigo : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    color: isSelected ? AppTheme.primaryIndigo : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            if (badgeCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryIndigo,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
