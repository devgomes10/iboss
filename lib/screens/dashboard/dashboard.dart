import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/dashboard/personal_dash.dart';
import '../../components/show_confirmation_password.dart';
import '../../repositories/authentication/auth_service.dart';
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
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  (widget.user.displayName != null)
                      ? widget.user.displayName!
                      : "",
                ),
                accountEmail: Text(widget.user.email!),
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
                title: const Text("Sair"),
                onTap: () {
                  AuthService().logOut();
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.trash),
                title: const Text("Remover conta"),
                onTap: () {
                  showConfirmationPassword(context: context, email: "");
                },
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Painel'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.industry),
                text: 'NEGÓCIO',
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.userLarge),
                text: 'PESSOAL',
              ),
            ],
            indicatorColor: Colors.white,
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
