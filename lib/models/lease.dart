class Lease {
  int? id;
  DateTime? startDate;
  DateTime? endDate;
  double? depositAmount;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? renewMonthly;
  int? tenant;
  int? house;

  Lease(
      {this.id,
      this.startDate,
      this.endDate,
      this.depositAmount,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.renewMonthly,
      this.house,
      this.tenant});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "start_date": startDate.toString(),
      "end_date": endDate.toString(),
      "deposit_amount": depositAmount,
      "is_active": isActive,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "renew_monthly": renewMonthly,
      "tenant": tenant,
      "house": house
    };
  }

  Lease.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    startDate = DateTime.tryParse(json['start_date']) ?? DateTime.now();
    endDate = DateTime.tryParse(json['end_date']) ?? DateTime.now();
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    depositAmount = double.parse(json['deposit_amount']);
    isActive = json['is_active'];
    renewMonthly = json['renew_monthly'];
    tenant = json['tenant'];
    house = json['house'];
  }
}
