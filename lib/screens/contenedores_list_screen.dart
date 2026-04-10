import 'package:flutter/material.dart';
import '../models/contenedor.dart';
import '../repositories/contenedor_repository.dart';
import 'contenedor_detail_screen.dart';
import 'contenedor_form_screen.dart';

class ContenedoresListScreen extends StatefulWidget {
  const ContenedoresListScreen({Key? key}) : super(key: key);

  @override
  State<ContenedoresListScreen> createState() => _ContenedoresListScreenState();
}

class _ContenedoresListScreenState extends State<ContenedoresListScreen> {
  final ContenedorRepository _repository = ContenedorRepository();
  late Future<List<Contenedor>> _contenedores;

  @override
  void initState() {
    super.initState();
    _refreshContenedores();
  }

  void _refreshContenedores() {
    setState(() {
      _contenedores = _repository.getAllContenedores();
    });
  }

  Future<void> _deleteContenedor(int id, String nombre) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar contenedor'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "$nombre"? '
          'Todos los objetos dentro también se eliminarán.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _repository.deleteContenedor(id);
        _refreshContenedores();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contenedor eliminado')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('San Alejo'),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<List<Contenedor>>(
        future: _contenedores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final contenedores = snapshot.data ?? [];

          if (contenedores.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No hay contenedores.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Agrega tu primera caja, maleta o cajón.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar contenedor'),
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContenedorFormScreen(),
                        ),
                      );
                      if (result == true) {
                        _refreshContenedores();
                      }
                    },
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: contenedores.length,
            itemBuilder: (context, index) {
              final contenedor = contenedores[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                  onTap: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ContenedorDetailScreen(contenedor: contenedor),
                      ),
                    );
                    if (result == true) {
                      _refreshContenedores();
                    }
                  },
                  leading: const Icon(Icons.inventory_2, color: Colors.blue),
                  title: Text(
                    contenedor.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(contenedor.descripcion),
                      const SizedBox(height: 4),
                      Text(
                        '📍 ${contenedor.ubicacion}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteContenedor(contenedor.id!, contenedor.nombre);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 10),
                            Text('Eliminar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const ContenedorFormScreen(),
            ),
          );
          if (result == true) {
            _refreshContenedores();
          }
        },
        tooltip: 'Agregar contenedor',
        child: const Icon(Icons.add),
      ),
    );
  }
}
