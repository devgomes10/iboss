import 'package:flutter/material.dart';
import 'package:iboss/models/wage.dart';
import 'package:iboss/repositories/wage_repository.dart';
import 'package:iboss/screens/business_screens/categories.dart';
import 'package:provider/provider.dart';
import '../business_screens/expense.dart';
import '../business_screens/revenue.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  TextEditingController wageController = TextEditingController();

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
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Revenue(),
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
          Container(
            width: 350,
            height: 100,
            decoration: BoxDecoration(border: Border.all(width: 3)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Text('Pró-labore'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<WageRepository> (builder: (BuildContext context, WageRepository wage, Widget? widget) {
                      return Text(wageController.text);
                    }),
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.info)),
                          IconButton(onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                scrollable: true,
                                title: const Text('Adicione um pró-labore'),
                                content: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: wageController,
                                            decoration:
                                            const InputDecoration(hintText: 'pró-labore'),
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Consumer<WageRepository>(
                                                builder: (BuildContext context,
                                                    WageRepository wage,
                                                    Widget? widget) {
                                                  return TextButton(
                                                    onPressed: () async {
                                                      wage.add(Wage(value: double.parse(wageController.text)),);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Criando um novo pró-labore'),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Atualizar'),
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
                          }, icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
                    Text('2.000'),
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.info)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
