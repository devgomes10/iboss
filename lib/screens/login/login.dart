import 'package:flutter/material.dart';
import '../register/register.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff003060),
                  Color(0xff6495ed),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 350,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/login_image.png',
                        width: 200,
                        height: 200,
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
                          focusColor: Colors.white,
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(Icons.email),
                          prefixIconColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
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
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(Icons.lock),
                          prefixIconColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          // Adicione aqui a lógica de autenticação
                        },
                        style: TextButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.blue[300],
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003060),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Adicione aqui a lógica para redirecionar para a tela de recuperação de senha
                        },
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 70.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.grey[200],
                        ),
                        child: const Text(
                          'Crie uma conta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003060),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
