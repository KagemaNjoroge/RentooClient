class Maintenance {
  int? id;
  String? description;
  DateTime? requestDate;
  bool? isCompleted;
  DateTime? completedDate;
  int? house;

  Maintenance({
    this.id,
    this.completedDate,
    this.description,
    this.house,
    this.isCompleted,
    this.requestDate,
  });

  Maintenance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    completedDate = DateTime.parse(json['completed_date']);
    description = json['description'];
    house = json['house'];
    isCompleted = json['is_completed'];
    requestDate = json['request_date'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "completed_date": completedDate,
        "description": description,
        "house": house,
        "is_completed": isCompleted,
        "request_date": requestDate
      };
}
