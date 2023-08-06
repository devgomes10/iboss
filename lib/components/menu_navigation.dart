import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/main_screens/business.dart';
import '../screens/main_screens/dashboard.dart';
import '../screens/main_screens/goals.dart';
import '../screens/main_screens/personal.dart';

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
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.industry,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: "Empresa",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.userLarge,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: "Pessoal",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bullseye,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: "Metas",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.gauge,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: "Painel",
          ),
        ],
        onTap: (page) {
          pc.animateToPage(page,
              duration: Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}

// BottomAppBar(
// shape: const CircularNotchedRectangle(),
// color: Theme.of(context).colorScheme.primary,
// child: IconTheme(
// data:
// IconThemeData(color: Theme.of(context).colorScheme.secondary),
// child: Padding(
// padding: const EdgeInsets.all(12),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
//
// ],
// ),
// ))),

// BottomNavigationBar(
// currentIndex: currentPage, items: [
// BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.industry), label: "Empresa",),
// BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.userLarge), label: "Pessoal",),
// BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.bullseye), label: "Metas",),
// BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.gauge), label: "Painel",),
// ],
// onTap: (page) {
// pc.animateToPage(page, duration: Duration(milliseconds: 400), curve: Curves.ease);
// },
// ),

// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// floatingActionButton: FloatingActionButton(
// onPressed: () {},
// child: FaIcon(FontAwesomeIcons.plus),
// ),
