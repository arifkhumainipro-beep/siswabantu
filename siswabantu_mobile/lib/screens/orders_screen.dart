import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/security_service.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

class OrdersScreen extends StatefulWidget {
  final UserModel currentUser;
  final List<OrderModel> orders;
  final Function(String orderId, String nextStatus, {bool autoCancel}) onUpdateOrderStatus;
  final Function(String orderId, double amount, String reason) onRaiseDispute;

  const OrdersScreen({
    super.key,
    required this.currentUser,
    required this.orders,
    required this.onUpdateOrderStatus,
    required this.onRaiseDispute,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  void _showFpxModal(OrderModel order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance, color: AppTheme.selangorRed),
                const SizedBox(width: 8),
                const Text('Gerbang Pembayaran FPX Sandbox', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Jumlah Bayaran: ${SecurityService.formatRM(order.totalAmount)} (Escrow Held)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const Text('🟡', style: TextStyle(fontSize: 22)),
              title: const Text('Maybank2u', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.pop(context);
                widget.onUpdateOrderStatus(order.orderId, 'MENUNGGU_TERIMA');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bayaran FPX berjaya! Dana kini dipegang selamat di Escrow.')),
                );
              },
            ),
            ListTile(
              leading: const Text('🔴', style: TextStyle(fontSize: 22)),
              title: const Text('CIMB Clicks', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.pop(context);
                widget.onUpdateOrderStatus(order.orderId, 'MENUNGGU_TERIMA');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bayaran FPX berjaya! Dana kini dipegang selamat di Escrow.')),
                );
              },
            ),
            ListTile(
              leading: const Text('🟢', style: TextStyle(fontSize: 22)),
              title: const Text('Bank Islam Internet Banking', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.pop(context);
                widget.onUpdateOrderStatus(order.orderId, 'MENUNGGU_TERIMA');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bayaran FPX berjaya! Dana kini dipegang selamat di Escrow.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDisputeDialog(OrderModel order) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        title: const Row(
          children: [
            Icon(Icons.gavel_rounded, color: AppTheme.selangorRed),
            SizedBox(width: 8),
            Text('Failkan Pertikaian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dana pesanan akan dibekukan serta-merta (Frozen Escrow) untuk semakan panel penimbang tara Admin SiswaBantu.',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Keterangan Masalah / Bukti Kegagalan Servis',
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
              backgroundColor: AppTheme.selangorRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              if (reasonController.text.trim().isEmpty) return;
              widget.onRaiseDispute(order.orderId, order.totalAmount, reasonController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pertikaian difailkan. Dana dibekukan di bawah klausa perlindungan FR-3.3.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Hantar Pertikaian'),
          ),
        ],
      ),
    );
  }

  void _showProofUploadModal(OrderModel order) {
    final defaultUrl = order.proofFileUrl ?? 'https://images.unsplash.com/photo-1526367790999-0150786686a2?auto=format&fit=crop&w=600&q=80';
    String currentUrl = defaultUrl;
    final urlController = TextEditingController(text: currentUrl);
    final noteController = TextEditingController(
      text: order.deliveryNote.isNotEmpty
          ? order.deliveryNote
          : 'Tugasan telah disempurnakan dengan teliti dan selamat diserahkan kepada pemohon.',
    );

    final List<Map<String, String>> presets = [
      {
        'label': '📦 Resit & Makanan',
        'desc': 'Runner makanan kolej',
        'url': 'https://images.unsplash.com/photo-1526367790999-0150786686a2?auto=format&fit=crop&w=600&q=80',
      },
      {
        'label': '💻 Laptop & SSD',
        'desc': 'Format Windows & perisian',
        'url': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=600&q=80',
      },
      {
        'label': '📚 Hardcover Tesis',
        'desc': 'Buku jilid siap cetak',
        'url': 'https://images.unsplash.com/photo-1568667256549-094345857637?auto=format&fit=crop&w=600&q=80',
      },
      {
        'label': '🎓 Bimbingan Tutor',
        'desc': 'Nota & modul selesai',
        'url': 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=600&q=80',
      },
      {
        'label': '🧺 Dobi Siap Lipat',
        'desc': 'Pakaian bersih kolej',
        'url': 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?auto=format&fit=crop&w=600&q=80',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
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
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.verified_rounded, size: 22, color: Colors.purple.shade700),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hantar Bukti Kerja (Proof of Work)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Pesanan #${order.orderId} • Lindungan Escrow Siswa',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kotak Penerangan Escrow
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.purple.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sertakan gambar resit, dokumen atau tangkap layar hasil kerja. Dana ${SecurityService.formatRM(order.totalAmount)} akan dilepaskan ke dompet anda selepas disahkan oleh ${order.buyerName}.',
                            style: TextStyle(fontSize: 11, color: Colors.purple.shade900, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Preset Pilihan Gambar Kampus
                  const Text(
                    'Pilih Contoh Bukti Serahan (Pantas 1-Ketik):',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presets.map((p) {
                      final isSelected = currentUrl == p['url'];
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            currentUrl = p['url']!;
                            urlController.text = currentUrl;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.purple.shade700 : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.purple.shade700 : const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            p['label']!,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Pratonton Gambar Bukti
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Image.network(
                        currentUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image_rounded, color: Colors.grey, size: 32),
                              SizedBox(height: 4),
                              Text('Imej tidak dapat dimuatkan', style: TextStyle(fontSize: 10.5, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Input URL Kustom
                  TextField(
                    controller: urlController,
                    style: const TextStyle(fontSize: 11.5),
                    decoration: InputDecoration(
                      labelText: 'Pautan Gambar / Tangkap Layar (URL)',
                      prefixIcon: const Icon(Icons.link_rounded, size: 18),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        onPressed: () {
                          setModalState(() {
                            currentUrl = urlController.text.trim();
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        currentUrl = val.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Nota Serahan
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 11.5),
                    decoration: InputDecoration(
                      labelText: 'Nota Serahan / Komen untuk Pemohon',
                      hintText: 'Cth: Servis siap diserahkan depan Kolej jam 2 ptg.',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Butang Serah
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send_rounded, size: 16),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        final finalProof = currentUrl.isNotEmpty ? currentUrl : defaultUrl;
                        final finalNote = noteController.text.trim().isNotEmpty
                            ? noteController.text.trim()
                            : 'Tugasan telah disempurnakan mengikut syarat pesanan.';

                        setState(() {
                          order.proofFileUrl = finalProof;
                          order.deliveryNote = finalNote;
                        });
                        widget.onUpdateOrderStatus(order.orderId, 'MENUNGGU_PENGESAHAN');

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF059669),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text('Bukti kerja dihantar! Menunggu pengesahan pemohon untuk pelepasan escrow.'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      label: const Text(
                        'Hantar Bukti & Minta Pengesahan',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                      ),
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

  void _showProofDetailModal(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.image_search_rounded, size: 20, color: Colors.purple.shade700),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Bukti Kerja Siap (Proof of Work)',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  order.proofFileUrl ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Text('Imej tidak tersedia', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (order.deliveryNote.isNotEmpty) ...[
                const Text(
                  'Nota Penyerahan Penyedia:',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    '"${order.deliveryNote}"',
                    style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: Color(0xFF334155)),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (order.orderStatus == 'MENUNGGU_PENGESAHAN') ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showReviewAndCompleteDialog(order);
                        },
                        child: const Text('Sahkan & Lepas Dana ✔', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewAndCompleteDialog(OrderModel order) {
    double selectedRating = 5.0;
    final commentController = TextEditingController(
      text: 'Servis sangat pantas, amanah dan berkualiti tinggi. Sangat berpuas hati!',
    );
    final List<String> availableTags = [
      '⚡ Pantas & Tepat Waktu',
      '🛡️ Sangat Amanah',
      '😊 Mesra & Sopan',
      '🏆 Kualiti Terbaik',
      '💡 Mahir & Berpengalaman',
    ];
    final Set<String> selectedTags = {'⚡ Pantas & Tepat Waktu', '🛡️ Sangat Amanah'};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final split = SecurityService.calculateEscrowSplit(order.totalAmount);

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 18,
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
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.rate_review_rounded, size: 22, color: AppTheme.primaryIndigo),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengesahan Siap & Ulasan Siswa',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Pelepasan Dana Escrow Selamat (FR-3.2)',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kad Ringkasan Servis
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: AppTheme.primaryIndigo, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.serviceTitle,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Penyedia: ${order.providerName} • Jumlah: ${SecurityService.formatRM(order.totalAmount)}',
                                style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Kad Bukti Kerja Diserahkan (Jika ada)
                  if (order.proofFileUrl != null && order.proofFileUrl!.isNotEmpty) ...[
                    GestureDetector(
                      onTap: () => _showProofDetailModal(order),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.purple.shade200),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                order.proofFileUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.purple.shade100,
                                  child: Icon(Icons.broken_image, size: 20, color: Colors.purple.shade400),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.verified, size: 14, color: Colors.purple.shade700),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Bukti Kerja Diserahkan',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF6B21A8)),
                                      ),
                                      const Spacer(),
                                      const Text('Besarkan 🔍', style: TextStyle(fontSize: 9.5, color: AppTheme.primaryIndigo, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    order.deliveryNote.isNotEmpty ? '"${order.deliveryNote}"' : 'Kerja siap diserahkan.',
                                    style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 6),

                  // 1. Pilih Bintang Penarafan
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Berapa Bintang Untuk Servis Ini?',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final star = index + 1;
                            final isFilled = star <= selectedRating;
                            return GestureDetector(
                              onTap: () => setDialogState(() => selectedRating = star.toDouble()),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: isFilled ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                                  size: 38,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedRating == 5
                              ? 'Luar Biasa Hebat & Cemerlang! 🌟👑'
                              : selectedRating == 4
                                  ? 'Sangat Bagus & Memuaskan! 😊'
                                  : selectedRating == 3
                                      ? 'Memuaskan & Boleh Diterima 🙂'
                                      : selectedRating == 2
                                          ? 'Perlu Penambahbaikan 😐'
                                          : 'Kurang Memuaskan 🙁',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: selectedRating >= 4 ? const Color(0xFFB45309) : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Lencana Pujian Cepat
                  const Text(
                    'Pilih Lencana Pujian (Badge Pujian)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableTags.map((tag) {
                      final isTagSel = selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            if (isTagSel) {
                              selectedTags.remove(tag);
                            } else {
                              selectedTags.add(tag);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isTagSel ? AppTheme.primaryIndigo : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isTagSel ? AppTheme.primaryIndigo : const Color(0xFFCBD5E1),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isTagSel ? FontWeight.w900 : FontWeight.w600,
                              color: isTagSel ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 3. Komen Ulasan Pelajar
                  const Text(
                    'Komentar / Penghargaan Untuk Siswa',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: commentController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Tuliskan sedikit komen ikhlas untuk reputasi rakan siswa...',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4. Jaminan Pelepasan Escrow
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_rounded, color: Color(0xFF059669), size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pelepasan Dana Escrow Serta-Merta (FR-3.2)',
                                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF065F46)),
                              ),
                              Text(
                                'Jumlah ${SecurityService.formatRM(order.totalAmount)} (Net Penyedia: ${SecurityService.formatRM(split.netEarnings)}) akan terus dikreditkan ke baki dompet ${order.providerName}.',
                                style: const TextStyle(fontSize: 10, color: Color(0xFF047857), height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Butang Sahkan Siap & Lepaskan Wang
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: Text('Sahkan Siap & Lepaskan Bayaran (${SecurityService.formatRM(order.totalAmount)})'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () {
                        setState(() {
                          order.rating = selectedRating;
                          order.reviewComment = commentController.text.trim();
                          order.reviewTags = selectedTags.toList();
                        });
                        widget.onUpdateOrderStatus(order.orderId, 'SELESAI');
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Alhamdulillah! Pesanan disahkan siap. Dana Escrow telah dilepaskan dan ulasan ${selectedRating.toInt()} bintang berjaya diterbitkan!',
                            ),
                            backgroundColor: Colors.green.shade800,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'MENUNGGU_BAYARAN':
        return Colors.orange;
      case 'MENUNGGU_TERIMA':
        return Colors.blue;
      case 'SEDANG_DILAKUKAN':
        return Colors.purple;
      case 'MENUNGGU_PENGESAHAN':
        return AppTheme.selangorAmber;
      case 'SELESAI':
        return Colors.green;
      case 'PERTIKAIAN':
        return AppTheme.selangorRed;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Banner Pengurusan Pesanan & Escrow
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFC8102E).withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC8102E), Color(0xFFF59E0B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shield_rounded, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Pusat Pesanan & Escrow',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(width: 6),
                          Text('🛡️ 100% Sah', style: TextStyle(color: Color(0xFFFFCC00), fontSize: 9.5, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        'Transaksi aktif: ${widget.orders.length} | Perlindungan Penuh Hak Mahasiswa Malaysia',
                        style: const TextStyle(color: Color(0xFFFDE047), fontSize: 9.5, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (widget.orders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text('Tiada pesanan aktif pada masa ini.', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              ),
            )
          else
            ...widget.orders.map((ord) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ord.orderId,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: _getStatusColor(ord.orderStatus).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ord.orderStatus,
                            style: TextStyle(
                              color: _getStatusColor(ord.orderStatus),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ord.serviceTitle,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.slateDark),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Pemohon: ${ord.buyerName} • Penyedia: ${ord.providerName}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 10),

                    // Rincian Kewangan
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Jumlah Bayaran', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                              Text(
                                SecurityService.formatRM(ord.totalAmount),
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppTheme.slateDark),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Status Escrow', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                              Text(
                                ord.escrowStatus,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11.5,
                                  color: ord.escrowStatus == 'Released'
                                      ? Colors.green
                                      : ord.escrowStatus == 'Frozen'
                                          ? Colors.red
                                          : const Color(0xFFD97706),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Kad Bukti Kerja Siap (Jika ada dimuat naik)
                    if (ord.proofFileUrl != null && ord.proofFileUrl!.isNotEmpty) ...[
                      GestureDetector(
                        onTap: () => _showProofDetailModal(ord),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF5FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.purple.shade200),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  ord.proofFileUrl!,
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 52,
                                    height: 52,
                                    color: Colors.purple.shade100,
                                    child: Icon(Icons.broken_image, size: 20, color: Colors.purple.shade400),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.purple.shade700,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.verified, size: 9, color: Colors.white),
                                              SizedBox(width: 3),
                                              Text('BUKTI DISERAHKAN', style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900)),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text('Lihat 🔍', style: TextStyle(fontSize: 10, color: AppTheme.primaryIndigo, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ord.deliveryNote.isNotEmpty ? ord.deliveryNote : 'Servis siap diserahkan.',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Notis Peringatan Pemohon jika Menunggu Pengesahan
                    if (ord.orderStatus == 'MENUNGGU_PENGESAHAN') ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFCD34D)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFB45309)),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Bukti kerja telah dihantar oleh penyedia. Sila semak sebelum mengesahkan pelepasan dana Escrow.',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Kad Ulasan Siswa jika Pesanan Telah Dinilai
                    if (ord.rating != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ...List.generate(
                                      ord.rating!.toInt(),
                                      (i) => const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${ord.rating!.toStringAsFixed(1)} / 5.0',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF92400E)),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green.shade300),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified, size: 10, color: Colors.green),
                                      SizedBox(width: 3),
                                      Text(
                                        'Ulasan Disahkan',
                                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (ord.reviewTags != null && ord.reviewTags!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: ord.reviewTags!.map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFDE68A)),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                                  ),
                                )).toList(),
                              ),
                            ],
                            if (ord.reviewComment != null && ord.reviewComment!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                '"${ord.reviewComment}"',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF475569),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    // Butang Tindakan Pesanan
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                            label: const Text('Mesej', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    order: ord,
                                    currentUser: widget.currentUser,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),

                        if (ord.orderStatus == 'MENUNGGU_BAYARAN')
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.selangorRed,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _showFpxModal(ord),
                              child: const Text('Bayar FPX', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          )
                        else if (ord.orderStatus == 'MENUNGGU_TERIMA')
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => widget.onUpdateOrderStatus(ord.orderId, 'SEDANG_DILAKUKAN'),
                              child: const Text('Terima Tugasan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          )
                        else if (ord.orderStatus == 'SEDANG_DILAKUKAN')
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add_a_photo_rounded, size: 13),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _showProofUploadModal(ord),
                              label: const Text('Hantar Bukti 📸', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900)),
                            ),
                          )
                        else if (ord.orderStatus == 'MENUNGGU_PENGESAHAN')
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle_rounded, size: 13),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _showReviewAndCompleteDialog(ord),
                              label: const Text('Semak & Sahkan ✔', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900)),
                            ),
                          )
                        else if (ord.orderStatus == 'SELESAI' && ord.rating == null)
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.star_outline_rounded, size: 14),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryIndigo,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _showReviewAndCompleteDialog(ord),
                              label: const Text('Beri Ulasan ⭐', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                            ),
                          ),

                        if (ord.orderStatus != 'SELESAI' && ord.orderStatus != 'PERTIKAIAN') ...[
                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(Icons.report_problem_outlined, color: Colors.red, size: 18),
                            tooltip: 'Pertikaian',
                            onPressed: () => _showDisputeDialog(ord),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
