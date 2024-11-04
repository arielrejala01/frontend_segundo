part of 'pedido_bloc.dart';

@immutable
sealed class PedidoState {}

final class PedidoInitial extends PedidoState {}

final class PedidoLoaded extends PedidoState {
  final List<Venta>? ventas;

  PedidoLoaded({this.ventas});
}

final class PedidoNotLoaded extends PedidoState {
  final String? error;

  PedidoNotLoaded({this.error});
}
