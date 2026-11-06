class SanitizeResult {
  final String sanitizedText;
  final bool hasViolation;
  final String? violationType;
  final String warningMessage;

  SanitizeResult({
    required this.sanitizedText,
    required this.hasViolation,
    this.violationType,
    required this.warningMessage,
  });
}

class EscrowSplit {
  final double grossPrice;
  final double commissionFee;
  final double netEarnings;

  EscrowSplit({
    required this.grossPrice,
    required this.commissionFee,
    required this.netEarnings,
  });
}

class SecurityService {
  /// Normalisasi format e-mel rasmi universiti IPTA
  /// Menyokong format biasa (d20231106365@siswa.upsi.edu.my)
  /// serta format noktah tanpa @ (d20231106365.siswa.upsi.edu.my)
  static String normalizeEduEmail(String email) {
    String trimmed = email.trim().toLowerCase();
    if (trimmed.isEmpty) return trimmed;

    // Jika pengguna memasukkan format noktah cth: d20231106365.siswa.upsi.edu.my
    if (!trimmed.contains('@') && trimmed.contains('.edu.my')) {
      final firstDot = trimmed.indexOf('.');
      if (firstDot > 0) {
        trimmed = '${trimmed.substring(0, firstDot)}@${trimmed.substring(firstDot + 1)}';
      }
    }
    return trimmed;
  }

  /// Validasi e-mel universiti (.edu.my)
  static bool validateEduEmail(String email) {
    if (email.trim().isEmpty) return false;
    final normalized = normalizeEduEmail(email);
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.edu\.my$', caseSensitive: false);
    return regex.hasMatch(normalized);
  }

  /// Penapisan Keselamatan Sembang (FR-3.3 & TC-CHT-01 Anti-Bypass Filter)
  static SanitizeResult sanitizeChatMessage(String text) {
    if (text.isEmpty) {
      return SanitizeResult(
        sanitizedText: '',
        hasViolation: false,
        warningMessage: '',
      );
    }

    bool hasViolation = false;
    String sanitized = text;

    // Kesan deretan nombor akaun bank (10 - 18 digit)
    final bankRegex = RegExp(r'\b(\d[\d\s-]{8,18}\d)\b');
    if (bankRegex.hasMatch(text)) {
      hasViolation = true;
      sanitized = sanitized.replaceAllMapped(bankRegex, (match) {
        final digitsOnly = match.group(0)!.replaceAll(RegExp(r'[\s-]'), '');
        if (digitsOnly.length >= 10 && digitsOnly.length <= 18) {
          return '************';
        }
        return match.group(0)!;
      });
    }

    // Kesan pautan luar
    final linkRegex = RegExp(r'(https?://[^\s]+|wa\.me/[0-9]+|bit\.ly/[^\s]+)', caseSensitive: false);
    if (linkRegex.hasMatch(sanitized)) {
      hasViolation = true;
      sanitized = sanitized.replaceAll(linkRegex, '[Pautan Luar Disekat]');
    }

    return SanitizeResult(
      sanitizedText: sanitized,
      hasViolation: hasViolation,
      violationType: hasViolation ? 'bank_bypass' : null,
      warningMessage: 'Untuk perlindungan daripada penipuan (scam), sila lakukan semua pembayaran di dalam sistem Escrow SiswaBantu.',
    );
  }

  /// Pengiraan Komisen 5% Escrow (FR-4.2)
  static EscrowSplit calculateEscrowSplit(double price) {
    final commission = double.parse((price * 0.05).toStringAsFixed(2));
    final net = double.parse((price - commission).toStringAsFixed(2));
    return EscrowSplit(
      grossPrice: price,
      commissionFee: commission,
      netEarnings: net,
    );
  }

  /// Format Ringgit Malaysia
  static String formatRM(double amount) {
    return 'RM ${amount.toStringAsFixed(2)}';
  }
}

