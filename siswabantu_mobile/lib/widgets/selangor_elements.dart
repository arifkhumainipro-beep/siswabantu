import 'package:flutter/material.dart';

/// Ikon Miniatur Jenama Merah & Emas / Kuning
class AppBrandIconMini extends StatelessWidget {
  final double size;

  const AppBrandIconMini({
    super.key,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC8102E), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8102E).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.bolt_rounded, color: Colors.white, size: 11),
      ),
    );
  }
}

// Alias keserasian
typedef SelangorFlagMini = AppBrandIconMini;

/// Jalur Aksen Atas Jenama Merah & Kuning / Emas
class AppTopBarRibbon extends StatelessWidget {
  const AppTopBarRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF881337), // Crimson Pekat
            Color(0xFFC8102E), // Merah Utama
            Color(0xFFDC2626), // Scarlet
            Color(0xFFD97706), // Amber
            Color(0xFFFFCC00), // Kuning Emas
          ],
          stops: [0.0, 0.35, 0.65, 0.85, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x30C8102E),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const AppBrandIconMini(size: 16),
          const SizedBox(width: 8),
          const Text(
            'SISWABANTU MALAYSIA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCC00),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              '21 IPTA RESMI',
              style: TextStyle(
                color: Color(0xFF7F1D1D),
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🛡️ Lindungan Escrow 100%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Alias keserasian
typedef SelangorTopBarRibbon = AppTopBarRibbon;

/// Kad Promo & Inisiatif Mahasiswa (Tema Merah & Kuning / Emas Mewah)
class AppInitiativeCard extends StatelessWidget {
  final VoidCallback? onExploreServices;

  const AppInitiativeCard({
    super.key,
    this.onExploreServices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF881337), // Rose Red Deep
            Color(0xFFB91C1C), // Deep Red
            Color(0xFFC8102E), // Bright Red
            Color(0xFFE11D48), // Rose Bright
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8102E).withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          // Corak Aksen Lingkaran Emas Kuning di Latar Belakang
          Positioned(
            right: -25,
            top: -25,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFCC00).withValues(alpha: 0.35),
                    const Color(0xFFFFCC00).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Jalur Emas Diraja Menegak di sebelah kiri kad
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFCC00),
                    Color(0xFFF59E0B),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Lencana Rasmi Merah & Emas
                Row(
                  children: [
                    const AppBrandIconMini(size: 18),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCC00),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars_rounded, size: 12, color: Color(0xFF7F1D1D)),
                          SizedBox(width: 4),
                          Text(
                            'KOMUNITI MIKRO-GIG KAMPUS',
                            style: TextStyle(
                              color: Color(0xFF7F1D1D),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: const Text(
                        '🛡️ Escrow 100%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Tajuk Kad
                const Text(
                  'Ekosistem Mikro-Gig & Perlindungan Escrow',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),

                // Huraian
                Text(
                  'Platform selamat menghubungkan mahasiswa merentasi 21 IPTA Malaysia. Jana pendapatan sampingan halal dengan jaminan pelepasan dana telus.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),

                // Butang Carian & Tag Kampus
                Row(
                  children: [
                    if (onExploreServices != null)
                      GestureDetector(
                        onTap: onExploreServices,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFCC00), Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFCC00).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF7F1D1D)),
                              SizedBox(width: 4),
                              Text(
                                'Terokai Semua Gig',
                                style: TextStyle(
                                  color: Color(0xFF7F1D1D),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🎓 21 IPTA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(width: 6),
                          Text('⚡ Pantas', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(width: 6),
                          Text('🔒 Amanah', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Alias keserasian
typedef SelangorInitiativeCard = AppInitiativeCard;

/// Lencana Prestij Mahasiswa Aktif untuk Profil (Merah & Emas)
class StudentActiveBadge extends StatelessWidget {
  final String universityName;

  const StudentActiveBadge({
    super.key,
    required this.universityName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFEF2F2), // Merah Lembut
            Color(0xFFFFFBEB), // Emas Cerah
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBrandIconMini(size: 16),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lencana Mahasiswa Aktif',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF991B1B),
                ),
              ),
              Text(
                'Komuniti Siswa Sah 21 IPTA Malaysia',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Alias keserasian
typedef SelangorStudentBadge = StudentActiveBadge;
