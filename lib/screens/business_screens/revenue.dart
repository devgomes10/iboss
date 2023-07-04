import 'package:flutter/material.dart';
import 'package:iboss/models/card_revenue_now.dart';
import '../forms/form_revenue.dart';
import 'package:iboss/controllers/revenue_controller.dart';

class Revenue extends StatefulWidget {

  Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  var controller = RevenueController();

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
        floatingActionButton: const FormRevenue(),
        body: TabBarView(
          children: [
            cardsNow(),
            ListView(
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardsNow() {
    final quantidade = controller.revenueNow.length;

    return quantidade == 0
        ? Container(
            child: Center(
              child: Text('Nenhuma receita ainda!'),
            ),
          )
        : ListView.separated(
            itemCount: controller.revenueNow.length,
            itemBuilder: (BuildContext context, int i) {
              final viewList = controller.revenueNow;
              return ListTile(
                leading: Text(viewList[i].description),
                trailing: Text(viewList[i].value.toString()),
              );
            },
            separatorBuilder: (_, __) => Divider(),
            padding: EdgeInsets.all(16),

          );
  }
}
