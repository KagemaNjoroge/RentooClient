class Photo {
  int? id;
  String? image;
  String? caption;

  Photo({this.caption, this.id, this.image});
  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "image": image, "caption": caption};
  }
}
