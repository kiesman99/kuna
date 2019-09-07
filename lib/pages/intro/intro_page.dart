import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';
import 'package:ripple_color_selection/ripple_color_selection.dart';

import 'course_selection.dart';



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
      rippleExpandDuration: const Duration(milliseconds: 3000),
      controller: _colorSelectionController,
    ),
    CourseSelectionPage()
  ];

  /// This list will hold information if the specific page n is valid => The needed values were selected
  final List<bool> isPageValid = List.generate(_pages.length, (index) => false);

  @override
  void initState() {

    _colorSelectionController.addListener(() {
      setState(() {
        isPageValid.insert(0, true);
      });
    });

    super.initState();
  }

  Future<bool> willPop() async {
    if(_currentPage == 0)
      return true;

    setState(() {
      _currentPage--;
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: Duration(milliseconds: 200),
              child: _pages.elementAt(_currentPage),
            ),
        ),
        bottomNavigationBar: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 100.0),
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _currentPage == 0 ? Container() : RaisedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage--;
                    });
                  },
                  child: Text("Prev"),
                ),
                RaisedButton(
                  onPressed: !isPageValid.elementAt(_currentPage) ? null : () {
                    setState(() {
                      _currentPage++;
                    });
                  },
                  child: Text("Next"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
