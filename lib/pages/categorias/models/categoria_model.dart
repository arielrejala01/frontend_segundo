class CategoriaModel {
  int? id;
  String? name;

  CategoriaModel({this.id, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['idCategoria'] = id;
    data['nombre'] = name;
    return data;
  }

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(id: json['idCategoria'], name: json['nombre']);
  }
}
