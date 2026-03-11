import 'package:flutter/material.dart';
import 'package:clase5/modelo/salon.dart';
import 'package:clase5/controlador/salon_service.dart';
import 'package:clase5/vista/editar_salon_screen.dart';

class SalonDetallesScreen extends StatelessWidget {
  final Salon salon;
  final SalonService _salonService = SalonService();

  SalonDetallesScreen({required this.salon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(salon.nombre),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarSalonScreen(salon: salon),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _salonService.deleteSalon(salon.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<Salon>(
        stream: _salonService.getSalonStream(salon.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontraron datos del salón.'));
          } else {
            final updatedSalon = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      updatedSalon.imagenUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/person.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  updatedSalon.nombre,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text('Reservaciones',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${updatedSalon.reservaciones}',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text('Ubicación',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(updatedSalon.ubicacion,
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text('Contacto',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(updatedSalon.contacto,
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text('Descripción',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(updatedSalon.descripcion,
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
