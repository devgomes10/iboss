import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/components/show_confirmation_password.dart';
import '../repositories/authentication/auth_service.dart';

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
              leading: const Icon(Icons.exit_to_app),
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
                    messegerSnack: "Saiu com sucesso",
                    isError: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
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
