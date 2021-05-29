class UserDto {
  String id;
  int status;
  String googleId;
  DateTime createdAt;
  DateTime updatedAt;
  bool isDeleted;
  UserDto({
    this.id,
    this.status,
    this.googleId,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
  });
}
