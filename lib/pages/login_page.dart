import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:growdev_app/themes/pallete.dart';
import 'package:growdev_app/widgets/card_cadastro.dart';
import 'package:growdev_app/widgets/card_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _flipCard = GlobalKey<FlipCardState>();

  void onTap() {
    _flipCard.currentState.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulGrowdev,
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            color: azulGrowdev.shade600,
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100.0,
                  ),
                  Image.asset(
                    'assets/growdev_branco.png',
                    width: 200.0,
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: FlipCard(
                        key: _flipCard,
                        flipOnTouch: false,
                        direction: FlipDirection.HORIZONTAL,
                        front: CardLogin(
                          onTap: onTap,
                        ),
                        back: CardCadastro(
                          onTap: onTap,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
