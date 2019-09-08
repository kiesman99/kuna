import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuna/pages/intro/intro_page.dart';
import 'package:kuna/pages/my_home_page.dart';
import 'package:kuna/provider/calculator_provider.dart';
import 'package:kuna/provider/page_provider.dart';
import 'package:kuna/provider/shared_pref_provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  SharedPrefProvider _sharedPrefProvider;
  PageProvider _pageProvider;
  CalculatorProvider _calculatorProvider;

  Future _openBoxes() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    return Future.wait([
      Hive.openBox("settings")
    ]);
  }

  /// This function will instantiate the needed Provider and emit them to
  /// the CalculatorProvider instance that will be created, so that the other
  /// Provider are reachable from inside of the CalculatorProvider
  void initProviders(BuildContext context) {
    _sharedPrefProvider = new SharedPrefProvider();
    _pageProvider = new PageProvider();
    _calculatorProvider = new CalculatorProvider(
        sharedPrefProvider: _sharedPrefProvider, pageProvider: _pageProvider);
  }

  @override
  Widget build(BuildContext context) {
    initProviders(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => _sharedPrefProvider),
        ChangeNotifierProvider(builder: (_) => _pageProvider),
        ChangeNotifierProvider(builder: (_) => _calculatorProvider)
      ],
      child: FutureBuilder(
        future: _openBoxes(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.error != null){
              return _Error(error: snapshot.error.toString());
            }

            return WatchBoxBuilder(
              box: Hive.box("settings"),
              builder: (context, box){
                return MaterialApp(
                  theme: ThemeData(
                    primaryColor: Color(box.get("primaryColor", defaultValue: Colors.blue.value))
                  ),
                  home: _Main(box: box),
                );
              },
            );
          }

          return _Loading();
        },
      ),
    );
  }
}

class _Main extends StatelessWidget {

  final Box box;

  _Main({this.box});

  @override
  Widget build(BuildContext context) {
    return box.get("wasOpenedBefore", defaultValue: false) ? MyHomePage() : IntroPage();
  }
}

class _Error extends StatelessWidget {

  final String error;

  _Error({this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Text("Etwas ist schiefgelaufen..."),
              SizedBox(height: 50.0),
              Text(error)
            ],
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}


