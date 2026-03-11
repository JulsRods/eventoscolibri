import 'package:flutter/material.dart';
import 'package:clase5/modelo/salon.dart';
import 'package:clase5/controlador/salon_service.dart';
import 'package:clase5/vista/salon_detallesU_screen.dart';

class CatalogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Salones'),
      ),
      body: StreamBuilder<List<Salon>>(
        stream: SalonService().getSalonesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay salones disponibles.'));
          } else {
            final salones = snapshot.data!;
            return ListView.builder(
              itemCount: salones.length,
              itemBuilder: (context, index) {
                final salon = salones[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          salon.imagenUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(salon.nombre),
                      subtitle: Text('Reservaciones: ${salon.reservaciones}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SalonDetallesScreen(salon: salon),
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
    );
  }
}
