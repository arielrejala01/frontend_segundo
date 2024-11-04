import 'package:frontend_segundo/pages/ventas/clientes/models/cliente_model.dart';

class Venta {
  final int? idVenta;
  final String fecha;
  final Cliente? cliente;
  final double total;

  Venta({
    this.idVenta,
    required this.fecha,
    this.cliente,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (idVenta != null) data['idVenta'] = idVenta;
    data['fecha'] = fecha;
    data['idCliente'] = cliente?.idCliente;
    data['total'] = total;
    return data;
  }

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['idVenta'],
      fecha: json['fecha'],
      cliente: json['idCliente'] != null
          ? Cliente(
              idCliente: json['idCliente'],
              nombre: json['nombre'],
              apellido: json['apellido'],
              cedula: json['cedula'])
          : null,
      total: json['total'],
    );
  }
}
