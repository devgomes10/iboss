import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/goals/goals_form.dart';
import 'package:iboss/views/business/business_view.dart';
import 'package:iboss/views/business/expense_view.dart';
import 'package:iboss/views/business/revenue_view.dart';
import 'package:iboss/views/dashboard/dashboard_view.dart';
import 'package:iboss/views/goals/goals_view.dart';
import '../views/personal/personal.dart';

class MenuNavigation extends StatefulWidget {
  final User transaction;

  const MenuNavigation({super.key, required this.transaction});

  @override
  State<MenuNavigation> createState() => _MenuNavigationState();
}

class _MenuNavigationState extends State<MenuNavigation> {
  int currentPage = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setCurrentPage,
        children: [
          BusinessView(user: widget.transaction),
          Transactions(),
          GoalsView(user: widget.transaction),
          DashboardView(user: widget.transaction),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentPage == 2
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                NewGoalBottomSheet.show(context);
                // NewGoal.show(context);
              },
              child: const Icon(
                FontAwesomeIcons.plus,
              ),
            )
          : SpeedDial(
              icon: FontAwesomeIcons.plus,
              backgroundColor: const Color(0xFF5CE1E6),
              overlayColor: Colors.black,
              overlayOpacity: 0.7,
              spacing: 12,
              spaceBetweenChildren: 15,
              curve: Curves.easeInOutCirc,
              children: [
                SpeedDialChild(
                  child: const FaIcon(FontAwesomeIcons.solidHandshake),
                  label: 'Pagamento',
                  labelStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RevenueView(),
                      ),
                    );
                    // NewRevenueBottomSheet.show(context);
                  },
                ),
                SpeedDialChild(
                  child: const FaIcon(FontAwesomeIcons.solidHandshake),
                  label: 'Despesa',
                  labelStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpenseView(),
                      ),
                    );
                  },
                ),
                SpeedDialChild(
                  child: const FaIcon(FontAwesomeIcons.userLarge),
                  label: 'Renda',
                  labelStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Colors.green,
                  onTap: () {},
                ),
                SpeedDialChild(
                  child: const FaIcon(FontAwesomeIcons.userLarge),
                  label: 'Gasto',
                  labelStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        child: BottomAppBar(
          // notchMargin: 8,
          // shape: const CircularNotchedRectangle(),
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
                    icon: const FaIcon(FontAwesomeIcons.handshake),
                    color: currentPage == 0
                        ? const Color(0xFF5CE1E6)
                        : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentPage = 1;
                      });
                      pc.jumpToPage(1);
                    },
                    icon: const FaIcon(FontAwesomeIcons.user),
                    color: currentPage == 1
                        ? const Color(0xFF5CE1E6)
                        : Colors.grey,
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
                    icon: const FaIcon(FontAwesomeIcons.flag),
                    color: currentPage == 2
                        ? const Color(0xFF5CE1E6)
                        : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentPage = 3;
                      });
                      pc.jumpToPage(3);
                    },
                    icon: const FaIcon(FontAwesomeIcons.chartColumn),
                    color: currentPage == 3
                        ? const Color(0xFF5CE1E6)
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
