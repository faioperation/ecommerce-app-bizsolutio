class MessageModel {
  final String id;
  final String chatId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  // Future API integration: fromJson / toJson
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'],
        chatId: json['chatId'],
        text: json['text'],
        timestamp: DateTime.parse(json['timestamp']),
        isMe: json['isMe'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'isMe': isMe,
      };
}
