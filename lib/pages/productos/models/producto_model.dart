import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';

class ProductoModel {
  int? idProducto;
  String? nombre;
  CategoriaModel? categoria;
  double? precioVenta;
  int? stock;
  String? imagePath;

  ProductoModel(
      {this.idProducto,
      this.nombre,
      this.categoria,
      this.precioVenta,
      this.stock,
      this.imagePath});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (idProducto != null) data['idProducto'] = idProducto;
    if (nombre != null) data['nombre'] = nombre;
    if (categoria != null) data['idCategoria'] = categoria?.id;
    if (precioVenta != null) data['precioVenta'] = precioVenta;
    if (stock != null) data['stock'] = stock;
    if (imagePath != null) data['imagePath'] = imagePath;
    return data;
  }

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      idProducto: json['idProducto'],
      nombre: json['nombre'],
      categoria: json['idCategoria'] != null
          ? CategoriaModel(
              id: json['idCategoria'],
              name: json['nombreCategoria'],
              codePoint: json['codePoint'],
              fontFamily: json['fontFamily'],
              fontPackage: json['fontPackage'])
          : null,
      precioVenta: (json['precioVenta'] as num?)?.toDouble(),
      stock: json['stock'],
      imagePath: json['imagePath'],
    );
  }
}
