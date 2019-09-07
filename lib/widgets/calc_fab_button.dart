import 'package:flutter/material.dart';
import 'package:kuna/data/calculator_rows.dart';
import 'package:kuna/provider/page_provider.dart';
import 'package:kuna/widgets/calculator_pad.dart';
import 'package:provider/provider.dart';

class CalcFabButton extends StatefulWidget {
  /// Size of the Fab Button that will be rendered
  static final Size fabSize = Size(60, 60);

  /// The AnimationController that will handle expanding and shrinkig the
  /// Fab Button
  final AnimationController animationController;

  CalcFabButton({this.animationController});

  @override
  _CalcFabButtonState createState() => _CalcFabButtonState();
}

class _CalcFabButtonState extends State<CalcFabButton>
    with TickerProviderStateMixin {
  AnimationController get controller => widget.animationController;

  static Animation<double> _fabPositionAnimation, _fabRadiusAnimation;
  static Animation<Size> _fabSizeAnimation;

  bool get _gridView => Provider.of<PageProvider>(context).gridView;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _fabSizeAnimation = SizeTween(
                begin: CalcFabButton.fabSize,
                end: Size(constraints.maxWidth, constraints.maxHeight / 2))
            .animate(widget.animationController);

        _fabRadiusAnimation =
            Tween(begin: 100.0, end: 0.0).animate(widget.animationController);

        _fabPositionAnimation = Tween(begin: 20.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceIn))
            .animate(widget.animationController);

        return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: widget.animationController,
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
                          onTap: _gridView
                              ? () {
                                  Provider.of<PageProvider>(context)
                                      .switchView();
                                }
                              : null,
                          child: Container(
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

  /// This function will return the content of
  /// the FAB button depending on which view is enabled and
  /// wether the FAB button is expanded or not
  Widget _getFabContent() {
    // Grid View is enabled
    if (_gridView) return Icon(Icons.filter_9_plus, color: Colors.white);

    // if gridview is not enabled and the fab button is fully expanded
    // return the actual calculator
    if (widget.animationController.isCompleted) return CalculatorPad();

    // otherwise return a empty Container
    return Container();
  }
}
