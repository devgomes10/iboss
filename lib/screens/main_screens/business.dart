import 'package:flutter/material.dart';
import 'package:iboss/screens/business_screens/categories.dart';
import '../business_screens/expense.dart';
import '../business_screens/revenue.dart';
import '../business_screens/wage.dart';


class Business extends StatelessWidget {
  const Business({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Empresa'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Revenue(),
                  ),
                );
              },
              style: ButtonStyle(
                alignment: Alignment.center,
                minimumSize: MaterialStateProperty.all(
                  const Size(350, 80),
                ),
              ),
              child: const Text(
                'Receitas',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Expense(),
                  ),
                );
              },
              style: ButtonStyle(
                alignment: Alignment.center,
                minimumSize: MaterialStateProperty.all(
                  const Size(350, 80),
                ),
              ),
              child: const Text(
                'Gastos',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Wage(),
                  ),
                );
              },
              style: ButtonStyle(
                alignment: Alignment.center,
                minimumSize: MaterialStateProperty.all(
                  const Size(350, 80),
                ),
              ),
              child: const Text(
                'Pró-labore',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const Categories(),
            //       ),
            //     );
            //   },
            //   style: ButtonStyle(
            //     alignment: Alignment.center,
            //     minimumSize: MaterialStateProperty.all(
            //       const Size(350, 80),
            //     ),
            //   ),
            //   child: const Text(
            //     'Categorias de Gastos',
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 20,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
