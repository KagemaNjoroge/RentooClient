class Maintenance {
  int? id;
  int? request;
  int? maintainer;
  double? cost;
  DateTime? dateDone;
  String? comments;
  bool? isDone;

  Maintenance({
    this.comments,
    this.cost,
    this.dateDone,
    this.id,
    this.isDone,
    this.maintainer,
    this.request,
  });
  Maintenance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comments = json['comments'];
    cost = double.parse(json['cost']);
    dateDone = DateTime.parse(json['date_done']);
    maintainer = json['maintainer'];
    request = json['request'];
    isDone = json['is_done'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "comments": comments,
      "cost": cost,
      "date_done": dateDone,
      "is_done": isDone,
      "request": request,
      "maintainer": maintainer
    };
  }
}
