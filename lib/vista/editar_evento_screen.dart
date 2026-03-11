import 'package:flutter/material.dart';
import 'package:clase5/modelo/evento.dart';
import 'package:clase5/controlador/evento_service.dart';
import 'package:intl/intl.dart';

class EditarEventoScreen extends StatefulWidget {
  final Evento evento;

  EditarEventoScreen({required this.evento});

  @override
  _EditarEventoScreenState createState() => _EditarEventoScreenState();
}

class _EditarEventoScreenState extends State<EditarEventoScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _emailController;
  late TextEditingController _celularController;
  late TextEditingController _organizacionController;
  late TextEditingController _nombreSalonController;
  late TextEditingController _necesidadesController;
  late TextEditingController _extrasController;
  late DateTime _fechaEvento;
  late TimeOfDay _horaEvento;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.evento.nombre);
    _apellidoController = TextEditingController(text: widget.evento.apellido);
    _emailController = TextEditingController(text: widget.evento.email);
    _celularController = TextEditingController(text: widget.evento.celular);
    _organizacionController =
        TextEditingController(text: widget.evento.organizacion);
    _nombreSalonController =
        TextEditingController(text: widget.evento.nombreSalon);
    _necesidadesController =
        TextEditingController(text: widget.evento.necesidades);
    _extrasController = TextEditingController(text: widget.evento.extras);
    _fechaEvento = widget.evento.fechaEvento;
    _horaEvento = TimeOfDay.fromDateTime(widget.evento.fechaEvento);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _celularController.dispose();
    _organizacionController.dispose();
    _nombreSalonController.dispose();
    _necesidadesController.dispose();
    _extrasController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaEvento,
      firstDate: DateTime(2023),
      lastDate: DateTime(2027),
    );
    if (picked != null && picked != _fechaEvento) {
      setState(() {
        _fechaEvento = picked;
        _horaEvento = TimeOfDay.now(); // Resetear la hora al cambiar la fecha
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaEvento,
    );
    if (picked != null && picked != _horaEvento) {
      setState(() {
        _horaEvento = picked;
      });
    }
  }

  void _guardarEvento() async {
    if (_nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty ||
        _emailController.text.isEmpty ||
        !_emailController.text.contains('@') ||
        _celularController.text.isEmpty ||
        _organizacionController.text.isEmpty ||
        _nombreSalonController.text.isEmpty ||
        _necesidadesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor completa todos los campos y en el email coloca un @')),
      );
      return;
    }

    final DateTime fechaHoraEvento = DateTime(
      _fechaEvento.year,
      _fechaEvento.month,
      _fechaEvento.day,
      _horaEvento.hour,
      _horaEvento.minute,
    );

    final Evento eventoActualizado = Evento(
      id: widget.evento.id,
      nombre: _nombreController.text,
      apellido: _apellidoController.text,
      email: _emailController.text,
      celular: _celularController.text,
      organizacion: _organizacionController.text,
      nombreSalon: _nombreSalonController.text,
      fechaEvento: fechaHoraEvento,
      necesidades: _necesidadesController.text,
      extras: _extrasController.text,
    );

    await EventoService().updateEvento(eventoActualizado);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evento guardado exitosamente')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
              controller: _nombreController,
              label: 'Nombre',
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingresa un nombre'
                  : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _apellidoController,
              label: 'Apellido',
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingresa un apellido'
                  : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un email';
                } else if (!value.contains('@')) {
                  return 'Por favor ingresa un email válido';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _celularController,
              label: 'Celular',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un número de celular';
                } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                  return 'Por favor ingresa solo números';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _organizacionController,
              label: 'Organización',
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingresa una organización'
                  : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _nombreSalonController,
              label: 'Nombre del Salón',
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingresa el nombre del salón'
                  : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _necesidadesController,
              label: 'Necesidades',
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingresa las necesidades'
                  : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _extrasController,
              label: 'Extras',
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingresa los extras'
                  : null,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaEvento)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Seleccionar Fecha'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Hora: ${_horaEvento.format(context)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Seleccionar Hora'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarEvento,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: validator(controller.text) != null
                  ? Icon(Icons.error, color: Colors.red)
                  : null,
            ),
            keyboardType: keyboardType,
            validator: validator,
          ),
          SizedBox(
              height: 8), // Espacio adicional entre campos y mensajes de error
          if (validator(controller.text) != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                validator(controller.text)!, // Mostrar el mensaje de error
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
