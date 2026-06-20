import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  static const String routeName = 'menu';
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Menu")));
  }
}
