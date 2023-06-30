import 'package:flutter/material.dart';

class Expense extends StatelessWidget {
  const Expense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Despesas',
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Center(),
    );
  }
}
