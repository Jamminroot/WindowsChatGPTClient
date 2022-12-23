import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'constants.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
            minWidth: Constants.titleBarHeight + 5,
            height: Constants.titleBarHeight + 24,
            mouseCursor: MouseCursor.defer,
            hoverColor: Colors.red.withOpacity(0.2),
            child: Icon(Icons.minimize, color: Constants.primaryColor.withOpacity(0.5)),
            onPressed: () {
              appWindow.hide();
              AppState.windowStateChanged.add(false);
            }),
      ],
    );
  }
}
