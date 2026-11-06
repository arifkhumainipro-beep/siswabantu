import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Rangka Peranti Pintar Moden & Minimalis (Flagship Titanium Smartphone Frame)
/// Direka khusus untuk persembahan aplikasi profesional pada pelayar web & desktop.
class ResponsiveDeviceFrame extends StatelessWidget {
  final Widget child;

  const ResponsiveDeviceFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Skrin mudah alih sebenar (< 600px): skrin penuh 100%
        if (constraints.maxWidth < 600) {
          return child;
        }

        // Paparan Desktop / Web Showcase: Bingkai telefon pintar moden
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: Stack(
            children: [
              // Ambient Glow Indigo & Cyan moden di latar belakang
              Positioned(
                top: -120,
                left: constraints.maxWidth * 0.22,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primary.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                right: constraints.maxWidth * 0.22,
                child: Container(
                  width: 480,
                  height: 480,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accent.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Maklumat Sisi Desktop (Kiri)
              Positioned(
                left: 48,
                bottom: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, size: 14, color: AppTheme.accent),
                          SizedBox(width: 6),
                          Text(
                            'PLATFORM EKONOMI MAHASISWA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'SiswaBantu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pasaran Kemahiran, Servis Kampus & Lindungan Escrow Siswa',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 220,
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: AppTheme.brandGradient,
                      ),
                    ),
                  ],
                ),
              ),

              // Rangka Telefon Pintar Moden
              Center(
                child: Container(
                  width: 412,
                  height: 870,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(46),
                    border: Border.all(
                      color: const Color(0xFF1E293B),
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 40,
                        spreadRadius: 6,
                        offset: const Offset(0, 18),
                      ),
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.18),
                        blurRadius: 40,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Kandungan Aplikasi
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: child,
                        ),
                      ),

                      // Bar Status Telefon Ultra-Nipis (Atas)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 26,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: Colors.transparent,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '09:41',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.signal_cellular_4_bar, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Icon(Icons.wifi, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Icon(Icons.battery_full, size: 13, color: Colors.white),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Penunjuk Home Bar (Bawah)
                      Positioned(
                        bottom: 6,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
