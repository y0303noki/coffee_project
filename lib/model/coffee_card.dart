class CoffeeCard {
  String name;
  int score;
  String memo;
  DateTime createdAt;
  DateTime coffeeAt;
  DateTime updatedAt;
  CoffeeCard(this.name, this.score, this.updatedAt,
      {this.memo, this.createdAt});
}
