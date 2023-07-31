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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // Defina a cor de fundo da BottomNavigationBar
          canvasColor: Color(0xFF3c3c3c),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPage,
          selectedItemColor: Colors.white, // Defina a cor do ícone e do texto selecionado
          unselectedItemColor: Color(0xFF00BF63), // Defina a cor do ícone e do texto não selecionado
          showSelectedLabels: true, // Mostre os rótulos quando o item estiver selecionado
          showUnselectedLabels: false, // Oculte os rótulos quando o item não estiver selecionado
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.industry),// Substitua pelo ícone gamificado de sua escolha
              label: 'Empresa',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userLarge), // Substitua pelo ícone gamificado de sua escolha
              label: 'Pessoal',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bullseye), // Substitua pelo ícone gamificado de sua escolha
              label: 'Metas',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartSimple), // Substitua pelo ícone gamificado de sua escolha
              label: 'Painel',
            ),
          ],
          onTap: (page) {
            pc.animateToPage(
              page,
              duration: const Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:iboss/screens/main_screens/business.dart';
// import '../screens/main_screens/dashboard.dart';
// import '../screens/main_screens/goals.dart';
// import '../screens/main_screens/personal.dart';
// import '../screens/main_screens/settings.dart';
//
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
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentPage,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Empresa'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Pessoais'),
//           BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Metas'),
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Painel'),
//         ],
//         onTap: (page) {
//           pc.animateToPage(
//               page,
//               duration: const Duration(milliseconds: 400),
//               curve: Curves.ease);
//         },
//       ),
//     );
//   }
// }