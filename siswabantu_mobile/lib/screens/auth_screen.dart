import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/ipta_data.dart';
import '../models/models.dart';
import '../services/security_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ipta_logo_badge.dart';

class AuthScreen extends StatefulWidget {
  final List<UserModel> users;
  final Function(UserModel user) onLoginSiswa;
  final VoidCallback onLoginAdmin;
  final Function(UserModel newUser) onRegisterSiswa;

  const AuthScreen({
    super.key,
    required this.users,
    required this.onLoginSiswa,
    required this.onLoginAdmin,
    required this.onRegisterSiswa,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  int _tabIndex = 0; // 0: Login Siswa, 1: Daftar Siswa, 2: Login Admin

  // Login controllers
  final _loginEmailController = TextEditingController(text: 'm20261024@siswa.upsi.edu.my');
  final _loginPassController = TextEditingController(text: 'Siswa@2026');

  // Register controllers
  final _regNameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regMatricController = TextEditingController();
  final _regPhoneController = TextEditingController();
  String _selectedUniv = 'Universiti Pendidikan Sultan Idris (UPSI)';
  bool _isVerifyingOtp = false;

  // UX state
  bool _obscurePass = true;
  bool _isLoading = false;

  // Animasi
  late final AnimationController _orbController;
  late final AnimationController _entryController;
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat(reverse: true);
    _entryController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  }

  @override
  void dispose() {
    _orbController.dispose();
    _glowController.dispose();
    _entryController.dispose();
    _loginEmailController.dispose();
    _loginPassController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regMatricController.dispose();
    _regPhoneController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: AppTheme.roseDanger,
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(msg, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStudentLogin() async {
    final rawEmail = _loginEmailController.text.trim();
    final email = SecurityService.normalizeEduEmail(rawEmail);
    _loginEmailController.text = email;

    if (!SecurityService.validateEduEmail(email)) {
      _showError('Sila masukkan e-mel universiti rasmi yang sah (.edu.my)');
      return;
    }

    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final matched = widget.users.firstWhere(
      (u) => u.eduEmail.toLowerCase() == email.toLowerCase(),
      orElse: () => UserModel(
        userId: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        fullName: email.split('@')[0].toUpperCase(),
        eduEmail: email,
        phoneNo: '+6012-3456789',
        universityName: IPTAData.allIPTA
                .where((i) => email.toLowerCase().contains(i.websiteDomain))
                .map((i) => '${i.fullName} (${i.code})')
                .firstOrNull ??
            'Universiti Pendidikan Sultan Idris (UPSI)',
        matricNo: email.split('@')[0].toUpperCase(),
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
        college: 'Kolej Kediaman',
      ),
    );

    widget.onLoginSiswa(matched);
  }

  void _handleRegisterSubmit() {
    final rawEmail = _regEmailController.text.trim();
    final email = SecurityService.normalizeEduEmail(rawEmail);
    _regEmailController.text = email;

    if (!SecurityService.validateEduEmail(email)) {
      _showError('Pendaftaran hanya sah untuk e-mel universiti (.edu.my). Contoh: d20231106365@siswa.upsi.edu.my');
      return;
    }

    // Auto-detect dan tetapkan IPTA daripada domain e-mel jika ada padanan
    final matchedIpta = IPTAData.allIPTA.where((i) => email.toLowerCase().contains(i.websiteDomain)).firstOrNull;
    if (matchedIpta != null) {
      _selectedUniv = '${matchedIpta.fullName} (${matchedIpta.code})';
    }

    // Auto-isi No. Matrik jika belum diisi
    if (_regMatricController.text.trim().isEmpty) {
      _regMatricController.text = email.split('@').first.toUpperCase();
    }

    HapticFeedback.lightImpact();
    setState(() => _isVerifyingOtp = true);
  }

  void _completeRegistration() {
    HapticFeedback.heavyImpact();
    final email = SecurityService.normalizeEduEmail(_regEmailController.text.trim());
    final matric = _regMatricController.text.trim().isNotEmpty
        ? _regMatricController.text.trim().toUpperCase()
        : email.split('@').first.toUpperCase();

    final newUser = UserModel(
      userId: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      fullName: _regNameController.text.trim().isEmpty ? 'Mahasiswa $matric' : _regNameController.text.trim(),
      eduEmail: email,
      phoneNo: _regPhoneController.text.trim().isEmpty ? '+6011-0000000' : _regPhoneController.text.trim(),
      universityName: _selectedUniv,
      matricNo: matric,
      avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=250&q=80',
      college: 'Kolej Kediaman',
    );

    widget.onRegisterSiswa(newUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1D),
      body: Stack(
        children: [
          // Latar belakang gradien teknologi moden
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F172A), Color(0xFF0A0F1D), Color(0xFF030712)],
              ),
            ),
          ),

          // Ambient Glow Indigo & Cyan
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, _) {
              final t = _orbController.value * 2 * math.pi;
              return Stack(
                children: [
                  Positioned(
                    left: -60 + 20 * math.sin(t),
                    top: -40 + 20 * math.cos(t),
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primary.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -70 + 20 * math.cos(t),
                    bottom: 60 + 20 * math.sin(t),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.accent.withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildCard(),
                    const SizedBox(height: 20),
                    _buildTrustFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo dengan glow lembut
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: AppTheme.brandGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Image.asset(
              'assets/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: AppTheme.primary,
                child: const Center(
                  child: Text('SB', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        const Text(
          'SiswaBantu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pasaran Kemahiran & Servis Kampus Malaysia',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF881337), Color(0xFFC8102E)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFCC00), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC8102E).withValues(alpha: 0.4),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.stars_rounded, size: 14, color: Color(0xFFFFCC00)),
              SizedBox(width: 5),
              Text(
                'Lindungan Escrow 100% • 21 IPTA Malaysia',
                style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(gradient: AppTheme.brandGradient),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                _buildTabs(),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _tabIndex == 0
                      ? _buildLoginTab()
                      : _tabIndex == 1
                          ? (_isVerifyingOtp ? _buildOtpView() : _buildRegisterTab())
                          : _buildAdminTab(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const labels = ['Log Masuk', 'Daftar Siswa', 'Pentadbir'];
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final isSel = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _tabIndex = i;
                  _isVerifyingOtp = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSel ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSel
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                      color: isSel ? AppTheme.primary : AppTheme.slateMuted,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // TAB: LOG MASUK
  Widget _buildLoginTab() {
    final emailText = _loginEmailController.text.toLowerCase();
    final domain = emailText.contains('@') ? emailText.split('@').last : '';
    final detected = domain.isEmpty
        ? null
        : IPTAData.allIPTA.where((i) => domain == i.emailDomain || domain.endsWith(i.websiteDomain)).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selamat Kembali', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
        const SizedBox(height: 2),
        const Text('Sila gunakan e-mel universiti (.edu.my) untuk akses', style: TextStyle(fontSize: 11.5, color: AppTheme.slateMuted)),
        const SizedBox(height: 16),
        TextField(
          controller: _loginEmailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'E-mel Siswa (.edu.my)',
            prefixIcon: const Icon(Icons.school_outlined, size: 20, color: AppTheme.primary),
            suffixIcon: detected != null
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: IPTALogoBadge(ipta: detected, size: 22),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _loginPassController,
          obscureText: _obscurePass,
          decoration: InputDecoration(
            labelText: 'Kata Laluan',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppTheme.primary),
            suffixIcon: IconButton(
              icon: Icon(_obscurePass ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 18, color: AppTheme.slateLight),
              onPressed: () => setState(() => _obscurePass = !_obscurePass),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleStudentLogin,
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Log Masuk'),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: Divider(color: AppTheme.borderLight)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('LOG MASUK PANTAS DEMO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 0.8)),
            ),
            const Expanded(child: Divider(color: AppTheme.borderLight)),
          ],
        ),
        const SizedBox(height: 10),
        _buildDemoCard(
          name: 'Muhammad Haziq (UPSI)',
          email: 'm20261024@siswa.upsi.edu.my',
          iptaCode: 'UPSI',
          avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=120&q=80',
        ),
        const SizedBox(height: 6),
        _buildDemoCard(
          name: 'Aiman Hakimi (UiTM)',
          email: '20261234@student.uitm.edu.my',
          iptaCode: 'UiTM',
          avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=120&q=80',
        ),
      ],
    );
  }

  Widget _buildDemoCard({required String name, required String email, required String iptaCode, required String avatar}) {
    return Material(
      color: AppTheme.surfaceLight,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          _loginEmailController.text = email;
          _handleStudentLogin();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatar)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                    Text(email, style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(iptaCode, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB: DAFTAR
  Widget _buildRegisterTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daftar Akaun Baharu', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
        const SizedBox(height: 2),
        const Text('Wajib menggunakan e-mel rasmi IPTA (.edu.my)', style: TextStyle(fontSize: 11.5, color: AppTheme.slateMuted)),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _selectedUniv,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Universiti Awam (IPTA)'),
          items: IPTAData.allIPTA.map((ipta) {
            return DropdownMenuItem<String>(
              value: '${ipta.fullName} (${ipta.code})',
              child: Row(
                children: [
                  IPTALogoBadge(ipta: ipta, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${ipta.code} - ${ipta.shortName}',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val == null) return;
            setState(() {
              _selectedUniv = val;
              final matched = IPTAData.allIPTA.firstWhere((i) => '${i.fullName} (${i.code})' == val);
              if (_regEmailController.text.trim().isEmpty) {
                final prefix = _regMatricController.text.isNotEmpty
                    ? _regMatricController.text.toLowerCase()
                    : (_regNameController.text.isNotEmpty ? _regNameController.text.toLowerCase().replaceAll(' ', '') : 'siswa2026');
                _regEmailController.text = '$prefix@${matched.emailDomain}';
              }
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _regNameController,
          decoration: const InputDecoration(
            labelText: 'Nama Penuh Mahasiswa',
            hintText: 'cth: Muhammad Danish',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _regEmailController,
          onChanged: (val) {
            final normalized = SecurityService.normalizeEduEmail(val);
            // Auto padan universiti jika domain sepadan
            final matched = IPTAData.allIPTA.where((i) => normalized.contains(i.websiteDomain)).firstOrNull;
            if (matched != null && _selectedUniv != '${matched.fullName} (${matched.code})') {
              setState(() {
                _selectedUniv = '${matched.fullName} (${matched.code})';
              });
            }
            // Auto isi no matrik jika kosong
            if (normalized.contains('@') && _regMatricController.text.isEmpty) {
              final prefix = normalized.split('@').first.toUpperCase();
              _regMatricController.text = prefix;
            }
          },
          decoration: const InputDecoration(
            labelText: 'E-mel Rasmi Universiti (.edu.my)',
            hintText: 'cth: d20231106365@siswa.upsi.edu.my atau d20231106365.siswa.upsi.edu.my',
            helperText: 'Menyokong format standard (@) & format noktah (.)',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _regMatricController,
                decoration: const InputDecoration(
                  labelText: 'No. Matrik',
                  hintText: 'cth: D20231106365',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _regPhoneController,
                decoration: const InputDecoration(labelText: 'No. Telefon'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _handleRegisterSubmit,
            child: const Text('Hantar Kod OTP'),
          ),
        ),
      ],
    );
  }

  // OTP
  Widget _buildOtpView() {
    return Column(
      children: [
        const Icon(Icons.mark_email_read_rounded, size: 40, color: AppTheme.primary),
        const SizedBox(height: 10),
        const Text('Sahkan Kod OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text('Kod dihantar ke ${_regEmailController.text}', style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['5', '2', '8', '9', '1', '4'].map((d) {
            return Container(
              width: 38,
              height: 46,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                border: Border.all(color: AppTheme.primary, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(d, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _completeRegistration,
            child: const Text('Sahkan & Mulakan'),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _isVerifyingOtp = false),
          child: const Text('Ubah Maklumat', style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
        ),
      ],
    );
  }

  // ADMIN
  Widget _buildAdminTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.admin_panel_settings_rounded, color: AppTheme.slateDark, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Portal Pengurusan & Audit SiswaBantu',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const TextField(
          decoration: InputDecoration(
            labelText: 'ID Pentadbir',
            hintText: 'admin@siswabantu.my',
            prefixIcon: Icon(Icons.badge_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: _obscurePass,
          decoration: InputDecoration(
            labelText: 'Kata Laluan',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, size: 18),
              onPressed: () => setState(() => _obscurePass = !_obscurePass),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.slateDark),
            onPressed: widget.onLoginAdmin,
            child: const Text('Log Masuk Pentadbir'),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustFooter() {
    Widget item(IconData icon, String text) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return Row(
      children: [
        item(Icons.lock_rounded, 'Escrow Selamat'),
        item(Icons.verified_user_rounded, 'e-KYC Rasmi'),
        item(Icons.security_rounded, 'Anti-Scam'),
      ],
    );
  }
}
