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

  Lease({
    this.id,
    this.startDate,
    this.endDate,
    this.depositAmount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.renewMonthly,
    this.tenant,
    this.house,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "start_date": startDate,
      "end_date": endDate,
      "deposit_amount": depositAmount,
      "is_active": isActive,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "renew_monthly": renewMonthly,
      "tenant": tenant,
      "house": house,
    };
  }

  Lease.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    startDate = DateTime.parse(json['start_date']);
    endDate = DateTime.parse(json['end_date']);
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    depositAmount = double.parse(json['deposit_amount']);
    isActive = json['is_active'];
    renewMonthly = json['renew_monthly'];
    tenant = json['tenant'];
    house = json['house'];
  }
}
