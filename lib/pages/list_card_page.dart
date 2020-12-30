import 'package:flutter/material.dart';
import 'package:growdev_app/controllers/appcontroller.dart';
import 'package:growdev_app/routes/routes.dart';
import 'package:growdev_app/themes/pallete.dart';
import 'package:growdev_app/entities/custom_card.dart';

class ListCardPage extends StatefulWidget {
  @override
  _ListCardPageState createState() => _ListCardPageState();
}

class _ListCardPageState extends State<ListCardPage> {
  var cards = <CustomCard>[];

  void carregaCards() async {
    var appController = AppController();
    cards = await appController.carregaCards();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    carregaCards();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulGrowdev,
        title: Text('Cards'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: Text(''),
                onPressed: () async {
                  carregaCards();
                  setState(() {});
                },
              ),
              FlatButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(''),
                onPressed: () async {
                  var cardUpdated =
                      await Navigator.of(context).pushNamed(Routes.CADEDIT);
                  if (cardUpdated != null) {
                    setState(() {
                      cards.add(cardUpdated);
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: azulGrowdev,
              ),
              accountEmail: Text(AppController?.user?.email ?? 'E-Mail'),
              accountName: Text(AppController?.user?.name ?? 'User'),
              currentAccountPicture: CircleAvatar(
                radius: 200,
                backgroundImage: AssetImage(
                  'assets/user01.png',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Navigator.of(context).popAndPushNamed(Routes.LOGIN);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        //cards = await appController.carregaCards();
        itemCount: cards?.length ?? 0,
        itemBuilder: (_, index) {
          var card = cards[index];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: AspectRatio(
              aspectRatio: 8.5 / 5.4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: laranjaGrowdev,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: laranjaGrowdev,
                              child: Text(
                                '${card.id}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              '${card.title}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 20,
                        indent: 5,
                        endIndent: 5,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${card.content}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            child: Text('Editar'),
                            onPressed: () async {
                              var cardUpdated =
                                  await Navigator.of(context).pushNamed(
                                Routes.CADEDIT,
                                arguments: card,
                              );

                              if (cardUpdated != null) {
                                setState(() {
                                  card = cardUpdated;
                                });
                              }
                            },
                          ),
                          FlatButton(
                            child: Text('Excluir'),
                            onPressed: () async {
                              var appController = AppController();
                              if (await appController.deletarCard(card.id)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green[600],
                                    duration: Duration(seconds: 3),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.delete_sweep,
                                            color: Colors.white,
                                          ),
                                          Text("Card excluído com sucesso!"),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                carregaCards();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
