import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';
import 'package:frontend_segundo/services/db.dart';

class CategoriaApiProvider extends DBProvider {
  CategoriaApiProvider._();

  static final CategoriaApiProvider db = CategoriaApiProvider._();

  Future<int> newCategoria(CategoriaModel? categoria) async {
    final db = (await database)!;
    var res = await db.insert('categoria', categoria!.toJson());

    return res;
  }

  Future<List<CategoriaModel>> getCategorias() async {
    final db = (await database)!;
    var res = await db.query('categoria');
    List<CategoriaModel> categorias = res.isNotEmpty
        ? res.map((note) => CategoriaModel.fromJson(note)).toList()
        : [];

    return categorias;
  }

  Future<List<CategoriaModel>> searchCategoria(String text) async {
    final db = (await database)!;
    var res = await db.query(
      'categoria',
      where: 'nombre LIKE ?',
      whereArgs: ['%$text%'],
    );

    List<CategoriaModel> categorias = res.isNotEmpty
        ? res.map((note) => CategoriaModel.fromJson(note)).toList()
        : [];

    return categorias;
  }

  Future<int> deleteCategoria(int? id) async {
    final db = (await database)!;

    var res =
        await db.delete('categoria', where: 'idCategoria = ?', whereArgs: [id]);
    return res;
  }

  Future<int> updateCategoria(CategoriaModel? categoria) async {
    final db = (await database)!;
    var res = await db.update('categoria', categoria!.toJson(),
        where: 'idCategoria = ?', whereArgs: [categoria.id]);
    return res;
  }
}
