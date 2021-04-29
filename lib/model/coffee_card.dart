class CoffeeCard {
  String name;
  int score;
  String memo;
  bool isPublic;
  DateTime createdAt;
  DateTime coffeeAt;
  DateTime updatedAt;
  CoffeeCard(
      {this.name,
      this.score,
      this.memo,
      this.isPublic,
      this.updatedAt,
      this.createdAt});
}
