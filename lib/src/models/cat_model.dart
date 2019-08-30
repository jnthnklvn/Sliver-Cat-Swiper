class CatModel {
  final String url;
  final int width;
  final int height;
  final String id;

  CatModel(this.url, this.width, this.height, this.id);

  CatModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        url = json['url'],
        height = json['height'],
        width = json['width'];
}
