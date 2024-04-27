import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  var number1 = "";
  var operand = "";
  var number2 = "";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          //Output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  style: const TextStyle(
                      fontSize: 38, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          //Inputs
          Wrap(
            children: Btn.buttonValues
                .map((value) => SizedBox(
                    height: screenSize.width / 6,
                    width: value == Btn.n0
                        ? (screenSize.width / 2)
                        : (screenSize.width / 4),
                    child: buildButton(value)))
                .toList(),
          )
        ],
      ),
    ));
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
          color: getButtonColor(value),
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(100),
          ),
          child: InkWell(
              onTap: () => onButtonTap(value),
              child: Center(
                  child: Text(
                value,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              )))),
    );
  }

  void onButtonTap(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculateResult(); // Calculate result if both operands are set
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        number1 = "0.";
      } else {
        number1 += value;
      }
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        number2 = "0.";
      } else {
        number2 += value;
      }
    }
    if (value == Btn.clr) {
      clearAll();
    }
    if (value == Btn.calculate) {
      calculateResult(); // Calculate result when equals button is pressed
    }
    if (value == Btn.del) {
      delete(); // Call the delete function here
      return; // Add a return statement to avoid executing further logic for Btn.del
    }
    // if (value == Btn.per) {
    //   calculatePercentage();
    //   return;
    // }

    setState(() {});
  }

  /// Deletes the last character from either `number2` or `number1` if they are not empty.
  /// If `number2` is empty but `operand` is not empty, clears the `operand`.
  /// If both `number2` and `operand` are empty but `number1` is not empty, deletes the last character from `number1`.
  ///
  /// This function does not return anything.
  void delete() {
    if (number2.isNotEmpty) {
      // If there are characters in number2, delete the last character from it
      number2 = number2.substring(0, number2.length - 1);
    }
    if (operand.isNotEmpty) {
      // If number2 is empty but there is an operand, clear the operand
      operand = "";
    }
    if (number1.isNotEmpty) {
      // If both number2 and operand are empty but there are characters in number1,
      // delete the last character from number1
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void calculateResult() {
    if (number1.isEmpty || number2.isEmpty || operand.isEmpty) {
      return; // Early return to avoid NullPointerException
    }
    double result = 0;
    double num1;
    double num2;
    try {
      num1 = double.parse(number1);
      num2 = double.parse(number2);
    } on FormatException {
      return; // Early return to avoid FormatException
    }
    if (operand == Btn.per) {
      double num1 = double.parse(number1);
      double num2 = double.parse(number2);
      double percentage = (num1 * num2) / 100;
      number1 = percentage.toStringAsFixed(2);
    }
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.substract:
        result = num1 - num2;
        break;
      case Btn.multipy:
        result = num1 * num2;
        break;
      case Btn.divide:
        if (num2 == 0) {
          result = double.infinity; // Handle division by zero
        } else {
          result = num1 / num2;
        }
        break;
      default:
        return; //Unknown operator, early return
    }
    number1 = result.toString();
    operand = "";
    number2 = "";
  }

  Color getButtonColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blue.shade600
        : [
            Btn.per,
            Btn.add,
            Btn.substract,
            Btn.multipy,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black45;
  }
}
