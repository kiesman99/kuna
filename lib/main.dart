import 'package:flutter/material.dart';
import 'package:kuna/pages/intro/intro_page.dart';
import 'package:kuna/pages/my_home_page.dart';
import 'package:kuna/provider/calculator_provider.dart';
import 'package:kuna/provider/page_provider.dart';
import 'package:kuna/provider/shared_pref_provider.dart';

import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  SharedPrefProvider _sharedPrefProvider;
  PageProvider _pageProvider;
  CalculatorProvider _calculatorProvider;

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
      child: MaterialApp(
        home: IntroPage(),
      ),
    );
  }
}
