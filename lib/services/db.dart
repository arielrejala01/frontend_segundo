import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  Database? _database;
  static const int version = 7;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'front.db'),
      version: version,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        Batch batch = db.batch();

        batch.execute('''
          CREATE TABLE Categoria (
              idCategoria INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              codePoint INTEGER NOT NULL,
              fontFamily TEXT NOT NULL,
              fontPackage TEXT
          );
        ''');

        batch.execute('''
CREATE TABLE Productos(
                    idProducto INTEGER PRIMARY KEY AUTOINCREMENT,
                    nombre TEXT NOT NULL,
                    idCategoria INTEGER,
                    precioVenta REAL NOT NULL,
                    stock INTEGER NOT NULL,
                    imagePath TEXT NOT NULL,
                    FOREIGN KEY(idCategoria) REFERENCES Categoria(idCategoria)
                );
        ''');

        batch.execute('''
CREATE TABLE Venta(
                    idVenta INTEGER PRIMARY KEY AUTOINCREMENT,
                    fecha TEXT NOT NULL,
                    idCliente INTEGER,
                    total REAL NOT NULL,
                    tipoOperacion TEXT NOT NULL,
                    direccionEntrega TEXT,
                    lat REAL,
                    lon REAL,
                    FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
                );
        ''');

        batch.execute('''
CREATE TABLE DetalleVenta(
                    idDetalleVenta INTEGER PRIMARY KEY AUTOINCREMENT,
                    idVenta INTEGER,
                    idProducto INTEGER,
                    cantidad INTEGER NOT NULL,
                    precio REAL NOT NULL,
                    FOREIGN KEY(idVenta) REFERENCES Venta(idVenta),
                    FOREIGN KEY(idProducto) REFERENCES Productos(idProducto)
                );
        ''');

        batch.execute('''
CREATE TABLE Cliente(
                    idCliente INTEGER PRIMARY KEY AUTOINCREMENT,
                    cedula TEXT NOT NULL,
                    nombre TEXT NOT NULL,
                    apellido TEXT NOT NULL
                );
        ''');

        batch.execute('''
          CREATE TABLE Carrito (
            idCarrito INTEGER PRIMARY KEY AUTOINCREMENT,
            tipoOperacion TEXT,
            direccionEntrega TEXT,
            lat REAL,
            lon REAL
          );
        ''');

        batch.execute('''
          CREATE TABLE CarritoDetalles (
            idDetalle INTEGER PRIMARY KEY AUTOINCREMENT,
            idCarrito INTEGER,
            idProducto INTEGER,
            cantidad INTEGER NOT NULL,
            precioVenta REAL,
            FOREIGN KEY(idCarrito) REFERENCES Carrito(idCarrito),
            FOREIGN KEY(idProducto) REFERENCES Productos(idProducto)
          );
        ''');

        await batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        Batch batch = db.batch();

        batch.execute('DROP TABLE IF EXISTS Categoria');
        batch.execute('DROP TABLE IF EXISTS Productos');
        batch.execute('DROP TABLE IF EXISTS Venta');
        batch.execute('DROP TABLE IF EXISTS DetalleVenta');
        batch.execute('DROP TABLE IF EXISTS Cliente');
        batch.execute('DROP TABLE IF EXISTS Carrito');

        batch.execute('''
          CREATE TABLE Categoria (
              idCategoria INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              codePoint INTEGER NOT NULL,
              fontFamily TEXT NOT NULL,
              fontPackage TEXT
          );
        ''');

        batch.execute('''
CREATE TABLE Productos(
                    idProducto INTEGER PRIMARY KEY AUTOINCREMENT,
                    nombre TEXT NOT NULL,
                    idCategoria INTEGER,
                    precioVenta REAL NOT NULL,
                    stock INTEGER NOT NULL,
                    imagePath TEXT NOT NULL,
                    FOREIGN KEY(idCategoria) REFERENCES Categoria(idCategoria)
                );
        ''');

        batch.execute('''
CREATE TABLE Venta(
                    idVenta INTEGER PRIMARY KEY AUTOINCREMENT,
                    fecha TEXT NOT NULL,
                    idCliente INTEGER,
                    total REAL NOT NULL,
                    tipoOperacion TEXT NOT NULL,
                    direccionEntrega TEXT,
                    lat REAL,
                    lon REAL,
                    FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
                );
        ''');

        batch.execute('''
CREATE TABLE DetalleVenta(
                    idDetalleVenta INTEGER PRIMARY KEY AUTOINCREMENT,
                    idVenta INTEGER,
                    idProducto INTEGER,
                    cantidad INTEGER NOT NULL,
                    precio REAL NOT NULL,
                    FOREIGN KEY(idVenta) REFERENCES Venta(idVenta),
                    FOREIGN KEY(idProducto) REFERENCES Productos(idProducto)
                );
        ''');

        batch.execute('''
CREATE TABLE Cliente(
                    idCliente INTEGER PRIMARY KEY AUTOINCREMENT,
                    cedula TEXT NOT NULL,
                    nombre TEXT NOT NULL,
                    apellido TEXT NOT NULL
                );
        ''');

        batch.execute('''
          CREATE TABLE Carrito (
            idCarrito INTEGER PRIMARY KEY AUTOINCREMENT,
            tipoOperacion TEXT,
            direccionEntrega TEXT,
            lat REAL,
            lon REAL
          );
        ''');

        batch.execute('''
          CREATE TABLE CarritoDetalles (
            idDetalle INTEGER PRIMARY KEY AUTOINCREMENT,
            idCarrito INTEGER,
            idProducto INTEGER,
            cantidad INTEGER NOT NULL,
            precioVenta REAL,
            FOREIGN KEY(idCarrito) REFERENCES Carrito(idCarrito),
            FOREIGN KEY(idProducto) REFERENCES Productos(idProducto)
          );
        ''');

        await batch.commit();
      },
    );
  }
}
