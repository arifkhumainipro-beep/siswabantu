import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/security_service.dart';
import '../theme/app_theme.dart';

class WalletScreen extends StatefulWidget {
  final UserModel currentUser;
  final Function(double amount) onWithdraw;

  const WalletScreen({
    super.key,
    required this.currentUser,
    required this.onWithdraw,
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isBalanceVisible = true;
  final double _monthlyGoal = 300.0;

  void _showWithdrawDialog(BuildContext context) {
    final amountController = TextEditingController(text: '15.00');
    final accountController = TextEditingController(text: '162106123456');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_rounded, size: 20, color: AppTheme.primaryIndigo),
                const SizedBox(width: 8),
                const Text('Pengeluaran Wang ke Bank Siswa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Baki semasa boleh keluar: ${SecurityService.formatRM(widget.currentUser.walletBalance)}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Pengeluaran (RM)',
                helperText: '* Had minimum pengeluaran ialah RM 10.00 (TC-FIN-01)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: accountController,
              decoration: const InputDecoration(labelText: 'Nombor Akaun Bank Penerima (Maybank/CIMB/Bank Islam)'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text) ?? 0.0;
                  if (amount < 10.0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ralat: Jumlah pengeluaran minimum ialah RM10.00.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (amount > widget.currentUser.walletBalance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Baki tidak mencukupi untuk membuat pengeluaran ini.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  widget.onWithdraw(amount);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Permohonan pengeluaran ${SecurityService.formatRM(amount)} diproses ke bank!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Sahkan Pemindahan Wang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.currentUser.walletBalance / _monthlyGoal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // 1. Kad Mewah SiswaPay Digital
          Container(
            height: 220,
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
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7F1D1D).withValues(alpha: 0.3),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC8102E), Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, size: 18, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SISWAPAY DIGITAL WALLET',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFCC00),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'ESCROW VERIFIED',
                                    style: TextStyle(
                                      color: Color(0xFF7F1D1D),
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'PLATFORM GIG SISWA • 21 IPTA',
                                  style: TextStyle(
                                    color: Color(0xFFFDE047),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Cip EMV Emas Simbolik
                    Container(
                      width: 36,
                      height: 26,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(Icons.nfc, size: 16, color: Color(0xFF5B3400)),
                      ),
                    ),
                  ],
                ),

                // Baki Dompet Utama
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Baki Boleh Keluar (Available)',
                          style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                          child: Icon(
                            _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _isBalanceVisible ? SecurityService.formatRM(widget.currentUser.walletBalance) : '••••••••',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),

                // Pemilik Kad & No Matrik
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.currentUser.fullName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'MATRIK: ${widget.currentUser.matricNo}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9.5),
                        ),
                      ],
                    ),
                    const Text(
                      'ESCROW SAH',
                      style: TextStyle(
                        color: AppTheme.accentCyan,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Sasaran Pendapatan Mahasiswa (UX Income Goal Tracker)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
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
                        Icon(Icons.flag_rounded, color: AppTheme.primaryIndigo, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Sasaran Sara Hidup Bulanan',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                        ),
                      ],
                    ),
                    Text(
                      '${(progress * 100).toInt()}% Tercapai',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.primaryIndigo),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryIndigo),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terkumpul: ${SecurityService.formatRM(widget.currentUser.walletBalance)}',
                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Sasaran: ${SecurityService.formatRM(_monthlyGoal)}',
                      style: const TextStyle(fontSize: 10.5, color: AppTheme.slateDark, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Tindakan Pantas Dompet
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.account_balance_rounded, size: 16),
                  label: const Text('Keluarkan ke Bank'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryIndigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _showWithdrawDialog(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_card_rounded, size: 16, color: AppTheme.slateDark),
                  label: const Text('Tambah Baki FPX', style: TextStyle(color: AppTheme.slateDark, fontWeight: FontWeight.w800, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('FPX Gateway Simulator: Baki ditambah RM50.00!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4. Ringkasan Status Dana Amanah Escrow
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lock_clock_rounded, color: AppTheme.primaryIndigo, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Pecahan Baki & Lindungan Amanah',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dana Dipegang (Escrow)', style: TextStyle(fontSize: 10, color: Color(0xFF92400E))),
                            const SizedBox(height: 2),
                            Text(
                              SecurityService.formatRM(widget.currentUser.escrowBalance),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFB45309)),
                            ),
                            const Text('Dilepaskan bila kerja siap', style: TextStyle(fontSize: 8.5, color: Color(0xFFB45309))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kadar Caj Platform', style: TextStyle(fontSize: 10, color: Color(0xFF475569))),
                            SizedBox(height: 2),
                            Text('5.0% Sahaja', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slateDark)),
                            Text('TC-FIN-01 (Kadar Terendah)', style: TextStyle(fontSize: 8.5, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 5. Sejarah Transaksi Escrow Terkini (Ledger History)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Aktiviti Transaksi Terkini',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                    ),
                    Text(
                      'Semua Sah',
                      style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTransactionRow(
                  icon: Icons.check_circle_rounded,
                  iconColor: Colors.green,
                  title: 'Pendapatan Servis Selesai',
                  subtitle: 'Format Laptop SSD • ORD-2026-901',
                  amount: '+ RM 28.50',
                  amountColor: Colors.green,
                ),
                const Divider(height: 16),
                _buildTransactionRow(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: AppTheme.primaryIndigo,
                  title: 'Komisen Platform SiswaBantu (5%)',
                  subtitle: 'Potongan Automatik FR-4.2',
                  amount: '- RM 1.50',
                  amountColor: const Color(0xFF64748B),
                ),
                const Divider(height: 16),
                _buildTransactionRow(
                  icon: Icons.lock_clock_rounded,
                  iconColor: Colors.blue,
                  title: 'Bayaran FPX ke Akaun Escrow',
                  subtitle: 'Maybank2u • Dipegang Selamat',
                  amount: 'RM 30.00',
                  amountColor: AppTheme.slateDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 6. Jaminan Keselamatan Kewangan Mahasiswa Kebangsaan
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFEF2F2), Color(0xFFF8FAFC)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_rounded, size: 24, color: AppTheme.primaryIndigo),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Piawaian Keselamatan Kewangan Mahasiswa Kebangsaan',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF991B1B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Semua transaksi dilindungi protokol Escrow automatik dengan penapisan anti-scam untuk melindungi keselamatan mahasiswa seluruh IPTA.',
                        style: TextStyle(fontSize: 9.5, color: Color(0xFF7F1D1D), height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.slateDark)),
              Text(subtitle, style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
            ],
          ),
        ),
        Text(amount, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: amountColor)),
      ],
    );
  }
}
