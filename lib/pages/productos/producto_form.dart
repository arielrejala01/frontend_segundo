import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/categorias/bloc/categoria_bloc.dart';
import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';
import 'package:frontend_segundo/pages/productos/bloc/producto_bloc.dart';
import 'package:frontend_segundo/pages/productos/models/producto_model.dart';
import 'package:frontend_segundo/services/image_picker_services.dart';

class ProductoForm extends StatefulWidget {
  final ProductoModel? producto;
  const ProductoForm({this.producto, super.key});

  @override
  State<ProductoForm> createState() => _ProductoFormState();
}

class _ProductoFormState extends State<ProductoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _precioEditingController =
      TextEditingController();
  final TextEditingController _stockEditingController = TextEditingController();
  List<CategoriaModel>? categorias;
  CategoriaModel? categoriaSeleccionada;
  String? photoPath;

  @override
  void initState() {
    super.initState();

    loadCategorias();

    if (widget.producto != null) {
      _nameEditingController.text = widget.producto?.nombre ?? '';
      _precioEditingController.text =
          widget.producto?.precioVenta.toString() ?? '';
      _stockEditingController.text = widget.producto?.stock.toString() ?? '';
      categoriaSeleccionada = widget.producto?.categoria;
      photoPath = widget.producto?.imagePath;
    }
  }

  void loadCategorias() {
    BlocProvider.of<CategoriaBloc>(context).add(LoadCategorias());
    CategoriaState state = BlocProvider.of<CategoriaBloc>(context).state;
    if (state is CategoriaLoaded) {
      categorias = state.categorias;
    }
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                widget.producto != null
                    ? 'Editar un producto'
                    : 'Agregar un producto',
                style: const TextStyle(fontSize: 22),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _precioEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un precio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _stockEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una cantidad';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DropdownButton<CategoriaModel>(
                      hint: const Text("Selecciona una categoría"),
                      dropdownColor: Colors.white,
                      value: categoriaSeleccionada,
                      onChanged: (CategoriaModel? newValue) {
                        setState(() {
                          categoriaSeleccionada = newValue;
                        });
                      },
                      items: categorias?.map((CategoriaModel categoria) {
                        return DropdownMenuItem<CategoriaModel>(
                          value: categoria,
                          child: Text(categoria.name ?? ''),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(132, 182, 244, 1)),
                      ),
                      onPressed: () async {
                        final path = await CameraGalleryService().selectPhoto();
                        if (path == null) return;
                        setState(() {
                          photoPath = path;
                        });
                      },
                      child: const Text(
                        'Seleccionar una imagen',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                    if (photoPath != null)
                      SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.file(File(photoPath ?? '')))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (widget.producto != null) {
              BlocProvider.of<ProductoBloc>(context).add(UpdateProducto(
                  producto: ProductoModel(
                      idProducto: widget.producto?.idProducto,
                      nombre: _nameEditingController.text,
                      categoria: categoriaSeleccionada,
                      precioVenta: double.parse(_precioEditingController.text),
                      stock: int.parse(_stockEditingController.text),
                      imagePath: photoPath)));
            } else {
              BlocProvider.of<ProductoBloc>(context).add(AddProducto(
                  producto: ProductoModel(
                      nombre: _nameEditingController.text,
                      categoria: categoriaSeleccionada,
                      precioVenta: double.parse(_precioEditingController.text),
                      stock: int.parse(_stockEditingController.text),
                      imagePath: photoPath)));
            }

            Navigator.of(context).pop();
          }
        },
        child: const Icon(FontAwesomeIcons.floppyDisk),
      ),
    );
  }
}
