import 'package:flutter/material.dart';
import 'package:flutter_flame_experiment/global/myPlayer_state.dart';
import '../game/game_objects.dart';

class InventoryBar extends StatelessWidget {
  InventoryBar({
    Key? key,
  }) : super(key: key);
  final List<Widget> inventorySquares = [
    InventorySquare(none),
    InventorySquare(wood),
    InventorySquare(grass),
    InventorySquare(wood),
    InventorySquare(grass),
    InventorySquare(wood),
    InventorySquare(grass),
    InventorySquare(wood),
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
  final GameObject object;
  InventorySquare(GameObject object) : object = object;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double tileSize = screenSize.width / 16;
    return GestureDetector(
      onTap: () {
        holdingObject = object;
      },
      child: Container(
        width: tileSize,
        height: tileSize,
        color: Color.fromRGBO(0, 0, 0, 0.5),
        child: Padding(
          padding: EdgeInsets.all(tileSize / 6),
          child: (object.name != 'none')
              ? Image(
                  width: double.infinity,
                  height: double.infinity,
                  image: AssetImage('images/' + object.image),
                )
              : FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    object.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
