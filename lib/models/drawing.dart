class Drawing {
  final int ID; // ID can be null when inserting a new drawing
  final String drawingName;
  final String drawingJSON;
  final int canvasSize;
  final String createdAtDate;
  final String lastModifiedDate;

  // TODO: Add BackgroundColor
  Drawing({
    required this.ID,
    required this.drawingName,
    required this.drawingJSON,
    required this.canvasSize,
    required this.createdAtDate,
    required this.lastModifiedDate,
  });

}
