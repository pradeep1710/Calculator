import 'package:flutter/material.dart';
import './ui_elements/input_widget.dart';
import './ui_elements/output_widget.dart';
// import './ui_elements/output_widget.dart';

class UI extends StatelessWidget {
  const UI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontSize: 28,
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
           Expanded(flex: 2,child: OutputWidget()),
            Expanded(flex: 3, child: InputWidget()),
          ],
        ),
      ),
    );
  }
}
