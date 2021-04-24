/**
 * 投稿dto
 */
class Post {
  String id;
  String name;
  String memo;
  DateTime createdAt;
  DateTime updatedAt;
  Post({this.id, this.name, this.memo, this.createdAt, this.updatedAt});
}
