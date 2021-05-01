class CoffeeCard {
  String name;
  int score;
  String memo;
  bool isPublic;
  String imageUrl;
  DateTime createdAt;
  DateTime coffeeAt;
  DateTime updatedAt;
  CoffeeCard(
      {this.name,
      this.score,
      this.memo,
      this.isPublic,
      this.imageUrl,
      this.updatedAt,
      this.createdAt});
}
