import "dart:convert";
import "dart:developer";
import "dart:io";
import "dart:typed_data";
import "package:canvas_notes_flutter/database/drawing_db.dart";
import "package:flutter/material.dart";
import "package:flutter_drawing_board/flutter_drawing_board.dart";
import "package:flutter_drawing_board/paint_contents.dart";
import "package:permission_handler/permission_handler.dart";
import "package:path_provider/path_provider.dart";

import "../models/drawing.dart";

class CanvasView extends StatefulWidget {
  const CanvasView({super.key, this.importedDrawing, required this.canvasSize});

  final Drawing? importedDrawing;
  final int canvasSize;

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView>
    with SingleTickerProviderStateMixin {
  final DrawingController _controller = DrawingController();
  final _nameController = TextEditingController();

  final DrawingDatabase _drawingDb = DrawingDatabase.instance;

  late final importedDrawing = widget.importedDrawing;

  late int canvasSize = widget.canvasSize;

  double _colorOpacity = 1.0;

  Color _activeColor = Colors.black;

  Color _backgroundColor = Colors.white;

  bool _showDrawTools = true;

  final TransformationController _transformationController =
      TransformationController();

  static List colorsList = [
    // Reds
    [0, "Red", Colors.red.shade600],
    [1, "Red Accent", Colors.redAccent.shade400],
    [2, "Pink", Colors.pink.shade600],
    [3, "Pink Accent", Colors.pinkAccent.shade400],

    // Oranges and Yellows
    [4, "Orange", Colors.orange.shade600],
    [5, "Deep Orange", Colors.deepOrange.shade600],
    [6, "Orange Accent", Colors.orangeAccent.shade400],
    [7, "Amber", Colors.amber.shade600],
    [8, "Yellow", Colors.yellow.shade600],
    [9, "Yellow Accent", Colors.yellowAccent.shade400],

    // Greens
    [10, "Green", Colors.green.shade600],
    [11, "Light Green", Colors.lightGreen.shade600],
    [12, "Green Accent", Colors.greenAccent.shade400],
    [13, "Teal", Colors.teal.shade600],
    [14, "Teal Accent", Colors.tealAccent.shade400],

    // Blues
    [15, "Blue", Colors.blue.shade600],
    [16, "Light Blue", Colors.lightBlue.shade600],
    [17, "Blue Accent", Colors.blueAccent.shade400],
    [18, "Cyan", Colors.cyan.shade600],
    [19, "Cyan Accent", Colors.cyanAccent.shade400],

    // Purples and Indigo
    [20, "Purple", Colors.purple.shade600],
    [21, "Deep Purple", Colors.deepPurple.shade600],
    [22, "Purple Accent", Colors.purpleAccent.shade400],
    [23, "Indigo", Colors.indigo.shade600],
    [24, "Indigo Accent", Colors.indigoAccent.shade400],

    // Neutral and Others
    [25, "Black", Colors.black],
    [26, "Brown", Colors.brown.shade600],
    [27, "Grey", Colors.grey.shade600],
    [28, "Blue Grey", Colors.blueGrey.shade600],
    [29, "White", Colors.white]
  ];

  final colorPickerList = [
    [
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[0][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[1][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[2][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[3][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[4][2])
    ],
    [
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[5][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[6][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[7][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[8][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[9][2])
    ],
    [
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[10][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[11][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[12][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[13][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[14][2])
    ],
    [
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[15][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[16][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[17][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[18][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[19][2])
    ],
    [
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[20][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[21][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[22][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[23][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[24][2])
    ],
    [
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[25][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[26][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[27][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[28][2]),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          color: colorsList[29][2])
    ]
  ];

  void setDrawingBoardStyles() {
    _controller.setStyle(
      color: Colors.black,
    );
  }

  void setColor(Color color) {
    setState(() {
      _activeColor = color;
    });
    _controller.setStyle(color: _activeColor.withOpacity(_colorOpacity));
  }

  void setBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }

  // TODO: Modify function to display for choosing a background color
  // May or may not be needed
  void displayColorPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              backgroundColor: _backgroundColor == Colors.black
                  ? Colors.white70
                  : Colors.black45,
              title: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(20)),
                  width: 200,
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Color Picker",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  )),
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Active Color: ",
                          style: TextStyle(
                              color: _backgroundColor == Colors.black
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.circle,
                          color: _activeColor.withOpacity(_colorOpacity),
                          size: 40,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[0][1],
                            onPressed: () => {Navigator.pop(context, 0)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[0][2]),
                        IconButton(
                            tooltip: colorsList[1][1],
                            onPressed: () => {Navigator.pop(context, 1)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[1][2]),
                        IconButton(
                            tooltip: colorsList[2][1],
                            onPressed: () => {Navigator.pop(context, 2)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[2][2]),
                        IconButton(
                            tooltip: colorsList[3][1],
                            onPressed: () => {Navigator.pop(context, 3)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[3][2]),
                        IconButton(
                            tooltip: colorsList[4][1],
                            onPressed: () => {Navigator.pop(context, 4)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[4][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[5][1],
                            onPressed: () => {Navigator.pop(context, 5)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[5][2]),
                        IconButton(
                            tooltip: colorsList[6][1],
                            onPressed: () => {Navigator.pop(context, 6)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[6][2]),
                        IconButton(
                            tooltip: colorsList[7][1],
                            onPressed: () => {Navigator.pop(context, 7)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[7][2]),
                        IconButton(
                            tooltip: colorsList[8][1],
                            onPressed: () => {Navigator.pop(context, 8)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[8][2]),
                        IconButton(
                            tooltip: colorsList[9][1],
                            onPressed: () => {Navigator.pop(context, 9)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[9][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[10][1],
                            onPressed: () => {Navigator.pop(context, 10)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[10][2]),
                        IconButton(
                            tooltip: colorsList[11][1],
                            onPressed: () => {Navigator.pop(context, 11)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[11][2]),
                        IconButton(
                            tooltip: colorsList[12][1],
                            onPressed: () => {Navigator.pop(context, 12)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[12][2]),
                        IconButton(
                            tooltip: colorsList[13][1],
                            onPressed: () => {Navigator.pop(context, 13)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[13][2]),
                        IconButton(
                            tooltip: colorsList[14][1],
                            onPressed: () => {Navigator.pop(context, 14)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[14][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[15][1],
                            onPressed: () => {Navigator.pop(context, 15)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[15][2]),
                        IconButton(
                            tooltip: colorsList[16][1],
                            onPressed: () => {Navigator.pop(context, 16)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[16][2]),
                        IconButton(
                            tooltip: colorsList[17][1],
                            onPressed: () => {Navigator.pop(context, 17)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[17][2]),
                        IconButton(
                            tooltip: colorsList[18][1],
                            onPressed: () => {Navigator.pop(context, 18)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[18][2]),
                        IconButton(
                            tooltip: colorsList[19][1],
                            onPressed: () => {Navigator.pop(context, 19)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[19][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[20][1],
                            onPressed: () => {Navigator.pop(context, 20)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[20][2]),
                        IconButton(
                            tooltip: colorsList[21][1],
                            onPressed: () => {Navigator.pop(context, 21)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[21][2]),
                        IconButton(
                            tooltip: colorsList[22][1],
                            onPressed: () => {Navigator.pop(context, 22)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[22][2]),
                        IconButton(
                            tooltip: colorsList[23][1],
                            onPressed: () => {Navigator.pop(context, 23)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[23][2]),
                        IconButton(
                            tooltip: colorsList[24][1],
                            onPressed: () => {Navigator.pop(context, 24)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[24][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[25][1],
                            onPressed: () => {Navigator.pop(context, 25)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[25][2]),
                        IconButton(
                            tooltip: colorsList[26][1],
                            onPressed: () => {Navigator.pop(context, 26)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[26][2]),
                        IconButton(
                            tooltip: colorsList[27][1],
                            onPressed: () => {Navigator.pop(context, 27)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[27][2]),
                        IconButton(
                            tooltip: colorsList[28][1],
                            onPressed: () => {Navigator.pop(context, 28)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[28][2]),
                        IconButton(
                            tooltip: colorsList[29][1],
                            onPressed: () => {Navigator.pop(context, 29)},
                            iconSize: 38,
                            icon: const Icon(Icons.circle),
                            color: colorsList[29][2])
                      ],
                    ),
                    Column(
                      children: [
                        Text("Opacity: ${(_colorOpacity * 100).toInt()}",
                            style: TextStyle(
                                color: _backgroundColor == Colors.black
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700)),
                        Slider(
                          activeColor: Colors.blue.shade600,
                          min: 0.0,
                          max: 1.0,
                          divisions: 100,
                          value: _colorOpacity,
                          onChanged: (value) {
                            setState(() {
                              _colorOpacity = value;
                            });
                            setColor(_activeColor);
                          },
                        ),
                      ],
                    )
                  ],
                );
              }));
        }).then((colorChoice) {
      if (colorChoice == null) return;
      Color color = colorsList[colorChoice][2];
      setColor(color);
    });
  }

  void saveDrawingChanges(BuildContext context) async {
    DateTime now = DateTime.now();
    //TODO: Issue found on time format time 8:07pm -> 20:7, need to fixed to include leading 0 if minutes < 10
    String modifiedDate =
        "${now.month}/${now.day}/${now.year} ${now.hour}:${now.minute < 10 ? "0${now.minute}" : now.minute}";
    _drawingDb.updateDrawing(
      importedDrawing!.ID,
      _convertImageToJson(),
      modifiedDate,
    );

    final snackBar = SnackBar(
      content: const Text(
        'Changes Saved!',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(
          milliseconds: 1100), // Duration the snack bar will be shown
      behavior: SnackBarBehavior.floating, // Makes the SnackBar float
      margin: const EdgeInsets.all(16.0), // Adds margin to the SnackBar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
      ),
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void drawImportedDrawing() {
    List<dynamic> drawingSteps =
        jsonDecode(importedDrawing!.drawingJSON) as List<dynamic>;

    List<Map<String, dynamic>> lines =
        drawingSteps.cast<Map<String, dynamic>>();

    for (var i = 0; i < lines.length; i++) {
      String lineType = lines[i]["type"];
      if (lineType == "SimpleLine") {
        _controller.addContent(SimpleLine.fromJson(lines[i]));
      } else if (lineType == "SmoothLine") {
        _controller.addContent(SmoothLine.fromJson(lines[i]));
        // Fixed misspelling with straight line
      } else if (lineType == "StraightLine") {
        _controller.addContent(StraightLine.fromJson(lines[i]));
      } else if (lineType == "Rectangle") {
        _controller.addContent(Rectangle.fromJson(lines[i]));
      } else if (lineType == "Circle") {
        _controller.addContent(Circle.fromJson(lines[i]));
      } else if (lineType == "Eraser") {
        _controller.addContent(Eraser.fromJson(lines[i]));
      }
    }
  }

  String _convertImageToJson() {
    String jsonData = jsonEncode(_controller.getJsonList());
    return jsonData;
  }

  void resetCanvas() {
    _transformationController.value = Matrix4.identity();
  }

  void displayFullCanvas() async {
    Uint8List? data = (await _controller.getImageData())?.buffer.asUint8List();
    if (data == null) {
      debugPrint('Error');
      return;
    }

    if (mounted) {
      showDialog<void>(
          context: context,
          builder: (BuildContext c) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => Navigator.pop(c),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(data),
                      ),
                      ElevatedButton(
                          onPressed: () => {_downloadImage(data)},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.save_alt,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Download Drawing",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ))
                    ],
                  )),
            );
          });
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  Future<void> _downloadImage(Uint8List imageBytes) async {
    try {
      // Request storage permission
      if (await _requestPermission(Permission.manageExternalStorage)) {
        // Get the directory to save the image
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          String path = "/storage/emulated/0/Download";
          DateTime now = DateTime.now();
          String createdDate =
              "${now.month}${now.day}${now.year}${now.hour}${now.minute}${now.second}";
          String filePath = "$path/newDrawing_$createdDate.png";

          if (importedDrawing != null) {
            filePath =
                '$path/${importedDrawing!.drawingName == "Untitled" ? "${importedDrawing!.drawingName}${importedDrawing!.ID}" : importedDrawing!.drawingName}.png'; // File path
          }

          // Save the image to a file
          File file = File(filePath);
          await file.writeAsBytes(imageBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved to $filePath')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    }
  }

  Future<void> _getImageData() async {
    _nameController.text = "";

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            title: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(16)),
                width: 275,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Enter a Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                )),
            backgroundColor: Colors.blue.shade800,
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text(
                    "Default Name: Untitled",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _nameController,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    cursorWidth: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      fillColor: Color.fromRGBO(30, 136, 229, 1),
                      filled: true,
                      hintText: "Drawing #...",
                      hintStyle: TextStyle(color: Colors.white60, fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () => {Navigator.pop(context, false)},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600),
                            child: const Text("Cancel",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))),
                        ElevatedButton(
                            onPressed: () => {Navigator.pop(context, true)},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600),
                            child: const Text("Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))),
                      ]),
                ),
              ],
            ),
          );
        }).then((saveDrawing) async {
      if (saveDrawing == null || !saveDrawing) return;

      String name = _nameController.text;
      if (saveDrawing) {
        if (name.isEmpty) {
          name = "Untitled";
        }

        String drawingJSON = _convertImageToJson();

        DateTime now = DateTime.now();
        String createdDate =
            "${now.month}/${now.day}/${now.year} ${now.hour}:${now.minute < 10 ? "0${now.minute}" : now.minute}";
        _drawingDb.addDrawing(name, drawingJSON, canvasSize, createdDate, "");
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (importedDrawing != null) {
      drawImportedDrawing();
    }
    _transformationController.value = Matrix4.identity()..scale(0.8);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDrawingBoardStyles();
    });
  }

  Widget canvasMenu(BuildContext context) {
    return PopupMenuButton<int>(
      color: Colors.blue.shade500,
      icon: const Icon(
        Icons.menu,
        size: 32,
      ),
      onSelected: (int value) async {
        if (value == 1) {
          setState(() {
            _showDrawTools = !_showDrawTools;
          });
        } else if (value == 2) {
          if (importedDrawing != null) {
            saveDrawingChanges(context);
          } else {
            _getImageData();
          }
        } else if (value == 3) {
          resetCanvas();
        } else if (value == 4) {
          displayFullCanvas();
        } else if (value == 5) {
          Uint8List? data =
              (await _controller.getImageData())?.buffer.asUint8List();
          if (data == null) {
            debugPrint('Error');
            return;
          }
          _downloadImage(data);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Icon(Icons.build, size: 32),
              ),
              Text(
                _showDrawTools ? "Hide Tools" : "Show Tools",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Icon(Icons.save, size: 32),
              ),
              Text(
                "Save Drawing",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Icon(Icons.restore_page_outlined, size: 32),
              ),
              Text(
                "Reset Position",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 4,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Icon(Icons.image_search, size: 32),
              ),
              Text(
                "View Full Canvas",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Icon(Icons.save_alt, size: 32),
              ),
              Text(
                "Download Canvas",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: canvasMenu(context),
            ),
          ],
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue.shade800,
          title: Text(
            importedDrawing != null
                ? importedDrawing!.drawingName == "Untitled"
                    ? "${importedDrawing!.drawingName}${importedDrawing!.ID}"
                    : importedDrawing!.drawingName
                : "New Drawing",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              DrawingBoard(
                  controller: _controller,
                  background: Container(
                    width: canvasSize * 1.0,
                    height: canvasSize * 1.0,
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      //border: Border.all(color: Colors.red, width: (canvasSize / 1000) + 2)
                    ),
                  ),
                  boardBoundaryMargin:
                      EdgeInsets.all(deviceWidth * (canvasSize / 1000)),
                  showDefaultActions: _showDrawTools,
                  minScale: 0.05,
                  transformationController: _transformationController,

                  /// Enable default action options
                  showDefaultTools: _showDrawTools,

                  /// Enable default toolbar
                  boardClipBehavior: Clip.hardEdge,
                  clipBehavior: Clip.antiAlias,
                  defaultToolsBuilder: (Type t, _) {
                    return DrawingBoard.defaultTools(t, _controller)
                      ..insert(
                          0,
                          DefToolItem(
                            icon: Icons.color_lens_rounded,
                            color: Colors.blue.shade500,
                            onTap: () => displayColorPicker(),
                            iconSize: 42,
                            isActive: false,
                          ))
                      ..insert(
                          1,
                          DefToolItem(
                            icon: _backgroundColor == Colors.white
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: _backgroundColor == Colors.white
                                ? Colors.black
                                : Colors.yellow.shade800,
                            onTap: () => {
                              setState(() {
                                _backgroundColor =
                                    _backgroundColor == Colors.white
                                        ? Colors.black
                                        : Colors.white;
                                if (_activeColor == Colors.black) {
                                  setColor(Colors.white);
                                } else if (_activeColor == Colors.white) {
                                  setColor(Colors.black);
                                }
                              })
                            },
                            iconSize: 42,
                            isActive: false,
                          ));
                  }),
              Positioned(
                  top: 10,
                  left: 5,
                  child: Row(
                    children: [
                      Text(
                        "Active Color: ",
                        style: TextStyle(
                            color: _backgroundColor == Colors.white
                                ? Colors.black
                                : Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      _backgroundColor == Colors.black
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.circle,
                                color: _activeColor.withOpacity(_colorOpacity),
                                size: 32,
                              ),
                            )
                          : Icon(
                              Icons.circle,
                              color: _activeColor.withOpacity(_colorOpacity),
                              size: 32,
                            )
                    ],
                  )),
            ],
          );
        }));
  }
}
