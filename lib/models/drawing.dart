// lib/models/drawing.dart
import 'dart:typed_data';

class Drawing {
  final int id; // ID can be null when inserting a new drawing
  final String name;
  final Uint8List drawingData;

  Drawing({required this.id, required this.name, required this.drawingData});

}
