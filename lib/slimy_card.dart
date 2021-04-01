library slimy_card;

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:async';

/// Global variable to access the status of the card.
StatusBloc slimyCard = StatusBloc();

/// SlimyCard provides a beautiful slime-like animation of a Card that
/// separates into two different Cards, one at the top and the other at bottom.
/// It is possible to put any custom widget in these two separate cards,
/// `topCardWidget` & `bottomCardWidget`.
///
/// Attributes like width of SlimyCard(`width`),
/// height of Top Card(`topCardHeight`)
/// & height of Bottom Card(`bottomCardHeight`) along with its
/// Border Radius(`borderRadius`) and color(`color`) can be adjusted
/// as per requirement.
///
/// If required, slime-like animation can also be removed by setting
/// the value of expression `slimeEnabled` to false.
///
/// SlimyCard supports the Streams(BLoC) for providing its real-time status.
/// For that, wrap SlimyCard in a StreamBuilder, and in its `stream` property,
/// assign `slimyCard.stream`. Its snapshot will contain the status.

class SlimyCard extends StatefulWidget {
  final Color color;
  final double width;
  final double topCardHeight;
  final double bottomCardHeight;
  final double borderRadius;
  final Widget? topCardWidget;
  final Widget? bottomCardWidget;
  final bool slimeEnabled;

  SlimyCard({
    this.color = const Color(0xff5858FF),
    this.width = 300,
    this.topCardHeight = 300,
    this.bottomCardHeight = 150,
    this.borderRadius = 25,
    this.topCardWidget,
    this.bottomCardWidget,
    this.slimeEnabled = true,
  })  : assert(topCardHeight >= 150, 'Height of Top Card must be atleast 150.'),
        assert(bottomCardHeight >= 100,
            'Height of Bottom Card must be atleast 100.'),
        assert(width >= 100, 'Width must be atleast 100.'),
        assert(borderRadius <= 30 && borderRadius >= 0,
            'Border Radius must neither exceed 30 nor be negative');

  @override
  _SlimyCardState createState() => _SlimyCardState();
}

class _SlimyCardState extends State<SlimyCard> with TickerProviderStateMixin {
  static const double initialBottomDimension = 100;
  late bool isSeperated;
  late double bottomDimension;
  late double finalBottomDimension;
  late double gap;
  late double gapInitial;
  late double gapFinal;
  late double x;
  late double y;

  late String activeAnimation;
  late Widget topCardWidget;
  late Widget bottomCardWidget;

  late Animation<double> arrowAnimation;
  late AnimationController arrowAnimController;

  /// `action` is the main function that triggers the process of separation of
  /// the cards and vice-versa.
  ///
  /// It also updates the status of the SlimyCard.

  void action() {
    if (isSeperated) {
      isSeperated = false;
      slimyCard.updateStatus(false);
      arrowAnimController.reverse();
      gap = gapInitial;
      bottomDimension = initialBottomDimension;
    } else {
      isSeperated = true;
      slimyCard.updateStatus(true);
      arrowAnimController.forward();
      gap = gapFinal;
      bottomDimension = finalBottomDimension;
    }

    activeAnimation = (activeAnimation == 'Idle') ? 'Action' : 'Idle';
  }

  @override
  void initState() {
    super.initState();

    isSeperated = false;
    activeAnimation = 'Idle';
    finalBottomDimension = widget.bottomCardHeight;
    bottomDimension = initialBottomDimension;

    topCardWidget =
        widget.topCardWidget ?? simpleTextWidget('This is Top Card Widget.');

    bottomCardWidget = widget.bottomCardWidget ??
        simpleTextWidget('This is Bottom Card Widget.');

    arrowAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    arrowAnimation =
        Tween<double>(begin: 0, end: 0.5).animate(arrowAnimController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    x = (widget.borderRadius < 10) ? 10 : widget.borderRadius;
    y = (widget.borderRadius < 2) ? 2 : widget.borderRadius;

    gapInitial = ((widget.topCardHeight - x - widget.width / 4) > 0)
        ? (widget.topCardHeight - x - widget.width / 4)
        : 0;

    gapFinal = ((widget.topCardHeight + x - widget.width / 4 + 50) > 0)
        ? (widget.topCardHeight + x - widget.width / 4 + 50)
        : 2 * x + 50;

    gap = gapInitial;
  }

  /// It supports multiple states and updates app according to them.

  @override
  void didUpdateWidget(SlimyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.topCardWidget != null) {
        topCardWidget = widget.topCardWidget!;
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          action();
        });
      },
      child: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 1800),
                  height: gap,
                  curve: Curves.elasticOut,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: bottomDimension,
                      width: widget.width,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
                        opacity: (isSeperated) ? 1.0 : 0,
                        child: bottomCardWidget,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: FlareActor(
                            'packages/slimy_card/assets/flare/bottomSlime.flr',
                            color: widget.color
                                .withOpacity((widget.slimeEnabled) ? 1 : 0),
                            animation: activeAnimation,
                            sizeFromArtboard: true,
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.contain,
                          ),
                          height: widget.width / 4,
                          width: widget.width,
                        ),
                        SizedBox(
                          height: bottomDimension - (x),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  height: widget.topCardHeight,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: topCardWidget,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: ((widget.topCardHeight - y) > 0)
                          ? (widget.topCardHeight - y)
                          : 0,
                    ),
                    Container(
                      height: widget.width / 4,
                      width: widget.width,
                      child: FlareActor(
                        'packages/slimy_card/assets/flare/topSlime.flr',
                        color: widget.color
                            .withOpacity((widget.slimeEnabled) ? 1 : 0),
                        animation: activeAnimation,
                        sizeFromArtboard: true,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: ((widget.topCardHeight - 2 * 50 / 3) > 0)
                      ? (widget.topCardHeight - 2 * 50 / 3)
                      : 0,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: RotationTransition(
                    turns: arrowAnimation,
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// `simpleTextWidget` is a place-holder Widget that can be replaced with
/// `topCardWidget` & `bottomCardWidget`.

Widget simpleTextWidget(String text) {
  return Center(
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

/// This is stream(according to BLoC) which enables to update real-time status
/// of SlimyCard

class StatusBloc {
  var statusController = StreamController<bool>.broadcast();
  Function(bool) get updateStatus => statusController.sink.add;
  Stream<bool> get stream => statusController.stream;

  dispose() {
    statusController.close();
  }
}
