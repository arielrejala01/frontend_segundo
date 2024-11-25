import 'package:frontend_segundo/pages/ventas/compras/models/item_carrito_model.dart';

class CarritoModel {
  final int idCarrito;
  final String? tipoOperacion;
  final String? direccionEntrega;
  final double? lat;
  final double? lon;
  final List<ItemCarritoModel> items;

  CarritoModel({
    required this.idCarrito,
    this.tipoOperacion,
    this.direccionEntrega,
    this.lat,
    this.lon,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idCarrito'] = idCarrito;
    if (tipoOperacion != null) data['tipoOperacion'] = tipoOperacion;
    if (direccionEntrega != null) data['direccionEntrega'] = direccionEntrega;
    if (lat != null) data['lat'] = lat;
    if (lon != null) data['lon'] = lon;
    return data;
  }

  factory CarritoModel.fromJson(
      Map<String, dynamic> json, List<ItemCarritoModel> items) {
    return CarritoModel(
      idCarrito: json['idCarrito'],
      tipoOperacion: json['tipoOperacion'] ?? '',
      direccionEntrega: json['direccionEntrega'] ?? '',
      lat: json['lat'] ?? 0,
      lon: json['lon'] ?? 0,
      items: items,
    );
  }
}
