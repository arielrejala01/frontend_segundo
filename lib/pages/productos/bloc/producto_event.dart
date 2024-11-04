part of 'producto_bloc.dart';

@immutable
sealed class ProductoEvent {}

final class LoadProductos extends ProductoEvent {}

final class AddProducto extends ProductoEvent {
  final ProductoModel? producto;

  AddProducto({this.producto});
}

final class UpdateProducto extends ProductoEvent {
  final ProductoModel? producto;

  UpdateProducto({this.producto});
}

final class DeleteProducto extends ProductoEvent {
  final int? id;

  DeleteProducto({this.id});
}

final class SearchProducto extends ProductoEvent {
  final String? text;

  SearchProducto({this.text});
}
