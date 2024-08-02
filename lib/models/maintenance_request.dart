class MaintenanceRequest {
  int? id;
  String? description;
  DateTime? requestDate;
  bool? isCompleted;

  int? house;
  String? status;

  MaintenanceRequest({
    this.id,
    this.description,
    this.house,
    this.isCompleted,
    this.requestDate,
    this.status,
  });

  MaintenanceRequest.fromJson(Map<String, dynamic> json) {
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
        "request_date": requestDate.toString(),
        "status": status
      };
}