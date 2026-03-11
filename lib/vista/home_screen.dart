import 'package:clase5/GUI/login.dart';
import 'package:clase5/controlador/autenticar.dart';
import 'package:clase5/controlador/evento_service.dart';
import 'package:clase5/modelo/evento.dart';
import 'package:clase5/vista/agregar_evento_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<Evento>> _eventosStream;
  final EventoService _eventoService = EventoService();
  String? userRole;

  @override
  void initState() {
    super.initState();
    _eventosStream = _eventoService.getEventosStream();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://static.wixstatic.com/media/04b44a_b366ba583f014f019532598992cccace~mv2.png/v1/fill/w_708,h_169,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Logo%20versi%C3%B3n%202%20Eventos%20Colibr%C3%AD_4x_edited.png',
          height: 50,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Cerrar sesión
              await AuthServices().signOut();

              // Eliminar preferencias almacenadas (cerrar sesión)
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.remove('Email');
              await prefs.remove('userRole');

              // Navegar a la pantalla de login
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Evento>>(
        stream: _eventosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay eventos disponibles'));
          } else {
            List<Evento> eventos = snapshot.data!;
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://yourimageurl.com/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenido a Eventos Colibrí',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoCard2(eventos),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Rápido acceso:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            children: [
                              _buildQuickAccessButton(
                                  context, 'Salones', '/catalogo', Icons.list),
                              _buildQuickAccessButton(context, 'Calendario',
                                  '/calendario', Icons.calendar_today),
                              _buildQuickAccessButton(context, 'Eventos',
                                  '/eventos', Icons.visibility),
                              _buildQuickAccessButton(context, 'Cotizador',
                                  '/cotizador', Icons.calculate),
                              _buildQuickAccessButton(context, 'Preguntas',
                                  '/preguntas', Icons.question_mark_rounded),
                              _buildQuickAccessButton(context, 'Comentarios',
                                  '/comentarios', Icons.comment),
                              if (userRole == 'Admin')
                                _buildQuickAccessButton(context, 'Empleados',
                                    '/empleados', Icons.list),
                              if (userRole == 'Admin')
                                _buildQuickAccessButton(context, 'Usuarios',
                                    '/usuarios', Icons.list),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menú'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Catálogo de Salones'),
              onTap: () {
                Navigator.pushNamed(context, '/catalogo');
              },
            ),
            ListTile(
              title: Text('Calendario de Reservas'),
              onTap: () {
                Navigator.pushNamed(context, '/calendario');
              },
            ),
            ListTile(
              title: Text('Visualización de Eventos'),
              onTap: () {
                Navigator.pushNamed(context, '/eventos');
              },
            ),
            ListTile(
              title: Text('Cotizador'),
              onTap: () {
                Navigator.pushNamed(context, '/cotizador');
              },
            ),
            ListTile(
              title: Text('Preguntas'),
              onTap: () {
                Navigator.pushNamed(context, '/preguntas');
              },
            ),
            ListTile(
              title: Text('Comentarios'),
              onTap: () {
                Navigator.pushNamed(context, '/comentarios');
              },
            ),
            if (userRole == 'Admin')
              ListTile(
                title: Text('Empleados'),
                onTap: () {
                  Navigator.pushNamed(context, '/empleados');
                },
              ),
            if (userRole == 'Admin')
              ListTile(
                title: Text('Usuarios'),
                onTap: () {
                  Navigator.pushNamed(context, '/usuarios');
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarEventoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoCard(String title, String data, IconData icon) {
    return Card(
      elevation: 4,
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              data,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard2(List<Evento> eventos) {
    DateTime hoy = DateTime.now();
    List<Evento> eventosFuturos =
        eventos.where((evento) => evento.fechaEvento.isAfter(hoy)).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              'Próximos Eventos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              eventosFuturos.length.toString(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(
      BuildContext context, String title, String route, IconData icon) {
    return Card(
      elevation: 4,
      color: Colors.white70,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
