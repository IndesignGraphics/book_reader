import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/book.dart';

class PdfViewScreen extends StatefulWidget {
  final Book book;

  const PdfViewScreen({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late Database _database;
  late int lastPage = 1;

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
      _database = await openDatabase(path, version: 1);
      final result = await _database.rawQuery(
          "SELECT lastPage FROM recent WHERE id = ?", [widget.book.id]);
      setState(() {
        lastPage = result[0]['lastPage'] as int;
        _pdfViewerController.jumpToPage(lastPage);
      });
    }
  }

  Future<void> updateLastPage(String id, int pageNumber) async {
    await _database.rawUpdate(
        'UPDATE recent SET lastPage = ? WHERE id = ?', [pageNumber, id]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.name),
      ),
      body: SfPdfViewer.network(
        widget.book.path,
        controller: _pdfViewerController,
        enableDoubleTapZooming: true,
        onPageChanged: (PdfPageChangedDetails pdfPageChangedDetails) async {
          await updateLastPage(
              widget.book.id, pdfPageChangedDetails.newPageNumber);
        },
      ),
    );
  }
}
