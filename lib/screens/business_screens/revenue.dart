import 'package:flutter/material.dart';
import 'package:iboss/data/revenue_inherited.dart';
import '../forms/form_revenue.dart';

class Revenue extends StatefulWidget {
  const Revenue({super.key,});


  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Receitas',
          ),
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
                text: 'Pagamento à Vista',
              ),
              Tab(
                text: 'Pagamento a Prazo',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        floatingActionButton: FormRevenue(),
        body: TabBarView(
          children: [
            ListView(
              children: RevenueInhereted.of(context).nowList,
            ),
            ListView(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
