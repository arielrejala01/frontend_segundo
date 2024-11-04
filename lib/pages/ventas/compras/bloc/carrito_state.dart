part of 'carrito_bloc.dart';

@immutable
sealed class CarritoState {}

final class CarritoInitial extends CarritoState {}

final class CarritoLoaded extends CarritoState {
  final List<ItemCarritoModel>? items;

  CarritoLoaded({this.items});
}

final class CarritoNotLoaded extends CarritoState {
  final String? error;

  CarritoNotLoaded({this.error});
}

final class CarritoFinalizado extends CarritoState {}
