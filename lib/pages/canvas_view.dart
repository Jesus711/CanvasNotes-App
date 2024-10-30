import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:canvas_notes_flutter/database/drawing_db.dart";
import "package:canvas_notes_flutter/utils/color_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_drawing_board/flutter_drawing_board.dart";
import "package:flutter_drawing_board/paint_contents.dart";
import "package:permission_handler/permission_handler.dart";
import "package:path_provider/path_provider.dart";
import "dart:math" as math;
import "../models/drawing.dart";

class CanvasView extends StatefulWidget {
  const CanvasView({super.key, this.importedDrawing, required this.canvasSize});

  final Drawing? importedDrawing;
  final int canvasSize;

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> with SingleTickerProviderStateMixin {
  final DrawingController _controller = DrawingController();
  final _nameController = TextEditingController();

  final DrawingDatabase _drawingDb = DrawingDatabase.instance;

  late final importedDrawing = widget.importedDrawing;
  late int canvasSize = widget.canvasSize;

  String drawingLastSave = "";

  double _colorOpacity = 1.0;
  Color _activeColor = Colors.black;
  Color _backgroundColor = Colors.white;

  bool _showDrawTools = true;
  bool _showActiveColor = true;

  final TransformationController _transformationController =
      TransformationController();

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

  Color getImportedBGColor() {
    Map<String, dynamic> savedBGColor = jsonDecode(importedDrawing!.backgroundColor);
    return Color.fromRGBO(savedBGColor["R"] as int, savedBGColor["G"] as int, savedBGColor["B"] as int, 1);
  }

  String convertBGtoString(Color color) {
    Map<String, int> colors = {"R": _backgroundColor.red, "G":_backgroundColor.green, "B": _backgroundColor.blue };
    String bgString = jsonEncode(colors);
    return bgString;
  }

  void displayBackgroundColorPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              backgroundColor: _backgroundColor == Colors.black
                  ? Colors.white.withOpacity(0.85)
                  : Colors.black.withOpacity(0.5),
              title: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Background Color Picker",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  )),
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                        child: ColorPicker(activeColor: _backgroundColor),
                        );
                  }));
        }).then((colorChoice) {
      if (colorChoice == null) return;
      Color color = colorChoice;
      setBackgroundColor(color);
    });
  }

  void displayColorPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              backgroundColor: _backgroundColor == Colors.black
                  ? Colors.white.withOpacity(0.85)
                  : Colors.black.withOpacity(0.5),
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
                return SingleChildScrollView(
                  child: Column(
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
                    ColorPicker(activeColor: _activeColor),
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
                ));
              }));
        }).then((colorChoice) {
      if (colorChoice == null) return;
      Color color = colorChoice;
      setColor(color);
    });
  }

  void saveDrawingChanges(BuildContext context) async {
    DateTime now = DateTime.now();

    String modifiedDate =
        "${now.month}/${now.day}/${now.year} ${now.hour}:${now.minute < 10 ? "0${now.minute}" : now.minute}";

    String backgroundColor = convertBGtoString(_backgroundColor);

    String drawingJson = _convertImageToJson();

    _drawingDb.updateDrawing(
      importedDrawing!.ID,
      drawingJson,
      modifiedDate,
      backgroundColor
    );

    final snackBar = SnackBar(
      content: const Text(
        'Changes Saved!',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 1100), // Duration the snack bar will be shown
      behavior: SnackBarBehavior.floating, // Makes the SnackBar float
      margin: const EdgeInsets.all(16.0), // Adds margin to the SnackBar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );

    setState(() {
      drawingLastSave = drawingJson;
    });

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void drawImportedDrawing() {
    List<dynamic> drawingSteps = jsonDecode(importedDrawing!.drawingJSON) as List<dynamic>;
    List<Map<String, dynamic>> lines = drawingSteps.cast<Map<String, dynamic>>();

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
    setBackgroundColor(getImportedBGColor());
    setState(() {
      drawingLastSave = importedDrawing!.drawingJSON;
    });
  }

  String _convertImageToJson() {
    String jsonData = jsonEncode(_controller.getJsonList());
    return jsonData;
  }

  void resetCanvas() {
    _transformationController.value = Matrix4.identity()..scale(1.4);
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
                              elevation: 20,
                              backgroundColor: Colors.blue.shade600),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.download,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Download",
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

  Future<bool?> _getImageData(bool onBackPressed) async {
    _nameController.text = "";

    bool? saveDrawing = await showDialog(
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
            backgroundColor: const Color.fromRGBO(85, 87, 91, 1),
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
                      fillColor: Color.fromRGBO(105, 107, 111, 1),
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
                            child: Text(onBackPressed ? "Exit" : "Cancel",
                                style: const TextStyle(
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
        });

    if (saveDrawing == null) return null;

    String name = _nameController.text;
    if (saveDrawing) {
      if (name.isEmpty) {
        name = "Untitled";
      }

      String drawingJSON = _convertImageToJson();
      DateTime now = DateTime.now();
      String bgString = convertBGtoString(_backgroundColor);
      String createdDate =
          "${now.month}/${now.day}/${now.year} ${now.hour}:${now.minute < 10 ? "0${now.minute}" : now.minute}";
      _drawingDb.addDrawing(name, drawingJSON, canvasSize, createdDate, "", bgString);
      if(!onBackPressed){
        Navigator.pop(context, true);
        return null;
      }
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    if (importedDrawing != null) {
      drawImportedDrawing();
    }
    _transformationController.value = Matrix4.identity()..scale(1.4);
    setColor(Colors.black);
  }

  Widget canvasMenu(BuildContext context) {
    return PopupMenuButton<int>(
      color: const Color.fromRGBO(105, 107, 111, 1),
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
          setState(() {
            _showActiveColor = !_showActiveColor;
          });
        }
        else if (value == 3) {
          if (importedDrawing != null) {
            saveDrawingChanges(context);
          } else {
            _getImageData(false);
          }
        } else if (value == 4) {
          resetCanvas();
        } else if (value == 5) {
          displayFullCanvas();
        } else if (value == 6) {
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
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Icon(_showActiveColor ? Icons.visibility_off : Icons.visibility, size: 32),
              ),
              Text(
                _showActiveColor ? "Hide Active Color" : "Show Active Color",
                style: const TextStyle(
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
                child: Icon(Icons.save, size: 32),
              ),
              Text(
                "Save Canvas",
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
          value: 5,
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
          value: 6,
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop){
          return;
        }
        final navigator = Navigator.of(context);

        if (importedDrawing != null && (drawingLastSave != _convertImageToJson() || _backgroundColor != getImportedBGColor())) {

          bool? saveDrawing = await showDialog(
              context: context, builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(85, 87, 91, 1),
              title: const Text("Save Changes?", textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),),
              content: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => {Navigator.pop(context, false)},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red
                      ),
                      child: const Text("Exit", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500))
                  ),
                  ElevatedButton(
                      onPressed: () => {Navigator.pop(context, true)},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500))
                  ),
                ],
              ),
            );
          });

          if (saveDrawing == null) return;

          if (saveDrawing) {
            saveDrawingChanges(context);
          }
        }
        else if (importedDrawing == null && _controller.getJsonList().isNotEmpty) {
          bool? createDrawing  = await _getImageData(true);
          if (createDrawing == null) return;
        }

        navigator.pop();
      },
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(105, 107, 111, 1),
                        Color.fromRGBO(146, 148, 152, 1)
                      ],
                    )
                )
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: canvasMenu(context),
              ),
            ],
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade600,
            title: Text(
              importedDrawing != null
                  ? importedDrawing!.drawingName == "Untitled"
                      ? "${importedDrawing!.drawingName}${importedDrawing!.ID}"
                      : importedDrawing!.drawingName
                  : "New Canvas",
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children:
              [
                DrawingBoard(
                    controller: _controller,
                    background: Container(
                      width: canvasSize * 1.0,
                      height: canvasSize * 1.0,
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                      ),
                    ),
                    minScale: 0.05,
                    transformationController: _transformationController,
                    // TODO: Build own tools to fix menu toggle bug
                    // BUG: When max zoomed out with menu showing, toggling menu causes canvas to spring to the top
                    // due to rerender
                    showDefaultActions: _showDrawTools,
                    showDefaultTools: _showDrawTools,
                    defaultToolsBuilder: (Type t, _) {
                      return DrawingBoard.defaultTools(t, _controller)
                        ..insert(
                            0,
                            DefToolItem(
                              icon: Icons.color_lens_rounded,
                              color: Colors.blue.shade500,
                              onTap: () => displayColorPicker(),
                              iconSize: 36,
                              isActive: false,
                            ))
                        ..insert(
                            1,
                            DefToolItem(
                              icon: Icons.format_color_fill,
                              color: Colors.blue,
                              onTap: () => {
                                displayBackgroundColorPicker(),
                              },
                              iconSize: 36,
                              isActive: false,
                            )
                        );
                      }
                    ),
                _showActiveColor ? Positioned(
                    top: 10,
                    left: 5,
                    child: Row(
                      children: [
                        Text(
                          "Active Color: ",
                          style: TextStyle(
                              color: _backgroundColor == Colors.black ? Colors.white : Colors.black,
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
                            : Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:  BorderRadius.circular(20),
                              ),
                              child: Icon(
                                  Icons.circle,
                                  color: _activeColor.withOpacity(_colorOpacity),
                                  size: 32,
                                ),
                            )
                      ],
                    )
                ) : Container(),
                Positioned(
                    bottom: _showDrawTools ? 100 : 10,
                    right: 5,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: _showDrawTools ? Matrix4.rotationX(0) : Matrix4.rotationX(math.pi),
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        tooltip: _showDrawTools ? "Close Draw Tools" :"Open Draw Tools",
                        onPressed: () {
                          setState(() {
                            _showDrawTools = !_showDrawTools;
                          });
                        },
                        icon: Icon(
                          Icons.expand_circle_down,
                          size: 36,
                          color: _backgroundColor == Colors.black ? Colors.white : Colors.black,),
                        ),
                    )
                    ),
                ]
            );
          }
          )
      ),
    );
  }
}
