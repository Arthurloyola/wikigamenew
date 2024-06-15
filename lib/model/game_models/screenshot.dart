class ScreenshotModel {
  final int id;
  final String imageId;

  ScreenshotModel(this.id, this.imageId);

  ScreenshotModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        imageId = json["image_id"];
}
