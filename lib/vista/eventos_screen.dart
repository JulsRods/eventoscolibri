import 'package:flutter/material.dart';
import 'package:clase5/modelo/evento.dart';
import 'package:clase5/controlador/evento_service.dart';
import 'package:clase5/vista/evento_detalles_screen.dart';
import 'package:clase5/vista/agregar_evento_screen.dart';
import 'package:intl/intl.dart';

class EventosScreen extends StatefulWidget {
  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de Eventos'),
      ),
      body: StreamBuilder<List<Evento>>(
        stream: EventoService().getEventosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay eventos disponibles'));
          } else {
            final eventos = snapshot.data!;
            eventos.sort((a, b) => a.fechaEvento.compareTo(b.fechaEvento));
            return ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        '${evento.nombre} ${evento.apellido}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          _buildDetailRow(Icons.business, 'Organización',
                              evento.organizacion),
                          _buildDetailRow(
                              Icons.place, 'Salón', evento.nombreSalon),
                          _buildDetailRow(
                              Icons.date_range,
                              'Fecha y Hora',
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(evento.fechaEvento)),
                          _buildDetailRow(
                              Icons.list, 'Necesidades', evento.necesidades),
                          _buildDetailRow(Icons.add, 'Extras', evento.extras),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventoDetallesScreen(evento: evento),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
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
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
