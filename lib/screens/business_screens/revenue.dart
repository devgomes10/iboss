import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/cash_payment.dart';
import '../../models/deferred_payment.dart';
import '../../repositories/cash_payment_repository.dart';
import '../../repositories/deferred_payment_repository.dart';

class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  Map<String, List<DeferredPayment>> _revenueMap = {};
  List<DeferredPayment> wasPaid = [];
  DateTime _selectedDate = DateTime.now();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  @override
  void initState() {
    super.initState();
    _initializeRevenueMap(_selectedDate);
    _initializeWasPaidList();
  }

  void _initializeWasPaidList() {
    final monthYearString = DateFormat('MM-yyyy').format(_selectedDate);
    wasPaid = _revenueMap[monthYearString] ?? [];
  }

  void _initializeRevenueMap(DateTime date) {
    final monthYearString = DateFormat('MM-yyyy', 'pt_BR').format(date);
    if (!_revenueMap.containsKey(monthYearString)) {
      _revenueMap[monthYearString] = [];
    }
  }

  void add(DeferredPayment paid) {
    final monthYearString = DateFormat('MM-yyyy').format(_selectedDate);
    _revenueMap[monthYearString]?.add(paid);
  }

  void _changeMonth(bool increment) {
    setState(() {
      if (increment) {
        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      } else {
        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      }
      _initializeRevenueMap(_selectedDate);
    });
  }

  String _getMonthYearString() {
    return DateFormat.yMMMM('pt_BR').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Receitas'),
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
                color: Colors.white,
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
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                scrollable: true,
                title: Text(
                  'Adicione uma nova receita',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
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
                            decoration: InputDecoration(
                              hintText: 'Descrição',
                              labelText: 'Descrição',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: valueController,
                            decoration: InputDecoration(
                              hintText: 'Valor',
                              labelText: 'Valor',
                              border: OutlineInputBorder(),
                            ),
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
                        const Text(
                          'Escolha a classificação',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Consumer<CashPaymentRepository>(
                                builder: (BuildContext context,
                                    CashPaymentRepository inCash,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      inCash.add(CashPayment(
                                        description: descriptionController.text,
                                        value:
                                            double.parse(valueController.text),
                                        date: DateTime
                                            .now(), // Usando a data atual
                                      ));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Criando um pagamento à vista'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: const Text(
                                      'À vista',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Consumer<DeferredPaymentRepository>(
                                builder: (BuildContext context,
                                    DeferredPaymentRepository inTerm,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      inTerm.add(DeferredPayment(
                                        description: descriptionController.text,
                                        value:
                                            double.parse(valueController.text),
                                        date: DateTime.now(),
                                      ));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Criando um pagamento a prazo'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.blue,
                                    ),
                                    child: const Text(
                                      'Fiado',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
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
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () => _changeMonth(false),
                      ),
                      Text(
                        _getMonthYearString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () => _changeMonth(true),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<CashPaymentRepository>(
                    builder: (BuildContext context,
                        CashPaymentRepository inCash, Widget? widget) {
                      final monthYearString =
                          DateFormat('MM-yyyy', 'pt_BR').format(_selectedDate);
                      final List<CashPayment> cashPayments =
                          inCash.getCashPaymentsByMonth(_selectedDate);
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            leading: Icon(Icons.trending_up),
                            title: Text(
                              cashPayments[i].description,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(cashPayments[i].value),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(DateFormat('dd/MM/yyyy')
                                    .format(cashPayments[i].date)),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    scrollable: true,
                                    title: const Text(
                                        'Deseja mesmo excluir este pagamento?'),
                                    content: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Não'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                inCash.remove(
                                                    i, monthYearString);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Pagamento deletado'),
                                                  ),
                                                );
                                              },
                                              child: Text('Excluir'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        padding: const EdgeInsets.all(22),
                        itemCount: cashPayments.length,
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () => _changeMonth(false),
                      ),
                      Text(
                        _getMonthYearString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () => _changeMonth(true),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<DeferredPaymentRepository>(
                    builder: (BuildContext context,
                        DeferredPaymentRepository inTerm, Widget? widget) {
                      final monthYearString =
                          DateFormat('MM-yyyy', 'pt_BR').format(_selectedDate);
                      final List<DeferredPayment> deferredPayments =
                          inTerm.getDeferredPaymentsByMonth(_selectedDate);
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            leading: Icon(Icons.trending_up),
                            title: Text(
                              deferredPayments[i].description,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(deferredPayments[i].value),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(deferredPayments[i].date),
                                ),
                              ],
                            ),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          scrollable: true,
                                          title: const Text(
                                              'Você realmente recebeu o dinheiro?'),
                                          content: SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Não'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      inTerm.remove(
                                                          i, monthYearString);
                                                      wasPaid
                                                          .add(DeferredPayment(
                                                        description:
                                                            descriptionController
                                                                .text,
                                                        value: double.parse(
                                                            valueController
                                                                .text),
                                                        date: DateFormat(
                                                                "dd/MM/yyyy")
                                                            .parse(_selectedDate
                                                                .toString()),
                                                      ));
                                                      print(wasPaid.length);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Pagamento Recebido'),
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Sim'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.done),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          scrollable: true,
                                          title: const Text(
                                              'Deseja mesmo excluir este pagamento?'),
                                          content: SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Não'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      inTerm.remove(
                                                          i, monthYearString);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Pagamento deletado'),
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Excluir'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        padding: const EdgeInsets.all(16),
                        itemCount: deferredPayments.length,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
