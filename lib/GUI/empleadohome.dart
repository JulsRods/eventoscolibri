import 'package:clase5/controlador/autenticar.dart';
import 'package:clase5/vista/calendario_screen.dart';
import 'package:clase5/vista/catalogo_screen.dart';
import 'package:clase5/vista/commen.dart';
import 'package:clase5/vista/cotizador_screen.dart';
import 'package:clase5/vista/eventos_screen.dart';
import 'package:clase5/vista/home_screen.dart';
import 'package:clase5/vista/listEmp.dart';
import 'package:clase5/vista/listU.dart';
import 'package:clase5/vista/preguntas_frecuente.dart';
import 'package:flutter/material.dart';

class HomeE extends StatefulWidget {
  const HomeE({super.key});

  @override
  State<HomeE> createState() => _HomeEState();
}

class _HomeEState extends State<HomeE> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final authServices = AuthServices();
    final role = await authServices.getUserRoleFromPrefs();
    setState(() {
      userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos Colibrí',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/catalogo': (context) => CatalogoScreen(),
        '/calendario': (context) => CalendarioScreen(),
        '/eventos': (context) => EventosScreen(),
        '/cotizador': (context) => CotizarScreen(),
        '/preguntas': (context) => FaqScreen(),
        '/comentarios': (context) => ComentarioScreen(),
        if (userRole != 'Empleado' && userRole == 'Admin')
          '/empleados': (context) => ListScreen(),
        if (userRole != 'Empleado' && userRole == 'Admin')
          '/usuarios': (context) => List2Screen(),
      },
    );
  }
}
