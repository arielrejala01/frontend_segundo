import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_segundo/pages/ventas/clientes/bloc/cliente_bloc.dart';
import 'package:frontend_segundo/pages/ventas/clientes/models/cliente_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/bloc/carrito_bloc.dart';
import 'package:frontend_segundo/pages/ventas/consultas/bloc/pedido_bloc.dart';

class ClienteRegisterForm extends StatelessWidget {
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();

  ClienteRegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClienteBloc, ClienteState>(
      listener: (context, clienteState) {
        if (clienteState is ClienteLoaded) {
          final carritoState = context.read<CarritoBloc>().state;
          if (carritoState is CarritoLoaded) {
            final double total = carritoState.items?.fold(
                  0,
                  (sum, item) =>
                      sum! + (item.precio ?? 0) * (item.cantidad ?? 0),
                ) ??
                0;

            BlocProvider.of<PedidoBloc>(context).add(
              AddPedido(
                cliente: clienteState.cliente,
                detalles: carritoState.items,
                total: total,
              ),
            );

            BlocProvider.of<CarritoBloc>(context).add(FinalizarCarrito());

            Navigator.of(context).pop();
          }
        }
      },
      child: AlertDialog(
        title: const Text('Registrar Cliente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cedulaController,
              decoration: const InputDecoration(labelText: 'Cédula'),
            ),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<ClienteBloc>(context).add(
                AddCliente(
                  cliente: Cliente(
                    cedula: cedulaController.text,
                    nombre: nombreController.text,
                    apellido: apellidoController.text,
                  ),
                ),
              );
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }
}
