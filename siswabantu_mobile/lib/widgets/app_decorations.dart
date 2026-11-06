import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Lencana Pengesahan Mahasiswa IPTA Kebangsaan (National Student Verification)
class StudentVerifiedBadge extends StatelessWidget {
  final String text;
  final bool isCompact;

  const StudentVerifiedBadge({
    super.key,
    this.text = 'Pelajar Disahkan',
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 9,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 12, color: AppTheme.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryDeep,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Jalur Garisan Aksen Moden (Clean Divider / Accent Strip)
class ModernAccentStrip extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const ModernAccentStrip({
    super.key,
    this.height = 3,
    this.width = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
        gradient: AppTheme.brandGradient,
      ),
    );
  }
}

