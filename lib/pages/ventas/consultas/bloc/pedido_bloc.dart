import 'package:bloc/bloc.dart';
import 'package:frontend_segundo/pages/ventas/clientes/models/cliente_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/detalle_venta_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/item_carrito_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/venta_model.dart';
import 'package:frontend_segundo/services/carrito_api_provider.dart';
import 'package:frontend_segundo/services/pedido_api_provider.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'pedido_event.dart';
part 'pedido_state.dart';

class PedidoBloc extends Bloc<PedidoEvent, PedidoState> {
  PedidoBloc() : super(PedidoInitial()) {
    on<LoadPedidos>(_mapLoadPedidosToState);
    on<AddPedido>(_mapAddPedidoToState);
    on<SearchPedidos>(_mapSearchPedidosToState);
  }

  _mapLoadPedidosToState(LoadPedidos event, emit) async {
    emit(PedidoInitial());

    var pedidos = await PedidoApiProvider.db.getPedidos();

    emit(PedidoLoaded(ventas: pedidos));
  }

  _mapAddPedidoToState(AddPedido event, emit) async {
    emit(PedidoInitial());

    try {
      var res = await PedidoApiProvider.db.addPedido(Venta(
          cliente: event.cliente,
          fecha: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          total: event.total ?? 0));

      if (res != 0) {
        int id = await PedidoApiProvider.db.obtenerUltimoIdPedido();

        if (event.detalles != null) {
          for (var detalle in event.detalles!) {
            await PedidoApiProvider.db.addPedidoDetalle(DetalleVenta(
                idVenta: id,
                producto: detalle.producto,
                cantidad: detalle.cantidad ?? 0,
                precio: detalle.precio ?? 0));
          }
        }

        await CarritoApiProvider.db.deleteAllItems();

        var pedidos = await PedidoApiProvider.db.getPedidos();

        emit(PedidoLoaded(ventas: pedidos));
      }
    } catch (e) {
      emit(PedidoNotLoaded(error: e.toString()));
    }
  }

  _mapSearchPedidosToState(SearchPedidos event, emit) async {
    emit(PedidoInitial());

    try {
      if (event.fecha != null && event.fecha != '') {
        var pedidos = await PedidoApiProvider.db.getVentasByFecha(event.fecha!);
        emit(PedidoLoaded(ventas: pedidos));
      } else if (event.textoCliente != null && event.textoCliente != '') {
        var pedidos =
            await PedidoApiProvider.db.getVentasByCliente(event.textoCliente!);
        emit(PedidoLoaded(ventas: pedidos));
      }
    } catch (e) {
      emit(PedidoNotLoaded(error: e.toString()));
    }
  }
}
