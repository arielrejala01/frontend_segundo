import 'package:frontend_segundo/pages/ventas/compras/models/detalle_venta_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/venta_model.dart';
import 'package:frontend_segundo/services/db.dart';

class PedidoApiProvider extends DBProvider {
  PedidoApiProvider._();

  static final PedidoApiProvider db = PedidoApiProvider._();

  Future<int> addPedido(Venta? venta) async {
    final db = (await database)!;
    var res = await db.insert('venta', venta!.toJson());

    return res;
  }

  Future<int> obtenerUltimoIdPedido() async {
    final db = (await database)!;
    var res = await db.rawQuery('SELECT MAX(idVenta) as lastId FROM Venta');

    if (res.isNotEmpty && res.first['lastId'] != null) {
      return res.first['lastId'] as int;
    } else {
      return 0;
    }
  }

  Future<int> addPedidoDetalle(DetalleVenta? detalle) async {
    final db = (await database)!;
    var res = await db.insert('DetalleVenta', detalle!.toJson());

    return res;
  }

  Future<int> updateProductoStock(int idProducto, int cantidadVendida) async {
    final db = (await database)!;
    var res = await db.rawUpdate('''
    UPDATE Productos
    SET stock = stock - ?
    WHERE idProducto = ? AND stock >= ?
  ''', [cantidadVendida, idProducto, cantidadVendida]);

    return res;
  }

  Future<List<Venta>> getPedidos() async {
    final db = (await database)!;
    final List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT v.idVenta, v.fecha, v.total, v.tipoOperacion, v.direccionEntrega, v.lat, v.lon, c.idCliente, c.cedula, c.nombre, c.apellido
    FROM Venta v
    JOIN Cliente c ON v.idCliente = c.idCliente
  ''');

    return res.isNotEmpty
        ? res.map((venta) => Venta.fromJson(venta)).toList()
        : [];
  }

  Future<List<Venta>> getVentasByFecha(String fecha) async {
    final db = (await database)!;
    final List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT v.idVenta, v.fecha, v.total, v.tipoOperacion, v.direccionEntrega, v.lat, v.lon, c.idCliente, c.cedula, c.nombre, c.apellido
    FROM Venta v
    JOIN Cliente c ON v.idCliente = c.idCliente
    WHERE v.fecha = ?
  ''', [fecha]);

    return res.isNotEmpty
        ? res.map((venta) => Venta.fromJson(venta)).toList()
        : [];
  }

  Future<List<Venta>> getVentasByCliente(String text) async {
    final db = (await database)!;

    final List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT v.idVenta, v.fecha, v.total, v.tipoOperacion, v.direccionEntrega, v.lat, v.lon, c.idCliente, c.cedula, c.nombre, c.apellido
    FROM Venta v
    JOIN Cliente c ON v.idCliente = c.idCliente
    WHERE c.cedula LIKE ? OR c.nombre LIKE ? OR c.apellido LIKE ?
  ''', ['%$text%', '%$text%', '%$text%']);

    return res.isNotEmpty
        ? res.map((venta) => Venta.fromJson(venta)).toList()
        : [];
  }

  Future<List<Venta>> getVentasByTipo(String text) async {
    final db = (await database)!;

    final List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT v.idVenta, v.fecha, v.total, v.tipoOperacion, v.direccionEntrega, v.lat, v.lon, c.idCliente, c.cedula, c.nombre, c.apellido
    FROM Venta v
    JOIN Cliente c ON v.idCliente = c.idCliente
    WHERE v.tipoOperacion = ?
  ''', [text]);

    return res.isNotEmpty
        ? res.map((venta) => Venta.fromJson(venta)).toList()
        : [];
  }

  Future<List<DetalleVenta>> getDetalles(int id) async {
    final db = (await database)!;

    final List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT DetalleVenta.idDetalleVenta, DetalleVenta.idVenta,
          DetalleVenta.idProducto, DetalleVenta.cantidad,
          DetalleVenta.precio, Productos.nombre AS nombreProducto
    FROM DetalleVenta
    JOIN Productos ON DetalleVenta.idProducto = Productos.idProducto
    WHERE DetalleVenta.idVenta = ?
  ''', [id]);

    return res.isNotEmpty
        ? res.map((venta) => DetalleVenta.fromJson(venta)).toList()
        : [];
  }
}
