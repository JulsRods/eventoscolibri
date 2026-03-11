import 'package:flutter/material.dart';
import 'package:clase5/modelo/evento.dart';
import 'package:clase5/controlador/evento_service.dart';
import 'package:clase5/vista/editar_evento_screen.dart';
import 'package:intl/intl.dart';

class EventoDetallesScreen extends StatefulWidget {
  final Evento evento;

  EventoDetallesScreen({required this.evento});

  @override
  _EventoDetallesScreenState createState() => _EventoDetallesScreenState();
}

class _EventoDetallesScreenState extends State<EventoDetallesScreen> {
  late Stream<Evento> _eventoStream;

  @override
  void initState() {
    super.initState();
    _eventoStream = EventoService().getEventoStream(widget.evento.id);
  }

  void _eliminarEvento(BuildContext context) async {
    await EventoService().deleteEvento(widget.evento.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.evento.nombre} ${widget.evento.apellido}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<Evento>(
          stream: _eventoStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No se encontraron datos del evento'));
            } else {
              final eventoActualizado = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Detalles del Evento'),
                  _buildDetailItem(
                      'Organización', eventoActualizado.organizacion),
                  _buildDetailItem('Salón', eventoActualizado.nombreSalon),
                  _buildDetailItem('Celular', eventoActualizado.celular),
                  _buildDetailItem('Email', eventoActualizado.email),
                  _buildDetailItem(
                      'Fecha',
                      _formatDate(eventoActualizado
                          .fechaEvento)), // Formatea la fecha aquí
                  _buildDetailItem(
                      'Necesidades', eventoActualizado.necesidades),
                  _buildDetailItem('Extras', eventoActualizado.extras),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        text: 'Editar Evento',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarEventoScreen(evento: eventoActualizado),
                            ),
                          );
                        },
                      ),
                      _buildButton(
                        text: 'Eliminar Evento',
                        onPressed: () => _eliminarEvento(context),
                        buttonColor: Colors.red,
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Widget _buildButton(
      {required String text,
      required Function() onPressed,
      Color? buttonColor}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            buttonColor ?? Theme.of(context).primaryColor),
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
