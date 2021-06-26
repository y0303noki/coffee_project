class CoffeeCard {
  String id;
  String name;
  int score;
  String memo;
  bool isPublic;
  // String imageUrl;
  String userImageId;
  DateTime createdAt;
  DateTime coffeeAt;
  DateTime updatedAt;
  bool isMyBottle;
  CoffeeCard(
      {this.id,
      this.name,
      this.score,
      this.memo,
      this.isPublic,
      this.userImageId,
      this.updatedAt,
      this.createdAt,
      this.isMyBottle});
}
