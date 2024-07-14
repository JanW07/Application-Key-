import 'package:flutter/material.dart';

class HomeBodyContent extends StatelessWidget {
  final bool isGateOpen;
  final List<String> gates;
  final String? selectedGate;
  final Function toggleGate;
  final Color Function() getButtonColor;
  final Function(String) updateSelectedGate;

  const HomeBodyContent({
    required this.isGateOpen,
    required this.gates,
    required this.selectedGate,
    required this.toggleGate,
    required this.getButtonColor,
    required this.updateSelectedGate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (selectedGate != null) ...[
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => toggleGate(),
                icon: Icon(isGateOpen ? Icons.lock_open : Icons.lock, size: 48),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    isGateOpen ? 'Close Gate' : 'Open Gate',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(getButtonColor()),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              value: selectedGate,
              onChanged: (newValue) {
                updateSelectedGate(newValue!);
              },
              items: gates.map<DropdownMenuItem<String>>((String gate) {
                return DropdownMenuItem<String>(
                  value: gate,
                  child: Text(
                    gate,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        if (gates.isEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'No gates available. Please add gates in Settings.',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ],
    );
  }
}
