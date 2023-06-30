import 'package:flutter/material.dart';

class CompanyReservation extends StatelessWidget {
  const CompanyReservation ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reserva de Emergência',
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
