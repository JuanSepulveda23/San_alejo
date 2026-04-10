import 'package:flutter/material.dart';
import '../models/contenedor.dart';
import '../repositories/contenedor_repository.dart';

class ContenedorFormScreen extends StatefulWidget {
  final Contenedor? contenedor;

  const ContenedorFormScreen({Key? key, this.contenedor}) : super(key: key);

  @override
  State<ContenedorFormScreen> createState() => _ContenedorFormScreenState();
}

class _ContenedorFormScreenState extends State<ContenedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ContenedorRepository _repository = ContenedorRepository();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _ubicacionController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.contenedor?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: widget.contenedor?.descripcion ?? '');
    _ubicacionController =
        TextEditingController(text: widget.contenedor?.ubicacion ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  Future<void> _saveContenedor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final contenedor = Contenedor(
        id: widget.contenedor?.id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        ubicacion: _ubicacionController.text,
      );

      if (widget.contenedor == null) {
        await _repository.insertContenedor(contenedor);
      } else {
        await _repository.updateContenedor(contenedor);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.contenedor == null
                  ? 'Contenedor creado'
                  : 'Contenedor actualizado',
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
        title: Text(widget.contenedor == null
            ? 'Nuevo contenedor'
            : 'Editar contenedor'),
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
                'Nombre del contenedor',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  hintText: 'Ej: Caja cocina, Maleta ropa invierno',
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
                  hintText: 'Describe qué contiene aproximadamente',
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
              const SizedBox(height: 20),
              const Text(
                'Ubicación',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(
                  hintText: 'Ej: Closet cuarto principal, Garaje estante 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una ubicación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveContenedor,
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
