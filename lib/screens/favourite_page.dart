import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';
import '../widgets/book_image.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late Database _database;
  List<Book> _books = [];
  bool _isLoading = true;
  bool _isDataAvailable = true;

  @override
  void initState() {
    openDB();
    super.initState();
  }

  void openDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/books.db';
    final isDBExists = await databaseExists(path);
    if (isDBExists) {
      _database = await openDatabase(path);
      _books = await getFavBooks();
      if (!mounted) {
        return;
      }
      setState(() {
        _isDataAvailable = _books.isNotEmpty;
      });
    } else {
      if (!mounted) {
        return;
      }
      setState(() {
        _isDataAvailable = false;
      });
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
    });
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
              itemCount: _books.length,
              itemBuilder: (context, i) {
                return BookImage(
                  book: _books[i],
                  isFav: true,
                );
              },
            );
    } else {
      return const Center(
        child: Text("No Favourite Books"),
      );
    }
  }
}
