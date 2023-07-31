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
      backgroundColor: Color(0xFF3c3c3c),
      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: Color(0xFF3c3c3c),
        title: const Text(
          'EMPRESA',
          // textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
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
            icon: FaIcon(FontAwesomeIcons.gear, color: Colors.white),
            ),
          ],),
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
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
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
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          Container(
            width: 350,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Text(
                  'Reserva financeira',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                ListTile(
                  title: Text(
                    real.format(companyReservation.saldo),
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: updateSaldo,
                    icon: FaIcon(FontAwesomeIcons.penToSquare, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 350,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Text(
                  'Pró-labore',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                ListTile(
                  title: Text(
                    real.format(companyReservation.saldo),
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: updateSaldo,
                    icon: FaIcon(FontAwesomeIcons.penToSquare, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
        ]),
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
            onPressed: () => Navigator.pop(context), child: Text('CANCELAR')),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                companyReservation
                    .setSaldo(double.parse(valueReservation.text));
                Navigator.pop(context);
              }
            },
            child: Text('SALVAR')),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
