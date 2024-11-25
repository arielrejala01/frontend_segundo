import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/categorias/bloc/categoria_bloc.dart';
import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';

class CategoriaForm extends StatefulWidget {
  final CategoriaModel? categoria;
  const CategoriaForm({this.categoria, super.key});

  @override
  State<CategoriaForm> createState() => _CategoriaFormState();
}

class _CategoriaFormState extends State<CategoriaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  Icon? _icon;

  @override
  void initState() {
    super.initState();

    if (widget.categoria != null) {
      _nameEditingController.text = widget.categoria?.name ?? '';
      _icon = Icon(IconData(widget.categoria?.codePoint ?? 0,
          fontFamily: widget.categoria?.fontFamily,
          fontPackage: widget.categoria?.fontPackage));
    }
  }

  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: const SinglePickerConfiguration(
        iconPackModes: [IconPack.cupertino],
      ),
    );

    _icon = Icon(icon?.data);
    setState(() {});

    debugPrint('Picked Icon:  $_icon');
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              widget.categoria != null
                  ? 'Editar una categoría'
                  : 'Agregar una categoría',
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
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(132, 182, 244, 1)),
                    ),
                    onPressed: _pickIcon,
                    child: const Text(
                      'Seleccionar un ícono',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  if (_icon != null)
                    Row(
                      children: [
                        const Text(
                          'Ícono seleccionado: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        _icon!
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (widget.categoria != null) {
              BlocProvider.of<CategoriaBloc>(context).add(UpdateCategoria(
                  categoria: CategoriaModel(
                      id: widget.categoria?.id,
                      name: _nameEditingController.text,
                      codePoint: _icon?.icon?.codePoint,
                      fontFamily: _icon?.icon?.fontFamily,
                      fontPackage: _icon?.icon?.fontPackage)));
            } else {
              BlocProvider.of<CategoriaBloc>(context).add(AddCategoria(
                  categoria: CategoriaModel(
                      name: _nameEditingController.text,
                      codePoint: _icon?.icon?.codePoint,
                      fontFamily: _icon?.icon?.fontFamily,
                      fontPackage: _icon?.icon?.fontPackage)));
            }

            Navigator.of(context).pop();
          }
        },
        child: const Icon(FontAwesomeIcons.floppyDisk),
      ),
    );
  }
}
