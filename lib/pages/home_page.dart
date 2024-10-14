import 'package:canvas_notes_flutter/database/drawing_db.dart';
import 'package:canvas_notes_flutter/models/drawing.dart';
import 'package:canvas_notes_flutter/pages/canvas_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'package:flutter_drawing_board/paint_contents.dart';
//import 'package:canvas_notes_flutter/pages/draw_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final DrawingDatabase _drawingDb = DrawingDatabase.instance;

  List<Drawing> drawingsList = [];

  @override
  void initState() {
    super.initState();
  }

  void _createNewCanvas() async {
    bool? drawingSaved = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CanvasView()));
    setState(() {});
  }

  void _openSavedCanvas(Drawing loadDrawing) async {
    bool? saved = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CanvasView(
                  importedDrawing: loadDrawing,
                )));
  }

  void _deleteCanvas(drawingID) async {
    _drawingDb.deleteDrawing(drawingID);
    setState(() {

    });
  }

  Widget _drawingList() {
    return FutureBuilder(
      future: _drawingDb.getDrawings(),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const EmptyList();
        }
        return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Drawing drawing = snapshot.data![index];
              return Padding(
                  padding: const EdgeInsets.fromLTRB(2, 6, 2, 0),
                  child: Slidable(
                      endActionPane:
                          ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.3,
                              children: [
                                SlidableAction(
                                  onPressed: (value) => {_deleteCanvas(drawing.ID)},
                                  icon: Icons.delete,
                                  borderRadius: BorderRadius.circular(15),
                                  backgroundColor: Colors.red,
                                )
                      ]),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(12),
                              ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                drawing.drawingName,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              ElevatedButton(
                                  onPressed: () => {_openSavedCanvas(drawing)},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade700),
                                  child: const Text("Open",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)))
                            ],
                          ))));
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          "Canvas Notes",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
      body: _drawingList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _createNewCanvas,
        tooltip: 'Create New Canvas',
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Center(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              'Click on the + Icon to create a Canvas to start drawing',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            )));
  }
}
