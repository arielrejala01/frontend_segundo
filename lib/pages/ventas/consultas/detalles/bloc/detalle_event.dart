part of 'detalle_bloc.dart';

@immutable
sealed class DetalleEvent {}

final class LoadDetalle extends DetalleEvent {
  final int? idVenta;

  LoadDetalle({this.idVenta});
}
