import 'package:canvas_notes_flutter/models/drawing.dart';
import 'package:canvas_notes_flutter/pages/canvas_view.dart';
import 'package:flutter/material.dart';
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

  //final DatabaseHelper _dbHelper = DatabaseHelper();

  static List<String> canvases = [];

  static List<Drawing> drawingsList = [];

  @override
  void initState(){
    super.initState();
  }


  // Future<void> _getDrawings() async {
  //   List<Drawing> drawings = await _dbHelper.getDrawings();
  //   setState(() {
  //     drawingsList = drawings;
  //   });
  // }


  void _createNewCanvas() {
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CanvasView()));
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const DrawView()));

    setState(() {
// This call to setState tells the Flutter framework that something has
// changed in this State, which causes it to rerun the build method below
// so that the display can reflect the updated values. If we changed
// _counter without calling setState(), then the build method would not be
// called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
//
// The Flutter framework has been optimized to make rerunning build methods
// fast, so that you can just rebuild anything that needs updating rather
// than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text("Canvas Notes", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),),
      ),
      backgroundColor: Colors.blue.shade100,
      body: canvases.isEmpty ? const EmptyList()
          : ListView.builder(
              itemCount: canvases.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            border: const Border(
                                bottom: BorderSide(
                                    width: 4,
                                    color: Colors.white
                                )
                            )
                            //borderRadius: BorderRadius.circular(15),
                          ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Text(canvases[index], style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),))
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _createNewCanvas,
        tooltip: 'Create New Canvas',
        child: const Icon(Icons.add, size: 32,),
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
        'Click on the + Icon to create a Canvas to start drawing' ,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
        )
      )
    );
  }
}
