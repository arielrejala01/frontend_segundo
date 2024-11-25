import 'package:bloc/bloc.dart';
import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';
import 'package:frontend_segundo/pages/productos/models/producto_model.dart';
import 'package:frontend_segundo/services/producto_api_provider.dart';
import 'package:meta/meta.dart';

part 'producto_event.dart';
part 'producto_state.dart';

class ProductoBloc extends Bloc<ProductoEvent, ProductoState> {
  ProductoBloc() : super(ProductoInitial()) {
    on<LoadProductos>(_mapLoadProductosToState);
    on<AddProducto>(_mapAddProductoToState);
    on<UpdateProducto>(_mapUpdateProductoToState);
    on<DeleteProducto>(_mapDeleteProductoToState);
    on<SearchProducto>(_mapSearchProductoToState);
  }

  _mapLoadProductosToState(LoadProductos event, emit) async {
    emit(ProductoInitial());

    var productos = await ProductoApiProvider.db.getProductos();

    emit(ProductoLoaded(productos: productos));
  }

  _mapAddProductoToState(AddProducto event, emit) async {
    emit(ProductoInitial());
    try {
      if (event.producto != null) {
        await ProductoApiProvider.db.newProducto(event.producto);
      }
      var productos = await ProductoApiProvider.db.getProductos();
      emit(ProductoLoaded(productos: productos));
    } catch (e) {
      emit(ProductoNotLoaded(error: e.toString()));
    }
  }

  _mapUpdateProductoToState(UpdateProducto event, emit) async {
    emit(ProductoInitial());
    try {
      if (event.producto != null) {
        await ProductoApiProvider.db.updateProducto(event.producto);
      }
      var productos = await ProductoApiProvider.db.getProductos();
      emit(ProductoLoaded(productos: productos));
    } catch (e) {
      emit(ProductoNotLoaded(error: e.toString()));
    }
  }

  _mapDeleteProductoToState(DeleteProducto event, emit) async {
    emit(ProductoInitial());
    try {
      await ProductoApiProvider.db.deleteProducto(event.id);

      var productos = await ProductoApiProvider.db.getProductos();
      emit(ProductoLoaded(productos: productos));
    } catch (e) {
      emit(ProductoNotLoaded(error: e.toString()));
    }
  }

  _mapSearchProductoToState(SearchProducto event, emit) async {
    emit(ProductoInitial());
    try {
      if (event.text == '' && event.categoria == null) {
        var productos = await ProductoApiProvider.db.getProductos();
        emit(ProductoLoaded(productos: productos));
      } else {
        var productos = await ProductoApiProvider.db
            .searchProducto(event.text ?? '', event.categoria?.id ?? 0);
        emit(ProductoLoaded(productos: productos));
      }
    } catch (e) {
      emit(ProductoNotLoaded(error: e.toString()));
    }
  }
}
