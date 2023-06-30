import 'package:flutter/material.dart';

class Wage extends StatelessWidget {
  const Wage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pró-labore',
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
    );
  }
}
