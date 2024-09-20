class ChatModel {
  String? message;
  final String id;
  final String time;
  String? imagaeUrl;
  bool type;
  ChatModel({
    required this.message,
    required this.id,
    required this.time,
    required this.imagaeUrl,
    required this.type,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'],
      id: json['id'],
      time: json['time'],
      imagaeUrl: json['imagaeUrl'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'id': id,
      'time': time,
      'imagaeUrl': imagaeUrl,
      'type': type,
    };
  }
}
