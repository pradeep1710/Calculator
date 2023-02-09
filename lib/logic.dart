import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:developer';

class Calculation extends ChangeNotifier {
  String input = '';
  String output = '';

  /// fetch data from sharedPreferences
  Future<void> fetchData() async {
    final sp = await SharedPreferences.getInstance();
    input = sp.getString('input') ?? '';
    output = sp.getString('output') ?? '';
  }

  /// save data to sharedPreferences
  Future<void> saveData(input, output) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('input', input);
    sp.setString('output', output);
  }

  /// Input Logic to provide valid expression
  void calculate(String buttonName) {
    // remove coma from existing input
    input = input.replaceAll(',', '');

    if (buttonName == 'C') {
      input = '';
      output = '';
    } else if (buttonName == '⌫') {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (buttonName == '=') {
      if (output.isNotEmpty) {
        input = output;
        output = '';
      }
    } else if (buttonName == '.') {
      if (input.isEmpty ||
          input.lastIndexOf('.') <=
              input.lastIndexOf(RegExp(r'(\+|\-|x|÷|%)'))) {
        if (RegExp(r'[0-9]$').hasMatch(input)) {
          input += '.';
        } else {
          input += '0.';
        }
      }
    } else if (buttonName == '-') {
      if (input.endsWith('+')) {
        input = input.substring(0, input.length - 1);
        input += '-';
      } else if (input.endsWith('.')) {
        input += '0-';
      } else if (RegExp(r'[x÷%]\-$').hasMatch(input)) {
        input = input.substring(0, input.length - 2);
        input += '-';
      } else if (!input.endsWith('-')) {
        input += '-';
      }
    } else if (buttonName == '%') {
      if (input.isNotEmpty) {
        if (RegExp(r'[0-9]$').hasMatch(input)) {
          input += buttonName;
        } else if (input.endsWith('.')) {
          input += '0$buttonName';
        } else if (RegExp(r'%[x÷%][x÷+\-]$').hasMatch(input)) {
          input = input.substring(0, input.length - 3);
          input += buttonName;
        } else if (RegExp(r'[x÷%][x÷+\-]$').hasMatch(input)) {
          input = input.substring(0, input.length - 2);
          input += buttonName;
        } else if (RegExp(r'[+x÷\-]$').hasMatch(input) && input != '-') {
          input = input.substring(0, input.length - 1);
          input += buttonName;
        }
      }
    } else if (RegExp(r'[0-9]').hasMatch(buttonName)) {
      if (!input.endsWith('0') || buttonName != '0') {
        input += buttonName;
      } else if (double.parse(RegExp(r'(\d+(\.\d*)?)$').stringMatch(input)!) >
          0) {
        input += '0';
      }
    } else {
      if (input.isNotEmpty) {
        if (RegExp(r'[0-9%]$').hasMatch(input)) {
          input += buttonName;
        } else if (input.endsWith('.')) {
          input += '0$buttonName';
        } else if (RegExp(r'[x÷%].$').hasMatch(input) &&
            RegExp(r'[+\-÷x]$').stringMatch(input) == buttonName) {
          input = input.substring(0, input.length - 2);
          input += buttonName;
        } else if (RegExp(r'%[+x÷]\-$').hasMatch(input)) {
          input = input.substring(0, input.length - 2);
          input += buttonName;
        } else if (RegExp(r'%[+\-÷x]$').hasMatch(input)) {
          input = input.substring(0, input.length - 1);
          input += buttonName;
        } else if (RegExp(r'[+x÷]\-$').hasMatch(input)) {
          input = input.substring(0, input.length - 2);
          input += buttonName;
        } else if (RegExp(r'[+x÷%]$').hasMatch(input)) {
          input = input.substring(0, input.length - 1);
          input += buttonName;
        } else {
          input = input.substring(0, input.length - 1);
          input += buttonName;
        }
      }
    }

    // Calculation Output Preview
    try {
      final userInput = (input.startsWith('-')) ? input.substring(1) : input;

      if (input.isNotEmpty) {
        if (RegExp(r'[0-9%]$').hasMatch(userInput) &&
            RegExp(r'[+x÷%\-]').hasMatch(userInput)) {
          runCalculation(input);
        } else if (RegExp(r'%[x÷]\-$').hasMatch(userInput) &&
            RegExp(r'[+x÷%\-]')
                .hasMatch(userInput.substring(0, userInput.length - 3))) {
          runCalculation(input.substring(0, input.length - 3));
        } else if (RegExp(r'%[x÷+\-]$').hasMatch(userInput) &&
            RegExp(r'[+x÷%\-]')
                .hasMatch(userInput.substring(0, userInput.length - 1))) {
          runCalculation(input.substring(0, input.length - 1));
        } else if (RegExp(r'[x÷]\-$').hasMatch(userInput) &&
            RegExp(r'[+x÷%\-]')
                .hasMatch(userInput.substring(0, userInput.length - 2))) {
          runCalculation(input.substring(0, input.length - 2));
        } else if (RegExp(r'[0-9][x÷%+\-.]$').hasMatch(userInput) &&
            RegExp(r'[+x÷%\-]')
                .hasMatch(userInput.substring(0, userInput.length - 1))) {
          runCalculation(input.substring(0, input.length - 1));
        } else {
          output = '';
        }
      }
    } catch (e) {
      output = 'Expression error';
      log(e.toString());
    }

    // add coma for better representation
    input = input.replaceAllMapped(RegExp(r'(\d(\.\d+)?){4,}'), (match) {
      String m = match.group(0)!;
      return NumberFormat.decimalPatternDigits(
        locale: 'en_IN',
        decimalDigits: (m.contains('.')) ? m.split('.')[1].length : 0,
      ).format(double.parse(m));
    });

    // save the state in sharedPrefernces
    saveData(input, output);

    notifyListeners();
  }

  /// Caclculation Logic using math_expressions
  void runCalculation(String finalInput) {
    // resolve % with num/100
    finalInput =
        finalInput.replaceAllMapped(RegExp(r'(\d+(\.\d+)?)%'), (match) {
      final m = double.parse(match.group(1)!);
      return (match.end < finalInput.length &&
              RegExp(r'[0-9]').hasMatch(finalInput[match.end]))
          ? '${m / 100}x'
          : '${m / 100}';
    });
    // convert human readable symbols to machine readables
    finalInput = finalInput.replaceAll('x', '*');
    finalInput = finalInput.replaceAll('÷', '/');

    // evaluate
    final expression = Parser().parse(finalInput);
    double answer = expression.evaluate(EvaluationType.REAL, ContextModel());

    // parse to double
    answer = double.parse(answer.toStringAsFixed(10));

    // show only int if possible else double value
    if (answer.toString().endsWith('.0')) {
      output = answer.toStringAsFixed(0);
    } else {
      output = answer.toString();
    }

    // add coma to output
    output = NumberFormat.decimalPatternDigits(
      locale: 'en_IN',
      decimalDigits: (output.contains('.')) ? output.split('.')[1].length : 0,
    ).format(double.parse(output));
  }
}
