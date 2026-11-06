// SiswaBantu Security & Validation Engine

/**
 * Menormalkan e-mel IPTA (menyokong format titik seperti d20231106365.siswa.upsi.edu.my -> d20231106365@siswa.upsi.edu.my)
 */
export function normalizeEduEmail(email) {
  if (!email || typeof email !== 'string') return '';
  let trimmed = email.trim().toLowerCase();
  if (!trimmed.includes('@') && trimmed.includes('.edu.my')) {
    const firstDotIndex = trimmed.indexOf('.');
    if (firstDotIndex > 0) {
      trimmed = trimmed.substring(0, firstDotIndex) + '@' + trimmed.substring(firstDotIndex + 1);
    }
  }
  return trimmed;
}

/**
 * Validasi e-mel institusi IPTA (Mesti berakhir dengan .edu.my)
 * Rujukan: FR-1.1 & TC-AUTH-01 / TC-AUTH-02
 * Menyokong kedua-dua format standard (@) dan format titik portal universiti (.)
 */
export function validateEduEmail(email) {
  if (!email || typeof email !== 'string') return false;
  const normalized = normalizeEduEmail(email);
  // Format standard: student@uitm.edu.my, 20261234@student.uitm.edu.my, d20231106365@siswa.upsi.edu.my
  const eduRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.edu\.my$/;
  return eduRegex.test(normalized);
}

/**
 * Penapisan Keselamatan Sembang (Anti-Bypass Filter)
 * Rujukan: FR-3.3 & TC-CHT-01
 * Mengesan nombor akaun bank (10 - 16 digit), kata kunci pemindahan terus luar app
 */
export function sanitizeChatMessage(message) {
  if (!message) return { sanitizedText: '', hasViolation: false, violationType: null };

  let hasViolation = false;
  let violationType = null;

  // Corak nombor akaun bank (Maybank 12 digit, CIMB 10-14 digit, dsb)
  const bankAccountRegex = /\b(\d[\d\s-]{8,18}\d)\b/g;

  // Corak pautan luar / nombor telefon WhatsApp luar
  const externalLinkRegex = /(https?:\/\/[^\s]+|wa\.me\/[0-9]+|bit\.ly\/[^\s]+)/gi;

  let sanitized = message;

  if (bankAccountRegex.test(message)) {
    hasViolation = true;
    violationType = 'bank_account';
    sanitized = sanitized.replace(bankAccountRegex, (match) => {
      // jika panjang digit sekurang-kurangnya 10 digit sebenar
      const digitsOnly = match.replace(/[\s-]/g, '');
      if (digitsOnly.length >= 10 && digitsOnly.length <= 18) {
        return '************';
      }
      return match;
    });
  }

  if (externalLinkRegex.test(sanitized)) {
    hasViolation = true;
    violationType = 'external_link';
    sanitized = sanitized.replace(externalLinkRegex, '[Pautan Luar Disekat]');
  }

  return {
    sanitizedText: sanitized,
    hasViolation,
    violationType,
    warningMessage: "Untuk perlindungan daripada penipuan (scam), sila lakukan semua pembayaran di dalam sistem Escrow SiswaBantu."
  };
}

/**
 * Pengiraan Komisen Escrow 5%
 * Rujukan: FR-4.2
 */
export function calculateEscrowSplit(servicePrice) {
  const price = parseFloat(servicePrice) || 0;
  const commissionRate = 0.05; // 5%
  const commission = Math.round(price * commissionRate * 100) / 100;
  const netEarnings = Math.round((price - commission) * 100) / 100;

  return {
    grossPrice: price,
    commissionRatePercent: '5%',
    commissionFee: commission,
    netEarnings: netEarnings,
  };
}

/**
 * Format mata wang Ringgit Malaysia
 */
export function formatRM(amount) {
  const num = parseFloat(amount) || 0;
  return `RM ${num.toFixed(2)}`;
}

