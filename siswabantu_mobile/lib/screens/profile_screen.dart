import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/ipta_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_decorations.dart';
import '../widgets/selangor_elements.dart';
import '../services/image_upload_helper.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel currentUser;
  final Function(String newRole) onToggleRole;
  final Function(String matricNo) onVerifyKyc;
  final Function(UserModel updatedUser) onUpdateUser;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.currentUser,
    required this.onToggleRole,
    required this.onVerifyKyc,
    required this.onUpdateUser,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _showCertificateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.workspace_premium_rounded, size: 24, color: AppTheme.primaryIndigo),
                SizedBox(width: 8),
                Text(
                  'Sijil Kemahiran Digital SiswaBantu (SKDS)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Pengiktirafan Rasmi Pengalaman Gig Mahasiswa Malaysia',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('DIPERAKUKAN KEPADA', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 1, color: Color(0xFF92400E))),
                  const SizedBox(height: 6),
                  Text(
                    widget.currentUser.fullName.toUpperCase(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                  ),
                  Text(
                    'No. Matrik: ${widget.currentUser.matricNo} • ${widget.currentUser.universityName.split('(').first.trim()}',
                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFFFE6A7)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Penarafan', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                          Text('⭐ ${widget.currentUser.ratingAvg}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFB45309))),
                        ],
                      ),
                      const Column(
                        children: [
                          Text('Taraf Kebolehpercayaan', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                          Text('Tier 1: Elit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.green)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Tugasan Siap', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                          Text('${widget.currentUser.ratingCount}+ Servis', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share_rounded, size: 16),
                label: const Text('Kongsi ke LinkedIn / Muat Turun PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryIndigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pautan Sijil Digital Berjaya Dijana & Disalin!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKycDialog(BuildContext context) {
    setState(() => _isScanning = false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: const Row(
              children: [
                Icon(Icons.verified_user_rounded, size: 20, color: AppTheme.primaryIndigo),
                SizedBox(width: 8),
                Text('e-KYC Kad Siswa IPTA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengesahan automatik kad matrik & biometrik dengan sokongan institusi IPTA di seluruh Malaysia.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),
                // Kad dengan animasi imbasan laser
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.badge_rounded, size: 36, color: AppTheme.accentCyan),
                          const SizedBox(height: 6),
                          Text(
                            widget.currentUser.fullName,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'NO. MATRIK: ${widget.currentUser.matricNo}',
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'KAD DIGITAL MAHASISWA MALAYSIA • IPTA',
                            style: TextStyle(color: AppTheme.accentCyan, fontSize: 8.5, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    if (_isScanning)
                      AnimatedBuilder(
                        animation: _scanController,
                        builder: (context, child) {
                          return Positioned(
                            top: _scanController.value * 110 + 10,
                            left: 10,
                            right: 10,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppTheme.accentCyan,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentCyan.withValues(alpha: 0.8),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_isScanning)
                  const Center(
                    child: Text(
                      'Mengimbas OCR Kad Pelajar... 85%',
                      style: TextStyle(fontSize: 11, color: AppTheme.primaryIndigo, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryIndigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  setDialogState(() => _isScanning = true);
                  Future.delayed(const Duration(milliseconds: 1600), () {
                    widget.onVerifyKyc(widget.currentUser.matricNo);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tahniah! Status Siswa Sah Berjaya Disahkan 100%.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  });
                },
                child: const Text('Mula Imbasan'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Bottom Sheet Pilihan Tukar Gambar Profil (Muat Naik Peranti atau Preset Avatar)
  void _showAvatarOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tukar Gambar Profil Siswa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih kaedah untuk menetapkan gambar profil rasmi akaun anda.',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              // Pilihan 1: Muat naik gambar dari peranti terus
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: const Color(0xFFFEF2F2),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 20),
                ),
                title: const Text('Muat Naik dari Galeri / Komputer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                subtitle: const Text('Pilih fail gambar JPG, PNG dari storan anda.', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.primary),
                onTap: () {
                  Navigator.pop(ctx);
                  ImageUploadHelper.pickImage((base64DataUrl) {
                    widget.onUpdateUser(widget.currentUser.copyWith(avatar: base64DataUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gambar profil berjaya dikemaskini daripada peranti! 🎉'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 10),
              // Pilihan 2: Edit profil penuh
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: const Color(0xFFF8FAFC),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppTheme.slateDark, size: 20),
                ),
                title: const Text('Pilih Daripada Koleksi Avatar Sedia Ada', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
                subtitle: const Text('Pilih avatar mahasiswa atau ubah maklumat profil lain.', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditProfileModal(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dialog / Sheet Lengkap Edit Profil, Gambar, Kemahiran & Pengalaman
  void _showEditProfileModal(BuildContext context) {
    final nameCtrl = TextEditingController(text: widget.currentUser.fullName);
    final phoneCtrl = TextEditingController(text: widget.currentUser.phoneNo);
    final collegeCtrl = TextEditingController(text: widget.currentUser.college);
    final courseCtrl = TextEditingController(text: widget.currentUser.courseName);
    final yearCtrl = TextEditingController(text: widget.currentUser.yearOfStudy);
    final bioCtrl = TextEditingController(text: widget.currentUser.bio);
    final customAvatarCtrl = TextEditingController();

    final newExpCtrl = TextEditingController();
    final newSkillCtrl = TextEditingController();

    String currentAvatar = widget.currentUser.avatar;
    final matchedIpta = IPTAData.findByUnivString(widget.currentUser.universityName);
    String selectedUnivId = matchedIpta?.id ?? 'uitm';

    final List<String> tempSkills = List.from(widget.currentUser.skills);
    final List<String> tempExperiences = List.from(widget.currentUser.experiences);

    final List<Map<String, String>> presetAvatars = [
      {
        'label': 'Lelaki IT',
        'url': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=250&q=80',
      },
      {
        'label': 'Siswi Hijab',
        'url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
      },
      {
        'label': 'Kaca Mata',
        'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
      },
      {
        'label': 'Siswi Media',
        'url': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=250&q=80',
      },
      {
        'label': 'Runner Sukan',
        'url': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=250&q=80',
      },
      {
        'label': 'Siswi Tutor',
        'url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
      },
      {
        'label': 'Kejuruteraan',
        'url': 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=250&q=80',
      },
    ];

    final List<String> quickSkillSuggestions = [
      'Runner Kampus ⚡',
      'Format Laptop 💻',
      'Tutor Matematik 📚',
      'Reka Grafik Canva 🎨',
      'Dobi & Lipat 🧺',
      'SPSS & Data 📊',
      'Percetakan Tesis 📄',
      'Fotografi Siswa 📸',
      'Proofreading Tesis ✍️',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                          Icon(Icons.badge_rounded, color: AppTheme.primaryIndigo, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Kemaskini Profil Siswa',
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
                    'Ubah gambar profil, maklumat universiti, pengalaman gig, dan kemahiran anda.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 18),

                  // 1. Bahagian Tukar Gambar Profil (Avatar)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.photo_camera_rounded, size: 18, color: AppTheme.primaryIndigo),
                            SizedBox(width: 6),
                            Text('Gambar Profil Pelajar:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.primaryIndigo, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: ImageUploadHelper.getImageProvider(currentAvatar),
                                backgroundColor: Colors.grey.shade200,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Pilih daripada avatar pelajar sediakan:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                                  const SizedBox(height: 6),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: presetAvatars.map((p) {
                                        final isSel = currentAvatar == p['url'];
                                        return GestureDetector(
                                          onTap: () {
                                            HapticFeedback.selectionClick();
                                            setModalState(() => currentAvatar = p['url']!);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSel ? AppTheme.primaryIndigo : Colors.transparent,
                                                width: 2.5,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundImage: NetworkImage(p['url']!),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Butang Pilih Fail Dari Peranti / Komputer
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ImageUploadHelper.pickImage((base64DataUrl) {
                              setModalState(() {
                                currentAvatar = base64DataUrl;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF991B1B), Color(0xFFC8102E)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Muat Naik Gambar dari Peranti / Komputer (JPG/PNG)',
                                  style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: customAvatarCtrl,
                          decoration: InputDecoration(
                            hintText: 'Atau tampal URL pautan gambar sendiri...',
                            hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.link_rounded, size: 18, color: AppTheme.primaryIndigo),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 20),
                              onPressed: () {
                                if (customAvatarCtrl.text.trim().isNotEmpty) {
                                  setModalState(() => currentAvatar = customAvatarCtrl.text.trim());
                                }
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Maklumat Diri & Kampus
                  const Text('Maklumat Asas Mahasiswa:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
                  const SizedBox(height: 8),

                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nama Penuh Siswa',
                      prefixIcon: const Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.primaryIndigo),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'No. Telefon / WhatsApp',
                            prefixIcon: const Icon(Icons.phone_outlined, size: 18, color: AppTheme.primaryIndigo),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: collegeCtrl,
                          decoration: InputDecoration(
                            labelText: 'Kolej / Blok Bilik',
                            prefixIcon: const Icon(Icons.hotel_outlined, size: 18, color: AppTheme.primaryIndigo),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Pilihan IPTA
                  DropdownButtonFormField<String>(
                    initialValue: selectedUnivId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Pilih Universiti Awam (20 IPTA + UniSEL)',
                      prefixIcon: const Icon(Icons.school_rounded, size: 18, color: AppTheme.primaryIndigo),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                    items: IPTAData.allIPTA.map((ipta) {
                      return DropdownMenuItem<String>(
                        value: ipta.id,
                        child: Text('${ipta.code} - ${ipta.shortName}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedUnivId = val);
                    },
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: courseCtrl,
                          decoration: InputDecoration(
                            labelText: 'Bidang / Kursus Pengajian',
                            prefixIcon: const Icon(Icons.menu_book_rounded, size: 18, color: AppTheme.primaryIndigo),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: yearCtrl,
                          decoration: InputDecoration(
                            labelText: 'Tahun / Semester',
                            prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18, color: AppTheme.primaryIndigo),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: bioCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Bio / Pengenalan Ringkas',
                      prefixIcon: const Icon(Icons.description_outlined, size: 18, color: AppTheme.primaryIndigo),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Seksyen Kemahiran Siswa (Skills)
                  const Row(
                    children: [
                      Icon(Icons.star_outline_rounded, size: 18, color: Color(0xFFD97706)),
                      SizedBox(width: 6),
                      Text('Kemahiran Utama Siswa:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tag kemahiran semasa
                  if (tempSkills.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: tempSkills.map((sk) {
                        return Chip(
                          backgroundColor: const Color(0xFFFEF2F2),
                          side: const BorderSide(color: Color(0xFFFECACA)),
                          label: Text(sk, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryIndigo)),
                          deleteIcon: const Icon(Icons.close, size: 14, color: AppTheme.primaryIndigo),
                          onDeleted: () {
                            setModalState(() => tempSkills.remove(sk));
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 8),

                  // Tambah kemahiran baru
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newSkillCtrl,
                          decoration: InputDecoration(
                            hintText: 'Cth: Reka Web, Video Editor, Tutor Kimia...',
                            hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16, color: Colors.white),
                        label: const Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryIndigo,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (newSkillCtrl.text.trim().isNotEmpty) {
                            setModalState(() {
                              tempSkills.add(newSkillCtrl.text.trim());
                              newSkillCtrl.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Cadangan kemahiran popular
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: quickSkillSuggestions.map((q) {
                        final exists = tempSkills.contains(q);
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ActionChip(
                            label: Text(q, style: TextStyle(fontSize: 10, color: exists ? Colors.white : const Color(0xFF475569))),
                            backgroundColor: exists ? AppTheme.primaryIndigo : const Color(0xFFF1F5F9),
                            onPressed: () {
                              setModalState(() {
                                if (exists) {
                                  tempSkills.remove(q);
                                } else {
                                  tempSkills.add(q);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Seksyen Pengalaman Kerja & Khidmat Mahasiswa (Experience)
                  const Row(
                    children: [
                      Icon(Icons.work_history_rounded, size: 18, color: Color(0xFF059669)),
                      SizedBox(width: 6),
                      Text('Pengalaman Kerja & Khidmat Siswa:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (tempExperiences.isNotEmpty)
                    Column(
                      children: tempExperiences.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final exp = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(exp, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppTheme.slateDark)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                onPressed: () {
                                  setModalState(() => tempExperiences.removeAt(idx));
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newExpCtrl,
                          decoration: InputDecoration(
                            hintText: 'Cth: Runner Makanan Seksyen 7 (1 Tahun), Format 40+ Laptop...',
                            hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_circle_outline, size: 16, color: Colors.white),
                        label: const Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (newExpCtrl.text.trim().isNotEmpty) {
                            setModalState(() {
                              tempExperiences.add(newExpCtrl.text.trim());
                              newExpCtrl.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Butang Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                      label: const Text('Simpan Perubahan Profil & Pengalaman 💾', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryIndigo,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        final chosenIpta = IPTAData.allIPTA.where((i) => i.id == selectedUnivId).firstOrNull;
                        final newUniv = chosenIpta != null
                            ? '${chosenIpta.fullName} (${chosenIpta.code})'
                            : widget.currentUser.universityName;

                        final updated = widget.currentUser.copyWith(
                          fullName: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : widget.currentUser.fullName,
                          phoneNo: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : widget.currentUser.phoneNo,
                          universityName: newUniv,
                          college: collegeCtrl.text.trim().isNotEmpty ? collegeCtrl.text.trim() : widget.currentUser.college,
                          courseName: courseCtrl.text.trim().isNotEmpty ? courseCtrl.text.trim() : widget.currentUser.courseName,
                          yearOfStudy: yearCtrl.text.trim().isNotEmpty ? yearCtrl.text.trim() : widget.currentUser.yearOfStudy,
                          bio: bioCtrl.text.trim(),
                          avatar: currentAvatar,
                          skills: tempSkills,
                          experiences: tempExperiences,
                        );

                        widget.onUpdateUser(updated);
                        HapticFeedback.mediumImpact();
                        Navigator.pop(ctx);
                        setState(() {});

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tahniah! Profil, gambar & pengalaman anda telah dikemaskini.'),
                            backgroundColor: Color(0xFF10B981),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: ListView(
        padding: const EdgeInsets.all(14),
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. Kad Profil Utama Mahasiswa (Dengan Avatar Camera Trigger & Butang Edit)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryIndigo, width: 2.5),
                      ),
                      child: CircleAvatar(
                        backgroundImage: ImageUploadHelper.getImageProvider(widget.currentUser.avatar),
                        radius: 42,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showAvatarOptionsBottomSheet(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryIndigo,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryIndigo.withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.currentUser.fullName,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, color: AppTheme.accentCyan, size: 18),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.currentUser.universityName,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const StudentVerifiedBadge(text: 'Pengesahan e-KYC Mahasiswa Sah'),
                const SizedBox(height: 6),
                SelangorStudentBadge(universityName: widget.currentUser.universityName),
                const SizedBox(height: 12),

                // Butang Utama: Edit Profil & Pengalaman
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit_note_rounded, size: 18, color: Colors.white),
                    label: const Text(
                      'Kemaskini Profil & Pengalaman Siswa',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryIndigo,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 1,
                    ),
                    onPressed: () => _showEditProfileModal(context),
                  ),
                ),
                const SizedBox(height: 14),

                // Pertukaran Dwi-Peranan (Mod Penyedia / Pemohon)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_rounded, color: AppTheme.primary, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Akaun Mahasiswa Bersepadu 🛡️',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Akses serentak: Tempah servis mahasiswa atau tawarkan servis kemahiran anda bila-bila masa.',
                              style: TextStyle(fontSize: 10, color: Color(0xFF64748B), height: 1.25),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Kad Kemahiran Utama & Pengalaman Mahasiswa (BAHARU)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, color: AppTheme.primaryIndigo, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Kemahiran & Pengalaman Siswa',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.primaryIndigo),
                      onPressed: () => _showEditProfileModal(context),
                    ),
                  ],
                ),

                // Info Akademik
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school_outlined, size: 18, color: AppTheme.primaryIndigo),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.currentUser.courseName,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                            ),
                            Text(
                              '${widget.currentUser.yearOfStudy} • ${widget.currentUser.college}',
                              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bio jika ada
                if (widget.currentUser.bio.isNotEmpty) ...[
                  Text(
                    widget.currentUser.bio,
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                ],

                // Kemahiran
                const Text('Kemahiran Utama:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.currentUser.skills.map((sk) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Text(
                        sk,
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppTheme.primaryIndigo),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Pengalaman
                const Text('Pengalaman & Khidmat Siswa:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                const SizedBox(height: 6),
                Column(
                  children: widget.currentUser.experiences.map((exp) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 15),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              exp,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w600, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Sijil Pengiktirafan Kemahiran Digital SiswaBantu (Micro-credential UX)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryIndigo.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.primaryIndigo, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sijil Kemahiran Siswa (SKDS)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Disahkan melalui rangkaian SiswaBantu untuk nilai tambah resume kerjaya.',
                        style: TextStyle(fontSize: 10, color: Color(0xFF64748B), height: 1.3),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryIndigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showCertificateModal(context),
                  child: const Text('Lihat Sijil', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4. Kad Pengenalan Digital Siswa (Virtual Matric ID)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF7F1D1D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.school_rounded, size: 18, color: AppTheme.accentCyan),
                        SizedBox(width: 6),
                        Text(
                          'KAD DIGITAL MAHASISWA MALAYSIA',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentCyan,
                        foregroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _showKycDialog(context),
                      child: const Text('Imbas Semula', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'NO. MATRIK: ${widget.currentUser.matricNo}',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                ),
                Text(
                  'KOLEJ: ${widget.currentUser.college}',
                  style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10.5),
                ),
                Text(
                  'EMEL RASMI: ${widget.currentUser.eduEmail}',
                  style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10.5),
                ),
                Text(
                  'NO. TELEFON: ${widget.currentUser.phoneNo}',
                  style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 5. Butang Log Keluar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 18),
              label: const Text('Log Keluar Akaun Siswa', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w800)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFECDD3), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                backgroundColor: Colors.white,
              ),
              onPressed: widget.onLogout,
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
