import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CButton(text: 'C', size: 30),
            CButton(text: '%', size: 32),
            CButton(text: '⌫', size: 30),
            CButton(text: '÷', size: 40),
          ],
        ),
        // const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CButton(text: '7'),
            CButton(text: '8'),
            CButton(text: '9'),
            CButton(text: 'x', size: 32),
          ],
        ),
        // const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CButton(text: '4'),
            CButton(text: '5'),
            CButton(text: '6'),
            CButton(text: '-', size: 40),
          ],
        ),
        // const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CButton(text: '1'),
            CButton(text: '2'),
            CButton(text: '3'),
            CButton(text: '+', size: 40),
          ],
        ),
        // const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CButton(text: '00'),
            CButton(text: '0'),
            CButton(text: '.'),
            CButton(text: '=', size: 40),
          ],
        ),
        // const SizedBox(height: 20),
      ],
    ));
  }
}

class CButton extends StatelessWidget {
  final String text;
  final double? size;

  const CButton({super.key, required this.text, this.size});

  @override
  Widget build(BuildContext context) {
    getTextColor() {
      if (RegExp(r'[0-9.]').hasMatch(text)) {
        return Theme.of(context).textTheme.bodyMedium!.color;
      } else if (text == '=') {
        return Colors.white;
      } else {
        return const Color.fromARGB(255, 151, 138, 255);
      }
    }

    getBgColor() {
      if (RegExp(r'[C%⌫÷x\-+]').hasMatch(text)) {
        return Theme.of(context).cardColor;
      } else if (text == '=') {
        return const Color.fromARGB(255, 151, 138, 255);
      } else {
        return Theme.of(context).cardColor.withAlpha(120);
      }
    }

    final provider = Provider.of<Calculation>(context, listen: false);

    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      onTap: () => provider.calculate(text),
      child: Ink(
        width: 68,
        height: 68,
        decoration: BoxDecoration(shape: BoxShape.circle, color: getBgColor()),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: size ?? 25,
              color: getTextColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
