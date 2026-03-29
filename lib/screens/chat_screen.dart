import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/language_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    await FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'senderId': user?.uid ?? 'anonymous',
      'senderName': user?.displayName ?? user?.email?.split('@')[0] ?? 'Farmer',
      'timestamp': FieldValue.serverTimestamp(),
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('💬 Farmer Community', '💬 రైతు సమూహం')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              lang.t(
                '🌾 Chat with farmers across India',
                '🌾 భారతదేశంలో రైతులతో మాట్లాడండి',
              ),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF2E7D32)));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🌾', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          lang.t(
                            'Be the first to say hello to\nthe farmer community!',
                            'రైతు సమూహానికి మొదట\nనమస్కారం చెప్పండి!',
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == user?.uid;
                    return _MessageBubble(
                      text: data['text'] ?? '',
                      senderName: data['senderName'] ?? 'Farmer',
                      isMe: isMe,
                      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText:
                          lang.t('Type a message...', 'సందేశం టైప్ చేయండి...'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _sendMessage,
                  backgroundColor: const Color(0xFF2E7D32),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final String senderName;
  final bool isMe;
  final DateTime? timestamp;

  const _MessageBubble({
    required this.text,
    required this.senderName,
    required this.isMe,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Text(
                '🌾 $senderName',
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF2E7D32).withOpacity(0.2),
                  child: Text(
                    senderName.isNotEmpty ? senderName[0].toUpperCase() : 'F',
                    style: const TextStyle(
                        color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                  ),
                ),
              if (!isMe) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFF2E7D32)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (timestamp != null)
            Padding(
              padding: EdgeInsets.only(
                  top: 2, left: isMe ? 0 : 42, right: isMe ? 4 : 0),
              child: Text(
                DateFormat('h:mm a').format(timestamp!),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
