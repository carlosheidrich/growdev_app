import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:growdev_app/controllers/appcontroller.dart';
import 'package:growdev_app/entities/user.dart';
import 'package:growdev_app/pages/login_page.dart';
import 'package:growdev_app/themes/pallete.dart';

class CardCadastro extends StatefulWidget {
  final void Function() onTap;

  const CardCadastro({this.onTap});

  @override
  _CardCadastroState createState() => _CardCadastroState();
}

class _CardCadastroState extends State<CardCadastro> {
  var _mostraSenha = false;
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, String>();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  bool loading = false;

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();

    AppController.user = User(
        name: _formData['name'],
        email: _formData['email'],
        password: _formData['password']);

    try {
      setState(() {
        loading = true;
      });

      var appController = AppController();

      var msgRet = await appController.criarNovoUsuario();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: msgRet == 'Usuário cadastrado com sucesso!'
              ? Colors.green[600]
              : Colors.red[900],
          duration: Duration(
            seconds: msgRet == 'Usuário cadastrado com sucesso!' ? 3 : 6,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  msgRet == 'Usuário cadastrado com sucesso!'
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  color: Colors.white,
                ),
                Text(msgRet),
              ],
            ),
          ),
        ),
      );

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.message);
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[900],
          duration: Duration(seconds: 2),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.yellow,
                ),
                Text(e.message),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Form(
        key: _form,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30.0),
                RichText(
                  text: TextSpan(
                    text: 'Já tem conta?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    children: [
                      TextSpan(
                        text: '  Faça login aqui',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: laranjaGrowdev,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onTap,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person, color: Colors.grey[900]),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 23.0),
                      labelText: "Nome",
                      filled: true,
                      fillColor: azulTextField,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: azulTextField,
                        ),
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      hintText: "Digite seu nome",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    focusNode: focus1,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus2);
                    },
                    onSaved: (value) => _formData['name'] = value,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.mail, color: Colors.grey[900]),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 23.0),
                      labelText: "E-mail",
                      filled: true,
                      fillColor: azulTextField,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: azulTextField,
                        ),
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      hintText: "Digite seu e-mail",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    focusNode: focus2,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus3);
                    },
                    onSaved: (value) => _formData['email'] = value,
                    validator: (value) {
                      bool isEmpty = value.trim().isEmpty;
                      bool isValidEmail = EmailValidator.validate(value);

                      if (isEmpty || !isValidEmail) {
                        return 'Informe um e-mail válido!';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                  child: TextFormField(
                    obscureText: _mostraSenha ? false : true,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                            _mostraSenha
                                ? Icons.visibility_off
                                : Icons.visibility_rounded,
                            color: Colors.grey[900]),
                        onPressed: () {
                          setState(() {
                            _mostraSenha = _mostraSenha ? false : true;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 23.0),
                      labelText: "Senha",
                      hintText: "Digite sua senha",
                      filled: true,
                      fillColor: azulTextField,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: azulTextField,
                        ),
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    focusNode: focus3,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    onSaved: (value) => _formData['password'] = value,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value.trim().length < 6) {
                        return 'Senha precisa de pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FlatButton(
                    minWidth: double.infinity,
                    padding: EdgeInsets.all(15.0),
                    color: laranjaGrowdev,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _saveForm();
                    },
                    child: loading
                        ? FittedBox(
                            child: Container(
                              height: 18.0,
                              width: 18.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            ),
                          )
                        : Text(
                            "Cadastrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
