import 'package:frontend_segundo/pages/productos/models/producto_model.dart';

class ItemCarritoModel {
  int? id;
  ProductoModel? producto;
  int? cantidad;
  double? precio;

  ItemCarritoModel({this.id, this.producto, this.cantidad, this.precio});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['idCarrito'] = id;
    if (producto != null) data['idProducto'] = producto?.idProducto;
    if (cantidad != null) data['cantidad'] = cantidad;
    if (precio != null) data['precioVenta'] = precio;
    return data;
  }

  factory ItemCarritoModel.fromJson(Map<String, dynamic> json) {
    return ItemCarritoModel(
      id: json['idCarrito'],
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
