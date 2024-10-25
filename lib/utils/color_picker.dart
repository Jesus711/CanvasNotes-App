import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {

  const ColorPicker({
    super.key,
    required this.activeColor,
  });

  final Color activeColor;

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


  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        width: deviceWidth / 1.5,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            ...List.generate(colorsList.length, (index) {
              return IconButton(
                  tooltip: colorsList[index][1],
                  onPressed: () => {Navigator.pop(context, index)},
                  iconSize: 38,
                  icon: const Icon(Icons.circle),
                  color: colorsList[index][2]);
            })
          ],
        ),
    );
  }
}