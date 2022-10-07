class Book {
  String id, name, image, path;

  Book(
      {required this.id,
      required this.name,
      required this.image,
      required this.path});
}

class RecentBook {
  String id, name, image, path;
  int lastPage;

  RecentBook({
    required this.id,
    required this.name,
    required this.image,
    required this.path,
    required this.lastPage,
  });
}
