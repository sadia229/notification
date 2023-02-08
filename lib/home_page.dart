import 'package:flutter/material.dart';
import 'package:localdatabase/db.dart';
import 'package:sqflite/sqflite.dart' as sql;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  int _counter = 0;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;

  void _refreshNotifications() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _notifications = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotifications();
    print("number of items ${_notifications.length}");
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(title.text, description.text);
    _refreshNotifications();
    print("number of items ${_notifications.length}");
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("successfully delete"),
    ));
    _refreshNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(controller: title),
            TextFormField(controller: description),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notifications[index]['title'].toString()),
                  subtitle:
                      Text(_notifications[index]['description'].toString()),
                  trailing: ElevatedButton(
                    onPressed: () => _deleteItem(_notifications[index]['id']),
                    child: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: () => _showForm(null),
        onPressed: () => _addItem(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
