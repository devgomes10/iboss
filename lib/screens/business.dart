import 'package:flutter/material.dart';
import 'package:iboss/screens/company_reservation.dart';
import 'package:iboss/screens/expense.dart';
import 'package:iboss/screens/plan_accounts.dart';
import 'package:iboss/screens/revenue.dart';
import 'package:iboss/screens/wage.dart';
import 'package:iboss/screens/working_capital.dart';

class Business extends StatelessWidget {
  const Business({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Empresa'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
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
                    builder: (context) => const Revenue(),
                  ),
                );
              },
              child: const Text(
                'Receitas',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Expense(),
                  ),
                );
              },
              child: const Text(
                'Despesas',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlanAccounts(),
                  ),
                );
              },
              child: const Text(
                'Plano de Contas',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkingCapital(),
                  ),
                );
              },
              child: const Text(
                'Capital de Giro',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Wage(),
                  ),
                );
              },
              child: const Text(
                'Pró-labore',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyReservation(),
                  ),
                );
              },
              child: const Text(
                'Reserva para Emergências',
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
