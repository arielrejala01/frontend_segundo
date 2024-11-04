import 'package:frontend_segundo/pages/ventas/clientes/models/cliente_model.dart';
import 'package:frontend_segundo/services/db.dart';

class ClienteApiProvider extends DBProvider {
  ClienteApiProvider._();

  static final ClienteApiProvider db = ClienteApiProvider._();

  Future<int> addCliente(Cliente? cliente) async {
    final db = (await database)!;
    var res = await db.insert('cliente', cliente!.toJson());

    return res;
  }

  Future<Cliente?> searchCliente(String? text) async {
    final db = (await database)!;
    var res = await db.rawQuery('''
    SELECT idCliente, cedula, nombre, apellido
    FROM Cliente
    WHERE cedula LIKE ? OR nombre LIKE ? OR apellido LIKE ?
  ''', ['%$text%', '%$text%', '%$text%']);

    if (res.isNotEmpty) {
      return Cliente.fromJson(res.first);
    } else {
      return null;
    }
  }
}
