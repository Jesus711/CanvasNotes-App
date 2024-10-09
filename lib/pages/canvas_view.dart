import "package:flutter/material.dart";
import "package:flutter_drawing_board/flutter_drawing_board.dart";

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {

  final DrawingController _controller = DrawingController();

  void setDrawingBoardStyles() {
    _controller.setStyle(color: Colors.black, );
  }

  Future<void> _getImageData() async {
    print((await _controller.getImageData())?.buffer.asInt8List());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setDrawingBoardStyles());
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
                IconButton(onPressed: _getImageData, icon: const Icon(Icons.save), iconSize: 30,),
                const Text("Save", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)
              ],
            ),
          )
        ],
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade800,
        title: const Text("New Drawing", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
      ),
      body: DrawingBoard(
        controller: _controller,
        background: Container(width: 1000, height: 1000, color: Colors.white),
        showDefaultActions: true, /// Enable default action options
        showDefaultTools: true,   /// Enable default toolbar
        boardClipBehavior: Clip.none,
      ),
    );

  }
}