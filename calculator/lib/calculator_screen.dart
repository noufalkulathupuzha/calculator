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

  /**
     * Builds a button widget with the given value.
     *
     * The button widget is wrapped in padding and has a circular shape.
     * The button's color is determined by the `getButtonColor` function.
     * The button's text is the value passed as a parameter.
     *
     * @param value The value to be displayed on the button.
     * @return The built button widget.
     */ ///
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

  // Handles button tap actions based on the input value.
  // Executes different actions depending on the value.
  // Calls other functions like calculateResult, clearAll, and delete.
  void onButtonTap(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      // Handle operators
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculateResult(); // Calculate result if both operands are set
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      // Handle number1 input
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      number1 = (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0))
          ? "0."
          : "$number1$value";
    } else if (number2.isEmpty || operand.isNotEmpty) {
      // Handle number2 input
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      number2 = (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0))
          ? "0."
          : "$number2$value";
    }
    // Handle special buttons
    if (value == Btn.clr) clearAll();
    if (value == Btn.calculate) {
      calculateResult(); // Calculate result when equals button is pressed
    }
    if (value == Btn.del) {
      delete(); // Call the delete function here
      return; // Add a return statement to avoid executing further logic for Btn.del
    }
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

  /// Clears all the input fields: number1, operand, and number2.
  /// This function triggers a state update to reflect the cleared values.
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  /// Calculates the result of a mathematical operation based on the current state of the calculator.
  ///
  /// This function takes the values of `number1`, `number2`, and `operand` and performs the corresponding mathematical operation.
  /// The result is then stored in `number1` and the values of `operand` and `number2` are reset to empty strings.
  ///
  /// Returns `void`.
  void calculateResult() {
    if (number1.isEmpty || number2.isEmpty || operand.isEmpty) return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    switch (operand) {
      case Btn.add:
        number1 = '${num1 + num2}';
        break;
      case Btn.subtract:
        number1 = '${num1 - num2}';
        break;
      case Btn.multiply:
        number1 = '${num1 * num2}';
        break;
      case Btn.divide:
        if (num2 == 0) {
          number1 = 'Infinity';
        } else {
          number1 = '${num1 / num2}';
        }
        break;
      case Btn.per:
        number1 = '${num1 * (num2 / 100)}';
        break;
      default:
        return; // Unknown operator, early return
    }

    operand = "";
    number2 = "";

    // Update the UI after calculation
    setState(() {});
  }

  /// Returns the color for a given button value.
  ///
  /// The color is determined based on the value of the button. If the value is
  /// [Btn.del] or [Btn.clr], the color is set to [Colors.blue.shade600]. If the
  /// value is any of [Btn.per], [Btn.add], [Btn.substract], [Btn.multipy],
  /// [Btn.divide], or [Btn.calculate], the color is set to [Colors.orange].
  /// Otherwise, the color is set to [Colors.black45].
  ///
  /// Parameters:
  ///   - value: The value of the button.
  ///
  /// Returns:
  ///   A [Color] representing the color for the button.
  Color getButtonColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blue.shade600
        : [
            Btn.per,
            Btn.add,
            Btn.subtract,
            Btn.multiply,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black45;
  }
}
