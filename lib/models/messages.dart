class Messages {
  final String fromUid;
  final String toUid;
  final DateTime timeOfMessage;
  final String message;
  Messages({this.fromUid, this.toUid, this.timeOfMessage, this.message});

  Map<String, dynamic> toMap() {
    return {
      'fromUid': fromUid,
      'toUid': toUid,
      'timeOfMessage': timeOfMessage,
      'message': message,
    };
  }
}
