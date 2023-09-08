import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/expense_form.dart';
import 'package:iboss/components/forms/business/revenue_form.dart';
import 'package:iboss/components/forms/personal/entry_form.dart';
import 'package:iboss/components/forms/personal/outflow_form.dart';
import 'package:iboss/screens/business/business.dart';
import 'package:iboss/screens/business/expense.dart';
import 'package:iboss/screens/dashboard/dashboard.dart';
import 'package:iboss/screens/goals/goals.dart';
import 'package:iboss/screens/personal/entry.dart';
import 'package:iboss/screens/personal/outflow.dart';
import 'package:iboss/screens/personal/personal.dart';
import '../screens/business/revenue.dart';

class MenuNavigation extends StatefulWidget {
  const MenuNavigation({super.key});

  @override
  State<MenuNavigation> createState() => _MenuNavigationState();
}

class _MenuNavigationState extends State<MenuNavigation> {
  int currentPage = 0;
  late PageController pc;
  bool isFABVisible = true;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
      isFABVisible = currentPage != 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setCurrentPage,
        children: const [
          Business(),
          Personal(),
          Goals(),
          Dashboard(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isFABVisible ? SpeedDial(
        icon: FontAwesomeIcons.plus,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        spacing: 12,
        spaceBetweenChildren: 12,
        children: [
          SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.industry),
            label: 'Pagamento',
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Revenue(),
                ),
              );
              NewRevenueDialog.show(context);
            },
          ),
          SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.industry),
            label: 'Despesa',
            backgroundColor: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Expense(),
                ),
              );
              NewExpenseDialog.show(context);
            },
          ),
          SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.userLarge),
            label: 'Renda',
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Entry(),
                ),
              );
              NewEntryDialog.show(context);
            },
          ),
          SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.userLarge),
            label: 'Gasto',
            backgroundColor: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Outflow(),
                ),
              );
              NewOutflowDialog.show(context);
            },
          ),
        ],
      ) : null,
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 0;
                    });
                    pc.jumpToPage(0);
                  },
                  icon: const FaIcon(FontAwesomeIcons.industry),
                  color: currentPage == 0 ? Colors.white : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 1;
                    });
                    pc.jumpToPage(1);
                  },
                  icon: const FaIcon(FontAwesomeIcons.userLarge),
                  color: currentPage == 1 ? Colors.white : Colors.grey,
                ),
                const SizedBox(
                  width: 24,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 2;
                    });
                    pc.jumpToPage(2);
                  },
                  icon: const FaIcon(FontAwesomeIcons.solidFlag),
                  color: currentPage == 2 ? Colors.white : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 3;
                    });
                    pc.jumpToPage(3);
                  },
                  icon: const FaIcon(FontAwesomeIcons.chartSimple),
                  color: currentPage == 3 ? Colors.white : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}