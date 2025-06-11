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
              );
            },
          );
        },
      ),
    );
  }
}
