import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';
import 'package:frontend_segundo/pages/productos/bloc/producto_bloc.dart';
import 'package:frontend_segundo/pages/ventas/compras/buscador/producto_card.dart';

class Buscador extends StatefulWidget {
  const Buscador({super.key});

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  final TextEditingController _textEditingController = TextEditingController();
  FocusNode? _focusNode;
  String _searchText = '';
  List<CategoriaModel>? categorias;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 0.5)),
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.only(left: 12),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(children: [
            Expanded(
              child: IntrinsicHeight(
                child: FractionalTranslation(
                  translation: const Offset(0.0, -0.11),
                  child: TextField(
                    controller: _textEditingController,
                    enableSuggestions: false,
                    autocorrect: false,
                    focusNode: _focusNode,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (String value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    onSubmitted: (String value) {
                      _searchText = value;
                      FocusScope.of(context).unfocus();
                      BlocProvider.of<ProductoBloc>(context)
                          .add(SearchProducto(text: _searchText));
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Buscar por nombre o categoría',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    cursorColor: const Color.fromARGB(255, 108, 166, 236),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<ProductoBloc>(context)
                    .add(SearchProducto(text: _searchText));
              },
              child: Container(
                  height: double.infinity,
                  width: 45,
                  color: const Color.fromARGB(255, 108, 166, 236),
                  child: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 22,
                    color: Colors.white,
                  )),
            ),
          ]),
        ),
        const Divider(
          thickness: 0.5,
          height: 5,
        ),
        Expanded(
          child: BlocBuilder<ProductoBloc, ProductoState>(
              builder: (context, state) {
            if (state is ProductoInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductoLoaded) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.productos?.length ?? 0,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350,
                      height: 200,
                      child: ProductoCard(state.productos?[index]),
                    ),
                  );
                },
              );
            }
            return Container();
          }),
        )
      ],
    );
  }
}
