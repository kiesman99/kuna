import 'package:flutter/material.dart';

class CourseSelectionPage extends StatefulWidget {
  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
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
          autofocus: false,
          keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
        ),
      ),
    );
  }
}