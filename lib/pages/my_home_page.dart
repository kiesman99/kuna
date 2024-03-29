import 'package:flutter/material.dart';
import 'package:kuna/provider/page_provider.dart';
import 'package:kuna/widgets/calc_fab_button.dart';
import 'package:provider/provider.dart';

import 'calculator_page.dart';
import 'money_page_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  GlobalKey _settingskey = new GlobalKey();
  GlobalKey _fabKey = new GlobalKey();

  /// This is the controller which handles starting the different animations
  /// if the fab button was pressed
  static AnimationController _fabAnimationController;

  /// This [pageController] will hold all information about the gridView and how far it was
  /// scrolled.
  /// It is used to go back to the start position once the user clicked on the name of the app
  /// in the Appbar
  static PageController pageController;

  /// This is the Animation which describes the fading of the [MoneyPageView]
  static final Animation<double> _gridViewOpacity =
      new Tween(begin: 1.0, end: 0.0).animate(_fabAnimationController);

  /// This is the Animation which describes the fading of the [CalculatorPage]
  static final Animation<double> _calcViewOpacity =
      new Tween(begin: 0.0, end: 1.0).animate(_fabAnimationController);

  @override
  void initState() {
    _fabAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    pageController = new PageController();

    super.initState();
  }

  Future<bool> _willPopCallback() async{
    if(Provider.of<PageProvider>(context).gridView.value)
      return true;

    Provider.of<PageProvider>(context).switchView();
    return false;

  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              // gridController.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
              pageController.animateTo(0.0,
                  duration: Duration(milliseconds: 200), curve: Curves.easeOut);
            },
            child: Text("Kuna"),
          ),
          actions: <Widget>[
            IconButton(
              key: _settingskey,
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _fabAnimationController,
              builder: (context, child) {
                return Stack(
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: ValueListenableBuilder(
                        valueListenable: Provider.of<PageProvider>(context).gridView,
                        builder: (context, gridview, child){
                          if(gridview)
                            return MoneyPageView(
                              pageController: pageController,
                              settingsKey: _settingskey,
                              fabKey: _fabKey,
                            );

                          return CalculatorPage();
                        },
                      ),
                    ),
                    CalcFabButton(fabKey: _fabKey)
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
