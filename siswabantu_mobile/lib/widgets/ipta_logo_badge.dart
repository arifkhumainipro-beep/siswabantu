import 'package:flutter/material.dart';
import '../data/ipta_data.dart';

/// Lencana Lambang & Logo Rasmi Universiti Awam (IPTA) Malaysia
class IPTALogoBadge extends StatelessWidget {
  final IPTAModel ipta;
  final double size;
  final bool showBorder;

  const IPTALogoBadge({
    super.key,
    required this.ipta,
    this.size = 28,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: ipta.primaryColor.withValues(alpha: 0.35), width: 1.2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        ipta.logoUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildEmblemFallback();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildEmblemFallback();
        },
      ),
    );
  }

  Widget _buildEmblemFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ipta.primaryColor, ipta.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          ipta.code.length <= 4 ? ipta.code : ipta.code.substring(0, 3),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.34,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

