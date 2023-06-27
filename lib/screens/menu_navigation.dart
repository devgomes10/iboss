import 'package:flutter/material.dart';
import 'package:iboss/screens/business.dart';
import 'package:iboss/screens/dashboard.dart';
import 'package:iboss/screens/goals.dart';
import 'package:iboss/screens/personal.dart';
import 'package:iboss/screens/settings.dart';

class MenuNavigation extends StatefulWidget {
  const MenuNavigation({super.key});

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

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          Business(),
          Personal(),
          Goals(),
          Dashboard(),
          Settings(),
        ],
        onPageChanged: setCurrentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Empresa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Pessoais'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Metas'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
        onTap: (page) {
          pc.animateToPage(
              page,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease);
        },
      ),
    );
  }
}
