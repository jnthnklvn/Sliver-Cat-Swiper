import 'package:flutter/material.dart';
import 'package:silver_app_bar/src/cats/cats_module.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider Cat Swiper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: CatsModule(),
    );
  }
}
