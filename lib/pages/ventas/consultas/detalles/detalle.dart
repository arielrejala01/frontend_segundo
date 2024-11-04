import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/ventas/consultas/detalles/bloc/detalle_bloc.dart';

class DetalleScreen extends StatefulWidget {
  final int id;

  const DetalleScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetalleBloc>(context).add(LoadDetalle(idVenta: widget.id));

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              'Detalle de Venta ID: ${widget.id}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            Expanded(
              child: BlocBuilder<DetalleBloc, DetalleState>(
                builder: (context, state) {
                  if (state is DetalleInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DetalleLoaded) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 0,
                          color: Color.fromRGBO(76, 89, 153, 0.5),
                          thickness: 0.25,
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.detalles?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 108, 166, 236),
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  FontAwesomeIcons.breadSlice,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.detalles?[index].producto?.nombre ??
                                          '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${state.detalles?[index].cantidad.toString()} unidades',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          ' - ${state.detalles?[index].precio.toString()} \$',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is DetalleNotLoaded) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return const Center(child: Text('Sin datos para mostrar'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
