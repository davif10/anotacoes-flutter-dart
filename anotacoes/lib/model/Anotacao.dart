class Anotacao{
  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data);

  Map toMap(){
    Map<String,dynamic> map = {
      "titulo": this.titulo,
      "descricao": this.descricao,
      "titulo": this.data,
    };
    if(this.id != null){
      map["id"]= this.id;
    }

    return map;
  }
}