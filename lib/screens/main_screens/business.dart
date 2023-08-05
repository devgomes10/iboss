import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/models/wage.dart';
import 'package:iboss/repositories/company_reservation_repository.dart';
import 'package:iboss/repositories/wage_repository.dart';
import 'package:iboss/screens/business_screens/categories.dart';
import 'package:iboss/screens/Register.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../business_screens/expense.dart';
import '../business_screens/revenue.dart';
import 'package:google_fonts/google_fonts.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  TextEditingController wageController = TextEditingController();
  TextEditingController reservationController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  @override
  Widget build(BuildContext context) {
    final companyReservation = context.watch<CompanyReservationRepository>();
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
                            'Receitas',
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
                      Text('Total', style: TextStyle(fontSize: 16),),
                      Text(
                        'RS 100,00',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Pagamentos à vista"),
                              Text("RS 50,00"),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Pagamentos a prazo"),
                              Text("RS 50,00"),
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
                height: 30,
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
                            'Gastos',
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
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red,),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Gastos fixos"),
                              Text("RS 50,00"),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Gastos variáveis"),
                              Text("RS 50,00"),
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
                height: 30,
              ),
              ListTile(
                title: Text('Pró-labore'),
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
              Divider(
                color: Colors.transparent,
                height: 30,
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

  updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valueReservation = TextEditingController();
    final companyReservation = context.read<CompanyReservationRepository>();

    valueReservation.text = companyReservation.saldo.toString();

    AlertDialog dialog = AlertDialog(
      title: Text('Qual sua reserva financeira atual?'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: valueReservation,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) return 'Informe o valor do saldo';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (form.currentState!.validate()) {
              companyReservation.setSaldo(double.parse(valueReservation.text));
              Navigator.pop(context);
            }
          },
          child: Text('Salvar'),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
