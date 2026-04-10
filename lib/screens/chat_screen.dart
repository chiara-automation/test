import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Bot'),
        centerTitle: true,
        elevation: 2,
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.playingIndex != null) {
                return IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    chatProvider.stopSpeaking();
                  },
                  tooltip: 'Stop speaking',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Clear Chat'),
                onTap: () {
                  context.read<ChatProvider>().clearChat();
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return _buildMessageBubble(message, context, index);
                  },
                );
              },
            ),
          ),
          if (context.watch<ChatProvider>().isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message, BuildContext context, int index) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: message.isUser
              ? Colors.blue[500]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!message.isUser) ...[
                  const SizedBox(width: 8),
                  _buildAudioButton(context, message, index),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: message.isUser ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioButton(BuildContext context, dynamic message, int index) {
    final isPlaying = context.watch<ChatProvider>().playingIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (isPlaying) {
          context.read<ChatProvider>().stopSpeaking();
        } else {
          context.read<ChatProvider>().speak(index);
        }
      },
      child: Icon(
        isPlaying ? Icons.stop_circle : Icons.play_circle,
        color: Colors.black54,
        size: 20,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final draft = chatProvider.currentDraft;
                if (_messageController.text != draft) {
                  _messageController.value = TextEditingValue(
                    text: draft,
                    selection: TextSelection.collapsed(offset: draft.length),
                  );
                }

                return TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    context.read<ChatProvider>().currentDraft = value;
                  },
                  onSubmitted: (value) {
                    _sendMessage();
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return FloatingActionButton(
                onPressed: () {
                  if (chatProvider.isListening) {
                    chatProvider.stopListening();
                  } else {
                    chatProvider.startListening();
                  }
                },
                mini: true,
                backgroundColor: chatProvider.isListening ? Colors.red : Colors.blue,
                child: Icon(
                  chatProvider.isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    context.read<ChatProvider>().sendDraft();
    _messageController.clear();
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
