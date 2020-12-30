class CustomCard {
  int id;
  String title;
  String content;

  //Construtor normal que recebe id, title e content
  CustomCard(this.title, this.content, {this.id});

  @override
  CustomCard.named({this.title, this.content, this.id});

  //Construtor com nome fromJson que pega os valores do map e coloca nos atributos
  CustomCard.fromJson(dynamic map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
  }

  //Método toJson() que retorna um map com as informações do Card
  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content};
  }

  @override
  String toString() {
    return 'Id $id ... title $title ... conteudo $content';
  }
}
