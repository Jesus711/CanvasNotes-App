import 'dart:async';
import 'package:canvas_notes_flutter/database/drawing_db.dart';
import 'package:canvas_notes_flutter/models/drawing.dart';
import 'package:canvas_notes_flutter/pages/canvas_view.dart';
import 'package:canvas_notes_flutter/utils/drawing_item.dart';
import 'package:flutter/material.dart';

enum SortOption {
  nameAsc,
  nameDesc,
  dateAsc,
  dateDesc,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final DrawingDatabase _drawingDb = DrawingDatabase.instance;

  List<Drawing> _allDrawings = [];
  List<Drawing> _filteredDrawings = [];
  bool _isLoading = true;
  String _error = "";

  final _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadDrawings();
  }

  Future<void> _loadDrawings() async {
    try{
      setState(() => _isLoading = true);
      final drawings = await _drawingDb.getDrawings();

      setState(() {
        _allDrawings = drawings;
        _filteredDrawings = drawings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterDrawings(String query) {
    setState(() {
      _filteredDrawings = _allDrawings
          .where((drawing) =>
          drawing.drawingName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sortDrawings(SortOption sortOption) {
    setState(() {
      switch (sortOption) {
        case SortOption.nameAsc:
          _filteredDrawings.sort((a, b) => a.drawingName.compareTo(b.drawingName));
          break;
        case SortOption.nameDesc:
          _filteredDrawings.sort((a, b) => b.drawingName.compareTo(a.drawingName));
          break;
        case SortOption.dateAsc:
          _filteredDrawings.sort((a, b) => a.ID.compareTo(b.ID));
          break;
        case SortOption.dateDesc:
          _filteredDrawings.sort((a, b) => b.ID.compareTo(a.ID));
          break;
      }
    });
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
      if (created != null && created){
        print("Create Drawing");
        _loadDrawings();
      }
    });
  }

  void _openSavedCanvas(Drawing loadDrawing) async {
    setState(() {
      isSearching = false;
    });

    bool? saved = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CanvasView(
                importedDrawing: loadDrawing,
                canvasSize: loadDrawing.canvasSize
            )
        )
    );

    if (saved != null && saved) {
      _loadDrawings();
    }
  }

  void _deleteCanvas(int index, int drawingID) async {
    _drawingDb.deleteDrawing(drawingID);
    setState(() {
      _filteredDrawings.removeAt(index);
    });
  }

  Widget _sortingMenu() {
    return PopupMenuButton<SortOption>(
      icon: const Icon(
        Icons.sort,
        color: Colors.white,
        size: 32,
      ),
      onSelected: _sortDrawings,
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: SortOption.nameAsc,
          child: Row(
            children: [
              Icon(Icons.arrow_upward),
              SizedBox(width: 8),
              Text('Name (A to Z)'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortOption.nameDesc,
          child: Row(
            children: [
              Icon(Icons.arrow_downward),
              SizedBox(width: 8),
              Text('Name (Z to A)'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortOption.dateAsc,
          child: Row(
            children: [
              Icon(Icons.arrow_upward),
              SizedBox(width: 8),
              Text('Oldest First'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortOption.dateDesc,
          child: Row(
            children: [
              Icon(Icons.arrow_downward),
              SizedBox(width: 8),
              Text('Newest First'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _displayDrawingList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadDrawings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_allDrawings.isEmpty){
      return const EmptyList();
    }

    return Column(
        children: [
          const Text("Tap to Open Canvas",
          style: TextStyle(color: Colors.white, fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredDrawings.length,
              itemBuilder: (context, index) {
                Drawing drawing = _filteredDrawings[index];
                return DrawingItem(
                    drawing: drawing,
                    deleteDrawing: (value) => {_deleteCanvas(index, drawing.ID)},
                    openCanvas: () => {_openSavedCanvas(drawing)},
                );
              }
          )
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _allDrawings.isEmpty ? [] : <Widget>[
          // Search
          Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton(
                  onPressed: () => {
                    if (isSearching){
                      setState(() {
                        _filterDrawings("");
                        _searchController.text = "";
                      })
                    },
                    setState(() {
                      isSearching = !isSearching;
                    })
                  },
                  icon: Icon(isSearching ? Icons.cancel : Icons.search, color: Colors.white, size: 32,)
              )
          ),
          // Sorting Menu
          Padding(padding: const EdgeInsets.all(4), child: _sortingMenu()),
        ],
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
        backgroundColor: Colors.blue.shade800,
        title: isSearching ? TextField(
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          controller: _searchController,
            onChanged: (value) => {_filterDrawings(value)},
            decoration: const InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.white),

            ),
        ) : const Text(
          "Canvas Notes",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: const Color.fromRGBO(64, 64, 64, 0.5),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _displayDrawingList(),
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
