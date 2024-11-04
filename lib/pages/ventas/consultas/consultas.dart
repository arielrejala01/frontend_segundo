// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_segundo/pages/ventas/consultas/bloc/pedido_bloc.dart';
import 'package:frontend_segundo/pages/ventas/consultas/detalles/detalle.dart';
import 'package:intl/intl.dart';

class Consultas extends StatefulWidget {
  const Consultas({super.key});

  @override
  State<Consultas> createState() => _ConsultasState();
}

class _ConsultasState extends State<Consultas> {
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? widget) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 108, 166, 236),
          ),
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: Colors.white,
            dividerColor: Color.fromARGB(255, 108, 166, 236),
            headerBackgroundColor: Color.fromARGB(255, 108, 166, 236),
            headerForegroundColor: Colors.white,
          ),
        ),
        child: widget!,
      ),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });

      BlocProvider.of<PedidoBloc>(context)
          .add(SearchPedidos(fecha: _dateController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: const InputDecoration(
              labelText: 'Seleccione una Fecha',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<PedidoBloc, PedidoState>(
              builder: (context, state) {
                if (state is PedidoInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PedidoLoaded) {
                  if (state.ventas != null && state.ventas!.isNotEmpty) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 0,
                          color: Color.fromRGBO(76, 89, 153, 0.5),
                          thickness: 0.25,
                        );
                      },
                      itemCount: state.ventas!.length,
                      itemBuilder: (context, index) {
                        final venta = state.ventas![index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalleScreen(id: venta.idVenta ?? 0),
                              ),
                            );
                          },
                          title: Text(
                            'Total: \$${venta.total.toString()}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                              '${venta.fecha} - ${venta.cliente?.nombre} ${venta.cliente?.apellido}'),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                            'No se encontraron pedidos para la fecha seleccionada.'));
                  }
                } else if (state is PedidoNotLoaded) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const Center(
                    child: Text('Seleccione una fecha para filtrar.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
