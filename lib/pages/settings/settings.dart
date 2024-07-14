import 'package:flutter/material.dart';
import 'package:testapp/pages/settings/myGatesPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> gates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                final updatedGates = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyGatesPage(
                    onUpdateGates: (updatedGates) {
                      setState(() {
                        gates = updatedGates;
                      });
                    },
                  )),
                );
                if (updatedGates != null) {
                  setState(() {
                    gates = updatedGates as List<String>;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Set button width and height
                backgroundColor: Colors.grey,
              ),
              child: const Text(
                'MyGates',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF424242),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
