class LiveActivityModel {
  final String username;
  final String text;
  final bool isBid;

  LiveActivityModel({
    required this.username,
    required this.text,
    required this.isBid,
  });

  // Convert from JSON for future API integration
  factory LiveActivityModel.fromJson(Map<String, dynamic> json) {
    return LiveActivityModel(
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      isBid: json['isBid'] ?? false,
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'text': text,
      'isBid': isBid,
    };
  }
}
