import 'package:dio/dio.dart';
import 'package:growdev_app/controllers/appcontroller.dart';
import 'package:growdev_app/entities/custom_card.dart';

var dio = Dio(BaseOptions(baseUrl: 'https://api-cards-growdev.herokuapp.com'));

class Api {
  Options getOptions() {
    return Options(
        headers: {'Authorization': 'Bearer ${AppController.user.token}'});
  }

  Future<Response> criarNovoUsuario() async {
    try {
      final resp = await dio.post('/users', data: AppController.user.toJson());
      
      return resp;
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> efetuaLogin() async {
    try {
      final resp = await dio.post('/login', data: AppController.user.toJson());
      
      return resp.data;
    } on DioError catch (e) {
      print(e.message);
    }
  }

  //2 - Deve carregar a lista dos cards
  Future<List<CustomCard>> carregarCards() async {
    try {
      var resp = await dio.get('/cards', options: getOptions());

      if (resp.statusCode == 200) {
        if (resp.data.length > 0) {
          return (resp.data as List)
              .map((card) => CustomCard.fromJson(card))
              .toList();
        } else {
          print('Não foram encontrados cards na API.');
          return null;
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      print('Ocorreu um erro: ${e.message}');
      return null;
    }
  }

  //2.1.2 Criar método para recuperar card por id
  Future<CustomCard> buscarCardId(int id) async {
    try {
      var resp = await dio.get('/cards/$id', options: getOptions());
      if (resp.statusCode == 200) {
        print(resp.data);
        return CustomCard.fromJson(resp.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.message != 'Http status error [404]') {
        print('Ocorreu um erro: ${e.message}');
      }
      return null;
    }
  }

  //2.1.3 Criar método para salvar card
  Future<CustomCard> salvarCard(CustomCard card) async {
    try {
      var resp =
          await dio.post('/cards', data: card.toJson(), options: getOptions());
      if (resp.statusCode == 200) {
        return CustomCard.fromJson(resp.data);
      } else {
        return card;
      }
    } on DioError catch (e) {
      print('Ocorreu um erro: ${e.message}');
      return card;
    }
  }

  //2.1.4 Criar método para atualizar card
  Future<CustomCard> atualizarCard(CustomCard card) async {
    try {
      var resp = await dio.put('/cards/${card.id}',
          data: card.toJson(), options: getOptions());
      if (resp.statusCode == 200) {
        return CustomCard.fromJson(resp.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      print('Ocorreu um erro: ${e.message}');
      return null;
    }
  }

  //2.1.5 Criar método para deletar card
  Future<bool> deletarCard(int id) async {
    try {
      var resp = await dio.delete('/cards/$id', options: getOptions());
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      if (e.message != 'Http status error [404]') {
        print('Ocorreu um erro: ${e.message}');
      } else {
        print('Card não encontrado.');
      }
      return false;
    }
  }
}
