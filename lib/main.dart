import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app/screens/home.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    windowManager.setTitle('Notes');
    WindowManager.instance.setMinimumSize(const Size(1280, 960));
    WindowManager.instance.setMinimumSize(const Size(640, 480));
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
