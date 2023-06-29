import 'package:flutter/material.dart';
import '../repositories/card_revenue_now_repository.dart';

class Revenue extends StatelessWidget {
  const Revenue({super.key});

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
                    return AlertDialog(
                      title: Text('Informação sobre a receita'),
                      content: Text('Texto passando as informações'),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.info,
                color: Colors.black,
              ),
            )
          ],
          bottom: TabBar(
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
          onPressed: () {},
          child: Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
              itemBuilder: (
                BuildContext context,
                int card_venue_now,
              ) {
                return ListTile(
                  leading: Text(table[card_venue_now].description),
                  title: Text(
                    table[card_venue_now].value.toString(),
                  ),
                  trailing: Text(
                    table[card_venue_now].date.toString(),
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(),
              itemCount: table.length,
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
