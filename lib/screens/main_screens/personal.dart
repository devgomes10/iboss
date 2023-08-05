import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/models/personal_reservation.dart';
import 'package:iboss/repositories/personal_reservation_repository.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:iboss/screens/personal_screens/entry.dart';
import 'package:provider/provider.dart';
import '../personal_screens/outflow.dart';

class Personal extends StatelessWidget {
  const Personal({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController reservationController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Empresa'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
            icon: FaIcon(
              FontAwesomeIcons.gear,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Theme.of(context).primaryColor,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Entradas',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.arrowTrendUp,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'RS 100,00',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Entradas fixas"),
                              Text("RS 50,00", style: TextStyle(color: Colors.green),),
                            ],
                          ),
                          Column(
                            children: [
                              Text("entradas variáveis"),
                              Text("RS 50,00", style: TextStyle(color: Colors.green),),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 50,
              ),
              Card(
                color: Theme.of(context).primaryColor,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saídas',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.arrowTrendDown,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text('Total', style: TextStyle(fontSize: 16)),
                      Text(
                        'RS 100,00',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Saídas fixos"),
                              Text("RS 50,00", style: TextStyle(color: Colors.red),),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Saídas variáveis"),
                              Text("RS 50,00", style: TextStyle(color: Colors.red),),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 50,
              ),
              ListTile(
                title: Text('Reserva de emergência'),
                subtitle: Text(
                  'RS 100,00',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.penToSquare),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
