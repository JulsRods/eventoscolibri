import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:clase5/modelo/evento.dart';
import 'package:clase5/controlador/evento_service.dart';
import 'package:clase5/vista/agregar_evento_screen.dart';
import 'package:clase5/vista/detallesEvento_calendario.dart';
import 'dart:collection';

class CalendarioScreen extends StatefulWidget {
  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Eventos'),
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
            final eventMap = _getEventMap(eventos);

            return Column(
              children: [
                TableCalendar<Evento>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: _onDaySelected,
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  eventLoader: (day) => _getEventsForDay(eventMap, day),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            color: Colors.blue,
                            child: Text(
                              '${events.length}',
                              style: TextStyle().copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(color: Colors.black),
                    weekendTextStyle: TextStyle(color: Colors.red),
                    holidayTextStyle: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _getEventsForDay(eventMap, _selectedDay).length,
                    itemBuilder: (context, index) {
                      final event =
                          _getEventsForDay(eventMap, _selectedDay)[index];
                      return Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            event.nombre,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'Organización: ${event.organizacion}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Fecha: ${event.fechaEvento}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventoDetallesScreen(evento: event),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
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

  Map<DateTime, List<Evento>> _getEventMap(List<Evento> eventos) {
    final Map<DateTime, List<Evento>> eventMap = {};
    for (var event in eventos) {
      final eventDate = DateTime(
        event.fechaEvento.year,
        event.fechaEvento.month,
        event.fechaEvento.day,
      );
      if (eventMap[eventDate] == null) {
        eventMap[eventDate] = [];
      }
      eventMap[eventDate]?.add(event);
    }
    return LinkedHashMap<DateTime, List<Evento>>(
      equals: isSameDay,
      hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll(eventMap);
  }

  List<Evento> _getEventsForDay(
      Map<DateTime, List<Evento>> events, DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }
}
