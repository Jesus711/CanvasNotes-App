import 'dart:typed_data';

import 'package:canvas_notes_flutter/models/drawing.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DrawingDatabase {

  static Database? _db;

  // Create a singleton instance of the database
  static final DrawingDatabase instance  = DrawingDatabase._constructor();

  DrawingDatabase._constructor();

  // Getter method to connect to the database
  // unary operator '!' is a null assertion operator,
  // tells dart compiler that a variable that might be nullable is guaranteed to not be null
  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await getDatabase();
    return _db!;
  }


  Future<Database> getDatabase() async {
    // Get the default database path
    // Android is data/data/package_name/databases
    final databaseDirPath = await getDatabasesPath();
    // Use path's join method to create drawings.bs at the default location
    final databasePath = join(databaseDirPath, 'drawings.db');
    final database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) => {
          db.execute("""
        Create Table IF Not Exists Drawing(
          ID Integer Primary Key,
          drawingName Text NOT NULL,
          drawingData Blob NOT NULL
        );
        """)
        }
    );
    return database;
  }


  void addDrawing(String name, Uint8List data) async {
    final db = await database;
    db.insert("Drawing", {
      "drawingName": name,
      "drawingData": data,
    });
  }

  void deleteDrawing(int drawingID) async {
    final db = await database;
    db.delete("Drawing", where: "id = ?", whereArgs: [drawingID]);
  }

  void updateDrawing() {

  }

  Future<List<Drawing>> getDrawings() async {
    final db = await database;
    final data = await db.query("Drawing");
    print(data);
    List<Drawing> drawings = data.
      map((drawing) =>
        Drawing(
          ID: drawing["ID"] as int,
          drawingName: drawing["drawingName"] as String,
          drawingData: drawing["drawingData"] as Uint8List)
    ).toList();



    return drawings;
  }


}