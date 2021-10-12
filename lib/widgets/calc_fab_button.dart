import 'package:flutter/material.dart';
import 'package:kuna/provider/page_provider.dart';
import 'package:kuna/widgets/calculator_pad.dart';
import 'package:provider/provider.dart';

class CalcFabButton extends StatefulWidget {
  /// Size of the Fab Button that will be rendered
  static final Size fabSize = Size(60, 60);

  final Key fabKey;

  CalcFabButton({this.fabKey});

  @override
  _CalcFabButtonState createState() => _CalcFabButtonState();
}

class _CalcFabButtonState extends State<CalcFabButton>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  static Animation<double> _fabPositionAnimation, _fabRadiusAnimation;
  static Animation<Size> _fabSizeAnimation;

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pageProvider = Provider.of<PageProvider>(context, listen: false);
      pageProvider.gridView.addListener(() {
        if(pageProvider.gridView.value)
          _animationController.reverse(from: 1.0);
        else
          _animationController.forward(from: 0.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _fabSizeAnimation = SizeTween(
                begin: CalcFabButton.fabSize,
                end: Size(constraints.maxWidth, constraints.maxHeight / 2))
            .animate(_animationController);

        _fabRadiusAnimation =
            Tween(begin: 100.0, end: 0.0).animate(_animationController);

        _fabPositionAnimation = Tween(begin: 20.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceIn))
            .animate(_animationController);

        return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, child) {
                    return Positioned(
                      bottom: _fabPositionAnimation.value,
                      right: _fabPositionAnimation.value,
                      child: Material(
                        elevation: 5.0,
                        borderRadius:
                            BorderRadius.circular(_fabRadiusAnimation.value),
                        color: Theme.of(context).primaryColor,
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(_fabRadiusAnimation.value),
                          onTap: _fabTap,
                          child: Container(
                              key: widget.fabKey,
                              height: _fabSizeAnimation.value.height,
                              width: _fabSizeAnimation.value.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      _fabRadiusAnimation.value)),
                              child: _getFabContent()),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ));
      },
    );
  }

  void _fabTap(){
    var pageProvider = Provider.of<PageProvider>(context, listen: false);
    if(pageProvider.gridView.value){
      pageProvider.switchView();
    }
    return null;
  }

  /// This function will return the content of
  /// the FAB button depending on which view is enabled and
  /// wether the FAB button is expanded or not
  Widget _getFabContent() {
    // Grid View is enabled
    if (Provider.of<PageProvider>(context, listen: false).gridView.value) return Icon(Icons.filter_9_plus, color: Colors.white);

    // if gridview is not enabled and the fab button is fully expanded
    // return the actual calculator
    if (_animationController.isCompleted) return CalculatorPad();

    // otherwise return a empty Container
    return Container();
  }
}
