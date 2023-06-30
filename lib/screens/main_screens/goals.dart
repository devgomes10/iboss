import 'package:flutter/material.dart';

class Goals extends StatelessWidget {
  const Goals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Metas'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Metas Profissionais',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                alignment: Alignment.center,
                minimumSize: MaterialStateProperty.all(
                  const Size(350, 80),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Metas Pessoais',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                alignment: Alignment.center,
                minimumSize: MaterialStateProperty.all(
                  const Size(350, 80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
