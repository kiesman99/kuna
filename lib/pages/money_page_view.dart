import 'package:flutter/material.dart';
import 'package:kuna/provider/shared_pref_provider.dart';
import 'package:provider/provider.dart';

class MoneyPageView extends StatefulWidget {
  PageController pageController;

  MoneyPageView({@required this.pageController});

  @override
  _MoneyPageViewState createState() => _MoneyPageViewState();
}

class _MoneyPageViewState extends State<MoneyPageView> {
  int itemsToShow = 2000;

  double get course => Provider.of<SharedPrefProvider>(context).course;

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

  Widget buildPage(int pagePosition, BoxConstraints constraints) {
    Size tileSize = Size(constraints.maxWidth / 5, constraints.maxHeight / 10);

    List<Widget> columns(int rowPosition) {
      return List.generate(10, (columnPosition) {
        int top = (columnPosition + 10 * rowPosition + (50 * pagePosition));
        double bottom = top / course;

        return _Tile(
          top: top.toString(),
          bottom: bottom.toStringAsFixed(2),
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
      this.color = Colors.white});

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
