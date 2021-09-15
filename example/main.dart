import 'package:flutter/material.dart';
import 'package:text_form_validator/form_validator.dart';

/// A very simple example showing how to add a [FormValidator] to a [TextFormField]
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: TextFormField(
        validator: FormValidator.builder().required().build(),
      ),
    ));
  }
}
