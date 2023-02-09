import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './logic.dart';
import './ui.dart';

void main() {
  return runApp(
    ChangeNotifierProvider(
      create: (context) => Calculation(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 236, 236, 236),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark),
      ),
      home: const UI(),
    );
  }
}
