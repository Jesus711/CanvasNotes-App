import "dart:typed_data";

import "package:canvas_notes_flutter/database/drawing_db.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_drawing_board/flutter_drawing_board.dart";
import "package:flutter_drawing_board/paint_contents.dart";

import "../models/drawing.dart";

class CanvasView extends StatefulWidget {
  const CanvasView({super.key, this.importedDrawing});

  final Drawing? importedDrawing;

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final DrawingController _controller = DrawingController();
  final _nameController = TextEditingController();

  final DrawingDatabase _drawingDb = DrawingDatabase.instance;

  late final importedDrawing = widget.importedDrawing;

  double _colorOpacity = 1.0;

  Color _activeColor = Colors.black;

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

  void setOpacity(double value) {
    setState(() {
      _colorOpacity = value.clamp(0, 1);
    });
    _controller.setStyle(color: _activeColor.withOpacity(value));
  }

  void displayColorPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              backgroundColor: Colors.black54,
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
                        const Text(
                          "Active Color: ",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        Icon(
                          Icons.circle,
                          color: _activeColor.withOpacity(_colorOpacity),
                          size: 56,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[0][1],
                            onPressed: () => {Navigator.pop(context, 0)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[0][2]),
                        IconButton(
                            tooltip: colorsList[1][1],
                            onPressed: () => {Navigator.pop(context, 1)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[1][2]),
                        IconButton(
                            tooltip: colorsList[2][1],
                            onPressed: () => {Navigator.pop(context, 2)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[2][2]),
                        IconButton(
                            tooltip: colorsList[3][1],
                            onPressed: () => {Navigator.pop(context, 3)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[3][2]),
                        IconButton(
                            tooltip: colorsList[4][1],
                            onPressed: () => {Navigator.pop(context, 4)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[4][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[5][1],
                            onPressed: () => {Navigator.pop(context, 5)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[5][2]),
                        IconButton(
                            tooltip: colorsList[6][1],
                            onPressed: () => {Navigator.pop(context, 6)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[6][2]),
                        IconButton(
                            tooltip: colorsList[7][1],
                            onPressed: () => {Navigator.pop(context, 7)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[7][2]),
                        IconButton(
                            tooltip: colorsList[8][1],
                            onPressed: () => {Navigator.pop(context, 8)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[8][2]),
                        IconButton(
                            tooltip: colorsList[9][1],
                            onPressed: () => {Navigator.pop(context, 9)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[9][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[10][1],
                            onPressed: () => {Navigator.pop(context, 10)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[10][2]),
                        IconButton(
                            tooltip: colorsList[11][1],
                            onPressed: () => {Navigator.pop(context, 11)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[11][2]),
                        IconButton(
                            tooltip: colorsList[12][1],
                            onPressed: () => {Navigator.pop(context, 12)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[12][2]),
                        IconButton(
                            tooltip: colorsList[13][1],
                            onPressed: () => {Navigator.pop(context, 13)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[13][2]),
                        IconButton(
                            tooltip: colorsList[14][1],
                            onPressed: () => {Navigator.pop(context, 14)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[14][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[15][1],
                            onPressed: () => {Navigator.pop(context, 15)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[15][2]),
                        IconButton(
                            tooltip: colorsList[16][1],
                            onPressed: () => {Navigator.pop(context, 16)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[16][2]),
                        IconButton(
                            tooltip: colorsList[17][1],
                            onPressed: () => {Navigator.pop(context, 17)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[17][2]),
                        IconButton(
                            tooltip: colorsList[18][1],
                            onPressed: () => {Navigator.pop(context, 18)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[18][2]),
                        IconButton(
                            tooltip: colorsList[19][1],
                            onPressed: () => {Navigator.pop(context, 19)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[19][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[20][1],
                            onPressed: () => {Navigator.pop(context, 20)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[20][2]),
                        IconButton(
                            tooltip: colorsList[21][1],
                            onPressed: () => {Navigator.pop(context, 21)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[21][2]),
                        IconButton(
                            tooltip: colorsList[22][1],
                            onPressed: () => {Navigator.pop(context, 22)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[22][2]),
                        IconButton(
                            tooltip: colorsList[23][1],
                            onPressed: () => {Navigator.pop(context, 23)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[23][2]),
                        IconButton(
                            tooltip: colorsList[24][1],
                            onPressed: () => {Navigator.pop(context, 24)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[24][2])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: colorsList[25][1],
                            onPressed: () => {Navigator.pop(context, 25)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[25][2]),
                        IconButton(
                            tooltip: colorsList[26][1],
                            onPressed: () => {Navigator.pop(context, 26)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[26][2]),
                        IconButton(
                            tooltip: colorsList[27][1],
                            onPressed: () => {Navigator.pop(context, 27)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[27][2]),
                        IconButton(
                            tooltip: colorsList[28][1],
                            onPressed: () => {Navigator.pop(context, 28)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[28][2]),
                        IconButton(
                            tooltip: colorsList[29][1],
                            onPressed: () => {Navigator.pop(context, 29)},
                            iconSize: 42,
                            icon: const Icon(Icons.circle),
                            color: colorsList[29][2])
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Opacity: ${(_colorOpacity * 100).toInt()}",
                          style: const TextStyle(
                              fontSize: 28, color: Colors.white),
                        ),
                        Slider(
                          activeColor: Colors.blue.shade600,
                          min: 0.0,
                          max: 1.0,
                          divisions: 100,
                          value: _colorOpacity,
                          label: (100 * _colorOpacity).toInt().toString(),
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

  Future<void> _getImageData() async {
    _nameController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            title: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(20)),
                width: 200,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Enter a Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                )),
            backgroundColor: Colors.blue.shade800,
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Default: Untitled",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                TextField(
                  controller: _nameController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  cursorWidth: 2,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: "Drawings #...",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 20),
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
                                    color: Colors.white, fontSize: 16))),
                        ElevatedButton(
                            onPressed: () => {Navigator.pop(context, true)},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600),
                            child: const Text("Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))),
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
          print("Saving Drawing under Untitled");
          name = "Untitled";
        } else {
          print("Saving the drawing with the name $name");
        }

        Uint8List? drawingData =
            (await _controller.getImageData())?.buffer.asUint8List();

        _drawingDb.addDrawing(name, drawingData!);
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDrawingBoardStyles();
    });
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800, elevation: 0),
                  onPressed: _getImageData,
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.save,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Save",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )
                    ],
                  )),
            )
          ],
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue.shade800,
          title: Text(
            importedDrawing?.drawingName ?? "New Drawing",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: Stack(
          children: [
            DrawingBoard(
                controller: _controller,
                background: importedDrawing != null
                    ? Image.memory(
                        width: 1000,
                        height: 1000,
                        importedDrawing!.drawingData,
                        fit: BoxFit.contain,
                      )
                    : Container(width: 1000, height: 1000, color: Colors.white),
                showDefaultActions: true,

                /// Enable default action options
                showDefaultTools: true,

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
                          iconSize: 48,
                          isActive: false,
                        ));
                }),
            Positioned(
                top: 10,
                left: 5,
                child: Row(
                  children: [
                    const Text(
                      "Active Color: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.circle,
                      color: _activeColor.withOpacity(_colorOpacity),
                      size: 32,
                    ),
                  ],
                )),
          ],
        ));
  }
}
