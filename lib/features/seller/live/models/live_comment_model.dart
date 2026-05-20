/// A model representing a chat message in the live stream.
class LiveCommentModel {
  final String id;
  final String userName;
  final String message;
  final DateTime timestamp;

  const LiveCommentModel({
    required this.id,
    required this.userName,
    required this.message,
    required this.timestamp,
  });
}
