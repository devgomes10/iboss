import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/screens/dashboard/personal_dash.dart';
import '../../components/drawer_component.dart';
import 'business_dash.dart';

class Dashboard extends StatefulWidget {
  final User user;

  const Dashboard({super.key, required this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: DrawerComponent(user: widget.user),
        appBar: AppBar(
          title: const Text('Painel'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                // icon: FaIcon(FontAwesomeIcons.industry),
                text: 'NEGÓCIO',
              ),
              Tab(
                // icon: FaIcon(FontAwesomeIcons.userLarge),
                text: 'PESSOAL',
              ),
            ],
            indicatorColor: Color(0xFF5CE1E6),
          ),
        ),
        body: const TabBarView(
          children: [
            BusinessDash(),
            PersonalDash(),
          ],
        ),
      ),
    );
  }
}
