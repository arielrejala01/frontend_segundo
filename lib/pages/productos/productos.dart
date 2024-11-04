import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/pages/categorias/models/categoria_model.dart';
import 'package:frontend_segundo/pages/productos/bloc/producto_bloc.dart';
import 'package:frontend_segundo/pages/productos/functions.dart';
import 'package:frontend_segundo/pages/productos/producto_form.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
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
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                    color: Color.fromRGBO(76, 89, 153, 0.5),
                    thickness: 0.25,
                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.productos?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProductoForm(
                          producto: state.productos?[index],
                        );
                      }));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 108, 166, 236),
                                shape: BoxShape.circle),
                            child: const Icon(
                              FontAwesomeIcons.breadSlice,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.productos?[index].nombre ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  state.productos?[index].categoria?.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDeleteDialog(
                                  context, state.productos?[index].idProducto);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 4),
                              width: 30,
                              height: 30,
                              child: const Icon(
                                FontAwesomeIcons.xmark,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
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
