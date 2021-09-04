import 'dart:math';
import 'package:flutter/material.dart';
import 'game_class.dart';

class InventoryBar extends StatelessWidget {
  InventoryBar({
    Key? key,
  }) : super(key: key);
  final List<Widget> inventorySquares = [
    InventorySquare('none'),
    InventorySquare('wood'),
    InventorySquare('grass'),
    InventorySquare('none'),
    InventorySquare('wood'),
    InventorySquare('grass'),
    InventorySquare('none'),
    InventorySquare('wood'),
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: screenSize.width,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: inventorySquares,
        ),
      ),
    );
  }
}

class InventorySquare extends StatelessWidget {
  late final contained_object;
  InventorySquare(String object) {
    contained_object = object;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double tileSize = screenSize.width / 16;
    return GestureDetector(
      onTap: () {
        selectedObject = contained_object;
      },
      child: Container(
        width: tileSize,
        height: tileSize,
        color: new Color.fromRGBO(128, 128, 128, 0.5),
        /*child: Image(
          image: AssetImage('images/grass_tile.jpeg'),
          width: double.infinity,
          height: double.infinity,
        ),

         */
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            contained_object,
          ),
        ),
      ),
    );
  }
}
