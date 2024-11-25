import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_segundo/pages/ventas/compras/bloc/carrito_bloc.dart';
import 'package:latlong2/latlong.dart' as coordinates;

class MetodoEntrega extends StatefulWidget {
  const MetodoEntrega({super.key});

  @override
  State<MetodoEntrega> createState() => _MetodoEntregaState();
}

class _MetodoEntregaState extends State<MetodoEntrega> {
  String selectedOption = 'pickup';
  late SimpleLocationResult _selectedLocation;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = SimpleLocationResult(-25.30066, -57.63591);
    CarritoLoaded carrito =
        BlocProvider.of<CarritoBloc>(context).state as CarritoLoaded;
    if (carrito.tipo != null) {
      selectedOption = carrito.tipo!.toLowerCase();
      if (carrito.tipo == 'delivery') {
        _addressController.text = carrito.direccion ?? '';
        _selectedLocation.latitude = carrito.lat ?? -25.30066;
        _selectedLocation.longitude = carrito.lon ?? -57.63591;
      }
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
        body: Column(
          children: [
            const Text(
              'Selecciona una opción:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedOption = 'pickup';
                    });
                  },
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedOption == 'pickup'
                          ? const Color.fromRGBO(132, 182, 244, 1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: selectedOption == 'pickup'
                          ? null
                          : Border.all(
                              color: const Color.fromRGBO(145, 145, 145, 1),
                            ),
                    ),
                    child: Center(
                      child: Text(
                        'Pickup',
                        style: TextStyle(
                            color: selectedOption == 'pickup'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedOption = 'delivery';
                    });
                  },
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedOption == 'delivery'
                          ? const Color.fromRGBO(132, 182, 244, 1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: selectedOption == 'delivery'
                          ? null
                          : Border.all(
                              color: const Color.fromRGBO(145, 145, 145, 1),
                            ),
                    ),
                    child: Center(
                      child: Text(
                        'Delivery',
                        style: TextStyle(
                            color: selectedOption == 'delivery'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (selectedOption == 'delivery')
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: _selectedLocation.getLatLng(),
                                initialZoom: 12.0,
                                onTap: (tapLoc, position) {
                                  setState(() {
                                    _selectedLocation = SimpleLocationResult(
                                        position.latitude, position.longitude);
                                  });
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                ),
                                MarkerLayer(markers: [
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: _selectedLocation.getLatLng(),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Color.fromARGB(255, 255, 7, 7),
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 80,
          color: Colors.white,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 166, 236),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (selectedOption == 'pickup') {
                      BlocProvider.of<CarritoBloc>(context)
                          .add(AddMetodoEntrega(tipo: 'pickup'));
                    } else {
                      BlocProvider.of<CarritoBloc>(context).add(
                          AddMetodoEntrega(
                              tipo: 'delivery',
                              direccion: _addressController.text,
                              lat: _selectedLocation.latitude,
                              lon: _selectedLocation.longitude));
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Seleccionar método de entrega',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class SimpleLocationResult {
  double latitude;
  double longitude;

  SimpleLocationResult(this.latitude, this.longitude);

  getLatLng() => coordinates.LatLng(latitude, longitude);
}
