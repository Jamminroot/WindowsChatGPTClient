import 'dart:async';

//import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'constants.dart';
import 'window_buttons.dart';

class _TitlePainter extends CustomPainter {
  _TitlePainter({required this.color});

  final Color color;
  static const tileSide = Constants.titleBarHeight / 2;
  static const tileSize = Size(tileSide, tileSide);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintMain = Paint()..color = color;
    final Paint paintAccent025 = Paint()..color = Color.alphaBlend(Constants.sidebarColor.withOpacity(0.25), color.withOpacity(0.2));
    final Paint paintAccent05 = Paint()..color = Color.alphaBlend(Constants.sidebarColor.withOpacity(0.5), color.withOpacity(0.2));
    final Paint paintAccent075 = Paint()..color = Color.alphaBlend(Constants.sidebarColor.withOpacity(0.75), color.withOpacity(0.2));
    final baseTileOffset = (size.width - tileSide * 6 - 1).ceilToDouble();
    canvas.drawRect(const Offset(0, 0) & Size(size.width - tileSide * 5, tileSide * 2), paintMain);
    canvas.drawRect(Offset(baseTileOffset + tileSide, 0) & tileSize, paintAccent075);
    canvas.drawRect(Offset(baseTileOffset + tileSide * 2, 0) & tileSize, paintAccent05);
    canvas.drawRect(Offset(baseTileOffset + tileSide, tileSide) & tileSize, paintAccent05);
    canvas.drawRect(Offset(baseTileOffset, tileSide) & tileSize, paintAccent05);
    canvas.drawRect(Offset(baseTileOffset + tileSide, tileSide) & tileSize, paintAccent025);
    canvas.drawRect(Offset(baseTileOffset, tileSide) & tileSize, paintAccent025);
    canvas.drawRect(Offset(baseTileOffset + tileSide, 0) & tileSize, paintAccent025);
  }

  @override
  bool shouldRepaint(_TitlePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

class WindowTitleBar extends StatefulWidget {
  String title;

  WindowTitleBar({Key? key, required this.title}) : super(key: key);

  @override
  WindowTitleBarState createState() => WindowTitleBarState();
}

class WindowTitleBarState extends State<WindowTitleBar> with SingleTickerProviderStateMixin {
  //static final GlobalKey<WindowTitleBarState> globalKey = GlobalKey<WindowTitleBarState>();

  AnimationController? _animationController;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget icon;
    try {
      icon = Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset('assets/app_icon.ico', width: 16, height: 16));
    } catch (_){
      icon = const Icon(
        Icons.public,
        color: Constants.primaryColor,
      );
    }
    return SizedBox(
      height: Constants.titleBarHeight,
      child: CustomPaint(
        painter: _TitlePainter(color: Constants.mainBackgroundColorDark),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 48,
              width: 40,
              child:
              PopupMenuButton<String>(
                tooltip: "Web commands",
                elevation: 0,
                shape: Border.all(),
                color: Constants.sidebarColor,
                onSelected: (cmd) {
                    if (cmd == "Refresh") {
                      AppState.controller?.reload();
                    }
                },
                child: icon,
                itemBuilder: (context) {
                  var list = List<PopupMenuEntry<String>>.empty(growable: true);
                  list.add(
                    const PopupMenuItem(
                      value: "Refresh",
                      child: Text(
                        "Refresh",
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  );

                  return list;
                },
              )
            ),
            Expanded(
              child: MoveWindow(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(.0),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            color: Constants.primaryColor, fontWeight: FontWeight.w400, fontSize: Constants.titleBarHeight / 2.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const WindowButtons(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Constants.animationDuration,
    );

    _animationController?.reset();
    _animationController?.forward();
  }
}
