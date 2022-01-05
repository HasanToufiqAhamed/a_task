class MessageRoom {
  final String name;
  final String id;
  final DateTime date;

  MessageRoom({required this.name, required this.id, required this.date});

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "date": date.toString(),
  };
}