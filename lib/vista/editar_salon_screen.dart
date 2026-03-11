import 'package:flutter/material.dart';
import 'package:clase5/modelo/salon.dart';
import 'package:clase5/controlador/salon_service.dart';
import 'package:http/http.dart' as http;

class EditarSalonScreen extends StatefulWidget {
  final Salon salon;

  EditarSalonScreen({required this.salon});

  @override
  _EditarSalonScreenState createState() => _EditarSalonScreenState();
}

class _EditarSalonScreenState extends State<EditarSalonScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _imagenUrlController;
  late TextEditingController _reservacionesController;
  late TextEditingController _contactoController;
  late TextEditingController _capacidadController;
  late TextEditingController _ubicacionController;
  late TextEditingController _descripcionController;
  final SalonService _salonService = SalonService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoadingImage = false;
  bool _isValidImageUrl = true;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.salon.nombre);
    _imagenUrlController = TextEditingController(text: widget.salon.imagenUrl);
    _reservacionesController =
        TextEditingController(text: widget.salon.reservaciones.toString());
    _contactoController = TextEditingController(text: widget.salon.contacto);
    _capacidadController =
        TextEditingController(text: widget.salon.capacidad.toString());
    _ubicacionController = TextEditingController(text: widget.salon.ubicacion);
    _descripcionController =
        TextEditingController(text: widget.salon.descripcion);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _imagenUrlController.dispose();
    _reservacionesController.dispose();
    _contactoController.dispose();
    _capacidadController.dispose();
    _ubicacionController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Salón'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nombreController,
                labelText: 'Nombre',
              ),
              _buildTextField(
                controller: _imagenUrlController,
                labelText: 'URL de la Imagen',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la URL de la imagen.';
                  }
                  if (!_isValidUrl(value)) {
                    return 'Por favor ingresa una URL válida.';
                  }
                  if (!_isValidImageUrl) {
                    return 'No se pudo cargar la imagen desde la URL.';
                  }
                  return null;
                },
                onChanged: (_) {
                  _updateImageUrlValidation();
                },
              ),
              _isLoadingImage
                  ? Center(child: CircularProgressIndicator())
                  : _buildImagePreview(),
              _buildTextField(
                controller: _reservacionesController,
                labelText: 'Reservaciones',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el número de reservaciones.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _contactoController,
                labelText: 'Contacto',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contacto del salón.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _capacidadController,
                labelText: 'Capacidad',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la capacidad del salón.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _ubicacionController,
                labelText: 'Ubicación',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la ubicación del salón.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _descripcionController,
                labelText: 'Descripción',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la descripción del salón.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Salon actualizado = Salon(
                      id: widget.salon.id,
                      nombre: _nombreController.text,
                      imagenUrl: _imagenUrlController.text,
                      reservaciones: int.parse(_reservacionesController.text),
                      contacto: _contactoController.text,
                      capacidad: int.parse(_capacidadController.text),
                      ubicacion: _ubicacionController.text,
                      descripcion: _descripcionController.text,
                    );
                    await _salonService.updateSalon(actualizado);
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  bool _isValidUrl(String url) {
    RegExp regExp = RegExp(
      r"^(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/)?",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(url);
  }

  void _updateImageUrlValidation() async {
    setState(() {
      _isLoadingImage = true;
      _isValidImageUrl = true; // Resetear el estado de la validación
    });

    try {
      final response = await http.get(Uri.parse(_imagenUrlController.text));
      setState(() {
        _isValidImageUrl = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        _isValidImageUrl = false;
      });
    } finally {
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  Widget _buildImagePreview() {
    if (_imagenUrlController.text.isEmpty) {
      return SizedBox.shrink();
    }

    if (_isValidImageUrl) {
      return Image.network(
        _imagenUrlController.text,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 8),
          Text(
            'La imagen no pudo ser cargada desde la URL proporcionada.',
            style: TextStyle(color: Colors.red),
          ),
        ],
      );
    }
  }
}
