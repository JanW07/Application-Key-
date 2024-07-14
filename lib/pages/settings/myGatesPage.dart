import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GateListNotifier extends ValueNotifier<List<String>> {
  GateListNotifier(List<String> gates) : super(gates);

  void addGate(String newGate) {
    value = [...value, newGate];
    _saveGates();
  }

  void removeGate(int index) {
    value.removeAt(index);
    _saveGates();
  }

  void renameGate(int index, String newName) {
    value[index] = newName;
    _saveGates();
  }

  Future<void> _saveGates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('gates', value);
    notifyListeners(); // Notify listeners after saving changes
  }
}

class MyGatesPage extends StatefulWidget {
  final Function(List<String>) onUpdateGates;

  const MyGatesPage({Key? key, required this.onUpdateGates}) : super(key: key);

  @override
  _MyGatesPageState createState() => _MyGatesPageState();
}

class _MyGatesPageState extends State<MyGatesPage> {
  late GateListNotifier gateListNotifier;

  @override
  void initState() {
    super.initState();
    gateListNotifier = GateListNotifier([]);
    _loadGates();
  }

  Future<void> _loadGates() async {
    final prefs = await SharedPreferences.getInstance();
    final gates = prefs.getStringList('gates') ?? [];
    gateListNotifier.value = gates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Gates',
          ),
        backgroundColor: Colors.grey,
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: gateListNotifier,
        builder: (context, gates, _) {
          return ListView.builder(
            itemCount: gates.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  gates[index],
                  style: TextStyle(
                    color: Colors.grey, // Set text color to gray
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        final newName = await showDialog<String>(
                          context: context,
                          builder: (context) => RenameDialog(gateName: gates[index]),
                        );
                        if (newName != null && newName.isNotEmpty) {
                          gateListNotifier.renameGate(index, newName);
                          widget.onUpdateGates(gateListNotifier.value); // Notify parent with updated gates
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        gateListNotifier.removeGate(index);
                        widget.onUpdateGates(gateListNotifier.value); // Notify parent with updated gates
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGate = await showDialog<String>(
            context: context,
            builder: (context) => AddGateDialog(),
          );
          if (newGate != null && newGate.isNotEmpty) {
            gateListNotifier.addGate(newGate);
            widget.onUpdateGates(gateListNotifier.value); // Notify parent with updated gates
          }
        },
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.add,
          color: Color(0xFF424242),
        ),
      ),
    );
  }
}

class RenameDialog extends StatelessWidget {
  final String gateName;

  const RenameDialog({required this.gateName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: gateName);

    return AlertDialog(
      title: const Text('Rename Gate'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Gate Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class AddGateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Gate'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Gate Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
