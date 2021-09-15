import 'package:flutter/material.dart';
import 'package:text_form_validator/form_validator.dart';

/// A very simple example showing how to add a [FormValidator] to a [TextFormField]
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextFormField(
      validator: FormValidator.builder().required().build(),
    ));
  }
}
