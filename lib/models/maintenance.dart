class Maintenance {
  int? id;
  String? description;
  DateTime? requestDate;
  bool? isCompleted;

  int? house;
  String? status;

  Maintenance(
      {this.id,
      this.description,
      this.house,
      this.isCompleted,
      this.requestDate,
      this.status});

  Maintenance.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    description = json['description'];
    house = json['house'];
    isCompleted = json['is_completed'];
    requestDate = DateTime.parse(json['request_date']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "house": house,
        "is_completed": isCompleted,
        "request_date": requestDate,
        "status": status
      };
}
