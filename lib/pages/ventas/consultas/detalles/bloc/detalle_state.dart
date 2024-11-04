part of 'detalle_bloc.dart';

@immutable
sealed class DetalleState {}

final class DetalleInitial extends DetalleState {}

final class DetalleLoaded extends DetalleState {
  final List<DetalleVenta>? detalles;

  DetalleLoaded({this.detalles});
}

final class DetalleNotLoaded extends DetalleState {
  final String? error;

  DetalleNotLoaded({this.error});
}
