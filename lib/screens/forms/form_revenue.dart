import 'package:flutter/material.dart';
import 'package:iboss/controllers/revenue_controller.dart';

class FormRevenue extends StatefulWidget {
  const FormRevenue({super.key});

  @override
  State<FormRevenue> createState() => _FormRevenueState();
}

class _FormRevenueState extends State<FormRevenue> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            scrollable: true,
            title: Text('Din Din'),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: descriptionController,
                        decoration: InputDecoration(hintText: 'Descrição'),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: valueController,
                        decoration: InputDecoration(hintText: 'Valor'),
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
                    Text('Escolha a classificação'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              // print(descriptionController.text);
                              // print(double.parse(valueController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Criando uma nova receita'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text('À vista'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Fiado'),
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
      child: const Icon(Icons.add),
    );
  }
}
