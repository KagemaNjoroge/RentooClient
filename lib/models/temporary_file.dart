class TemporaryFile {
  int? id;
  String? url;
  DateTime? createdAt;

  TemporaryFile({this.id, this.url, this.createdAt});
  TemporaryFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['file'];
    createdAt = DateTime.parse(json['created_at']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = url;
    data['created_at'] = createdAt.toString();
    return data;
  }
}
