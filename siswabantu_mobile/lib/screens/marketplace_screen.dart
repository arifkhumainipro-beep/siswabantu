import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/ipta_data.dart';
import '../models/models.dart';
import '../services/security_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ipta_logo_badge.dart';
import '../widgets/app_decorations.dart';
import '../widgets/selangor_elements.dart';
import '../services/image_upload_helper.dart';

class MarketplaceScreen extends StatefulWidget {
  final UserModel currentUser;
  final List<ServiceModel> services;
  final Function(ServiceModel) onBookService;
  final Function(ServiceModel) onAddService;
  final Function(String)? onToggleRole;

  const MarketplaceScreen({
    super.key,
    required this.currentUser,
    required this.services,
    required this.onBookService,
    required this.onAddService,
    this.onToggleRole,
  });

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedCampus = 'all';
  double _maxPrice = 150.0;
  final Set<String> _bookmarkedServiceIds = {'srv-1', 'srv-3'};



  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'name': 'Semua', 'icon': Icons.grid_view_rounded, 'color': AppTheme.primary, 'bg': Color(0xFFFEF2F2), 'border': Color(0xFFFECACA)},
    {'id': 'runner', 'name': 'Runner', 'icon': Icons.two_wheeler_rounded, 'color': Color(0xFFD97706), 'bg': Color(0xFFFFFBEB), 'border': Color(0xFFFDE68A)},
    {'id': 'akademik', 'name': 'Tutor', 'icon': Icons.school_rounded, 'color': Color(0xFF2563EB), 'bg': Color(0xFFEFF6FF), 'border': Color(0xFFBFDBFE)},
    {'id': 'teknikal', 'name': 'Teknikal', 'icon': Icons.laptop_mac_rounded, 'color': Color(0xFF0D9488), 'bg': Color(0xFFF0FDFA), 'border': Color(0xFF99F6E4)},
    {'id': 'rekaan', 'name': 'Rekaan', 'icon': Icons.palette_rounded, 'color': Color(0xFFC026D3), 'bg': Color(0xFFFDF4FF), 'border': Color(0xFFF0ABFC)},
    {'id': 'dobi', 'name': 'Dobi', 'icon': Icons.local_laundry_service_rounded, 'color': Color(0xFF0284C7), 'bg': Color(0xFFF0F9FF), 'border': Color(0xFFBAE6FD)},
  ];

  List<Map<String, String>> get _campuses {
    final list = <Map<String, String>>[
      {'id': 'all', 'name': '🌟 Semua IPTA (21)', 'code': 'ALL'},
    ];
    for (final ipta in IPTAData.allIPTA) {
      list.add({
        'id': ipta.id,
        'name': ipta.code,
        'fullName': '${ipta.fullName} (${ipta.code})',
        'code': ipta.code,
      });
    }
    return list;
  }

  bool _matchesCampus(String serviceUniv, String campusId) {
    if (campusId == 'all') return true;
    final s = serviceUniv.toLowerCase();
    if (campusId == 'selangor') {
      return s.contains('selangor') || s.contains('unisel') || s.contains('uitm') || s.contains('ukm') || s.contains('upm');
    }
    if (s.contains(campusId.toLowerCase())) return true;

    final matchedIpta = IPTAData.allIPTA.where((i) => i.id == campusId).firstOrNull;
    if (matchedIpta != null) {
      if (s.contains(matchedIpta.code.toLowerCase())) return true;
      if (s.contains(matchedIpta.fullName.toLowerCase())) return true;
      if (s.contains(matchedIpta.shortName.toLowerCase())) return true;
    }
    return false;
  }

  void _toggleBookmark(String serviceId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_bookmarkedServiceIds.contains(serviceId)) {
        _bookmarkedServiceIds.remove(serviceId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Servis dibuang daripada senarai kegemaran'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _bookmarkedServiceIds.add(serviceId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Servis disimpan ke senarai kegemaran ⭐'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _showNotificationsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.notifications_active_rounded, color: AppTheme.primaryIndigo, size: 22),
                SizedBox(width: 8),
                Text(
                  'Notifikasi Kampus Terkini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildNotificationItem(
              'Escrow Selamat Diaktifkan',
              'Dana RM 15.00 telah dipegang selamat dalam Escrow untuk pesanan Runner.',
              '5 minit lepas',
              Icons.shield_rounded,
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 10),
            _buildNotificationItem(
              'Tawaran Bantuan SOS Baharu',
              'Ahmad Danial (UPSI) menawarkan bantuan untuk tugasan anda.',
              '20 minit lepas',
              Icons.bolt_rounded,
              const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 10),
            _buildNotificationItem(
              'Komisen Rendah 5% Sahaja',
              'Nikmati kadar komisen terendah pasaran khas untuk siswa universiti awam.',
              '1 jam lepas',
              Icons.percent_rounded,
              AppTheme.primaryIndigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String desc, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    double tempMaxPrice = _maxPrice;
    String tempCategory = _selectedCategory;
    String tempCampus = _selectedCampus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tune_rounded, color: AppTheme.primaryIndigo, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Tapis Carian Gig & Servis',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setSheetState(() {
                        tempMaxPrice = 150.0;
                        tempCategory = 'all';
                        tempCampus = 'all';
                      });
                    },
                    child: const Text('Reset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFEF4444))),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Harga Maksimum Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Harga Maksimum:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primarySurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'RM ${tempMaxPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.primaryIndigo),
                    ),
                  ),
                ],
              ),
              Slider(
                value: tempMaxPrice,
                min: 5.0,
                max: 150.0,
                divisions: 29,
                activeColor: AppTheme.primaryIndigo,
                inactiveColor: const Color(0xFFE2E8F0),
                onChanged: (val) => setSheetState(() => tempMaxPrice = val),
              ),
              const SizedBox(height: 12),

              // Kategori Servis
              const Text('Kategori:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSel = tempCategory == cat['id'];
                  return ChoiceChip(
                    label: Text(cat['name']),
                    selected: isSel,
                    selectedColor: AppTheme.primaryIndigo,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSel ? AppTheme.primaryIndigo : const Color(0xFFE2E8F0)),
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : AppTheme.slateDark,
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                    ),
                    onSelected: (selected) {
                      if (selected) setSheetState(() => tempCategory = cat['id']);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Butang Tindakan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryIndigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    setState(() {
                      _maxPrice = tempMaxPrice;
                      _selectedCategory = tempCategory;
                      _selectedCampus = tempCampus;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Gunakan Penapis',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showAllIPTAPicker() {
    String filterText = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final list = IPTAData.allIPTA.where((i) {
            return filterText.isEmpty ||
                i.fullName.toLowerCase().contains(filterText.toLowerCase()) ||
                i.code.toLowerCase().contains(filterText.toLowerCase()) ||
                i.state.toLowerCase().contains(filterText.toLowerCase()) ||
                i.shortName.toLowerCase().contains(filterText.toLowerCase());
          }).toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.78,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.school_rounded, size: 20, color: AppTheme.primaryIndigo),
                        SizedBox(width: 8),
                        Text(
                          'Pilih Universiti Awam (20 IPTA + UniSEL)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (val) => setSheetState(() => filterText = val),
                  decoration: InputDecoration(
                    hintText: 'Cari nama universiti cth: UPSI, UiTM, UM, UTM...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.primaryIndigo),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Text('🌟', style: TextStyle(fontSize: 22)),
                  title: const Text('Semua Kampus Universiti', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                  subtitle: const Text('Tunjukkan semua servis mahasiswa seluruh Malaysia', style: TextStyle(fontSize: 11)),
                  trailing: _selectedCampus == 'all'
                      ? const Icon(Icons.check_circle, color: AppTheme.primaryIndigo)
                      : null,
                  onTap: () {
                    setState(() => _selectedCampus = 'all');
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final ipta = list[idx];
                      final isSel = _selectedCampus == ipta.id;
                      return ListTile(
                        leading: IPTALogoBadge(ipta: ipta, size: 36),
                        title: Text(
                          '${ipta.code} - ${ipta.shortName}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                            color: isSel ? AppTheme.primaryIndigo : AppTheme.slateDark,
                          ),
                        ),
                        subtitle: Text(
                          '${ipta.fullName} • ${ipta.state}',
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                        trailing: isSel
                            ? const Icon(Icons.check_circle, color: AppTheme.primaryIndigo, size: 18)
                            : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                        onTap: () {
                          setState(() => _selectedCampus = ipta.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }



  List<ServiceModel> get _filteredServices {
    return widget.services.where((srv) {
      final matchesSearch = _searchQuery.isEmpty ||
          srv.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          srv.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          srv.providerName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCat = _selectedCategory == 'all' || srv.category == _selectedCategory;
      final matchesCampus = _matchesCampus(srv.university, _selectedCampus);
      final matchesPrice = srv.price <= _maxPrice;

      return matchesSearch && matchesCat && matchesCampus && matchesPrice;
    }).toList();
  }

  void _showServiceDetail(ServiceModel srv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Jalur Aksen Moden di bahagian atas modal
              const ModernAccentStrip(height: 3.5),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Utama
                      Stack(
                        children: [
                          Image.network(
                            srv.images.isNotEmpty
                                ? srv.images.first
                                : 'https://images.unsplash.com/photo-1526367790999-0150786686a2?auto=format&fit=crop&w=800&q=80',
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 220,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 14,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.accentCyan,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.security, size: 14, color: Color(0xFF0F172A)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Escrow Protected • ${srv.categoryName}',
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const StudentVerifiedBadge(),
                                Text(
                                  SecurityService.formatRM(srv.price),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.primaryIndigo,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              srv.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.slateDark,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Profil Penyedia Servis Siswa
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(srv.providerAvatar),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          srv.providerName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.slateDark,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${srv.university} • ${srv.college}',
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${srv.rating.toStringAsFixed(1)} (${srv.reviewsCount} Ulasan Siswa Sah)',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.slateDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),
                            const Text(
                              'Keterangan Servis',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              srv.description,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.5),
                            ),
                            const SizedBox(height: 18),

                            // Jaminan Keselamatan Escrow SiswaBantu
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 24),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Jaminan Perlindungan Escrow SiswaBantu',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF065F46),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Wang bayaran disimpan selamat dalam akaun amanah. Penyedia hanya menerima wang selepas anda berpuas hati dan sahkan kerja.',
                                          style: TextStyle(fontSize: 10.5, color: Color(0xFF047857), height: 1.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // Bahagian Sistem Rating & Ulasan Siswa
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 20),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Penarafan & Ulasan (${srv.reviewsCount})',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => _showRateServiceDialog(srv, setModalState),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFFDE68A)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.rate_review_rounded, size: 13, color: Color(0xFF92400E)),
                                        SizedBox(width: 4),
                                        Text(
                                          '+ Tulis Ulasan',
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Kotak Ringkasan Penarafan Bintang
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        srv.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.slateDark,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: List.generate(5, (sIdx) {
                                          return Icon(
                                            sIdx < srv.rating.floor()
                                                ? Icons.star_rounded
                                                : (sIdx < srv.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                                            size: 15,
                                            color: const Color(0xFFF59E0B),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${srv.reviewsCount} penilaian siswa',
                                        style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 14),
                                  Container(width: 1, height: 60, color: const Color(0xFFE2E8F0)),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildRatingBar('5', srv.rating >= 4.5 ? 0.85 : 0.6),
                                        _buildRatingBar('4', 0.12),
                                        _buildRatingBar('3', 0.03),
                                        _buildRatingBar('2', 0.0),
                                        _buildRatingBar('1', 0.0),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Senarai Komen & Ulasan Pelajar Sebenar
                            if (srv.reviews.isNotEmpty) ...[
                              ...srv.reviews.map((rev) => _buildReviewCard(rev)),
                            ] else ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.chat_bubble_outline_rounded, size: 28, color: Color(0xFF94A3B8)),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Belum ada ulasan bertulis lagi.',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF475569)),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Jadilah mahasiswa pertama yang menilai servis ini!',
                                      style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton.icon(
                                      onPressed: () => _showRateServiceDialog(srv, setModalState),
                                      icon: const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                                      label: const Text('Beri Penarafan Sekarang', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryIndigo,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Butang Tempah Segera
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.lock_rounded, size: 18),
                    label: Text('Tempah Servis Sekarang (${SecurityService.formatRM(srv.price)})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryIndigo,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onBookService(srv);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRateServiceDialog(ServiceModel srv, StateSetter setModalState) {
    double userRating = 5.0;
    final commentController = TextEditingController();
    final Set<String> selectedTags = {'Pantas ⚡️'};
    final availableTags = ['Pantas ⚡️', 'Kemas ✨', 'Sopan 😊', 'Harga Berpatutan 💰', 'Amanah 🔒', 'Sangat Disyorkan 🌟'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setRatingState) {
          String ratingLabel = 'Cemerlang & Amat Disyorkan! 🌟';
          if (userRating == 1.0) {
            ratingLabel = 'Kurang Memuaskan 🙁';
          } else if (userRating == 2.0) {
            ratingLabel = 'Boleh Dibaiki 🤔';
          } else if (userRating == 3.0) {
            ratingLabel = 'Sederhana & Okey 👍';
          } else if (userRating == 4.0) {
            ratingLabel = 'Bagus & Memuaskan ✨';
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Beri Penarafan & Ulasan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Text(
                    'Ulasan anda membantu rakan siswa memilih servis terbaik & membina reputasi penyedia.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 18),

                  // Pilihan Bintang Interaktif
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final starVal = index + 1.0;
                            return IconButton(
                              iconSize: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              icon: Icon(
                                starVal <= userRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: const Color(0xFFF59E0B),
                              ),
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                setRatingState(() => userRating = starVal);
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Text(
                            ratingLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tag Pengalaman
                  const Text('Pilih Tag Pengalaman:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: availableTags.map((t) {
                      final isSel = selectedTags.contains(t);
                      return ChoiceChip(
                        label: Text(t),
                        selected: isSel,
                        selectedColor: const Color(0xFFEEF2FF),
                        backgroundColor: const Color(0xFFF8FAFC),
                        side: BorderSide(color: isSel ? AppTheme.primaryIndigo : const Color(0xFFE2E8F0)),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          color: isSel ? AppTheme.primaryIndigo : const Color(0xFF475569),
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                        ),
                        onSelected: (val) {
                          setRatingState(() {
                            if (val) {
                              selectedTags.add(t);
                            } else {
                              selectedTags.remove(t);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Komen Ulasan
                  const Text('Tulis Ulasan Anda:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Kongsi pengalaman servis, ketepatan masa, kualiti kerja atau keramahan penyedia...',
                      hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Butang Hantar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                      label: const Text('Hantar Penarafan ⭐', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryIndigo,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        final newRev = ServiceReview(
                          reviewId: 'rev-${DateTime.now().millisecondsSinceEpoch}',
                          reviewerName: widget.currentUser.fullName,
                          reviewerAvatar: widget.currentUser.avatar,
                          reviewerMatric: widget.currentUser.matricNo,
                          university: widget.currentUser.universityName,
                          rating: userRating,
                          comment: commentController.text.trim().isNotEmpty
                              ? commentController.text.trim()
                              : 'Servis sangat berpuas hati dan disyorkan untuk warga kampus!',
                          tags: selectedTags.toList(),
                          date: 'Baru sebentar tadi',
                        );

                        srv.addReview(newRev);
                        setModalState(() {});
                        setState(() {});

                        HapticFeedback.mediumImpact();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Terima kasih! Penarafan ${userRating.toStringAsFixed(1)}★ anda telah direkodkan.'),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingBar(String stars, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Text('$stars★', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 5,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ServiceReview rev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(rev.reviewerAvatar),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          rev.reviewerName,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Siswa Sah',
                            style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${rev.university} • ${rev.date}',
                      style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (sIdx) {
                  return Icon(
                    sIdx < rev.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 13,
                    color: const Color(0xFFF59E0B),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rev.comment,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF334155), height: 1.35),
          ),
          if (rev.tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 5,
              children: rev.tags.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddServiceDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController(text: '15.00');
    final defaultIpta = IPTAData.findByUnivString(widget.currentUser.universityName);
    String selectedCampusId = _selectedCampus != 'all'
        ? _selectedCampus
        : (defaultIpta?.id ?? 'uitm');
    final collegeController = TextEditingController(
      text: widget.currentUser.college.isNotEmpty ? widget.currentUser.college : 'Kolej Kediaman Kampus',
    );
    String selectedCategory = 'runner';
    String selectedSla = '24 Jam';
    double enteredPrice = 15.00;

    final Map<String, String> categoryNames = {
      'runner': 'Runner & Penghantaran',
      'akademik': 'Tutor & Akademik',
      'teknikal': 'Format Laptop & IT',
      'rekaan': 'Reka Grafik & Video',
      'dobi': 'Dobi & Kemas',
    };

    final Map<String, String> defaultImages = {
      'runner': 'https://images.unsplash.com/photo-1526367790999-0150786686a2?auto=format&fit=crop&w=800&q=80',
      'akademik': 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=800&q=80',
      'teknikal': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=800&q=80',
      'rekaan': 'https://images.unsplash.com/photo-1558655146-d09347e92766?auto=format&fit=crop&w=800&q=80',
      'dobi': 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?auto=format&fit=crop&w=800&q=80',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final commissionFee = enteredPrice * 0.05;
          final netEarnings = enteredPrice * 0.95;

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.add_business_rounded, color: AppTheme.primaryIndigo, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Tawar Servis Kemahiran Siswa',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Text(
                    'Jana pendapatan halal dengan menawarkan kemahiran anda kepada warga universiti awam.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),

                  // 1. Pilihan IPTA / Kampus (Bahagian Wajib Mengikut Kehendak Pengguna)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.school_rounded, color: AppTheme.primaryIndigo, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Pilih Universiti Awam (20 IPTA + UniSEL):',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: selectedCampusId,
                          isExpanded: true,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 1.5)),
                          ),
                          items: IPTAData.allIPTA.map((ipta) {
                            return DropdownMenuItem<String>(
                              value: ipta.id,
                              child: Row(
                                children: [
                                  IPTALogoBadge(ipta: ipta, size: 22),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${ipta.code} - ${ipta.shortName}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => selectedCampusId = val);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Kolej Kediaman / Zon Liputan Servis:',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: collegeController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Cth: Kolej Mawar, Kolej Harun Aminurrashid atau Seluruh Kampus',
                            hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.location_on_outlined, size: 18, color: AppTheme.primaryIndigo),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 1.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Pilihan Kategori
                  const Text('Pilih Kategori:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      {'id': 'runner', 'name': 'Runner', 'icon': Icons.two_wheeler_rounded},
                      {'id': 'akademik', 'name': 'Tutor', 'icon': Icons.school_rounded},
                      {'id': 'teknikal', 'name': 'Laptop & IT', 'icon': Icons.laptop_mac_rounded},
                      {'id': 'rekaan', 'name': 'Grafik', 'icon': Icons.palette_rounded},
                      {'id': 'dobi', 'name': 'Dobi', 'icon': Icons.local_laundry_service_rounded},
                    ].map((c) {
                      final isSel = selectedCategory == c['id'];
                      return ChoiceChip(
                        avatar: Icon(c['icon'] as IconData, size: 16, color: isSel ? Colors.white : AppTheme.primaryIndigo),
                        label: Text(c['name'] as String),
                        selected: isSel,
                        selectedColor: AppTheme.primaryIndigo,
                        backgroundColor: const Color(0xFFF8FAFC),
                        side: BorderSide(color: isSel ? AppTheme.primaryIndigo : const Color(0xFFE2E8F0)),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppTheme.slateDark,
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                        ),
                        onSelected: (val) {
                          if (val) setSheetState(() => selectedCategory = c['id'] as String);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // 3. Tajuk Servis
                  const Text('Tajuk Servis:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'cth: Runner Makanan Kolej, Format Laptop, Tutor Math...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.title_rounded, size: 20, color: AppTheme.primaryIndigo),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4. Keterangan Servis
                  const Text('Keterangan Servis:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Terangkan apa yang anda sediakan, kolej liputan, dan kelebihan servis anda...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.description_outlined, size: 20, color: AppTheme.primaryIndigo),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 5. Harga & Tempoh SLA
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Harga Servis (RM):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: priceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (val) {
                                final p = double.tryParse(val) ?? 0.0;
                                setSheetState(() => enteredPrice = p);
                              },
                              decoration: InputDecoration(
                                prefixText: 'RM ',
                                prefixStyle: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryIndigo),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 1.5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tempoh Siap (SLA):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: selectedSla,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                              ),
                              items: const [
                                DropdownMenuItem(value: '30 Minit', child: Text('30 Minit', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: '1 Jam', child: Text('1 Jam', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: '2 Jam', child: Text('2 Jam', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: '24 Jam', child: Text('24 Jam', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: '2-3 Hari', child: Text('2-3 Hari', style: TextStyle(fontSize: 12))),
                              ],
                              onChanged: (val) {
                                if (val != null) setSheetState(() => selectedSla = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kad Telus Komisen Escrow SiswaBantu
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_rounded, color: Color(0xFF059669), size: 18),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pendapatan Bersih Anda (95%):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
                                Text(
                                  'RM ${netEarnings.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF047857)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          'Yuran Escrow: RM ${commissionFee.toStringAsFixed(2)} (5%)',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Butang Terbitkan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.rocket_launch_rounded, size: 18, color: Colors.white),
                      label: const Text(
                        'Terbitkan Tawaran Servis Sekarang 🚀',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryIndigo,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sila masukkan tajuk servis anda.'), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        final chosenIpta = IPTAData.allIPTA.where((i) => i.id == selectedCampusId).firstOrNull;
                        final univName = chosenIpta != null
                            ? '${chosenIpta.fullName} (${chosenIpta.code})'
                            : widget.currentUser.universityName;
                        final collegeName = collegeController.text.trim().isNotEmpty
                            ? collegeController.text.trim()
                            : widget.currentUser.college;

                        final newSrv = ServiceModel(
                          serviceId: 'srv-${DateTime.now().millisecondsSinceEpoch}',
                          providerId: widget.currentUser.userId,
                          providerName: widget.currentUser.fullName,
                          providerAvatar: widget.currentUser.avatar,
                          providerMatric: widget.currentUser.matricNo,
                          university: univName,
                          college: collegeName,
                          title: titleController.text.trim(),
                          category: selectedCategory,
                          categoryName: categoryNames[selectedCategory] ?? 'Servis Siswa',
                          description: descController.text.trim().isNotEmpty
                              ? descController.text.trim()
                              : 'Servis pantas dan amanah oleh mahasiswa $univName.',
                          price: enteredPrice > 0 ? enteredPrice : 15.0,
                          slaHours: selectedSla,
                          rating: 5.0,
                          reviewsCount: 0,
                          images: [
                            defaultImages[selectedCategory] ??
                                'https://images.unsplash.com/photo-1526367790999-0150786686a2?auto=format&fit=crop&w=800&q=80'
                          ],
                          reviews: [],
                        );

                        widget.onAddService(newSrv);
                        if (widget.onToggleRole != null) {
                          widget.onToggleRole!('penyedia');
                        }

                        // Tukar filter ke kampus yang dipilih supaya pengguna nampak servis mereka serta-merta
                        setState(() {
                          _selectedCampus = selectedCampusId;
                        });

                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tahniah! Servis "${newSrv.title}" berjaya diterbitkan di ${chosenIpta?.code ?? univName}.'),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final popularServices = widget.services.take(5).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppTheme.primaryIndigo,
          backgroundColor: Colors.white,
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            await Future.delayed(const Duration(milliseconds: 900));
            if (mounted) setState(() {});
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              // 0. Jalur Rasmi Selangor Darul Ehsan (Merah & Kuning Diraja)
              const SliverToBoxAdapter(
                child: SelangorTopBarRibbon(),
              ),

              // 1. Dribbble-Style User Profile Greeting Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Row(
                    children: [
                      // Avatar Pengguna dengan Status Dot Hijau
                      Stack(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.primaryIndigo.withValues(alpha: 0.3), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryIndigo.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image(
                                image: ImageUploadHelper.getImageProvider(widget.currentUser.avatar),
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                                  backgroundColor: AppTheme.primaryIndigo,
                                  child: Icon(Icons.person, color: Colors.white, size: 24),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // Ucapan & Nama
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Hai, ${widget.currentUser.fullName.split(' ').first} 👋',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.slateDark,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Cari Mikro-Gig & Jawatan Kampus',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Butang Pantas Tawar Servis
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showAddServiceDialog();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF991B1B), Color(0xFFC8102E)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Tawar Servis',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Butang Notifikasi (Dribbble Squircle)
                      GestureDetector(
                        onTap: _showNotificationsDialog,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.notifications_none_rounded, color: AppTheme.slateDark, size: 22),
                              Positioned(
                                top: 10,
                                right: 11,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 2. Kotak Carian Moden + Butang Penapis Squircle (Dribbble Style)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    // Kotak Carian Rounded
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Cari servis cth: laptop, runner UPSI, tutor...',
                            hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 21),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                    onPressed: () => setState(() => _searchQuery = ''),
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Butang Filter Squircle Induk
                    GestureDetector(
                      onTap: _showFilterSheet,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF991B1B), Color(0xFFC8102E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2b. Kad Inisiatif Komuniti Mahasiswa (Tema Merah & Kuning / Emas Elegan)
            SliverToBoxAdapter(
              child: AppInitiativeCard(
                onExploreServices: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedCampus = 'all';
                    _selectedCategory = 'all';
                    _searchQuery = '';
                  });
                },
              ),
            ),

            // 3. "Peluang Gig Popular" (Horizontal Featured Gigs Carousel - Dribbble Card)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Peluang Gig Popular 🔥',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.slateDark,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = 'all';
                          _selectedCampus = 'all';
                          _searchQuery = '';
                        });
                      },
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryIndigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Horizontal Slider Kad Popular
            SliverToBoxAdapter(
              child: SizedBox(
                height: 195,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: popularServices.length,
                  itemBuilder: (context, idx) {
                    final srv = popularServices[idx];
                    return _buildPopularJobCard(srv);
                  },
                ),
              ),
            ),

            // 4. "Kategori Mikro-Gig" (Pastel Squircle Tiles - Dribbble Style)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Kategori Mikro-Gig',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.slateDark,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.stars_rounded, size: 16, color: Color(0xFFF59E0B)),
                      ],
                    ),
                    Text(
                      '${_categories.length} Pilihan',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Senarai Squircle Kategori Pastel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 94,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, idx) {
                    final cat = _categories[idx];
                    final isSelected = _selectedCategory == cat['id'];
                    final Color iconColor = cat['color'];
                    final Color bgColor = cat['bg'];
                    final Color borderColor = cat['border'];

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedCategory = cat['id']);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xFF991B1B), Color(0xFFC8102E)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected ? null : bgColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : borderColor,
                                width: isSelected ? 2 : 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isSelected ? AppTheme.primaryIndigo : Colors.black).withValues(alpha: isSelected ? 0.28 : 0.04),
                                  blurRadius: isSelected ? 12 : 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              cat['icon'],
                              color: isSelected ? Colors.white : iconColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['name'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                              color: isSelected ? AppTheme.primaryIndigo : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // 5. "Koleksi 21 IPTA Malaysia" (Horizontal Campus Bar)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          '🌟 Koleksi 21 IPTA Malaysia',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _showAllIPTAPicker,
                      child: const Text(
                        'Pilih Semua (21)',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.primaryIndigo),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Baris Pill Kampus IPTA
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    ..._campuses.map((camp) {
                      final isSelected = _selectedCampus == camp['id'];
                      final ipta = IPTAData.allIPTA.where((i) => i.id == camp['id']).firstOrNull;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedCampus = camp['id']!);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xFF991B1B), Color(0xFFC8102E)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primary.withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (ipta != null) ...[
                                  IPTALogoBadge(ipta: ipta, size: 18),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  camp['name']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                    color: isSelected ? Colors.white : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Kad Fokus Kampus Terpilih (Ditunjukkan apabila pengguna menapis satu IPTA spesifik)
            if (_selectedCampus != 'all') ...[
              SliverToBoxAdapter(
                child: Builder(
                  builder: (context) {
                    final activeIpta = IPTAData.allIPTA.where((i) => i.id == _selectedCampus).firstOrNull;
                    if (activeIpta == null) return const SizedBox.shrink();

                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            activeIpta.primaryColor.withValues(alpha: 0.10),
                            const Color(0xFFFFFFFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: activeIpta.primaryColor.withValues(alpha: 0.3), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: activeIpta.primaryColor.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IPTALogoBadge(ipta: activeIpta, size: 44),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: activeIpta.primaryColor,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            activeIpta.code,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          activeIpta.state,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      activeIpta.fullName,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_filteredServices.length} servis aktif di kampus ini',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: _filteredServices.isNotEmpty ? const Color(0xFF059669) : const Color(0xFFD97706),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() => _selectedCampus = 'all');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFCBD5E1)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.clear_rounded, size: 14, color: Color(0xFF64748B)),
                                      SizedBox(width: 4),
                                      Text('Semua IPTA (21)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF475569))),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _showAddServiceDialog,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryIndigo,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add_circle_outline_rounded, size: 14, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+ Tawar Servis di ${activeIpta.code}',
                                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            // 6. "Jawatan & Gig Terkini" (Recent Campus Gigs - Dribbble Style Job Cards)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCampus == 'all'
                          ? 'Jawatan & Gig Terkini (${_filteredServices.length})'
                          : 'Gig di ${IPTAData.allIPTA.where((i) => i.id == _selectedCampus).firstOrNull?.code ?? "Kampus"} (${_filteredServices.length})',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.slateDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_rounded, size: 12, color: Color(0xFF059669)),
                          SizedBox(width: 3),
                          Text(
                            '100% Escrow',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 7. Senarai Kad Servis Dribbble Style
            if (_filteredServices.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      if (_selectedCampus != 'all') ...[
                        Builder(
                          builder: (context) {
                            final activeIpta = IPTAData.allIPTA.where((i) => i.id == _selectedCampus).firstOrNull;
                            return Column(
                              children: [
                                if (activeIpta != null)
                                  IPTALogoBadge(ipta: activeIpta, size: 60)
                                else
                                  const Icon(Icons.school_rounded, size: 50, color: AppTheme.primaryIndigo),
                                const SizedBox(height: 14),
                                Text(
                                  'Belum Ada Servis di ${activeIpta?.code ?? "Kampus Ini"} Lagi',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Jadilah mahasiswa pertama di ${activeIpta?.fullName ?? "kampus"} yang menawarkan servis kemahiran dan menjana pendapatan halal!',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.rocket_launch_rounded, size: 16, color: Colors.white),
                                  label: Text(
                                    '+ Tawar Servis Pertama di ${activeIpta?.code ?? "Sini"} 🚀',
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryIndigo,
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  onPressed: _showAddServiceDialog,
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => setState(() => _selectedCampus = 'all'),
                                  child: const Text(
                                    '« Lihat Servis di Semua IPTA (21 Kampus)',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryIndigo),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ] else ...[
                        Icon(Icons.search_off_rounded, size: 50, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        const Text(
                          'Tiada gig atau servis dijumpai untuk carian ini.',
                          style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final srv = _filteredServices[index];
                      return TweenAnimationBuilder<double>(
                        key: ValueKey('${srv.serviceId}-$_selectedCampus-$_selectedCategory'),
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 320 + (index.clamp(0, 5) * 60)),
                        curve: Curves.easeOutCubic,
                        builder: (context, v, child) => Opacity(
                          opacity: v,
                          child: Transform.translate(offset: Offset(0, 24 * (1 - v)), child: child),
                        ),
                        child: _buildRecentJobCard(srv),
                      );
                    },
                    childCount: _filteredServices.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
      ),
      ),
    );
  }

  /// Kad Gig Popular Mendatar (Dribbble Signature Dark Card)
  Widget _buildPopularJobCard(ServiceModel srv) {
    final ipta = IPTAData.findByUnivString(srv.university);
    final isBookmarked = _bookmarkedServiceIds.contains(srv.serviceId);

    return Container(
      width: 295,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF7F1D1D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F1D1D).withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _showServiceDetail(srv),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Baris Atas: Logo Universiti + Kod IPTA + Bookmark Icon
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ipta != null
                          ? IPTALogoBadge(ipta: ipta, size: 34, showBorder: false)
                          : const Icon(Icons.school_rounded, color: AppTheme.primaryIndigo, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ipta?.code ?? srv.university.split('(').first.trim(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentCyan.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Separuh Masa',
                            style: TextStyle(
                              color: AppTheme.accentCyan,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Butang Bookmark Glassmorphism
                    GestureDetector(
                      onTap: () => _toggleBookmark(srv.serviceId),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isBookmarked ? AppTheme.accentCyan : Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                // Bahagian Tengah: Tajuk Gig & Lokasi Kolej
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      srv.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppTheme.accentCyan, size: 12),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${srv.college} • ${ipta?.shortName ?? srv.university}',
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Baris Bawah: Kadar Bayaran + Butang "Pohon" Segera
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          SecurityService.formatRM(srv.price),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          '/ tugas',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentCyan,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pohon',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.arrow_forward_rounded, color: Color(0xFF0F172A), size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Kad Jawatan & Gig Terkini (Dribbble Clean Job List Card)
  Widget _buildRecentJobCard(ServiceModel srv) {
    final ipta = IPTAData.findByUnivString(srv.university);
    final isBookmarked = _bookmarkedServiceIds.contains(srv.serviceId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showServiceDetail(srv),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo IPTA Squircle Bersih
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: ipta != null
                      ? IPTALogoBadge(ipta: ipta, size: 40, showBorder: false)
                      : const Icon(Icons.school_rounded, color: AppTheme.primaryIndigo, size: 28),
                ),
                const SizedBox(width: 12),

                // Kolum Maklumat Gig
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris Atas: Tajuk Gig & Bookmark
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              srv.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.slateDark,
                                height: 1.25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _toggleBookmark(srv.serviceId),
                            child: Icon(
                              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isBookmarked ? AppTheme.primaryIndigo : const Color(0xFF94A3B8),
                              size: 19,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Nama Penyedia & Lokasi
                      Row(
                        children: [
                          Text(
                            srv.providerName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 12, color: AppTheme.primaryIndigo),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '• ${srv.college}',
                              style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Tag Chips & Harga
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ipta?.code ?? 'IPTA',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${srv.rating}',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.slateDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Harga
                          Text(
                            SecurityService.formatRM(srv.price),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primaryIndigo,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
