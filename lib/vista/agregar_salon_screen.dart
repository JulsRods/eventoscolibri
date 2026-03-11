import 'package:flutter/material.dart';
import 'package:clase5/modelo/salon.dart';
import 'package:clase5/controlador/salon_service.dart';
import 'package:http/http.dart' as http;

class AgregarSalonScreen extends StatefulWidget {
  @override
  _AgregarSalonScreenState createState() => _AgregarSalonScreenState();
}

class _AgregarSalonScreenState extends State<AgregarSalonScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _imagenUrlController = TextEditingController();
  final _reservacionesController = TextEditingController();
  final _contactoController = TextEditingController();
  final _capacidadController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _descripcionController = TextEditingController();

  bool _saving = false;
  bool _isLoadingImage = false;
  bool _isValidImageUrl = true;

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

  void _updateImageUrlValidation() async {
    setState(() {
      _isLoadingImage = true;
      _isValidImageUrl = true; // Resetear el estado de la validación
    });

    try {
      final response = await http.get(Uri.parse(_imagenUrlController.text));
      if (response.statusCode == 200) {
        setState(() {
          _isValidImageUrl = true;
        });
      } else {
        setState(() {
          _isValidImageUrl = false;
        });
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Salón'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _imagenUrlController,
                labelText: 'URL de la Imagen',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una URL de la imagen';
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return 'Por favor ingresa una URL válida';
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
                    return 'Por favor ingresa el número de reservaciones';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un valor numérico válido';
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
                    return 'Por favor ingresa un contacto';
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
                    return 'Por favor ingresa la capacidad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un valor numérico válido';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _ubicacionController,
                labelText: 'Ubicación',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la ubicación';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _descripcionController,
                labelText: 'Descripción',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saving ? null : _saveSalon,
                child: _saving ? CircularProgressIndicator() : Text('Guardar'),
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

  void _saveSalon() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _saving = true;
      });

      try {
        final nuevoSalon = Salon(
          nombre: _nombreController.text,
          imagenUrl: _imagenUrlController.text,
          reservaciones: int.parse(_reservacionesController.text),
          contacto: _contactoController.text,
          capacidad: int.parse(_capacidadController.text),
          ubicacion: _ubicacionController.text,
          descripcion: _descripcionController.text,
        );
        await SalonService().addSalon(nuevoSalon);
        Navigator.pop(context);
      } catch (e) {
        print('Error al agregar el salón: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar el salón. Inténtalo de nuevo.'),
          ),
        );
      } finally {
        setState(() {
          _saving = false;
        });
      }
    }
  }
}
