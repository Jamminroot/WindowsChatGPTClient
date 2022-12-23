import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:system_tray/src/menu_item.dart' as TrayMenuItem;

import 'package:webview_windows/webview_windows.dart';
import 'package:windows_chat_gpt_client/windows_title_bar.dart';

import 'app_state.dart';
import 'constants.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(700, 450);
    appWindow.title = 'Windows ChatGPT Client';
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.topLeft;
    //appWindow.position = const Offset(10.0, 10.0);
    appWindow.alignment = Alignment.center;
    appWindow.show();
    AppState.windowStateChanged.add(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.dark().copyWith(
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith((state) => Constants.primaryColor))),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Constants.mainBackgroundColorDark),
        ));
    return MaterialApp(theme: theme, debugShowCheckedModeBanner: false, navigatorKey: navigatorKey, home: ExampleBrowser());
  }
}

class ExampleBrowser extends StatefulWidget {
  const ExampleBrowser({super.key});

  @override
  State<ExampleBrowser> createState() => _ExampleBrowser();
}

class _ExampleBrowser extends State<ExampleBrowser> {
  final _controller = WebviewController();
  final _textController = TextEditingController();
  StreamSubscription? _appVisibilityChangedSubs;
  bool _isWebviewSuspended = false;

  final SystemTray _systemTray = SystemTray();

  Future<void> initSystemTray() async {
    var path = p.joinAll([p.dirname(Platform.resolvedExecutable), 'data/flutter_assets/assets', 'app_icon.ico']);
    try {
      await _systemTray.initSystemTray('Windows ChatGPT Client', iconPath: path, toolTip: 'Windows ChatGPT Client');
    } on PlatformException catch (_) {
      log('Expected exception caught while registering tray icon.');
    }
    _systemTray.registerSystemTrayEventHandler((s) {
      if (s == "leftMouseUp") {
        appWindow.show();
        appWindow.restore();
        AppState.windowStateChanged.add(true);
      }
    });

    await _systemTray.setContextMenu(
      [
        TrayMenuItem.MenuItem(
          label: 'Show',
          onClicked: () {
            appWindow.show();
            appWindow.restore();
            AppState.windowStateChanged.add(true);
          },
        ),
        MenuSeparator(),
        TrayMenuItem.MenuItem(
          label: 'Exit',
          onClicked: () {
            AppState.windowStateChanged.add(false);
            appWindow.close();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    AppState.controller = _controller;
    _appVisibilityChangedSubs ??= AppState.windowStateChangedStream.listen((visible) {
      if (visible) {
        if (_isWebviewSuspended) {
          _isWebviewSuspended = false;
          _controller.resume();
        }
      } else {
        if (!_isWebviewSuspended) {
          _isWebviewSuspended = true;
          _controller.suspend();
        }
      }
    });
    initPlatformState();
    initSystemTray();
  }

  @override
  void dispose() {
    _appVisibilityChangedSubs?.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    try {
      await _controller.initialize();
      _controller.url.listen((url) {
        _textController.text = url;
      });

      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl('https://chat.openai.com/chat');

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Code: ${e.code}'),
                Text('Message: ${e.message}'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      });
    }
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Stack(
        children: [
          Webview(
            _controller,
            permissionRequested: _onPermissionRequested,
          ),
          StreamBuilder<LoadingState>(
            stream: _controller.loadingState,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == LoadingState.loading) {
                return const LinearProgressIndicator();
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WindowBorder(
        color: Constants.mainBackgroundColorDark,
        width: 8,
        child: Column(
          children: [
            WindowTitleBar(title: Constants.appName),
            Expanded(child: compositeView())
          ],
        ),
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
