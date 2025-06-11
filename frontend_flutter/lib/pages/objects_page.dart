import 'package:flutter/material.dart';
import '../services/api.dart';

class ObjectsPage extends StatefulWidget {
  const ObjectsPage({super.key});

  @override
  State<ObjectsPage> createState() => _ObjectsPageState();
}

class _ObjectsPageState extends State<ObjectsPage> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchObjects();
  }

  void _refresh() {
    setState(() {
      _future = fetchObjects();
    });
  }

  Future<void> _addObject() async {
    final nameCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Object'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: 'Address')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await createObject({'name': nameCtrl.text, 'address': addrCtrl.text});
              Navigator.pop(context);
              _refresh();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Objects')),
      floatingActionButton: FloatingActionButton(onPressed: _addObject, child: const Icon(Icons.add)),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final o = items[i];
              return ListTile(
                title: Text(o['name']),
                subtitle: Text(o['address']),
              );
            },
          );
        },
      ),
    );
  }
}
