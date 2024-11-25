import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/ventas/compras/metodo_entrega.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/venta_model.dart';
import 'package:frontend_segundo/pages/ventas/consultas/detalles/bloc/detalle_bloc.dart';

class DetalleScreen extends StatefulWidget {
  final Venta venta;

  const DetalleScreen({Key? key, required this.venta}) : super(key: key);

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetalleBloc>(context)
        .add(LoadDetalle(idVenta: widget.venta.idVenta));

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
              'Detalle de Venta ID: ${widget.venta.idVenta}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            Expanded(
              child: BlocBuilder<DetalleBloc, DetalleState>(
                builder: (context, state) {
                  if (state is DetalleInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DetalleLoaded) {
                    return Column(
                      children: [
                        ListView.separated(
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
                                        color:
                                            Color.fromARGB(255, 108, 166, 236),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      FontAwesomeIcons.breadSlice,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.detalles?[index].producto
                                                  ?.nombre ??
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
                        ),
                        if (widget.venta.tipoOperacion == 'delivery')
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: FlutterMap(
                                          options: MapOptions(
                                            initialCenter: SimpleLocationResult(
                                                    widget.venta.lat ?? 0,
                                                    widget.venta.lon ?? 0)
                                                .getLatLng(),
                                            initialZoom: 12.0,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                            ),
                                            MarkerLayer(markers: [
                                              Marker(
                                                width: 80.0,
                                                height: 80.0,
                                                point: SimpleLocationResult(
                                                        widget.venta.lat ?? 0,
                                                        widget.venta.lon ?? 0)
                                                    .getLatLng(),
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Color.fromARGB(
                                                      255, 255, 7, 7),
                                                ),
                                              ),
                                            ])
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
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
