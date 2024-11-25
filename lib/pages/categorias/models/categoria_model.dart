// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class CategoriaModel extends Equatable {
  int? id;
  String? name;
  int? codePoint;
  String? fontFamily;
  String? fontPackage;

  CategoriaModel({
    this.id,
    this.name,
    this.codePoint,
    this.fontFamily,
    this.fontPackage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['idCategoria'] = id;
    data['nombre'] = name;
    data['codePoint'] = codePoint;
    data['fontFamily'] = fontFamily;
    data['fontPackage'] = fontPackage;
    return data;
  }

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['idCategoria'],
      name: json['nombre'],
      codePoint: json['codePoint'],
      fontFamily: json['fontFamily'],
      fontPackage: json['fontPackage'],
    );
  }

  @override
  List<Object?> get props => [id, name, codePoint, fontFamily, fontPackage];
}
