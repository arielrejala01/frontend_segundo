import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/categorias/bloc/categoria_bloc.dart';
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
  CategoriaModel? categoriaSelected;

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
          margin: const EdgeInsets.only(top: 20, bottom: 10),
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
                      BlocProvider.of<ProductoBloc>(context).add(SearchProducto(
                          text: _searchText, categoria: categoriaSelected));
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Buscar por nombre',
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
        BlocBuilder<CategoriaBloc, CategoriaState>(
          builder: (context, state) {
            if (state is CategoriaLoaded) {
              return SizedBox(
                height: 65,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: state.categorias?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        CategoriaModel? prevValue = categoriaSelected;
                        setState(() {
                          if (prevValue == state.categorias?[index]) {
                            categoriaSelected = null;
                          } else {
                            categoriaSelected = state.categorias?[index];
                          }
                        });
                        BlocProvider.of<ProductoBloc>(context).add(
                            SearchProducto(
                                text: _searchText,
                                categoria: categoriaSelected));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: state.categorias?[index] == categoriaSelected
                                ? const Color.fromRGBO(132, 182, 244, 1)
                                : Colors.white,
                            border: state.categorias?[index] ==
                                    categoriaSelected
                                ? null
                                : Border.all(
                                    color:
                                        const Color.fromRGBO(145, 145, 145, 1),
                                  ),
                            shape: BoxShape.circle),
                        child: Icon(
                          IconData(
                            state.categorias?[index].codePoint ?? 0,
                            fontFamily: state.categorias?[index].fontFamily,
                            fontPackage: state.categorias?[index].fontPackage,
                          ),
                          color: state.categorias?[index] == categoriaSelected
                              ? Colors.white
                              : const Color.fromRGBO(145, 145, 145, 1),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return Container();
          },
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
                      height: 250,
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
