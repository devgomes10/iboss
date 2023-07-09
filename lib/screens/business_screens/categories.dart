// import 'package:flutter/material.dart';
//
// class Categories extends StatefulWidget {
//   const Categories({super.key});
//
//   @override
//   State<Categories> createState() => _CategoriesState();
// }
//
// class _CategoriesState extends State<Categories> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Categorias de Gastos',
//           ),
//           backgroundColor: Colors.green,
//           actions: <Widget>[
//             IconButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   barrierDismissible: true,
//                   builder: (BuildContext context) {
//                     return const AlertDialog(
//                       title: Text('Informação sobre as categorias'),
//                       content: Text('Texto passando as informações'),
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(
//                 Icons.info,
//                 color: Colors.black,
//               ),
//             )
//           ],
//           bottom: const TabBar(
//             tabs: [
//               Tab(
//                 text: 'Categorias',
//               ),
//               Tab(
//                 text: 'Gráfico',
//               ),
//             ],
//             indicatorColor: Colors.white,
//           ),
//         ),
//         body: TabBarView(),
//       ),
//     );
//   }
// }
