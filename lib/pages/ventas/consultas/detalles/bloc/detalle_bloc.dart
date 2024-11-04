import 'package:bloc/bloc.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/detalle_venta_model.dart';
import 'package:frontend_segundo/services/pedido_api_provider.dart';
import 'package:meta/meta.dart';

part 'detalle_event.dart';
part 'detalle_state.dart';

class DetalleBloc extends Bloc<DetalleEvent, DetalleState> {
  DetalleBloc() : super(DetalleInitial()) {
    on<LoadDetalle>(_mapLoadDetalleToState);
  }

  _mapLoadDetalleToState(LoadDetalle event, emit) async {
    emit(DetalleInitial());
    try {
      var detalles = await PedidoApiProvider.db.getDetalles(event.idVenta ?? 0);

      emit(DetalleLoaded(detalles: detalles));
    } catch (e) {
      emit(DetalleNotLoaded(error: e.toString()));
    }
  }
}
