import 'dart:async';

import 'package:webview_windows/webview_windows.dart';


abstract class AppState {
  static final windowStateChanged = StreamController.broadcast(sync: true);
  static final windowStateChangedStream = windowStateChanged.stream;
  static WebviewController? controller;
}