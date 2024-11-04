import 'package:bloc/bloc.dart';
import 'package:frontend_segundo/pages/productos/models/producto_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/item_carrito_model.dart';
import 'package:frontend_segundo/services/carrito_api_provider.dart';
import 'package:meta/meta.dart';

part 'carrito_event.dart';
part 'carrito_state.dart';

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  CarritoBloc() : super(CarritoInitial()) {
    on<LoadCarrito>(_mapLoadCarritoToState);
    on<AddItemCarrito>(_mapAddItemCarritoToState);
    on<UpdateItemCarrito>(_mapUpdateItemCarritoToState);
    on<FinalizarCarrito>(_mapFinalizarCarritoToState);
  }

  _mapLoadCarritoToState(LoadCarrito event, emit) async {
    emit(CarritoInitial());

    var items = await CarritoApiProvider.db.getAllItemsCarrito();
    emit(CarritoLoaded(items: items));
  }

  _mapAddItemCarritoToState(AddItemCarrito event, emit) async {
    emit(CarritoInitial());

    try {
      await CarritoApiProvider.db.addItemCarrito(ItemCarritoModel(
          producto: event.producto,
          cantidad: event.cantidad,
          precio: event.precioVenta));

      var items = await CarritoApiProvider.db.getAllItemsCarrito();

      emit(CarritoLoaded(items: items));
    } catch (e) {
      emit(CarritoNotLoaded(error: e.toString()));
    }
  }

  _mapUpdateItemCarritoToState(UpdateItemCarrito event, emit) async {
    emit(CarritoInitial());

    try {
      await CarritoApiProvider.db.updateItemCarrito(event.item);

      var items = await CarritoApiProvider.db.getAllItemsCarrito();

      emit(CarritoLoaded(items: items));
    } catch (e) {
      emit(CarritoNotLoaded(error: e.toString()));
    }
  }

  _mapFinalizarCarritoToState(FinalizarCarrito evet, emit) async {
    emit(CarritoInitial());

    await CarritoApiProvider.db.deleteAllItems();

    emit(CarritoFinalizado());
  }
}
