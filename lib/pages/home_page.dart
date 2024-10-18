import 'package:canvas_notes_flutter/database/drawing_db.dart';
import 'package:canvas_notes_flutter/models/drawing.dart';
import 'package:canvas_notes_flutter/pages/canvas_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final DrawingDatabase _drawingDb = DrawingDatabase.instance;

  @override
  void initState() {
    super.initState();
  }

  void _createNewCanvas() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Choose Canvas Size", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
            backgroundColor: Colors.white.withOpacity(0.8),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          backgroundColor: Colors.blue.shade800,
                          elevation: 8,
                        ),
                        onPressed: () => {Navigator.pop(context, 500)},
                        child: const Text("500x500", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        backgroundColor: Colors.blue.shade800,
                        elevation: 8,
                      ),
                        onPressed: () => {Navigator.pop(context, 1000)},
                        child: const Text("1000x1000", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        backgroundColor: Colors.blue.shade800,
                        elevation: 8,
                      ),
                        onPressed: () => {Navigator.pop(context, 1500)},
                        child: const Text("1500x1500", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        backgroundColor: Colors.blue.shade800,
                        elevation: 8,
                      ),
                        onPressed: () => {Navigator.pop(context, 2000)},
                        child: const Text("2000x2000", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        backgroundColor: Colors.blue.shade800,
                        elevation: 8,
                      ),
                        onPressed: () => {Navigator.pop(context, 2500)},
                        child: const Text("2500x2500", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),)),
                  )
                ],
              ),
            ),
          );
        }
    ).then((selectedSize) async {
      if (selectedSize  == null) return;

      bool? created = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CanvasView(
                    canvasSize: selectedSize,
                  )));
      setState(() {});
    });
  }

  void _openSavedCanvas(Drawing loadDrawing) async {
    bool? saved = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CanvasView(
                importedDrawing: loadDrawing,
                canvasSize: loadDrawing.canvasSize)));
    setState(() {});
  }

  void _deleteCanvas(drawingID) async {
    _drawingDb.deleteDrawing(drawingID);
    setState(() {});
  }

  Widget _drawingList() {
    return FutureBuilder(
      future: _drawingDb.getDrawings(),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const EmptyList();
        }
        return Column(
          children: [
            const Text("Tap to Open Canvas",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    Drawing drawing = snapshot.data![index];
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Slidable(
                            endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                extentRatio: 0.3,
                                children: [
                                  SlidableAction(
                                    onPressed: (value) =>
                                        {_deleteCanvas(drawing.ID)},
                                    icon: Icons.delete,
                                    borderRadius: BorderRadius.circular(15),
                                    backgroundColor: Colors.red,
                                  )
                                ]),
                            child: ElevatedButton(
                                onPressed: () => {_openSavedCanvas(drawing)},
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    backgroundColor: Colors.blue.shade600,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          drawing.drawingName == "Untitled"
                                              ? "${drawing.drawingName}${drawing.ID}"
                                              : drawing.drawingName,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "Size: ${drawing.canvasSize}x${drawing.canvasSize}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          drawing.lastModifiedDate == ""
                                              ? "Created On: ${drawing.createdAtDate}"
                                              : "Last Modified: ${drawing.lastModifiedDate}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                    const Icon(
                                      Icons.image_sharp,
                                      color: Colors.white,
                                      size: 48,
                                    )
                                  ],
                                ))));
                  }),
            )
          ],
        );
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
      backgroundColor: const Color.fromRGBO(64, 64, 64, 0.5),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _drawingList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _createNewCanvas,
        tooltip: 'Create New Canvas',
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
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
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            )));
  }
}
