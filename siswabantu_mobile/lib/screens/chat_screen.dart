import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/security_service.dart';
import '../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel order;
  final UserModel currentUser;

  const ChatScreen({
    super.key,
    required this.order,
    required this.currentUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  String? _securityWarning;

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      ChatMessage(
        id: 'msg-1',
        senderId: widget.order.providerId,
        senderName: widget.order.providerName,
        text: 'Salam ${widget.currentUser.fullName}! Ada apa-apa nota tambahan untuk tugasan ${widget.order.serviceTitle}?',
        timestamp: '10:00 AM',
      ),
    ]);
  }

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _controller.text;
    if (text.trim().isEmpty) return;

    // FR-3.3 & TC-CHT-01: Penapisan Keselamatan Sembang (Anti-Bypass Regex Scanner)
    final result = SecurityService.sanitizeChatMessage(text);

    setState(() {
      if (result.hasViolation) {
        _securityWarning = result.warningMessage;
      } else {
        _securityWarning = null;
      }

      _messages.add(
        ChatMessage(
          id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
          senderId: widget.currentUser.userId,
          senderName: widget.currentUser.fullName,
          text: result.sanitizedText,
          timestamp: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          isWarning: result.hasViolation,
          warningText: result.hasViolation ? result.warningMessage : null,
        ),
      );
    });

    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final otherParty = widget.order.buyerId == widget.currentUser.userId
        ? widget.order.providerName
        : widget.order.buyerName;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(otherParty, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(widget.order.serviceTitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: AppTheme.selangorRed),
            tooltip: 'Perlindungan Escrow Aktif',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sembang ini dilindungi sistem pengimbas keselamatan SiswaBantu.')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Anti-Bypass Scanner Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.amber.shade50,
            child: Row(
              children: [
                const Icon(Icons.security, size: 16, color: Colors.amber),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Anti-Bypass Filter Aktif: Pembayaran luar app adalah dilarang.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TC-CHT-01 Test Data
                    _sendMessage('Tolong transfer terus ke Maybank saya 162106123456 tak payah guna app');
                  },
                  child: const Text('Uji Scam', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Security Alert Toast Banner
          if (_securityWarning != null)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.selangorRed, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _securityWarning!,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.selangorRed),
                    ),
                  ),
                ],
              ),
            ),

          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.senderId == widget.currentUser.userId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: isMe
                          ? (msg.isWarning ? Colors.red.shade700 : AppTheme.selangorRed)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 13,
                            color: isMe ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (msg.isWarning && msg.warningText != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    msg.warningText!,
                                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          msg.timestamp,
                          style: TextStyle(
                            fontSize: 9,
                            color: isMe ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Preset Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                ActionChip(
                  label: const Text('📍 Pin Bilik Kolej', style: TextStyle(fontSize: 11)),
                  onPressed: () => _sendMessage('📍 Pin Lokasi: Kolej Harun Aminurrashid (KHAR) UPSI Blok B-2-10'),
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('Bayaran Escrow Selesai', style: TextStyle(fontSize: 11)),
                  onPressed: () => _sendMessage('Salam, bayaran telah disimpan di akaun Escrow SiswaBantu ya.'),
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('Minta Resit', style: TextStyle(fontSize: 11)),
                  onPressed: () => _sendMessage('Boleh tolong lampirkan resit atau gambar barang?'),
                ),
              ],
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Tulis mesej selamat...',
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.selangorRed,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
