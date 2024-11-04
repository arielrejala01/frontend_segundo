part of 'cliente_bloc.dart';

@immutable
sealed class ClienteEvent {}

final class AddCliente extends ClienteEvent {
  final Cliente? cliente;

  AddCliente({this.cliente});
}

final class SearchCliente extends ClienteEvent {
  final String? text;

  SearchCliente({this.text});
}
