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
    on<AddMetodoEntrega>(_mapAddMetodoEntregaToState);
  }

  _mapLoadCarritoToState(LoadCarrito event, emit) async {
    emit(CarritoInitial());

    try {
      var carrito = await CarritoApiProvider.db.getLastCarrito();
      emit(CarritoLoaded(
          items: carrito?.items,
          tipo: carrito?.tipoOperacion,
          direccion: carrito?.direccionEntrega,
          lat: carrito?.lat,
          lon: carrito?.lon));
    } catch (e) {
      emit(CarritoNotLoaded(error: e.toString()));
    }
  }

  _mapAddItemCarritoToState(AddItemCarrito event, emit) async {
    emit(CarritoInitial());

    try {
      await CarritoApiProvider.db.addItemCarrito(ItemCarritoModel(
          producto: event.producto,
          cantidad: event.cantidad,
          precio: event.precioVenta));

      var carrito = await CarritoApiProvider.db.getLastCarrito();
      emit(CarritoLoaded(
          items: carrito?.items,
          tipo: carrito?.tipoOperacion,
          direccion: carrito?.direccionEntrega,
          lat: carrito?.lat,
          lon: carrito?.lon));
    } catch (e) {
      emit(CarritoNotLoaded(error: e.toString()));
    }
  }

  _mapUpdateItemCarritoToState(UpdateItemCarrito event, emit) async {
    emit(CarritoInitial());

    try {
      await CarritoApiProvider.db.updateItemCarrito(event.item);
      var carrito = await CarritoApiProvider.db.getLastCarrito();

      emit(CarritoLoaded(
          items: carrito?.items,
          tipo: carrito?.tipoOperacion,
          direccion: carrito?.direccionEntrega,
          lat: carrito?.lat,
          lon: carrito?.lon));
    } catch (e) {
      emit(CarritoNotLoaded(error: e.toString()));
    }
  }

  _mapFinalizarCarritoToState(FinalizarCarrito event, emit) async {
    emit(CarritoInitial());

    try {
      await CarritoApiProvider.db.deleteAllItems();
      await CarritoApiProvider.db.deleteLastCarrito();
      emit(CarritoFinalizado());
    } catch (e) {
      emit(CarritoNotLoaded(error: e.toString()));
    }
  }

  _mapAddMetodoEntregaToState(AddMetodoEntrega event, emit) async {
    CarritoLoaded old = state as CarritoLoaded;

    emit(CarritoInitial());

    try {
      await CarritoApiProvider.db.updateMetodoEntregaCarrito(
          idCarrito: old.id ?? 0,
          tipoOperacion: event.tipo,
          direccionEntrega: event.direccion,
          lat: event.lat,
          lon: event.lon);

      var carrito = await CarritoApiProvider.db.getLastCarrito();

      emit(CarritoLoaded(
          items: carrito?.items,
          tipo: carrito?.tipoOperacion,
          direccion: carrito?.direccionEntrega,
          lat: carrito?.lat,
          lon: carrito?.lon));
    } catch (e) {
      emit(CarritoNotLoaded(error: e.toString()));
    }
  }
}
