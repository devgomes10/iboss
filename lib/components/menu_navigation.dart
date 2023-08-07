import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/main_screens/business.dart';
import 'package:iboss/screens/main_screens/dashboard.dart';
import 'package:iboss/screens/main_screens/goals.dart';
import 'package:iboss/screens/main_screens/personal.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: FaIcon(FontAwesomeIcons.plus),
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
                const SizedBox(width: 24,),
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




// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:iboss/screens/main_screens/business.dart';
// import '../screens/main_screens/dashboard.dart';
// import '../screens/main_screens/goals.dart';
// import '../screens/main_screens/personal.dart';
//
// class MenuNavigation extends StatefulWidget {
//   const MenuNavigation({super.key});
//
//   @override
//   State<MenuNavigation> createState() => _MenuNavigationState();
// }
//
// class _MenuNavigationState extends State<MenuNavigation> {
//   int currentPage = 0;
//   late PageController pc;
//
//   @override
//   void initState() {
//     super.initState();
//     pc = PageController(initialPage: currentPage);
//   }
//
//   setCurrentPage(page) {
//     setState(() {
//       currentPage = page;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: pc,
//         onPageChanged: setCurrentPage,
//         children: const [
//           Business(),
//           Personal(),
//           Goals(),
//           Dashboard(),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: FaIcon(FontAwesomeIcons.plus),
//       ),
//       extendBody: true,
//       bottomNavigationBar: BottomAppBar(
//         notchMargin: 8,
//         shape: const CircularNotchedRectangle(),
//         color: Theme.of(context).colorScheme.primary,
//         child: IconTheme(
//           data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       currentPage = 0;
//                     });
//                     pc.animateToPage(
//                       0,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.industry),
//                   color: currentPage == 0 ? Colors.white : Colors.grey,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       currentPage = 1;
//                     });
//                     pc.animateToPage(
//                       1,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.userLarge),
//                   color: currentPage == 1 ? Colors.white : Colors.grey,
//                 ),
//                 const SizedBox(width: 24,),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       currentPage = 2;
//                     });
//                     pc.animateToPage(
//                       2,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.bullseye),
//                   color: currentPage == 2 ? Colors.white : Colors.grey,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       currentPage = 3;
//                     });
//                     pc.animateToPage(
//                       3,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.gauge),
//                   color: currentPage == 3 ? Colors.white : Colors.grey,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:iboss/screens/main_screens/business.dart';
// import '../screens/main_screens/dashboard.dart';
// import '../screens/main_screens/goals.dart';
// import '../screens/main_screens/personal.dart';
//
// class MenuNavigation extends StatefulWidget {
//   const MenuNavigation({super.key});
//
//   @override
//   State<MenuNavigation> createState() => _MenuNavigationState();
// }
//
// class _MenuNavigationState extends State<MenuNavigation> {
//   int currentPage = 0;
//   late PageController pc;
//
//   @override
//   void initState() {
//     super.initState();
//     pc = PageController(initialPage: currentPage);
//   }
//
//   setCurrentPage(page) {
//     setState(() {
//       currentPage = page;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: pc,
//         onPageChanged: setCurrentPage,
//         children: const [
//           Business(),
//           Personal(),
//           Goals(),
//           Dashboard(),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: FaIcon(FontAwesomeIcons.plus),
//       ),
//       extendBody: true,
//       bottomNavigationBar: BottomAppBar(
//         notchMargin: 8,
//         shape: const CircularNotchedRectangle(),
//         color: Theme.of(context).colorScheme.primary,
//         child: IconTheme(
//           data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Business(),
//                       ),
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.industry),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Personal(),
//                       ),
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.userLarge),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Goals(),
//                       ),
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.bullseye),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Dashboard(),
//                       ),
//                     );
//                   },
//                   icon: FaIcon(FontAwesomeIcons.gauge),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
