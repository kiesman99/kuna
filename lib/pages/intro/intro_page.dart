import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:kuna/pages/my_home_page.dart';
import 'package:kuna/provider/shared_pref_provider.dart';
import 'package:number_slide_animation/number_slide_animation.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  bool _showFAB = false;
  TextEditingController _textEditingController;
  final _formKey = new GlobalKey<FormState>();

  Future<void> _infoModal() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text("Info")
            ],
          ),
          content: SingleChildScrollView(
            child: Text("Hey!\n\n"
                "Danke, dass du Kuna verwendest um den Überblick bei Währungsrechnungen im Urlaub zu behalten!\n"
                "Damit du starten kannst musst du den Kurs angeben, zu dem du dein Geld gewächselt hast.\n\n"
                "Du kannst den Kurs jederzeit in den Einstellungen ändern."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Okay!"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );
  }

  Future<void> _helpDialog(){
    return showDialog(context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          title: Text("Hilfe"),
          content: SingleChildScrollView(
            child: Text("Der Wechselkurs zeigt dir, wieviel Geld in Fremdwährung du für eine Einheit deiner Währung bekommst.\n\n"
            "Wenn du beispielsweise für einen Euro (deine Währung) vier US-Dollar (Fremdwährung) bekommst, wäre dein Wechselkurs: 4.\n\n"
                "Bekommst du für einen Euro (deine Währung ) 0,5 US-Dollar (Fremdwährung), wäre dein Wechselkurs: 0,5"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Okay"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }

  @override
  void initState() {
    _textEditingController = new TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      Future.delayed(Duration(milliseconds: 100), () => _infoModal());
    });

    _textEditingController.addListener(() {
      setState(() {
       _showFAB = _textEditingController.text.isNotEmpty;
      });
    });
  }

  String _validateTextField(String value){
    if(value.isEmpty) {
      return "Bitte gebe einen Wechselkurs ein";
    }

    if(num.tryParse(value) == null){
      return "$value ist keine gültige Nummer";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Dein Wechselkurs:", style: Styles.introPageHeader),
              SizedBox(
                height: 50.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 35.0
                ),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.euro_symbol),
                            labelText: "Wechselkurs",
                            border: OutlineInputBorder()
                        ),
                        keyboardType: TextInputType.number,
                        controller: _textEditingController,
                        validator: _validateTextField
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextButton(
                          child: Text("Was ist der Wechselkurs?", style: TextStyle(color: Theme.of(context).primaryColor)),
                          onPressed: () => _helpDialog(),
                        )
                      ],
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedSwitcher(
        child: _showFAB ?
        FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () => _nextPage(),
        ) : null,
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation){
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      )
    );
  }

  void _nextPage(){
    if(_formKey.currentState.validate()){
      final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      settingsProvider.course = double.tryParse(_textEditingController.text);
      settingsProvider.courseSet = true;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }
}
