import 'package:flutter/material.dart';

import 'Register.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlutterLogo(
                size: 100,
              ),
              SizedBox(height: 32.0),
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
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Insira uma senha";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Adicione aqui a lógica de autenticação
                },
                child: Text('Entrar'),
              ),
              TextButton(
                onPressed: () {
                  // Adicione aqui a lógica para redirecionar para a tela de recuperação de senha
                },
                child: Text('Esqueci minha senha'),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),),);
                },
                child: Text('Crie uma conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}