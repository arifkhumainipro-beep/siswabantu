import 'dart:ui';
import 'package:flutter/material.dart';
import 'data/mock_data.dart';
import 'models/models.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/admin_screen.dart';
import 'services/security_service.dart';
import 'theme/app_theme.dart';
import 'widgets/device_frame.dart';

void main() {
  runApp(const SiswaBantuMobileApp());
}

class SiswaBantuMobileApp extends StatefulWidget {
  const SiswaBantuMobileApp({super.key});

  @override
  State<SiswaBantuMobileApp> createState() => _SiswaBantuMobileAppState();
}

class _SiswaBantuMobileAppState extends State<SiswaBantuMobileApp> {
  // Authentication session
  bool _isAdminLoggedIn = false;
  UserModel? _currentStudent;

  // Global Data
  late List<UserModel> _users;
  late List<ServiceModel> _services;
  late List<SOSModel> _sosList;
  late List<OrderModel> _orders;
  late List<DisputeModel> _disputes;

  @override
  void initState() {
    super.initState();
    _users = List.from(MockData.initialUsers);
    _services = List.from(MockData.initialServices);
    _sosList = List.from(MockData.initialSOS);
    _orders = List.from(MockData.initialOrders);
    _disputes = List.from(MockData.initialDisputes);
  }

  // Auth Handlers
  void _loginSiswa(UserModel user) {
    setState(() {
      _currentStudent = user;
      _isAdminLoggedIn = false;
    });
  }

  void _loginAdmin() {
    setState(() {
      _isAdminLoggedIn = true;
      _currentStudent = null;
    });
  }

  void _registerSiswa(UserModel newUser) {
    setState(() {
      _users.add(newUser);
      _currentStudent = newUser;
      _isAdminLoggedIn = false;
    });
  }

  void _logout() {
    setState(() {
      _currentStudent = null;
      _isAdminLoggedIn = false;
    });
  }

  // App Business Logic
  void _bookService(ServiceModel srv) {
    final split = SecurityService.calculateEscrowSplit(srv.price);
    final newOrder = OrderModel(
      orderId: 'ORD-2026-${DateTime.now().millisecondsSinceEpoch % 1000}',
      serviceId: srv.serviceId,
      serviceTitle: srv.title,
      category: srv.category,
      buyerId: _currentStudent!.userId,
      buyerName: _currentStudent!.fullName,
      providerId: srv.providerId,
      providerName: srv.providerName,
      totalAmount: srv.price,
      commissionFee: split.commissionFee,
      netAmount: split.netEarnings,
      escrowStatus: 'Held',
      orderStatus: 'MENUNGGU_TERIMA',
      createdAt: 'Baru sahaja',
      deliveryNote: 'Pesanan dibuat melalui aplikasi mudah alih SiswaBantu.',
    );

    setState(() {
      _orders.insert(0, newOrder);
      _currentStudent!.escrowBalance += srv.price;
    });
  }

  void _addService(ServiceModel newSrv) {
    setState(() {
      _services.insert(0, newSrv);
    });
  }

  void _postSOS(SOSModel newSOS) {
    setState(() {
      _sosList.insert(0, newSOS);
    });
  }

  void _offerHelp(SOSModel sos) {
    setState(() {
      sos.offersCount += 1;
    });
  }

  void _updateOrderStatus(String orderId, String nextStatus, {bool autoCancel = false}) {
    final order = _orders.firstWhere((o) => o.orderId == orderId);

    setState(() {
      if (nextStatus == 'SELESAI') {
        order.orderStatus = 'SELESAI';
        order.escrowStatus = 'Released';
        final split = SecurityService.calculateEscrowSplit(order.totalAmount);
        _currentStudent!.walletBalance += split.netEarnings;
        if (_currentStudent!.escrowBalance >= order.totalAmount) {
          _currentStudent!.escrowBalance -= order.totalAmount;
        }
      } else if (nextStatus == 'DIBATALKAN' && autoCancel) {
        order.orderStatus = 'DIBATALKAN';
        order.escrowStatus = 'Refunded';
        _currentStudent!.walletBalance += order.totalAmount;
        if (_currentStudent!.escrowBalance >= order.totalAmount) {
          _currentStudent!.escrowBalance -= order.totalAmount;
        }
      } else {
        order.orderStatus = nextStatus;
      }
    });
  }

  void _raiseDispute(String orderId, double amount, String reason) {
    final order = _orders.firstWhere((o) => o.orderId == orderId);
    setState(() {
      order.orderStatus = 'PERTIKAIAN';
      order.escrowStatus = 'Frozen';
      _disputes.insert(
        0,
        DisputeModel(
          disputeId: 'DSP-${DateTime.now().millisecondsSinceEpoch % 1000}',
          orderId: orderId,
          serviceTitle: order.serviceTitle,
          raisedByName: _currentStudent!.fullName,
          providerName: order.providerName,
          amount: amount,
          reason: reason,
          evidenceUrl: 'https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?auto=format&fit=crop&w=400&q=80',
        ),
      );
    });
  }

  void _resolveDispute(String disputeId, String resolution) {
    final dsp = _disputes.firstWhere((d) => d.disputeId == disputeId);
    setState(() {
      dsp.status = 'Resolved';
      dsp.adminResolution = resolution;
      final order = _orders.firstWhere((o) => o.orderId == dsp.orderId);
      order.orderStatus = 'SELESAI';
      order.escrowStatus = 'Resolved';
    });
  }

  void _withdraw(double amount) {
    setState(() {
      if (_currentStudent!.walletBalance >= amount) {
        _currentStudent!.walletBalance -= amount;
      }
    });
  }

  void _toggleRole(String newRole) {
    setState(() {
      _currentStudent!.activeRole = newRole;
    });
  }

  void _verifyKyc(String matricNo) {
    setState(() {
      _currentStudent!.kycStatus = 'Verified';
    });
  }

  void _updateUser(UserModel updatedUser) {
    setState(() {
      _currentStudent = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiswaBantu Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      home: ResponsiveDeviceFrame(
        child: _isAdminLoggedIn
            ? AdminScreen(
                disputes: _disputes,
                orders: _orders,
                onResolveDispute: _resolveDispute,
                onLogout: _logout,
              )
            : _currentStudent != null
                ? MainNavigationScreen(
                    currentUser: _currentStudent!,
                    services: _services,
                    sosList: _sosList,
                    orders: _orders,
                    onBookService: _bookService,
                    onAddService: _addService,
                    onPostSOS: _postSOS,
                    onOfferHelp: _offerHelp,
                    onUpdateOrderStatus: _updateOrderStatus,
                    onRaiseDispute: _raiseDispute,
                    onWithdraw: _withdraw,
                    onToggleRole: _toggleRole,
                    onVerifyKyc: _verifyKyc,
                    onUpdateUser: _updateUser,
                    onLogout: _logout,
                  )
                : AuthScreen(
                    users: _users,
                    onLoginSiswa: _loginSiswa,
                    onLoginAdmin: _loginAdmin,
                    onRegisterSiswa: _registerSiswa,
                  ),
      ),
    );
  }
}
