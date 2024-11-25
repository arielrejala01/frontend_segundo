part of 'carrito_bloc.dart';

@immutable
sealed class CarritoEvent {}

final class LoadCarrito extends CarritoEvent {}

final class AddItemCarrito extends CarritoEvent {
  final ProductoModel? producto;
  final int? cantidad;
  final double? precioVenta;

  AddItemCarrito({this.producto, this.cantidad, this.precioVenta});
}

final class UpdateItemCarrito extends CarritoEvent {
  final ItemCarritoModel? item;

  UpdateItemCarrito({this.item});
}

final class AddMetodoEntrega extends CarritoEvent {
  final String? tipo;
  final String? direccion;
  final double? lat;
  final double? lon;

  AddMetodoEntrega({this.tipo, this.direccion, this.lat, this.lon});
}

final class FinalizarCarrito extends CarritoEvent {}
