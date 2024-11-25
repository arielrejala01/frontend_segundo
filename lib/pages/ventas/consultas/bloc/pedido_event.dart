part of 'pedido_bloc.dart';

@immutable
sealed class PedidoEvent {}

final class LoadPedidos extends PedidoEvent {}

final class AddPedido extends PedidoEvent {
  final List<ItemCarritoModel>? detalles;
  final double? total;
  final Cliente? cliente;
  final String? tipo;
  final String? direccion;
  final double? lat;
  final double? lon;

  AddPedido(
      {this.detalles,
      this.cliente,
      this.total,
      this.tipo,
      this.direccion,
      this.lat,
      this.lon});
}

final class SearchPedidos extends PedidoEvent {
  final String? fecha;
  final String? textoCliente;
  final String? tipo;

  SearchPedidos({this.fecha, this.textoCliente, this.tipo});
}
