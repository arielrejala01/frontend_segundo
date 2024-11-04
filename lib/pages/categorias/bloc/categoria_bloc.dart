import 'package:bloc/bloc.dart';
import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';
import 'package:frontend_segundo/services/categoria_api_provider.dart';
import 'package:meta/meta.dart';

part 'categoria_event.dart';
part 'categoria_state.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  CategoriaBloc() : super(CategoriaInitial()) {
    on<LoadCategorias>(_mapLoadCategoriasToState);
    on<AddCategoria>(_mapAddCategoriaToState);
    on<UpdateCategoria>(_mapUpdateCategoriaToState);
    on<DeleteCategoria>(_mapDeleteCategoriaToState);
    on<SearchCategoria>(_mapSearchCategoriaToState);
  }

  _mapLoadCategoriasToState(LoadCategorias event, emit) async {
    emit(CategoriaInitial());

    var categorias = await CategoriaApiProvider.db.getCategorias();

    emit(CategoriaLoaded(categorias: categorias));
  }

  _mapAddCategoriaToState(AddCategoria event, emit) async {
    emit(CategoriaInitial());
    try {
      if (event.categoria != null) {
        await CategoriaApiProvider.db.newCategoria(event.categoria);
      }
      var categorias = await CategoriaApiProvider.db.getCategorias();
      emit(CategoriaLoaded(categorias: categorias));
    } catch (e) {
      emit(CategoriaNotLoaded(error: e.toString()));
    }
  }

  _mapUpdateCategoriaToState(UpdateCategoria event, emit) async {
    emit(CategoriaInitial());
    try {
      if (event.categoria != null) {
        await CategoriaApiProvider.db.updateCategoria(event.categoria);
      }
      var categorias = await CategoriaApiProvider.db.getCategorias();
      emit(CategoriaLoaded(categorias: categorias));
    } catch (e) {
      emit(CategoriaNotLoaded(error: e.toString()));
    }
  }

  _mapDeleteCategoriaToState(DeleteCategoria event, emit) async {
    emit(CategoriaInitial());
    try {
      await CategoriaApiProvider.db.deleteCategoria(event.id);

      var categorias = await CategoriaApiProvider.db.getCategorias();
      emit(CategoriaLoaded(categorias: categorias));
    } catch (e) {
      emit(CategoriaNotLoaded(error: e.toString()));
    }
  }

  _mapSearchCategoriaToState(SearchCategoria event, emit) async {
    emit(CategoriaInitial());
    try {
      if (event.text == '') {
        var categorias = await CategoriaApiProvider.db.getCategorias();
        emit(CategoriaLoaded(categorias: categorias));
      } else {
        var categorias =
            await CategoriaApiProvider.db.searchCategoria(event.text ?? '');
        emit(CategoriaLoaded(categorias: categorias));
      }
    } catch (e) {
      emit(CategoriaNotLoaded(error: e.toString()));
    }
  }
}
