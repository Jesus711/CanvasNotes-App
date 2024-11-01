import 'package:canvas_notes_flutter/models/drawing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DrawingItem extends StatelessWidget {
  const DrawingItem({
    super.key,
    required this.drawing,
    required this.deleteDrawing,
    required this.openCanvas,
  });

  final Drawing drawing;
  final Function()? openCanvas;
  final Function(BuildContext)? deleteDrawing;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Slidable(
            endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    onPressed: deleteDrawing,
                    icon: Icons.delete,
                    borderRadius: BorderRadius.circular(15),
                    backgroundColor: Colors.red,
                  )
                ]),
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(105, 107, 111, 1),
                    Color.fromRGBO(146, 148, 152, 1)
                  ],
                    //begin: Alignment.topRight,
                    //end: Alignment.bottomLeft
                ),
              ),
              child: ElevatedButton(
                  onPressed: openCanvas,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: deviceWidth / 1.5,
                            child: Text(
                              drawing.drawingName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            "Size: ${drawing.canvasSize}x${drawing.canvasSize}",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            drawing.lastModifiedDate == drawing.createdAtDate
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
                  )
              ),
            )
        )
    );
  }
}
