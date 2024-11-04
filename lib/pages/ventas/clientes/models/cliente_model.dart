class Cliente {
  final int? idCliente;
  final String cedula;
  final String nombre;
  final String apellido;

  Cliente({
    this.idCliente,
    required this.cedula,
    required this.nombre,
    required this.apellido,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (idCliente != null) data['idCliente'] = idCliente;
    data['cedula'] = cedula;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    return data;
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        idCliente: json['idCliente'],
        cedula: json['cedula'],
        nombre: json['nombre'],
        apellido: json['apellido']);
  }
}
