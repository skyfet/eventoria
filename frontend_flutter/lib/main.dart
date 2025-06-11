import 'package:flutter/material.dart';
import 'pages/objects_page.dart';
import 'pages/worklogs_page.dart';

void main() {
  runApp(const EventoriaApp());
}

class EventoriaApp extends StatelessWidget {
  const EventoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventoria',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final _pages = [const ObjectsPage(), const WorkLogsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Objects'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Logs'),
        ],
      ),
    );
  }
}
