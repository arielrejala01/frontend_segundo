import 'package:frontend_segundo/pages/productos/models/producto_model.dart';

class ItemCarritoModel {
  int? id;
  int? idCarrito;
  ProductoModel? producto;
  int? cantidad;
  double? precio;

  ItemCarritoModel(
      {this.id, this.idCarrito, this.producto, this.cantidad, this.precio});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (idCarrito != null) {
      data['idCarrito'] = idCarrito;
    }
    if (producto != null) {
      data['idProducto'] = producto?.idProducto;
    }
    if (cantidad != null) data['cantidad'] = cantidad;
    if (precio != null) data['precioVenta'] = precio;
    return data;
  }

  factory ItemCarritoModel.fromJson(Map<String, dynamic> json) {
    return ItemCarritoModel(
      id: json['idDetalle'],
      idCarrito: json['idCarrito'],
      cantidad: json['cantidad'],
      producto: json['idProducto'] != null
          ? ProductoModel(
              idProducto: json['idProducto'],
              nombre: json['nombreProducto'],
            )
          : null,
      precio: (json['precioVenta'] as num?)?.toDouble(),
    );
  }
}
