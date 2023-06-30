import 'package:flutter/material.dart';

class WorkingCapital extends StatelessWidget {
  const WorkingCapital ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Capital de Giro',
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.info,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
