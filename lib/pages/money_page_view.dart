import 'package:flutter/material.dart';
import 'package:kuna/provider/shared_pref_provider.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../styles.dart';

class MoneyPageView extends StatefulWidget {
  final PageController pageController;

  final GlobalKey fabKey;
  final GlobalKey settingsKey;

  MoneyPageView({
    @required this.pageController,
    @required this.fabKey,
    @required this.settingsKey
  });

  @override
  _MoneyPageViewState createState() => _MoneyPageViewState();
}

class _MoneyPageViewState extends State<MoneyPageView> {

  // keys
  GlobalKey _tileKey = new GlobalKey();

  int itemsToShow = 2000;

  SettingsProvider get _settingsProvider => Provider.of<SettingsProvider>(context);

  double get course => _settingsProvider.course;

  List<TargetFocus> _tutorialTargets = List();

  void _showTutorial() {
    TutorialCoachMark(
      context,
      textSkip: "Überspringen",
      targets: _tutorialTargets,
      colorShadow: Color(_settingsProvider.primaryColor),
      finish: () => _settingsProvider.tutorialWatched = true,
      clickSkip: () => _settingsProvider.tutorialWatched = true,
      alignSkip: Alignment.bottomLeft
    )..show();
  }

  void _initTargets(){

    _tutorialTargets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: _tileKey,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                children: <Widget>[
                  Text("Hier siehst du eine Schnellansicht mit vorberechneten Werten.\n\n"
                      "Die obere Zeile zeigt den Wert in Fremdwährung.\n\n"
                      "Der untere Wert zeigt dir, wieviel dies in deiner Währung wäre", style: Styles.tutorialText)
                ],
              ),
            ),
          )
        ]
      )
    );

    _tutorialTargets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: widget.fabKey,
          contents: [
            ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text("Du möchtest nicht durch die Liste scrollen, sondern schnell einen Wert suchen?"
                        "Kein Problem! Versuchs mal hier.", style: Styles.tutorialText)
                  ],
                ),
              ),
            )
          ]
      )
    );

    _tutorialTargets.add(
        TargetFocus(
            identify: "Target 3",
            keyTarget: widget.settingsKey,
            contents: [
              ContentTarget(
                align: AlignContent.bottom,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text("In den Einstellungen kannst du ganz einfach den Kurs oder "
                          "sogar dir Farbe der App verändern!", style: Styles.tutorialText)
                    ],
                  ),
                ),
              )
            ]
        )
    );
  }

  @override
  void initState() {
    _initTargets();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!_settingsProvider.tutorialWatched){
        Future.delayed(Duration(milliseconds: 300), () => _showTutorial());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: PageView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: widget.pageController,
            itemCount: 40,
            itemBuilder: (_, position) {
              return buildPage(position, constraints);
            },
          ),
        );
      },
    );
  }

  bool tileTargetSet = false;

  Widget buildPage(int pagePosition, BoxConstraints constraints) {
    Size tileSize = Size(constraints.maxWidth / 5, constraints.maxHeight / 10);

    List<Widget> columns(int rowPosition) {
      return List.generate(10, (columnPosition) {
        int top = (columnPosition + 10 * rowPosition + (50 * pagePosition));
        double bottom = top / course;

        var key = (columnPosition == 4 && !tileTargetSet) ? _tileKey : new GlobalKey();
        if(columnPosition == 4 && !tileTargetSet)
          tileTargetSet = true;

        return _Tile(
          key: key,
          top: top.toString(), // fremdwährung
          bottom: bottom.toStringAsFixed(2), // eigene Währung
          size: tileSize,
          color: columnPosition % 2 == 0 ? Colors.white : Colors.grey,
        );
      });
    }

    Widget column(int rowPosition) {
      return Column(
        children: columns(rowPosition).toList(),
      );
    }

    List<Widget> rows = List.generate(5, (index) {
      return column(index);
    });

    return Container(
        child: Row(
      children: rows.toList(),
    ));
  }
}

class _Tile extends StatelessWidget {
  String top;
  String bottom;
  Size size;
  Color color;

  _Tile(
      {@required this.top,
      @required this.bottom,
      @required this.size,
        Key key,
      this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size.width,
      height: this.size.height,
      color: color,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 7.0,
            child: Center(
              child: Text(
                top,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 7.0,
            child: Center(
              child: Text(bottom),
            ),
          )
        ],
      ),
    );
  }
}
