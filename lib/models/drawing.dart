// lib/models/drawing.dart
import 'dart:typed_data';

class Drawing {
  final int ID; // ID can be null when inserting a new drawing
  final String drawingName;
  final String drawingJSON;

  Drawing({
    required this.ID,
    required this.drawingName,
    required this.drawingJSON});

}
