import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/show_confirmation_password.dart';
import '../repositories/authentication/auth_service.dart';

class DrawerComponent extends StatelessWidget {
  final User user;

  const DrawerComponent({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              (user.displayName != null) ? user.displayName! : "",
            ),
            accountEmail: Text(user.email!),
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
    );
  }
}
