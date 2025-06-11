import 'package:flutter/material.dart';
import '../services/api.dart';

class WorkLogsPage extends StatefulWidget {
  const WorkLogsPage({super.key});

  @override
  State<WorkLogsPage> createState() => _WorkLogsPageState();
}

class _WorkLogsPageState extends State<WorkLogsPage> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchWorkLogs();
  }

  void _refresh() {
    setState(() {
      _future = fetchWorkLogs();
    });
  }

  Future<void> _addLog() async {
    final woCtrl = TextEditingController();
    final perfCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New WorkLog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: woCtrl, decoration: const InputDecoration(labelText: 'WorkOrder ID')),
            TextField(controller: perfCtrl, decoration: const InputDecoration(labelText: 'Performer ID')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await createWorkLog({
                'work_order_id': int.tryParse(woCtrl.text) ?? 0,
                'performer_id': int.tryParse(perfCtrl.text) ?? 0,
                'description': descCtrl.text,
              });
              Navigator.pop(context);
              _refresh();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editLog(Map<String, dynamic> log) async {
    final woCtrl = TextEditingController(text: log['work_order_id'].toString());
    final perfCtrl = TextEditingController(text: log['performer_id'].toString());
    final descCtrl = TextEditingController(text: log['description']);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit WorkLog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: woCtrl, decoration: const InputDecoration(labelText: 'WorkOrder ID')),
            TextField(controller: perfCtrl, decoration: const InputDecoration(labelText: 'Performer ID')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await updateWorkLog(log['id'] as int, {
                'work_order_id': int.tryParse(woCtrl.text) ?? 0,
                'performer_id': int.tryParse(perfCtrl.text) ?? 0,
                'description': descCtrl.text,
              });
              Navigator.pop(context);
              _refresh();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLog(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete WorkLog?'),
        content: const Text('This action cannot be undone'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await deleteWorkLog(id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work Logs')),
      floatingActionButton: FloatingActionButton(onPressed: _addLog, child: const Icon(Icons.add)),
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
              final l = items[i];
              return ListTile(
                title: Text('Order ${l['work_order_id']}'),
                subtitle: Text(l['description']),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editLog(l),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteLog(l['id'] as int),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
