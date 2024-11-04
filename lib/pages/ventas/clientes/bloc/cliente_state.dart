part of 'cliente_bloc.dart';

@immutable
sealed class ClienteState {}

final class ClienteInitial extends ClienteState {}

final class ClienteLoaded extends ClienteState {
  final Cliente? cliente;

  ClienteLoaded({this.cliente});
}

final class ClienteNotLoaded extends ClienteState {
  final String? error;

  ClienteNotLoaded({this.error});
}
