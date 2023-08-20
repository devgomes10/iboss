import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/business_screens/revenue.dart';
import 'package:iboss/screens/main_screens/business.dart';
import 'package:iboss/screens/main_screens/dashboard.dart';
import 'package:iboss/screens/main_screens/goals.dart';
import 'package:iboss/screens/main_screens/personal.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        icon: FontAwesomeIcons.plus,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        spacing: 12,
        spaceBetweenChildren: 12,
        children: [
          SpeedDialChild(
            child:FaIcon(FontAwesomeIcons.industry),
            label: 'Receita',
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Revenue(),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: FaIcon(FontAwesomeIcons.industry),
            label: 'Gasto',
            backgroundColor: Colors.red,
          ),
          SpeedDialChild(
            child: FaIcon(FontAwesomeIcons.userLarge),
            label: 'Entrada',
            backgroundColor: Colors.green,
          ),
          SpeedDialChild(
            child: FaIcon(FontAwesomeIcons.userLarge),
            label: 'Saída',
            backgroundColor: Colors.red,
          ),
        ],
      ),
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
                  icon: FaIcon(FontAwesomeIcons.industry),
                  color: currentPage == 0 ? Colors.white : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 1;
                    });
                    pc.jumpToPage(1);
                  },
                  icon: FaIcon(FontAwesomeIcons.userLarge),
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
                  icon: FaIcon(FontAwesomeIcons.bullseye),
                  color: currentPage == 2 ? Colors.white : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 3;
                    });
                    pc.jumpToPage(3);
                  },
                  icon: FaIcon(FontAwesomeIcons.gauge),
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