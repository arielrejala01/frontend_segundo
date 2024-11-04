part of 'categoria_bloc.dart';

@immutable
sealed class CategoriaState {}

final class CategoriaInitial extends CategoriaState {}

final class CategoriaLoaded extends CategoriaState {
  final List<CategoriaModel>? categorias;

  CategoriaLoaded({this.categorias});
}

final class CategoriaNotLoaded extends CategoriaState {
  final String? error;

  CategoriaNotLoaded({this.error});
}
