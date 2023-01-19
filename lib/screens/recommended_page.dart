import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';
import '../widgets/book_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  final List<Book> bookList = [];
  List<Book> _books = [];
  var _isLoading = true;
  late Database _database;

  Future<void> loadData() async {
    const url =
        "https://book-reader-7ae88-default-rtdb.asia-southeast1.firebasedatabase.app/amreli.json";
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> extractedData =
        Map<String, dynamic>.from(jsonDecode(response.body));
    for (var element in extractedData.values) {
      String? id, name, image, path;
      for (var e in element.keys) {
        if (e == "id") {
          id = element[e];
        } else if (e == "name") {
          name = element[e];
        } else if (e == "image") {
          image = element[e];
        } else if (e == "path") {
          path = element[e];
        }
      }
      bookList.add(Book(id: id!, name: name!, image: image!, path: path!));
    }
    if(!mounted){
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void openDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/books.db';
    final isDBExists = await databaseExists(path);
    if (!isDBExists) {
      _database = await openDatabase(
        path,
        onCreate: (db, version) {
          return db.execute(
              'CREATE TABLE favourites(id TEXT PRIMARY KEY,name TEXT, image TEXT, path TEXT)');
        },
        version: 1,
      );
    } else {
      _database = await openDatabase(path, version: 1);
      _books = await getFavBooks();
    }
  }

  Future<List<Book>> getFavBooks() async {
    final List<Map<String, dynamic>> books =
        await _database.query('favourites');
    return List.generate(books.length, (index) {
      return Book(
        id: books[index]['id'],
        name: books[index]['name'],
        image: books[index]['image'],
        path: books[index]['path'],
      );
    });
  }

  @override
  void initState() {
    loadData();
    openDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: SpinKitSpinningLines(
              color: Colors.white,
              size: 40,
            ),
          )
        : MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 12,
            itemCount: bookList.length,
            itemBuilder: (context, i) {
              bool temp = false;
              for (var j = 0; j < _books.length; j++) {
                if (bookList[i].id == _books[j].id) {
                  temp = true;
                  break;
                }
              }
              return BookImage(
                book: bookList[i],
                isFav: temp,
              );
            },
          );
  }
}
