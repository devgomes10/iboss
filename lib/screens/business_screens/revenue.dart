import 'package:flutter/material.dart';
import 'package:iboss/screens/forms/form_revenue.dart';
import '../../repositories/card_revenue_now_repository.dart';

class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  @override
  Widget build(BuildContext context) {
    final table = CardNowRepository.table;

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FormRevenue(),),);
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
            children: [
              ListView.separated(
                itemBuilder: (
                  BuildContext context,
                  int cardVenueNow,
                ) {
                  return ListTile(
                    leading: Text(table[cardVenueNow].description),
                    title: Text(
                      table[cardVenueNow].value.toString(),
                    ),
                    trailing: Text(
                      table[cardVenueNow].date.toString(),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: table.length,
              ),
              Container(),
            ],
          ),
        ),
    );
  }
}