import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/ventas/consultas/bloc/pedido_bloc.dart';

Widget floatingActionButton(BuildContext context, int index) {
  return FloatingActionButton(
    onPressed: () {
      floatingActionButtonEvent(context, index);
    },
    child: floatingActionButtonIcon(index),
  );
}

Widget floatingActionButtonIcon(int index) {
  if (index == 0) {
    return const Icon(
      FontAwesomeIcons.cartShopping,
    );
  } else if (index == 1) {
    return const Icon(FontAwesomeIcons.solidUser);
  } else if (index == 2 || index == 3) {
    return const Icon(
      FontAwesomeIcons.plus,
    );
  }
  return Container();
}

void floatingActionButtonEvent(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushNamed('/carrito');
      break;
    case 1:
      _showClienteDialog(context);
      break;
    case 2:
      Navigator.of(context).pushNamed('/add_producto');
      break;
    case 3:
      Navigator.of(context).pushNamed('/add_categoria');
      break;
    default:
  }
}

void _showClienteDialog(BuildContext context) {
  final TextEditingController buscarController = TextEditingController();
  0;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Busque por cédula, nombre o apellido'),
        content: TextField(
          controller: buscarController,
          decoration: const InputDecoration(
            labelText: 'Buscar',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final buscar = buscarController.text.trim();
              if (buscar.isNotEmpty) {
                BlocProvider.of<PedidoBloc>(context)
                    .add(SearchPedidos(textoCliente: buscar));
              }
              Navigator.of(context).pop();
            },
            child: const Text('Buscar'),
          ),
        ],
      );
    },
  );
}
