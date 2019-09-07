import 'package:flutter/material.dart';
import 'package:kuna/provider/calculator_provider.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Container(
              height: constraints.maxHeight / 2,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      Provider.of<CalculatorProvider>(context).calcPadNumber,
                      style: TextStyle(fontSize: 36.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(Provider.of<CalculatorProvider>(context)
                        .calculatedValue)
                  ],
                ),
              ),
            ));
      },
    );
  }
}
