import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/pages/settings/settings.dart';
import 'package:testapp/pages/home/homeWidgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool isGateOpen = false;
  List<String> gates = [];
  String? selectedGate;

  @override
  void initState() {
    super.initState();
    _loadGates();
    _loadSelectedGate();
  }

  Future<void> _loadGates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gates = prefs.getStringList('gates') ?? [];
      if (selectedGate == null && gates.isNotEmpty) {
        selectedGate = prefs.getString('selectedGate') ?? gates[0];
      }
    });
  }

  Future<void> _loadSelectedGate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGate = prefs.getString('selectedGate');
    });
  }

  Future<void> _saveSelectedGate(String gate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedGate', gate);
  }

  void toggleGate() {
    setState(() {
      isGateOpen = !isGateOpen;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isGateOpen ? 'Gate is opening...' : 'Gate is closing...')),
      );
    });
  }

  Color getButtonColor() {
    return isGateOpen ? Colors.green : Colors.red;
  }

  void updateSelectedGate(String newSelectedGate) {
    setState(() {
      selectedGate = newSelectedGate;
      _saveSelectedGate(newSelectedGate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBodyContent(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'GateOC',
        style: TextStyle(
          color: Color(0xFF424242),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey,
      elevation: 0.0,
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () async {
            final updatedGates = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
            if (updatedGates != null) {
              setState(() {
                gates = updatedGates as List<String>;
                if (!gates.contains(selectedGate)) {
                  selectedGate = gates.isNotEmpty ? gates[0] : null;
                }
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.settings,
              color: Color(0xFF424242),
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    return Center(
      child: HomeBodyContent(
        isGateOpen: isGateOpen,
        gates: gates,
        selectedGate: selectedGate,
        toggleGate: toggleGate,
        getButtonColor: getButtonColor,
        updateSelectedGate: updateSelectedGate,
      ),
    );
  }
}
