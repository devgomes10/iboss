import 'package:flutter/material.dart';
import '../register/register.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FlutterLogo(
                size: 100,
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Adicione um e-mail";
                  }
                  if (!value.contains("@")) {
                    return "Adicione um e-mail válido";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Insira uma senha";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Adicione aqui a lógica de autenticação
                },
                child: const Text('Entrar'),
              ),
              TextButton(
                onPressed: () {
                  // Adicione aqui a lógica para redirecionar para a tela de recuperação de senha
                },
                child: const Text('Esqueci minha senha'),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),),);
                },
                child: const Text('Crie uma conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}