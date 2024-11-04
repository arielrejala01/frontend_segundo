import 'package:flutter/material.dart';
import 'package:frontend_segundo/pages/productos/models/producto_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/components/cantidad_productos.dart';

class ProductoCard extends StatefulWidget {
  final ProductoModel? producto;
  const ProductoCard(this.producto, {super.key});

  @override
  State<ProductoCard> createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade400)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.producto?.nombre ?? '',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          ),
          Text(widget.producto?.categoria?.name ?? '',
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          Text('${widget.producto?.precioVenta.toString()} \$',
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return CantidadProductos(producto: widget.producto);
                  });
            },
            child: Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 108, 166, 236),
                  borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: const Text(
                'Agregar al carrito',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
