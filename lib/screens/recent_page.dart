import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';
import '../widgets/book_image.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  List<Book> _recentBooks = [];
  List<Book> _books = [];
  var _isLoading = true;
  bool _isDataAvailable = true;
  late Database _database;

  Future<void> loadData() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/books.db';
    final isDBExists = await databaseExists(path);
    if (isDBExists) {
      _database = await openDatabase(path);
      _recentBooks = await getRecentBooks();
      if(!mounted){
        return;
      }
      setState(() {
        _isDataAvailable = _recentBooks.isNotEmpty;
      });
    } else {
      if(!mounted){
        return;
      }
      setState(() {
        _isDataAvailable = false;
      });
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

  Future<List<Book>> getRecentBooks() async {
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS recent(id TEXT PRIMARY KEY,name TEXT, image TEXT, path TEXT, lastPage INTEGER)");
    final List<Map<String, dynamic>> books = await _database.query('recent');
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
    if (_isDataAvailable) {
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
              itemCount: _recentBooks.length,
              itemBuilder: (context, i) {
                bool temp = false;
                for (var j = 0; j < _books.length; j++) {
                  if (_recentBooks[i].id == _books[j].id) {
                    temp = true;
                    break;
                  }
                }
                return BookImage(
                  book: _recentBooks[i],
                  isFav: temp,
                );
              },
            );
    } else {
      return const Center(
        child: Text("No Recent Books"),
      );
    }
  }
}
