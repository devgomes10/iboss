import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final currentMonth = DateFormat.MMM().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController (
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Receitas - $currentMonth'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Informação sobre a receita'),
                      content: Text('Texto passando as informações'),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.info,
                color: Colors.black,
              ),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Empresa',
              ),
              Tab(
                text: 'Pessoal',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
