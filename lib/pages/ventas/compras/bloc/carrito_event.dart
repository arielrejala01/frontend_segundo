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

final class FinalizarCarrito extends CarritoEvent {}
