import 'package:flutter/material.dart';
import 'package:clase5/modelo/cotizacion.dart';
import 'package:clase5/controlador/cotizacion_service.dart';
import 'package:clase5/vista/cotizador_screen.dart';

class RegistroCotizacionesScreen extends StatefulWidget {
  @override
  _RegistroCotizacionesScreenState createState() =>
      _RegistroCotizacionesScreenState();
}

class _RegistroCotizacionesScreenState
    extends State<RegistroCotizacionesScreen> {
  final CotizacionService _cotizacionService = CotizacionService();
  late Stream<List<Cotizacion>> _cotizacionesStream;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _cotizacionesStream = _cotizacionService.getCotizacionesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: Text('Registro de Cotizaciones'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CotizarScreen()),
            );
          },
        ),
      ),
      body: StreamBuilder<List<Cotizacion>>(
        stream: _cotizacionesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las cotizaciones'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay cotizaciones registradas'));
          }

          List<Cotizacion> cotizaciones = snapshot.data!;

          return ListView.builder(
            itemCount: cotizaciones.length,
            itemBuilder: (context, index) {
              Cotizacion cotizacion = cotizaciones[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(cotizacion.tipoEvento),
                  subtitle: Text(
                      'Asistentes: ${cotizacion.numAsistentes}, Invitados: ${cotizacion.numInvitados}, Duración: ${cotizacion.duracionEvento}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\Lps${cotizacion.cotizacion.toStringAsFixed(2)}'),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _eliminarCotizacion(cotizacion.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _mostrarDetallesCotizacion(context, cotizacion);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _eliminarCotizacion(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Cotización'),
          content: Text('¿Está seguro que desea eliminar esta cotización?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                _cotizacionService.deleteCotizacion(id).then((_) {
                  _scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Cotización eliminada con éxito')),
                  );
                }).catchError((error) {
                  _scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                        content:
                            Text('Error al eliminar la cotización: $error')),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetallesCotizacion(BuildContext context, Cotizacion cotizacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la Cotización'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tipo de Evento: ${cotizacion.tipoEvento}'),
              Text('Asistentes: ${cotizacion.numAsistentes}'),
              Text('Invitados: ${cotizacion.numInvitados}'),
              Text('Duración: ${cotizacion.duracionEvento}'),
              Text('Necesidades: ${cotizacion.necesidades}'),
              Text('Servicios: ${cotizacion.servicios}'),
              Text(
                  'Cotización: \Lps${cotizacion.cotizacion.toStringAsFixed(2)}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
