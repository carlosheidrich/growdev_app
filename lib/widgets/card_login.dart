import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:growdev_app/controllers/appcontroller.dart';
import 'package:growdev_app/entities/user.dart';
import 'package:growdev_app/routes/routes.dart';
import 'package:growdev_app/themes/pallete.dart';

class CardLogin extends StatefulWidget {
  final void Function() onTap;

  const CardLogin({this.onTap});

  @override
  _CardLoginState createState() => _CardLoginState();
}

class _CardLoginState extends State<CardLogin> {
  var _checkBox = true;
  var _mostraSenha = false;
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, String>();
  final focus = FocusNode();

  bool loading = false;

  Future<void> _saveForm() async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();

    AppController.user =
        User(email: _formData['email'], password: _formData['password']);

    try {
      setState(() {
        loading = true;
      });

      var appController = AppController();

      var logou = await appController.efetuarLogin();

      if (logou) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            duration: Duration(seconds: 2),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  Text("Login efetuado com sucesso!"),
                ],
              ),
            ),
          ),
        );

        setState(() {
          loading = false;
        });
        Navigator.of(context).pushNamed(Routes.LISTA);
      }
    } catch (e) {
      print('E-mail ou senha incorretos.');
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
                Text("E-mail ou senha incorretos!"),
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
                RichText(
                  text: TextSpan(
                    text: 'Novo por aqui?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    children: [
                      TextSpan(
                        text: '  Crie sua conta aqui',
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
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
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
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
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
                      const EdgeInsets.only(top: 5.0, right: 15.0, left: 15.0),
                  child: TextFormField(
                    obscureText: _mostraSenha ? false : true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textInputAction: TextInputAction.done,
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
                    focusNode: focus,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    onSaved: (value) => _formData['password'] = value,
                  ),
                ),
                SizedBox(height: 15.0),
                Row(children: [
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(15.0),
                      color: checkBoxColor,
                      height: 40.0,
                      width: 40.0,
                      child: Icon(_checkBox ? Icons.check : null,
                          color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        _checkBox = _checkBox ? false : true;
                      });
                    },
                  ),
                  Text(
                    "Mantenha-me conectado",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
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
                            "Entrar",
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
