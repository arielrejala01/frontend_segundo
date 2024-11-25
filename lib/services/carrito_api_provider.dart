import 'package:frontend_segundo/pages/ventas/compras/models/carrito_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/item_carrito_model.dart';
import 'package:frontend_segundo/services/db.dart';

class CarritoApiProvider extends DBProvider {
  CarritoApiProvider._();

  static final CarritoApiProvider db = CarritoApiProvider._();

  Future<int> createNewCarrito() async {
    final db = (await database)!;
    var res = await db.insert('Carrito', {
      'tipoOperacion': null,
      'direccionEntrega': null,
      'lat': null,
      'lon': null,
    });
    return res;
  }

  Future<int> addItemCarrito(ItemCarritoModel? itemCarrito) async {
    final db = (await database)!;

    var lastCarrito = await getLastCarrito();
    if (lastCarrito == null) {
      await createNewCarrito();
      lastCarrito = await getLastCarrito();
    }

    itemCarrito?.idCarrito = lastCarrito?.idCarrito;

    var res = await db.insert('carritodetalles', itemCarrito!.toJson());
    return res;
  }

  Future<CarritoModel?> getLastCarrito() async {
    final db = (await database)!;

    var carritoRes = await db.rawQuery('''
    SELECT idCarrito, tipoOperacion, direccionEntrega, lat, lon
    FROM Carrito
    ORDER BY idCarrito DESC
    LIMIT 1
  ''');

    if (carritoRes.isEmpty) {
      return null;
    }

    var itemsRes = await db.rawQuery('''
  SELECT CarritoDetalles.idProducto, CarritoDetalles.cantidad, CarritoDetalles.precioVenta,
         Productos.nombre AS nombreProducto, CarritoDetalles.idDetalle, CarritoDetalles.idCarrito
  FROM CarritoDetalles
  INNER JOIN Productos ON CarritoDetalles.idProducto = Productos.idProducto
  WHERE CarritoDetalles.idCarrito = ?
''', [carritoRes.first['idCarrito']]);

    List<ItemCarritoModel> items = itemsRes.isNotEmpty
        ? itemsRes.map((item) => ItemCarritoModel.fromJson(item)).toList()
        : [];

    return CarritoModel.fromJson(carritoRes.first, items);
  }

  Future<int> updateItemCarrito(ItemCarritoModel? item) async {
    final db = (await database)!;
    var res = await db.update('carritodetalles', item!.toJson(),
        where: 'idDetalle = ?', whereArgs: [item.id]);
    return res;
  }

  Future<int> deleteAllItems() async {
    final db = (await database)!;
    var res = await db.delete('carritodetalles');
    return res;
  }

  Future<int> updateMetodoEntregaCarrito({
    required int idCarrito,
    String? tipoOperacion,
    String? direccionEntrega,
    double? lat,
    double? lon,
  }) async {
    final db = (await database)!;

    Map<String, Object?> updateValues = {};
    if (tipoOperacion != null) updateValues['tipoOperacion'] = tipoOperacion;
    if (direccionEntrega != null) {
      updateValues['direccionEntrega'] = direccionEntrega;
    }
    if (lat != null) updateValues['lat'] = lat;
    if (lon != null) updateValues['lon'] = lon;

    var lastCarrito = await getLastCarrito();
    if (lastCarrito != null) {
      var res = await db.update(
        'Carrito',
        updateValues,
        where: 'idCarrito = ?',
        whereArgs: [lastCarrito.idCarrito],
      );
      return res;
    }
    return 0;
  }

  Future<int> deleteLastCarrito() async {
    final db = (await database)!;

    var lastCarrito = await getLastCarrito();
    if (lastCarrito != null) {
      var res = await db.delete('Carrito',
          where: 'idCarrito = ?', whereArgs: [lastCarrito.idCarrito]);
      return res;
    }
    return 0;
  }
}
