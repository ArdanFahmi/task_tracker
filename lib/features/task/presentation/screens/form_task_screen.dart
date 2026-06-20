import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormTaskScreen extends ConsumerStatefulWidget {
  const FormTaskScreen({super.key});

  @override
  ConsumerState<FormTaskScreen> createState() => _FormTaskScreenState();
}

class _FormTaskScreenState extends ConsumerState<FormTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Form Task Screen")));
  }
}
