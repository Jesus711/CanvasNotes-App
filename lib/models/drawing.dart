// lib/models/drawing.dart
import 'dart:typed_data';

class Drawing {
  final int ID; // ID can be null when inserting a new drawing
  final String drawingName;
  final Uint8List drawingData;

  Drawing({required this.ID, required this.drawingName, required this.drawingData});

}
