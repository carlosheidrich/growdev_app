import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growdev_app/controllers/appcontroller.dart';
import 'package:growdev_app/entities/custom_card.dart';
import 'package:growdev_app/themes/pallete.dart';

class NewCardPage extends StatefulWidget {
  @override
  _NewCardPageState createState() => _NewCardPageState();
}

class _NewCardPageState extends State<NewCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final String initialValue = '';
  CustomCard card;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    card = ModalRoute.of(context).settings?.arguments ?? CustomCard.named();
  }

  void saveCard() async {
    if (!_formKey.currentState.validate()) {
      showSnackBar(
        message: 'Formulário inválido!',
        color: Colors.red,
      );
      return;
    }

    _formKey.currentState.save();
    var appController = AppController();
    CustomCard cardReturn;

    if (card.id == null) {
      cardReturn = await appController.salvarCard(card);
      if (cardReturn.id == null) {
        return;
      }
      Navigator.of(context).pop(cardReturn);
    } else {
      cardReturn = await appController.atualizarCard(card);
      if (cardReturn != null) {
        Navigator.of(context).pop(card);
      }
    }
  }

  void showSnackBar({String message, Color color}) {
    _scafoldKey.currentState.hideCurrentSnackBar();
    _scafoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulGrowdev,
        title: Text(
            'Card ${card.id == null ? 'Novo' : 'Nº ${card.id} - Editando'}'),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: card?.title,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Título',
                            hintText: 'Digite o título do Card',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onSaved: (value) => card.title = value,
                          validator: (value) {
                            return value.isEmpty ? 'Campo obrigatório' : null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: card?.content,
                          maxLines: 6,
                          scrollPadding: EdgeInsets.all(50),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Conteúdo',
                            hintText: 'Digite o conteúdo do Card',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          //controller: nomeController,
                          onSaved: (value) => card.content = value,
                          validator: (value) {
                            return value.isEmpty ? 'Campo obrigatório' : null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FlatButton(
                minWidth: double.infinity,
                padding: EdgeInsets.all(15.0),
                color: laranjaGrowdev,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: saveCard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
