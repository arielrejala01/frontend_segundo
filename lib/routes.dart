import 'package:flutter/material.dart';
import 'package:frontend_segundo/pages/categorias/categoria_form.dart';
import 'package:frontend_segundo/pages/productos/producto_form.dart';
import 'package:frontend_segundo/pages/ventas/compras/carrito.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/add_categoria': (BuildContext context) => const CategoriaForm(),
  '/add_producto': (BuildContext context) => const ProductoForm(),
  '/carrito': (BuildContext context) => const Carrito(),
};
