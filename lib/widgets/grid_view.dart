import 'package:flutter/material.dart';

class MoneyGridView extends StatelessWidget {
  final double course;
  final ScrollController gridController;

  MoneyGridView({@required this.course, @required this.gridController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          controller: gridController,
          itemCount: 2000,
          scrollDirection: Axis.horizontal,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
          itemBuilder: (_, position) {
            return GridTile(
              child: Container(
                decoration: BoxDecoration(
                    color: position % 2 == 0 ? Colors.grey : Colors.white),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 7.0,
                      child: Center(
                        child: Text(
                          position.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 7.0,
                      child: Center(
                        child:
                            Text((position / course).toStringAsFixed(2) + "€"),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
