import 'package:flutter/material.dart';
import '../models/contenedor.dart';
import '../models/objeto.dart';
import '../repositories/contenedor_repository.dart';
import '../repositories/objeto_repository.dart';
import 'objeto_form_screen.dart';

class ContenedorDetailScreen extends StatefulWidget {
  final Contenedor contenedor;

  const ContenedorDetailScreen({Key? key, required this.contenedor})
      : super(key: key);

  @override
  State<ContenedorDetailScreen> createState() => _ContenedorDetailScreenState();
}

class _ContenedorDetailScreenState extends State<ContenedorDetailScreen> {
  final ObjetoRepository _objetoRepository = ObjetoRepository();
  late Future<List<Objeto>> _objetos;

  @override
  void initState() {
    super.initState();
    _refreshObjetos();
  }

  void _refreshObjetos() {
    setState(() {
      _objetos = _objetoRepository.getObjetosByContenedorId(widget.contenedor.id!);
    });
  }

  Future<void> _deleteObjeto(int id, String nombre) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar objeto'),
        content: Text('¿Estás seguro de que deseas eliminar "$nombre"?'),
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
        await _objetoRepository.deleteObjeto(id);
        _refreshObjetos();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Objeto eliminado')),
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
        title: const Text('Detalle del contenedor'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with container info
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory_2, size: 32, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contenedor.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.contenedor.descripcion,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 18, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.contenedor.ubicacion,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Objects list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Objetos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                  onPressed: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ObjetoFormScreen(
                          idContenedor: widget.contenedor.id!,
                        ),
                      ),
                    );
                    if (result == true) {
                      _refreshObjetos();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Objeto>>(
              future: _objetos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final objetos = snapshot.data ?? [];

                if (objetos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inbox_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Este contenedor está vacío.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Agrega los objetos que hay dentro.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: objetos.length,
                  itemBuilder: (context, index) {
                    final objeto = objetos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.circle, size: 12),
                        title: Text(
                          objeto.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(objeto.descripcion),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteObjeto(objeto.id!, objeto.nombre);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      color: Colors.red, size: 20),
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
          ),
        ],
      ),
    );
  }
}
