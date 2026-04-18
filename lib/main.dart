import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'agenda.pages/agenda.view.dart'; 

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const SunflowerApp(),
    ),
  );
}

class SunflowerApp extends StatelessWidget {
  const SunflowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      title: 'Schedule Sunflower',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF9E4A0),
          brightness: Brightness.light,
        ),
        fontFamily: 'Georgia',
      ),
      
      home: const LoginView(), 
    );
  }
}