part of 'categoria_bloc.dart';

@immutable
sealed class CategoriaEvent {}

final class LoadCategorias extends CategoriaEvent {}

final class AddCategoria extends CategoriaEvent {
  final CategoriaModel? categoria;

  AddCategoria({this.categoria});
}

final class UpdateCategoria extends CategoriaEvent {
  final CategoriaModel? categoria;

  UpdateCategoria({this.categoria});
}

final class DeleteCategoria extends CategoriaEvent {
  final int? id;

  DeleteCategoria({this.id});
}

final class SearchCategoria extends CategoriaEvent {
  final String? text;

  SearchCategoria({this.text});
}
