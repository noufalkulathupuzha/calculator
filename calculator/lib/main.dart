import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController(text: 'Fixed Value');
  var value1 = 0;
  var value2 = 0;
  @override
  Widget build(BuildContext context) {
    var data = 'Button Demo';
    var number1 = '1';
    var number2 = '2';
    var addition = '+';
    var equals = '=';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(data),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 80, // Adjust the height as needed
              child: TextField(
                style: const TextStyle(fontSize: 30),
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    controller = TextEditingController(text: number1);
                    value1 = int.parse(controller.text);
                  });
                },
                child: Text(number1),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    controller = TextEditingController(text: number2);
                    value2 = int.parse(controller.text);
                  });
                },
                child: Text(number2),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    controller = TextEditingController(text: addition);
                  });
                },
                child: Text(addition),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int sum = value1 + value2;
                    controller = TextEditingController(text: sum.toString());
                  });
                },
                child: Text(equals),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
