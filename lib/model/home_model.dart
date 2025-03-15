class HomeModel {
  String _uuid;
  String _name;
  String _image;

  HomeModel({required String uuid, required String name, required String image})
    : _uuid = uuid,
      _name = name,
      _image = image;

  factory HomeModel.fromMap(Map<String, dynamic> data, String docId) {
    return HomeModel(
      uuid: docId,
      name: data["name"] ?? "",
      image: data["image"] ?? "",
    );
  }

  set setName(String newName) {
    _name = newName;
  }

  set setUuid(String newUuid) {
    _name = newUuid;
  }

  set setImage(String newImage) {
    _name = newImage;
  }

  String get uuid => _uuid;
  String get name => _name;
  String get image => _image;
}
