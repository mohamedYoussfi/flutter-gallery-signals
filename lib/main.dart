import 'package:flutter/material.dart';
import 'package:signal_posts/ui/pages/gallery.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: GalleryPage(),
    );
  }
}
