import 'dart:async';
import 'dart:developer';

//import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'constants.dart';
import 'window_buttons.dart';

class WindowTitleBar extends StatefulWidget {
  String title;

  WindowTitleBar({Key? key, required this.title}) : super(key: key);

  @override
  WindowTitleBarState createState() => WindowTitleBarState();
}

class WindowTitleBarState extends State<WindowTitleBar> with SingleTickerProviderStateMixin {
  //static final GlobalKey<WindowTitleBarState> globalKey = GlobalKey<WindowTitleBarState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget icon;
    try {
      icon = Padding(padding: const EdgeInsets.all(6), child: Image.asset('assets/app_icon.ico', width: 16, height: 16));
    } catch (_) {
      icon = const Icon(
        Icons.public,
        color: Constants.primaryColor,
      );
    }
    return ColoredBox(
      color: Constants.mainBackgroundColorDark,
      child: SizedBox(
        height: Constants.titleBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 48,
                width: 40,
                child: PopupMenuButton<String>(
                  tooltip: "Web commands",
                  elevation: 0,
                  shape: Border.all(),
                  color: Constants.mainBackgroundColorDark,
                  onSelected: (cmd) async {
                    if (cmd == "Refresh") {
                      AppState.controller?.reload();
                    } else if (cmd == "DevTools") {
                      AppState.controller?.openDevTools();
                    } else if (cmd == "HideAd") {
                      AppState.trimPage();
                      //AppState.controller?.executeScript();
                    }
                  },
                  child: icon,
                  itemBuilder: (context) {
                    var list = List<PopupMenuEntry<String>>.empty(growable: true);list.add(
                      const PopupMenuItem(
                        value: "HideAd",
                        child: Text(
                          "Hide banner",
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    );
                    if (kDebugMode) {
                      list.add(
                        const PopupMenuItem(
                          value: "DevTools",
                          child: Text(
                            "DevTools",
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      );
                    }
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
                )),
            Expanded(
              child: MoveWindow(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(.0),
                      child: Text(
                        widget.title,
                        style: const TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w400, fontSize: Constants.titleBarHeight / 2.6),
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
  }
}
