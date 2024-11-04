import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_segundo/components/floating_action_button.dart';
import 'package:frontend_segundo/pages.dart';
import 'package:frontend_segundo/pages/categorias/bloc/categoria_bloc.dart';
import 'package:frontend_segundo/pages/productos/bloc/producto_bloc.dart';
import 'package:frontend_segundo/pages/ventas/clientes/bloc/cliente_bloc.dart';
import 'package:frontend_segundo/pages/ventas/compras/bloc/carrito_bloc.dart';
import 'package:frontend_segundo/pages/ventas/consultas/bloc/pedido_bloc.dart';
import 'package:frontend_segundo/pages/ventas/consultas/detalles/bloc/detalle_bloc.dart';
import 'package:frontend_segundo/routes.dart';

void main() {
  runApp(const MyAppProviders());
}

class MyAppProviders extends StatelessWidget {
  const MyAppProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoriaBloc>(
          create: (context) => CategoriaBloc()..add(LoadCategorias()),
        ),
        BlocProvider<ProductoBloc>(
          create: (context) => ProductoBloc()..add(LoadProductos()),
        ),
        BlocProvider<CarritoBloc>(
          create: (context) => CarritoBloc()..add(LoadCarrito()),
        ),
        BlocProvider<ClienteBloc>(
          create: (context) => ClienteBloc(),
        ),
        BlocProvider<PedidoBloc>(
          create: (context) => PedidoBloc()..add(LoadPedidos()),
        ),
        BlocProvider<DetalleBloc>(
          create: (context) => DetalleBloc(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
      locale: const Locale('es'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(132, 182, 244, 1),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white, size: 30),
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

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
        body: Pages(
          index: selectedIndex,
        ),
        floatingActionButton: floatingActionButton(context, selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          selectedItemColor: const Color.fromRGBO(132, 182, 244, 1),
          unselectedItemColor: const Color.fromRGBO(160, 160, 160, 1),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.magnifyingGlass), label: ''),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.box), label: ''),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.breadSlice), label: ''),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.list), label: ''),
          ],
        ));
  }
}
