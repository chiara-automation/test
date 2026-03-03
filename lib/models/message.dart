class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  bool isRead;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isRead = false,
  });
}
