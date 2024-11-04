import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_segundo/pages/productos/bloc/producto_bloc.dart';

void showDeleteDialog(BuildContext context, int? id) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          actionsPadding: const EdgeInsets.only(right: 8, bottom: 8),
          contentPadding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 4),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Desea eliminar este producto?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color.fromARGB(255, 108, 166, 236)),
                )),
            TextButton(
                onPressed: () {
                  BlocProvider.of<ProductoBloc>(context).add(DeleteProducto(
                    id: id,
                  ));
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'ACEPTAR',
                  style: TextStyle(color: Color.fromARGB(255, 108, 166, 236)),
                ))
          ],
        );
      });
}
