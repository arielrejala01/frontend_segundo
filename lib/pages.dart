import 'package:flutter/material.dart';
import 'package:frontend_segundo/pages/categorias/categorias.dart';
import 'package:frontend_segundo/pages/productos/productos.dart';
import 'package:frontend_segundo/pages/ventas/compras/buscador/buscador.dart';
import 'package:frontend_segundo/pages/ventas/consultas/consultas.dart';

class Pages extends StatefulWidget {
  final int index;
  const Pages({super.key, required this.index});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  List<Widget> pages = [
    const Buscador(),
    const Consultas(),
    const Productos(),
    const Categorias()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: pages[widget.index],
    );
  }
}
