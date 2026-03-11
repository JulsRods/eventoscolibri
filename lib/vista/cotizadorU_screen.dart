import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clase5/modelo/cotizacion.dart';
import 'package:clase5/controlador/cotizadorUsuario.dart';

class CotizacionModel {
  Map<String, dynamic> tipoEventos;
  Map<String, dynamic> duracionEventos;
  double precioPorAsistente;
  double precioPorInvitado;
  Map<String, dynamic> necesidades;
  Map<String, dynamic> serviciosAdicionales;

  CotizacionModel({
    required this.tipoEventos,
    required this.duracionEventos,
    required this.precioPorAsistente,
    required this.precioPorInvitado,
    required this.necesidades,
    required this.serviciosAdicionales,
  });
}

class CotizarClienteScreen extends StatefulWidget {
  @override
  _CotizarClienteScreenState createState() => _CotizarClienteScreenState();
}

class _CotizarClienteScreenState extends State<CotizarClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _tipoEvento;
  int? _numAsistentes;
  int? _numInvitados;
  String? _duracionEvento;
  List<String> _selectedServiciosAd = [];
  List<String> _selectedNecesidades = [];
  double _cotizacion = 0.0;

  TextEditingController _cotizacionController = TextEditingController();
  CotizacionModel? _cotizacionModel;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _cotizacionController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CotizacionUService service = CotizacionUService();

      Map<String, dynamic> tipoEventos = await service.getTipoEventos();
      Map<String, dynamic> duracionEventos = await service.getDuracionEvento();

      DocumentSnapshot numAsistentesDoc = await firestore
          .collection('numAsistentes')
          .doc('numAsistentes')
          .get();
      double precioPorAsistente =
          (numAsistentesDoc['precioA'] as dynamic).toDouble();

      DocumentSnapshot numInvitadosDoc =
          await firestore.collection('numInvitados').doc('numInvitados').get();
      double precioPorInvitado =
          (numInvitadosDoc['precioI'] as dynamic).toDouble();

      Map<String, dynamic> necesidades = await service.getNecesidades();
      Map<String, dynamic> serviciosAdicionales =
          await service.getServiciosAdicionales();

      setState(() {
        _cotizacionModel = CotizacionModel(
          tipoEventos: tipoEventos,
          duracionEventos: duracionEventos,
          precioPorAsistente: precioPorAsistente,
          precioPorInvitado: precioPorInvitado,
          necesidades: necesidades,
          serviciosAdicionales: serviciosAdicionales,
        );
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $error')),
      );
    }
  }

  void _calcularCotizacion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      dynamic costoBase = _cotizacionModel!.tipoEventos[_tipoEvento!]!;
      dynamic costoDuracion =
          _cotizacionModel!.duracionEventos[_duracionEvento!]!;
      dynamic costoAsistentes =
          (_numAsistentes ?? 0) * _cotizacionModel!.precioPorAsistente;
      dynamic costoInvitados =
          (_numInvitados ?? 0) * _cotizacionModel!.precioPorInvitado;

      dynamic total =
          costoBase + costoDuracion + costoAsistentes + costoInvitados;

      for (String servicio in _selectedServiciosAd) {
        total += _cotizacionModel!.serviciosAdicionales[servicio]!;
      }

      for (String necesidad in _selectedNecesidades) {
        total += _cotizacionModel!.necesidades[necesidad]!;
      }

      setState(() {
        _cotizacion = total;
      });

      _guardarCotizacion();
      _cotizacionController.text = _cotizacion.toStringAsFixed(2);
    }
  }

  void _guardarCotizacion() {
    Cotizacion nuevaCotizacion = Cotizacion(
      id: "",
      tipoEvento: _tipoEvento!,
      numAsistentes: _numAsistentes!,
      numInvitados: _numInvitados!,
      duracionEvento: _duracionEvento!,
      servicios: _selectedServiciosAd,
      necesidades: _selectedNecesidades,
      cotizacion: _cotizacion,
    );

    CotizacionUService().addCotizacion(nuevaCotizacion).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cotización guardada con éxito')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la cotización: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotización de Eventos - Cliente'),
      ),
      body: _cotizacionModel == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datos del Evento',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildDropdown(
                        label: 'Tipo de Evento',
                        value: _tipoEvento,
                        items: _cotizacionModel!.tipoEventos.keys.toList(),
                        onChanged: (value) {
                          setState(() {
                            _tipoEvento = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        label: 'Número de Asistentes',
                        onSaved: (value) {
                          _numAsistentes = int.tryParse(value!);
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        label: 'Número de Invitados',
                        onSaved: (value) {
                          _numInvitados = int.tryParse(value!);
                        },
                      ),
                      SizedBox(height: 20),
                      _buildDropdown(
                        label: 'Duración del Evento',
                        value: _duracionEvento,
                        items: _cotizacionModel!.duracionEventos.keys.toList(),
                        onChanged: (value) {
                          setState(() {
                            _duracionEvento = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildMultiSelectDropdown(
                        label: 'Servicios Adicionales',
                        items: _cotizacionModel!.serviciosAdicionales.keys
                            .toList(),
                        selectedItems: _selectedServiciosAd,
                      ),
                      SizedBox(height: 20),
                      _buildMultiSelectDropdown(
                        label: 'Necesidades',
                        items: _cotizacionModel!.necesidades.keys.toList(),
                        selectedItems: _selectedNecesidades,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _calcularCotizacion,
                        child: Text('Calcular Cotización'),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cotizacionController,
                              decoration: InputDecoration(
                                labelText: 'Cotización Total',
                                border: OutlineInputBorder(),
                              ),
                              enabled: false,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Lps',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null ? 'Por favor selecciona $label' : null,
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa $label';
        }
        if (int.tryParse(value) == null) {
          return 'Por favor ingresa un número válido';
        }
        return null;
      },
    );
  }

  Widget _buildMultiSelectDropdown({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Seleccione $label',
            border: OutlineInputBorder(),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null && !selectedItems.contains(value)) {
              setState(() {
                selectedItems.add(value);
              });
            }
          },
        ),
        Wrap(
          children: selectedItems
              .map((item) => Chip(
                    label: Text(item),
                    onDeleted: () {
                      setState(() {
                        selectedItems.remove(item);
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
