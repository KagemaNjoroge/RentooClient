class MpesaPaymentSettings {
  int? id;
  String? consumerKey;
  String? consumerSecret;
  String? passKey;
  String? shortCode;
  bool? testMode;

  MpesaPaymentSettings({
    this.id,
    this.consumerKey,
    this.consumerSecret,
    this.shortCode,
    this.passKey,
    this.testMode,
  });

  MpesaPaymentSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    consumerKey = json['consumer_key'];
    consumerSecret = json['consumer_secret'];
    shortCode = json['short_code'];
    passKey = json['pass_key'];
    testMode = json['test_mode'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": 1,
      "consumer_key": consumerKey,
      "consumer_secret": consumerSecret,
      "pass_key": passKey,
      "short_code": shortCode,
      "test_mode": testMode
    };
  }
}
