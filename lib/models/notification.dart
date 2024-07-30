class Notifications {
  int? id;
  String? title;
  String? message;
  DateTime? createdAt;
  bool? read;
  int? user;

  Notifications({
    this.id,
    this.title,
    this.message,
    this.createdAt,
    this.read,
    this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "message": message,
      "created_at": createdAt.toString(),
      "read": read,
      "user": user
    };
  }

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    createdAt = DateTime.parse(json['created_at']);
    read = json['read'];
    user = json['user'];
  }
}
