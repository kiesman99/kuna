import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';
import 'package:ripple_color_selection/ripple_color_selection.dart';



class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  static final ColorSelectionController _colorSelectionController =
      new ColorSelectionController();

  int _currentPage = 0;
  static final List<Widget> _pages = [

    RippleColorSelection(
      controller: _colorSelectionController,
    ),
    _CourseSelectionPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: Duration(milliseconds: 200),
              child: _pages.elementAt(_currentPage),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    _currentPage--;
                  },
                  child: Text("Prev"),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage++;
                    });
                  },
                  child: Text("Next"),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

// TODO: Seperate into widget
class _CourseSelectionPage extends StatefulWidget {
  @override
  __CourseSelectionPageState createState() => __CourseSelectionPageState();
}

class __CourseSelectionPageState extends State<_CourseSelectionPage> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextField(
          controller: _textEditingController,
          autofocus: true,
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
        ),
      ),
    );
  }
}
