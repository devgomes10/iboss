import 'package:flutter/material.dart';

class PasswordRecoveryScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                Text(
                  "Recuperação de Senha",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Digite seu endereço de e-mail associado à sua conta para recuperar a senha.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Adicione um email válido";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {

                    // Lógica para enviar o e-mail de recuperação de senha
                  },
                  child: Text("Enviar"),
                ),
                TextButton(
                  onPressed: () {
                    // Navegar para a tela de login
                  },
                  child: Text("Voltar para o login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
