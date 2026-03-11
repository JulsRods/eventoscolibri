import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clase5/controlador/cotizacion_service.dart';
import 'package:clase5/vista/cotizador_screen.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _collectionName;
  String? _docId;
  String? _fieldName;
  String? _newValue;
  List<String> _collections = [
    'tipoEventos',
    'duracionevento',
    'serviciosAdicionales',
    'necesidades',
    'numAsistentes',
    'numInvitados',
  ];

  Map<String, dynamic>? _documentData;
  List<String>? _fields;

  @override
  void initState() {
    super.initState();
    _loadDocumentData(_collections.first);
  }

  Future<void> _loadDocumentData(String collectionName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      setState(() {
        _documentData = doc.data() as Map<String, dynamic>?;
        _fields = _documentData!.keys.toList();
        _collectionName = collectionName;
        _docId = doc.id;
        _fieldName = null;
      });
    }
  }

  void _updateField() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_collectionName != null && _fieldName != null && _docId != null) {
        dynamic parsedValue = double.tryParse(_newValue!);
        if (parsedValue == null) {
          parsedValue = int.tryParse(_newValue!);
        }
        parsedValue ??= _newValue;

        CotizacionService().updateField(
          _collectionName!,
          _docId!,
          {_fieldName!: parsedValue},
        ).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Campo actualizado con éxito')),
          );
          _formKey.currentState!.reset();
          setState(() {
            _fieldName = null;
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar el campo')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor selecciona una colección y un campo'),
          ),
        );
      }
    }
  }

  void _deleteField() {
    if (_collectionName != null && _docId != null && _fieldName != null) {
      if (_collectionName == 'numAsistentes' ||
          _collectionName == 'numInvitados') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se puede eliminar campos de  $_collectionName'),
          ),
        );
        return;
      }

      CotizacionService()
          .deleteField(_collectionName!, _docId!, _fieldName!)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Campo eliminado con éxito')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _fieldName = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el campo')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Por favor selecciona una colección y un campo a eliminar'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Campo'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _collectionName,
                  items: _collections.map((collection) {
                    return DropdownMenuItem(
                      value: collection,
                      child: Text(collection),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _loadDocumentData(value!);
                  },
                  decoration: InputDecoration(
                    labelText: 'Colección',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                if (_fields != null)
                  DropdownButtonFormField<String>(
                    value: _fieldName,
                    items: _fields!.map((field) {
                      return DropdownMenuItem(
                        value: field,
                        child: Text(field),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _fieldName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Campo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: 20),
                if (_fieldName !=
                    null) // Mostrar Nuevo Valor solo si se selecciona un campo
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nuevo Valor',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _newValue = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nuevo valor';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _updateField,
                      child: Text('Actualizar Campo'),
                    ),
                    ElevatedButton(
                      onPressed: _deleteField,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: Text('Eliminar Campo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
