class Chat {
  final String message;
  final String uId;
  final DateTime date;

  Chat({
    required this.message,
    required this.uId,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "message": message,
        "uId": uId,
        "date": date.toString(),
      };
}
