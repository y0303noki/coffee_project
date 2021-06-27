class CoffeeCard {
  String id;
  String name;
  int score;
  // String memo;
  String shopOrBrandName;
  bool isPublic;
  // String imageUrl;
  String userImageId;
  DateTime createdAt;
  DateTime coffeeAt;
  DateTime updatedAt;
  CoffeeCard(
      {this.id,
      this.name,
      this.score,
      this.shopOrBrandName,
      this.isPublic,
      this.userImageId,
      this.updatedAt,
      this.createdAt});
}
