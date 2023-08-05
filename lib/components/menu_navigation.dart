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
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: FaIcon(FontAwesomeIcons.plus),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: IconTheme(data: IconThemeData(color: Theme.of(context).colorScheme.secondary), child: Padding(padding: const EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [],),))
      ),
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
    );
  }
}
