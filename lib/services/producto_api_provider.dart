import 'package:frontend_segundo/pages/productos/models/producto_model.dart';
import 'package:frontend_segundo/services/db.dart';

class ProductoApiProvider extends DBProvider {
  ProductoApiProvider._();

  static final ProductoApiProvider db = ProductoApiProvider._();

  Future<int> newProducto(ProductoModel? producto) async {
    final db = (await database)!;
    var res = await db.insert('productos', producto!.toJson());

    return res;
  }

  Future<List<ProductoModel>> getProductos() async {
    final db = (await database)!;
    var res = await db.rawQuery('''
    SELECT p.idProducto, p.nombre, p.idCategoria, p.precioVenta, c.nombre AS nombreCategoria
    FROM Productos p
    LEFT JOIN Categoria c ON p.idCategoria = c.idCategoria
  ''');

    List<ProductoModel> productos = res.isNotEmpty
        ? res.map((note) => ProductoModel.fromJson(note)).toList()
        : [];

    return productos;
  }

  Future<List<ProductoModel>> searchProducto(String text) async {
    final db = (await database)!;
    var res = await db.rawQuery('''
    SELECT p.idProducto, p.nombre, p.idCategoria, p.precioVenta, c.nombre AS nombreCategoria
    FROM Productos p
    LEFT JOIN Categoria c ON p.idCategoria = c.idCategoria
    WHERE p.nombre LIKE ? OR c.nombre LIKE ?
  ''', ['%$text%', '%$text%']);

    List<ProductoModel> productos = res.isNotEmpty
        ? res.map((note) => ProductoModel.fromJson(note)).toList()
        : [];

    return productos;
  }

  Future<int> deleteProducto(int? id) async {
    final db = (await database)!;

    var res =
        await db.delete('productos', where: 'idProducto = ?', whereArgs: [id]);
    return res;
  }

  Future<int> updateProducto(ProductoModel? producto) async {
    final db = (await database)!;
    var res = await db.update('productos', producto!.toJson(),
        where: 'idProducto = ?', whereArgs: [producto.idProducto]);
    return res;
  }
}
