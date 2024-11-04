import 'package:bloc/bloc.dart';
import 'package:frontend_segundo/pages/ventas/clientes/models/cliente_model.dart';
import 'package:frontend_segundo/services/cliente_api_provider.dart';
import 'package:meta/meta.dart';

part 'cliente_event.dart';
part 'cliente_state.dart';

class ClienteBloc extends Bloc<ClienteEvent, ClienteState> {
  ClienteBloc() : super(ClienteInitial()) {
    on<AddCliente>(_mapAddClienteToState);
    on<SearchCliente>(_mapSearchClienteToState);
  }

  _mapAddClienteToState(AddCliente event, emit) async {
    emit(ClienteInitial());
    try {
      if (event.cliente != null) {
        await ClienteApiProvider.db.addCliente(event.cliente);

        var cliente =
            await ClienteApiProvider.db.searchCliente(event.cliente?.cedula);

        emit(ClienteLoaded(cliente: cliente));
      }
    } catch (e) {
      emit(ClienteNotLoaded(error: e.toString()));
    }
  }

  _mapSearchClienteToState(SearchCliente event, emit) async {
    emit(ClienteInitial());
    try {
      if (event.text != null) {
        var cliente = await ClienteApiProvider.db.searchCliente(event.text);

        emit(ClienteLoaded(cliente: cliente));
      }
    } catch (e) {
      emit(ClienteNotLoaded(error: e.toString()));
    }
  }
}
