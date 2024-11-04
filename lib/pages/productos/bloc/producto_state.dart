part of 'producto_bloc.dart';

@immutable
sealed class ProductoState {}

final class ProductoInitial extends ProductoState {}

final class ProductoLoaded extends ProductoState {
  final List<ProductoModel>? productos;

  ProductoLoaded({this.productos});
}

final class ProductoNotLoaded extends ProductoState {
  final String? error;

  ProductoNotLoaded({this.error});
}
