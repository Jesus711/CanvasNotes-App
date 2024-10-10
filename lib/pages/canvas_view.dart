import "dart:typed_data";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_drawing_board/flutter_drawing_board.dart";
import "package:flutter_drawing_board/paint_contents.dart";

import "../database/database_helper.dart";

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final DrawingController _controller = DrawingController();
  final _nameController = TextEditingController();

  static List colorsList = [
    [0, "Red", Colors.red.shade600],
    [1, "Green", Colors.green.shade600],
    [2, "Blue", Colors.blue.shade600],
    [3, "Yellow", Colors.yellow.shade600],
    [4, "Orange", Colors.orange.shade600],
    [5, "Purple", Colors.purple.shade600],
    [6, "Pink", Colors.pink.shade600],
    [7, "Brown", Colors.brown.shade600],
    [8, "Grey", Colors.grey.shade600],
    [9, "Cyan", Colors.cyan.shade600],
    [10, "Lime", Colors.lime.shade600],
    [11, "Teal", Colors.teal.shade600],
    [12, "Indigo", Colors.indigo.shade600],
    [13, "Amber", Colors.amber.shade600],
    [14, "Deep Orange", Colors.deepOrange.shade600],
    [15, "Deep Purple", Colors.deepPurple.shade600],
    [16, "Light Blue", Colors.lightBlue.shade600],
    [17, "Light Green", Colors.lightGreen.shade600],
    [18, "Blue Grey", Colors.blueGrey.shade600],
    [19, "Pink Accent", Colors.pinkAccent.shade400],
    [20, "Red Accent", Colors.redAccent.shade400],
    [21, "Purple Accent", Colors.purpleAccent.shade400],
    [22, "Indigo Accent", Colors.indigoAccent.shade400],
    [23, "Cyan Accent", Colors.cyanAccent.shade400],
    [24, "Orange Accent", Colors.orangeAccent.shade400],
    [25, "Lime Accent", Colors.limeAccent.shade400],
    [26, "Yellow Accent", Colors.yellowAccent.shade400],
    [27, "Green Accent", Colors.greenAccent.shade400],
    [28, "Teal Accent", Colors.tealAccent.shade400],
    [29, "Blue Accent", Colors.blueAccent.shade400],
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

  void buildColorPicker() {
    List temp = [];
    List row = [];
    for (var i = 0; i < 30; i++) {
      if (i % 5 == 0 && i > 0) {
        temp.add(row);
        row = [];
      }
      row.add(
          '[IconButton(onPressed: () {}, icon: const Icon(Icons.circle), color: colorsList[$i][2]), $i]');
    }

    temp.add(row);

    for (var i = 0; i < colorPickerList.length; i++) {
      print(temp[i].toString());
    }
    print("ColorPicker Created");
  }

  //final DatabaseHelper _dbHelper = DatabaseHelper();

  void setDrawingBoardStyles() {
    _controller.setStyle(
      color: Colors.black,
    );
  }

  void setColor(Color color) {
    _controller.setStyle(color: color);
  }

  void displayColorPicker() {
    showDialog(
        context: context,
        builder: (BuildContext) {
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
                      "Color Picker",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  )),
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [

                      IconButton(
                          onPressed: () => {Navigator.pop(context, 0)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[0][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 1)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[1][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 2)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[2][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 3)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[3][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 4)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[4][2])
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 5)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[5][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 6)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[6][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 7)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[7][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 8)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[8][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 9)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[9][2])
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 10)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[10][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 11)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[11][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 12)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[12][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 13)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[13][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 14)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[14][2])
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 15)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[15][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 16)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[16][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 17)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[17][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 18)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[18][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 19)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[19][2])
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 20)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[20][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 21)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[21][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 22)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[22][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 23)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[23][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 24)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[24][2])
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 25)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[25][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 26)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[26][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 27)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[27][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 28)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[28][2]),
                      IconButton(
                          onPressed: () => {Navigator.pop(context, 29)},
                          iconSize: 42,
                          icon: const Icon(Icons.circle),
                          color: colorsList[29][2])
                    ],
                  )
                ],
              ));
        }).then((colorChoice) {
      if (colorChoice == null) return;

      _controller.setStyle(color: colorsList[colorChoice][2]);
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
                Text(
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
        }).then((saveDrawing) {
      if (saveDrawing == null || !saveDrawing) return;

      String name = _nameController.text;
      if (saveDrawing) {
        if (name.isEmpty) {
          print("Saving Drawing under Untitled");
        } else {
          print("Saving the drawing with the name $name");
        }
      }
    });
    List<Uint8List> drawing_data =
        (await _controller.getImageData()) as List<Uint8List>;
    print((await _controller.getImageData())?.buffer.asUint8List());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDrawingBoardStyles();
      buildColorPicker();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: _getImageData,
                  icon: const Icon(Icons.save),
                  iconSize: 30,
                ),
                const Text(
                  "Save",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              ],
            ),
          )
        ],
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          "New Drawing",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: DrawingBoard(
          controller: _controller,
          background: Container(width: 1000, height: 1000, color: Colors.white),
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
                    icon: Icons.color_lens_outlined,
                    color: Colors.blue.shade800,
                    onTap: () => displayColorPicker(),
                    iconSize: 48,
                    isActive: false,
                  ));
          }),
    );
  }
}
