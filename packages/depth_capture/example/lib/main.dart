import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:depth_capture/depth_capture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _capabilitySummary = 'Unknown';
  final _depthCapturePlugin = DepthCapture();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String capabilitySummary;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final capabilities = await _depthCapturePlugin.getCaptureCapabilities();
      capabilitySummary = capabilities.bestAvailableSource.name;
    } on PlatformException {
      capabilitySummary = 'Failed to get capture capabilities.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _capabilitySummary = capabilitySummary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Best depth source: $_capabilitySummary\n')),
      ),
    );
  }
}
