class Payment {
  int? id;
  double? amount;
  DateTime? paymentDate;
  String? paymentMethod;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? lease;
  String? notes;
  String? paymentStatus;
  String? referenceCode;

  Payment({
    this.id,
    this.amount,
    this.createdAt,
    this.lease,
    this.paymentDate,
    this.paymentMethod,
    this.updatedAt,
    this.notes,
    this.paymentStatus,
    this.referenceCode,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = double.parse(json['amount']);
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    lease = json['lease'];
    paymentDate = DateTime.parse(json['payment_date']);
    paymentMethod = json['payment_method'];
    notes = json['notes'];
    paymentStatus = json['payment_status'];
    referenceCode = json['reference_code'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "lease": lease,
      "payment_date": paymentDate,
      "payment_method": paymentMethod,
      "notes": notes,
      "reference_code": referenceCode,
      "payment_status": paymentStatus
    };
  }
}
