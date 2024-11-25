// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_segundo/pages/productos/bloc/producto_bloc.dart';
import 'package:frontend_segundo/pages/ventas/clientes/bloc/cliente_bloc.dart';
import 'package:frontend_segundo/pages/ventas/clientes/cliente_register_form.dart';
import 'package:frontend_segundo/pages/ventas/compras/bloc/carrito_bloc.dart';
import 'package:frontend_segundo/pages/ventas/compras/components/item_card.dart';
import 'package:frontend_segundo/pages/ventas/consultas/bloc/pedido_bloc.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(132, 182, 244, 1),
        centerTitle: true,
        title: const Text(
          'Cart App',
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CarritoBloc, CarritoState>(
        builder: (context, state) {
          if (state is CarritoNotLoaded) {
            return Center(child: Text(state.error ?? ''));
          }
          if (state is CarritoInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CarritoLoaded) {
            final double total = state.items?.fold(
                    0,
                    (sum, item) =>
                        sum! + (item.precio ?? 0) * (item.cantidad ?? 0)) ??
                0;
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/metodo_entrega');
                  },
                  child: Container(
                    width: 350,
                    height: 60,
                    margin: const EdgeInsets.only(top: 10, bottom: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 2, color: Colors.grey.shade400)
                        ]),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color.fromRGBO(132, 182, 244, 1),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text(
                          state.tipo == null || state.tipo?.isEmpty == true
                              ? 'Seleccionar un método de entrega'
                              : state.tipo == 'pickup'
                                  ? 'Pickup'
                                  : 'Entregar en ${state.direccion}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: state.items
                                  ?.map((item) => Center(child: ItemCard(item)))
                                  .toList() ??
                              [],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(255, 108, 166, 236)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total a pagar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 108, 166, 236),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${total.toString()} \$',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 108, 166, 236),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is CarritoFinalizado) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gracias por elegirnos!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<CarritoBloc>(context).add(LoadCarrito());
                      BlocProvider.of<ProductoBloc>(context)
                          .add(LoadProductos());
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                      width: 250,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 108, 166, 236),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        'Seguir comprando',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: BlocBuilder<CarritoBloc, CarritoState>(
        builder: (context, state) {
          if (state is CarritoLoaded) {
            return BottomAppBar(
              height: 80,
              color: Colors.white,
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 108, 166, 236),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _showClienteDialog(state);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Finalizar',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return const BottomAppBar(
            color: Colors.white,
          );
        },
      ),
    );
  }

  void _showClienteDialog(CarritoLoaded carrito) {
    final TextEditingController cedulaController = TextEditingController();
    final double total = carrito.items?.fold(0,
            (sum, item) => sum! + (item.precio ?? 0) * (item.cantidad ?? 0)) ??
        0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Ingrese la Cédula del Cliente'),
          content: TextField(
            controller: cedulaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cédula',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final cedula = cedulaController.text.trim();

                if (cedula.isNotEmpty) {
                  BlocProvider.of<ClienteBloc>(context)
                      .add(SearchCliente(text: cedula));

                  ClienteState clienteState =
                      await BlocProvider.of<ClienteBloc>(context)
                          .stream
                          .firstWhere((state) => state is ClienteLoaded);

                  if (clienteState is ClienteLoaded &&
                      clienteState.cliente != null) {
                    BlocProvider.of<PedidoBloc>(context).add(AddPedido(
                        cliente: clienteState.cliente,
                        total: total,
                        detalles: carrito.items,
                        tipo: carrito.tipo,
                        direccion: carrito.direccion,
                        lat: carrito.lat,
                        lon: carrito.lon));

                    BlocProvider.of<CarritoBloc>(context)
                        .add(FinalizarCarrito());

                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => ClienteRegisterForm(),
                    );
                  }
                }
              },
              child: const Text('Verificar'),
            ),
          ],
        );
      },
    );
  }
}
