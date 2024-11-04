import 'package:frontend_segundo/pages/productos/models/producto_model.dart';

class DetalleVenta {
  final int? idDetalleVenta;
  final int idVenta;
  final ProductoModel? producto;
  final int cantidad;
  final double precio;

  DetalleVenta({
    this.idDetalleVenta,
    required this.idVenta,
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (idDetalleVenta != null) data['idDetalleVenta'] = idDetalleVenta;
    data['idVenta'] = idVenta;
    data['idProducto'] = producto?.idProducto;
    data['cantidad'] = cantidad;
    data['precio'] = precio;
    return data;
  }

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      idDetalleVenta: json['idDetalleVenta'],
      idVenta: json['idVenta'],
      producto: json['idProducto'] != null
          ? ProductoModel(
              idProducto: json['idProducto'], nombre: json['nombreProducto'])
          : null,
      cantidad: json['cantidad'],
      precio: json['precio'],
    );
  }
}
