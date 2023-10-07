import 'package:flutter/material.dart';
import 'package:iboss/components/show_snackbar.dart';
import 'package:iboss/repositories/authentication/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isEntering = true;

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5CE1E6),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/icon2.png",
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      (isEntering)
                          ? "Colaborando com a sua Independência"
                          : "Organize suas finanças do jeito certo",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        label: Text("E-mail"),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Cor da borda inferior
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Insira um email";
                        }
                        if (!value.contains("@") ||
                            !value.contains(".") ||
                            value.length < 4) {
                          return "Insira um email válido";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        label: Text("Senha"),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Insira uma senha válida.";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: isEntering,
                      child: TextButton(
                        onPressed: () {
                          forgotMyPasswordClicked();
                        },
                        child: const Text(
                          "Esqueci minha senha",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: !isEntering,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _confirmController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Confirme a senha"),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 4) {
                                  return "Insira uma confirmação de senha válida.";
                                }
                                if (value != _passwordController.text) {
                                  return "As senhas devem ser iguais.";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Nome"),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 3) {
                                  return "Insira um nome maior.";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        botaoEnviarClicado();
                      },
                      style: TextButton.styleFrom(
                        elevation: 4,
                        backgroundColor: const Color(0xFF5CE1E6),
                      ),
                      child: Text(
                        (isEntering) ? "Entrar" : "Cadastrar",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isEntering = !isEntering;
                          });
                        },
                        style: TextButton.styleFrom(),
                        child: Text(
                          (isEntering)
                              ? "Ainda não tem conta?\nClique aqui para cadastrar."
                              : "Já tem uma conta?\nClique aqui para entrar",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoEnviarClicado() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    if (_formKey.currentState!.validate()) {
      if (isEntering) {
        _enterUser(email: email, password: password);
      } else {
        _registerUser(email: email, password: password, name: name);
      }
    }
  }

  _enterUser({required String email, required String password}) {
    authService
        .enterUser(email: email, password: password)
        .then((String? error) {
      if (error != null) {
        showSnackbar(context: context, menssager: error, isError: true);
      }
    });
  }

  _registerUser(
      {required String email, required String password, required String name}) {
    authService
        .registerUser(
      email: email,
      password: password,
      name: name,
    )
        .then(
      (String? error) {
        if (error != null) {
          showSnackbar(context: context, menssager: error, isError: true);
        }
      },
    );
  }

  forgotMyPasswordClicked() {
    String email = _emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController passwordResetController =
            TextEditingController(text: email);
        return AlertDialog(
          title: const Text("Confirme o e-mail para redefinição de senha"),
          content: TextFormField(
            controller: passwordResetController,
            decoration: const InputDecoration(
              label: Text("Confirme o email"),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                authService
                    .passwordReset(email: passwordResetController.text)
                    .then((String? error) {
                  if (error == null) {
                    showSnackbar(
                      context: context,
                      menssager: "E-mail de redefinição enviado",
                      isError: false,
                    );
                  } else {
                    showSnackbar(context: context, menssager: error);
                  }
                  Navigator.pop(context);
                });
              },
              child: const Text("Redefinir senha"),
            ),
          ],
        );
      },
    );
  }
}
