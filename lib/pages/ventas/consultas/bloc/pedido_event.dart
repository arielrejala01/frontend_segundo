part of 'pedido_bloc.dart';

@immutable
sealed class PedidoEvent {}

final class LoadPedidos extends PedidoEvent {}

final class AddPedido extends PedidoEvent {
  final List<ItemCarritoModel>? detalles;
  final double? total;
  final Cliente? cliente;

  AddPedido({this.detalles, this.cliente, this.total});
}

final class SearchPedidos extends PedidoEvent {
  final String? fecha;
  final String? textoCliente;

  SearchPedidos({this.fecha, this.textoCliente});
}
