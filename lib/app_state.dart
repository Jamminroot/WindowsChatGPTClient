import 'dart:async';
import 'dart:developer';

import 'package:webview_windows/webview_windows.dart';


abstract class AppState {
  static final windowStateChanged = StreamController.broadcast(sync: true);
  static final windowStateChangedStream = windowStateChanged.stream;
  static late WebviewController? controller;
  static String trimScript = """
    document.querySelector('.text-center.text-xs').remove()
  """;
  static void trimPage() async {
    controller?.executeScript(trimScript);

  }
}