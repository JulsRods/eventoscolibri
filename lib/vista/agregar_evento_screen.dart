import 'package:flutter/material.dart';
import 'package:clase5/modelo/evento.dart';
import 'package:clase5/controlador/evento_service.dart';
import 'package:intl/intl.dart';

class AgregarEventoScreen extends StatefulWidget {
  @override
  _AgregarEventoScreenState createState() => _AgregarEventoScreenState();
}

class _AgregarEventoScreenState extends State<AgregarEventoScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _nombre;
  late String _apellido;
  late String _email;
  late String _celular;
  late String _organizacion;
  late String _nombreSalon;
  late DateTime _fechaEvento;
  late TimeOfDay _horaEvento;
  late String _necesidades;
  late String _extras;

  @override
  void initState() {
    super.initState();
    _fechaEvento = DateTime.now(); // Fecha por defecto
    _horaEvento = TimeOfDay.now(); // Hora por defecto
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaEvento,
      firstDate: DateTime(2023),
      lastDate: DateTime(2027),
    );
    if (pickedDate != null && pickedDate != _fechaEvento) {
      setState(() {
        _fechaEvento = pickedDate;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _horaEvento,
    );
    if (pickedTime != null && pickedTime != _horaEvento) {
      setState(() {
        _horaEvento = pickedTime;
      });
    }
  }

  void _guardarEvento() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final DateTime fechaHoraEvento = DateTime(
        _fechaEvento.year,
        _fechaEvento.month,
        _fechaEvento.day,
        _horaEvento.hour,
        _horaEvento.minute,
      );
      final nuevoEvento = Evento(
        id: '', // Este campo se ignora al agregar un nuevo evento
        nombre: _nombre,
        apellido: _apellido,
        email: _email,
        celular: _celular,
        organizacion: _organizacion,
        nombreSalon: _nombreSalon,
        fechaEvento: fechaHoraEvento,
        necesidades: _necesidades,
        extras: _extras,
      );

      await EventoService().addEvento(nuevoEvento);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Nombre',
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa un nombre'
                    : null,
                onSaved: (value) => _nombre = value!,
              ),
              _buildTextField(
                label: 'Apellido',
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa un apellido'
                    : null,
                onSaved: (value) => _apellido = value!,
              ),
              _buildTextField(
                label: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un email';
                  } else if (!value.contains('@')) {
                    return 'Por favor ingresa un email válido';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              _buildTextField(
                label: 'Celular',
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa un número de celular'
                    : null,
                onSaved: (value) => _celular = value!,
              ),
              _buildTextField(
                label: 'Organización',
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa una organización'
                    : null,
                onSaved: (value) => _organizacion = value!,
              ),
              _buildTextField(
                label: 'Nombre del Salón',
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa el nombre del salón'
                    : null,
                onSaved: (value) => _nombreSalon = value!,
              ),
              _buildTextField(
                label: 'Necesidades',
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa las necesidades'
                    : null,
                onSaved: (value) => _necesidades = value!,
              ),
              _buildTextField(
                label: 'Extras',
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length > 100) {
                      return 'Los extras no deben exceder los 100 caracteres';
                    }
                  }
                  return null;
                },
                onSaved: (value) => _extras = value ?? '',
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                    'Seleccionar Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaEvento)}'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text('Seleccionar Hora: ${_horaEvento.format(context)}'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardarEvento,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
