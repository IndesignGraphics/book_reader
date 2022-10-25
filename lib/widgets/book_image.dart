import 'dart:io';

import 'package:book_reader/screens/pdf_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';

class BookImage extends StatefulWidget {
  final Book book;
  final bool isFav;

  const BookImage({
    Key? v,
    required this.book,
    required this.isFav,
  }) : super(key: v);

  @override
  State<BookImage> createState() => _BookImageState();
}

class _BookImageState extends State<BookImage> {
  var imageWidth = 0.0;
  bool _isFav = false;
  late Database _database;
  List<RecentBook> _recentBook = [];

  @override
  void initState() {
    openDB();
    _isFav = widget.isFav;
    super.initState();
  }

  void openDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/books.db';
    final isDBExists = await databaseExists(path);
    if (isDBExists) {
      _database = await openDatabase(path, version: 1);
    }
  }

  Future<void> makeBookFav(Book bk) async {
    await _database.insert('favourites', {
      "id": bk.id,
      "name": bk.name,
      "image": bk.image,
      "path": bk.path,
    });
  }

  Future<void> removeFromFav(String id) async {
    await _database.delete('favourites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> makeFavourite() async {
    if (_isFav) {
      await removeFromFav(widget.book.id);
    } else {
      await makeBookFav(widget.book);
    }
    setState(() {
      _isFav = !_isFav;
    });
  }

  Future<void> addToRecent(Book bk) async {
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS recent(id TEXT PRIMARY KEY,name TEXT, image TEXT, path TEXT, lastPage INTEGER)");
    _recentBook = await getRecentBooks();
    bool isRecent = false;
    for (var i = 0; i < _recentBook.length; i++) {
      if (bk.id == _recentBook[i].id) {
        isRecent = true;
        break;
      }
    }
    if (!isRecent) {
      await _database.insert('recent', {
        "id": bk.id,
        "name": bk.name,
        "image": bk.image,
        "path": bk.path,
        "lastPage": 1,
      });
    }
  }

  Future<List<RecentBook>> getRecentBooks() async {
    final List<Map<String, dynamic>> books = await _database.query('recent');
    return List.generate(books.length, (index) {
      return RecentBook(
        id: books[index]['id'],
        name: books[index]['name'],
        image: books[index]['image'],
        path: books[index]['path'],
        lastPage: books[index]['lastPage'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);
    final Image image = Image.network(
      widget.book.image,
    );
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      if (!mounted) {
        return;
      }
      setState(() {
        imageWidth = info.image.width.toDouble();
      });
    }));
    return imageWidth == 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.white70,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: imageWidth,
                child: Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      shadowColor: Theme.of(context).shadowColor,
                      elevation: 10,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      child: Center(child: image),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: borderRadius,
                          onTap: () async {
                            await addToRecent(widget.book);
                            if (!mounted) return;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PdfViewScreen(
                                  book: widget.book,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            await makeFavourite();
                            if (!mounted) return;
                            if (_isFav) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Added to Favourites"),
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Removed from Favourites"),
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            }
                          },
                          icon: _isFav
                              ? const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                )
                              : const Icon(
                                  Icons.star_border,
                                  color: Colors.yellow,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
