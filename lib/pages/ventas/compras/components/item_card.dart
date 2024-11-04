import 'package:flutter/material.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/item_carrito_model.dart';

class ItemCard extends StatefulWidget {
  final ItemCarritoModel? item;
  const ItemCard(this.item, {super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade400)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.item?.producto?.nombre ?? '',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          ),
          Text('${widget.item?.precio.toString()} \$',
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          Text('${widget.item?.cantidad} unidades',
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Total: ',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              Text(
                  '${calcularTotalItem(widget.item?.cantidad ?? 0, widget.item?.precio ?? 0).toString()} \$',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  double calcularTotalItem(int cantidad, double precio) {
    return cantidad * precio;
  }
}
