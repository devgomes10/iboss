import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/components/show_confirmation_password.dart';
import 'package:iboss/screens/business/catalog_screen.dart';
import '../controllers/authentication/auth_service.dart';

class DrawerComponent extends StatelessWidget {
  final User user;

  const DrawerComponent({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 5.0,
          ),
        ),
      ),
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF5CE1E6)),
              accountName: Text(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
                (user.displayName != null) ? user.displayName! : "",
              ),
              accountEmail: Text(
                user.email!,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.bookOpen,
                size: 20,
              ),
              title: const Text(
                "Catálogo",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatalogScreen(isSelecting: true),
                  ),
                );
              },
            ),
            const Divider(height: 12, color: Colors.white),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.rightFromBracket,
                size: 20,
              ),
              title: const Text(
                "Sair",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showConfirmation(
                    context: context,
                    title: "Deseja mesmo sair da sua conta?",
                    onPressed: () {
                      AuthService().logOut();
                    },
                    messegerSnack: "",
                    isError: false);
              },
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.trash,
                size: 20,
              ),
              title: const Text(
                "Remover conta",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showConfirmationPassword(context: context, email: "");
              },
            ),
          ],
        ),
      ),
    );
  }
}
