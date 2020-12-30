import 'package:flutter/material.dart';
import 'package:growdev_app/pages/list_card_page.dart';
import 'package:growdev_app/pages/login_page.dart';
import 'package:growdev_app/pages/new_card_page.dart';
import 'package:growdev_app/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.LOGIN,
      routes: {
        Routes.LOGIN: (context) => LoginPage(),
        Routes.LISTA: (context) => ListCardPage(),
        Routes.CADEDIT: (context) => NewCardPage(),        
      },      
    );
  }
}
