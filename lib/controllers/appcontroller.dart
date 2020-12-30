import 'package:growdev_app/entities/user.dart';
import 'package:growdev_app/services/api.dart';
import '../entities/custom_card.dart';
import 'package:dio/dio.dart';

class AppController {
  static User user;

  AppController();

  Future<bool> efetuarLogin() async {
    var api = Api();
    var data = await api.efetuaLogin();

    if (data['token'].toString().trim().isNotEmpty) {
      user.name = data['user']['name'];
      user.email = data['user']['email'];
      user.token = data['token'];
      return true;
    } else {
      return false;
    }
  }

  Future<String> criarNovoUsuario() async {
    var api = Api();
    Response resp = await api.criarNovoUsuario();

    switch (resp.statusCode) {
      case 200:
        return 'Usuário cadastrado com sucesso!';
        break;
      case 400:
        if (resp.data['error'] == 'User alredy exists.') {
          return 'Erro: Usuário já cadastrado.';
        }
        if (resp.data['error'] == 'password must be at least 6 characters') {
          return 'Erro: A senha precisa ter pelo menos 6 caracteres.';
        }
        break;
      default:
        return resp.data.toString();
    }
  }

  //3.1.2 Criar método para recuperar todos os cards
  Future<List<CustomCard>> carregaCards() async {
    var api = Api();
    var cards = await api.carregarCards();
    return cards;
  }

  //3.1.3 Criar método para recuperar card por ID
  Future<CustomCard> buscarCardId(int id) async {
    var api = Api();

    return await api.buscarCardId(id);
  }

  //3.1.4 Criar método para salvar card
  Future<CustomCard> salvarCard(CustomCard card) async {
    var api = Api();

    var cardSave = await api.salvarCard(card);

    if (cardSave != null) {
      return cardSave;
    } else {
      return card;
    }
  }

  //3.1.5 Criar método para atualizar o card
  Future<CustomCard> atualizarCard(CustomCard card) async {
    var api = Api();

    return await api.atualizarCard(card);
  }

//3.1.6 Criar método para remover card
  Future<bool> deletarCard(int id) async {
    var api = Api();

    return await api.deletarCard(id);
  }
}
