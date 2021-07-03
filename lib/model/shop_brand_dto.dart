class ShopBrandDto {
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  bool isCommon;
  bool isDeleted;
  ShopBrandDto({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.isCommon,
    this.isDeleted,
  });
}
