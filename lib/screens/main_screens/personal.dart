import 'package:flutter/material.dart';
import 'package:iboss/models/personal_reservation.dart';
import 'package:iboss/repositories/personal_reservation_repository.dart';
import 'package:iboss/screens/personal_screens/entry.dart';
import 'package:provider/provider.dart';
import '../personal_screens/outflow.dart';

class Personal extends StatelessWidget {
  const Personal({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController reservationController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Pessoais'),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Entry(),
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
                'Entradas',
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
                    builder: (context) => const Outflow(),
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
                'Saídas',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              width: 350,
              height: 100,
              decoration: BoxDecoration(border: Border.all(width: 3)),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text('Reserva de dinheiro'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<PersonalReservationRepository>(builder:
                          (BuildContext context,
                              PersonalReservationRepository personal,
                              Widget? widget) {
                        return Text(reservationController.text);
                      }),
                      Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.info)),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      scrollable: true,
                                      title: const Text('atualize pro'),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Form(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      reservationController,
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          'Reserva de Emergência'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                          actions: [
                                            Center(
                                              child: Column(
                                                children: [
                                                  // const Text('Escolha a classificação'),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        Consumer<PersonalReservationRepository>(
                                                          builder:
                                                              (BuildContext context,
                                                              PersonalReservationRepository personal,
                                                              Widget? widget) {
                                                            return TextButton(
                                                              onPressed: () async {
                                                                personal.add(
                                                                  PersonalReservation(
                                                                      value: double.parse(
                                                                          reservationController
                                                                              .text)),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                    context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Criando uma nova reserva de emegência'),
                                                                  ),
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Atualizar'),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
