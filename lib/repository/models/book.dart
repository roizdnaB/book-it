class Book {
  final String title;
  final String author;
  final String shortDescription;
  bool isRead;

  Book({this.title, this.author, this.shortDescription, this.isRead = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'shortDescription': shortDescription,
      'isRead': isRead,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    } else {
      return Book(
        title: map['title'],
        author: map['author'],
        shortDescription: map['shortDescription'],
        isRead: map['isRead'],
      );
    }
  }
}
