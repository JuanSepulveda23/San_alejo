import 'package:flutter/material.dart';
import '../models/objeto.dart';
import '../repositories/objeto_repository.dart';

class ObjetoFormScreen extends StatefulWidget {
  final int idContenedor;
  final Objeto? objeto;

  const ObjetoFormScreen({
    Key? key,
    required this.idContenedor,
    this.objeto,
  }) : super(key: key);

  @override
  State<ObjetoFormScreen> createState() => _ObjetoFormScreenState();
}

class _ObjetoFormScreenState extends State<ObjetoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ObjetoRepository _repository = ObjetoRepository();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.objeto?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: widget.objeto?.descripcion ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _saveObjeto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final objeto = Objeto(
        id: widget.objeto?.id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        idContenedor: widget.idContenedor,
      );

      if (widget.objeto == null) {
        await _repository.insertObjeto(objeto);
      } else {
        await _repository.updateObjeto(objeto);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.objeto == null ? 'Objeto creado' : 'Objeto actualizado',
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.objeto == null ? 'Nuevo objeto' : 'Editar objeto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nombre del objeto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  hintText: 'Ej: Cable HDMI, Camisa azul',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  hintText: 'Describe detalles del objeto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveObjeto,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
