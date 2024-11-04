import 'package:frontend_segundo/pages/ventas/compras/models/item_carrito_model.dart';
import 'package:frontend_segundo/services/db.dart';

class CarritoApiProvider extends DBProvider {
  CarritoApiProvider._();

  static final CarritoApiProvider db = CarritoApiProvider._();

  Future<int> addItemCarrito(ItemCarritoModel? itemCarrito) async {
    final db = (await database)!;
    var res = await db.insert('carrito', itemCarrito!.toJson());

    return res;
  }

  Future<List<ItemCarritoModel>> getAllItemsCarrito() async {
    final db = (await database)!;

    var res = await db.rawQuery('''
      SELECT Carrito.idCarrito, Carrito.cantidad, Carrito.precioVenta,
            Productos.idProducto, Productos.nombre AS nombreProducto
      FROM Carrito
      INNER JOIN Productos ON Carrito.idProducto = Productos.idProducto
    ''');

    List<ItemCarritoModel> items = res.isNotEmpty
        ? res.map((note) => ItemCarritoModel.fromJson(note)).toList()
        : [];

    return items;
  }

  Future<int> updateItemCarrito(ItemCarritoModel? item) async {
    final db = (await database)!;
    var res = await db.update('carrito', item!.toJson(),
        where: 'idCarrito = ?', whereArgs: [item.id]);
    return res;
  }

  Future<int> deleteAllItems() async {
    final db = (await database)!;
    var res = await db.delete('carrito');
    return res;
  }
}
