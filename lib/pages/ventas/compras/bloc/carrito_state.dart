part of 'carrito_bloc.dart';

@immutable
sealed class CarritoState {}

final class CarritoInitial extends CarritoState {}

final class CarritoLoaded extends CarritoState {
  final int? id;
  final List<ItemCarritoModel>? items;
  final String? tipo;
  final String? direccion;
  final double? lat;
  final double? lon;

  CarritoLoaded(
      {this.id, this.items, this.tipo, this.direccion, this.lat, this.lon});
}

final class CarritoNotLoaded extends CarritoState {
  final String? error;

  CarritoNotLoaded({this.error});
}

final class CarritoFinalizado extends CarritoState {}
