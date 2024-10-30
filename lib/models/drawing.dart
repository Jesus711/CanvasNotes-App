class Drawing {
  final int ID; 
  final String drawingName;
  final String drawingJSON;
  final int canvasSize;
  final String createdAtDate;
  final String lastModifiedDate;
  final String backgroundColor;

  Drawing({
    required this.ID,
    required this.drawingName,
    required this.drawingJSON,
    required this.canvasSize,
    required this.createdAtDate,
    required this.lastModifiedDate,
    required this.backgroundColor,
  });

}
