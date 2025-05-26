class Board{
  int? id;
  final String title;
  final String content;
  final String category;
  String? boardCategory;

  String? createdAt;
  String? imageUrl;
  Board({
  this.id,
  required this.category,
  required this.content,
  required this.title,
  this.createdAt,
  this.boardCategory,
  this.imageUrl,
});
  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      title: json['title'],
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      boardCategory: json['boardCategory'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt']
    );
  }
}