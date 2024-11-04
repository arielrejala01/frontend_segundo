import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_segundo/pages/productos/models/producto_model.dart';
import 'package:frontend_segundo/pages/ventas/compras/bloc/carrito_bloc.dart';
import 'package:frontend_segundo/pages/ventas/compras/models/item_carrito_model.dart';

class CantidadProductos extends StatefulWidget {
  final ProductoModel? producto;
  const CantidadProductos({
    Key? key,
    this.producto,
  }) : super(key: key);

  @override
  State<CantidadProductos> createState() => _CantidadProductosState();
}

class _CantidadProductosState extends State<CantidadProductos> {
  int cantidad = 1;
  bool addMoreItems = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CarritoBloc, CarritoState>(
          bloc: BlocProvider.of<CarritoBloc>(context),
          builder: (BuildContext context, CarritoState state) {
            if (state is CarritoInitial) {
              return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()));
            }
            if (state is CarritoLoaded) {
              ItemCarritoModel? productInCart = checkProductInCart(
                  state: state, nombre: widget.producto?.nombre);
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 108, 166, 236),
                              width: 2.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    cantidad > 1 ? cantidad-- : cantidad = 1;
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.grey[500],
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                cantidad.toString(),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 108, 166, 236)),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    cantidad++;
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.grey[500],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (true)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (productInCart != null) {
                              BlocProvider.of<CarritoBloc>(context)
                                  .add(UpdateItemCarrito(
                                item: ItemCarritoModel(
                                    id: productInCart.id,
                                    producto: productInCart.producto,
                                    cantidad:
                                        productInCart.cantidad! + cantidad,
                                    precio: productInCart.precio),
                              ));
                            } else {
                              BlocProvider.of<CarritoBloc>(context).add(
                                  AddItemCarrito(
                                      producto: widget.producto,
                                      cantidad: cantidad,
                                      precioVenta:
                                          widget.producto?.precioVenta));
                            }
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 108, 166, 236),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Agregar al carrito',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
            return Container();
          }),
    );
  }

  ItemCarritoModel? checkProductInCart({CarritoLoaded? state, String? nombre}) {
    for (ItemCarritoModel item in (state?.items)!) {
      if (item.producto?.nombre == nombre) {
        return item;
      }
    }
    return null;
  }
}
