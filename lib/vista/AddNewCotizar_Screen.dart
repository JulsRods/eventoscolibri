import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clase5/controlador/cotizacion_service.dart';
import 'package:clase5/vista/cotizador_screen.dart';

class AddFieldScreen extends StatefulWidget {
  @override
  _AddFieldScreenState createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _collectionName;
  String? _docId;
  String? _newFieldName;
  String? _newValue;
  List<String> _collections = [
    'tipoEventos',
    'duracionevento',
    'serviciosAdicionales',
    'necesidades',
  ];

  Map<String, dynamic>? _documentData;

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
        _collectionName = collectionName;
        _docId = doc.id;
      });
    }
  }

  void _addNewField() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_collectionName != null && _docId != null) {
        dynamic parsedValue = double.tryParse(_newValue!);
        if (parsedValue == null) {
          parsedValue = int.tryParse(_newValue!);
        }
        parsedValue ??= _newValue;

        CotizacionService().addNewField(
          _collectionName!,
          _docId!,
          {_newFieldName!: parsedValue},
        ).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Campo agregado con éxito')),
          );
          _formKey.currentState!.reset();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar el campo: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Por favor selecciona una colección y un ID de documento'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Campo'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                if (_docId != null && _documentData != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Datos actuales:'),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _documentData!.length,
                        itemBuilder: (context, index) {
                          var key = _documentData!.keys.toList()[index];
                          var value = _documentData![key];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.5),
                            child: Text('$key: $value'),
                          );
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nuevo Campo (Nombre)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _newFieldName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre del nuevo campo';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Valor del Nuevo Campo',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _newValue = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el valor del nuevo campo';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingresa un valor numérico válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addNewField,
                    child: Text('Agregar Campo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
