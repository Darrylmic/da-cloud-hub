import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = '';
  bool _isLoading = false;

  Future<void> _runCode() async {
    final code = _codeController.text;
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _output = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.148:5000/run'), // Update IP if needed
        headers: {'Content-Type': 'application/json'},
        body: '{"code": "${code.replaceAll('"', '\\"')}"}',
      );

      if (response.statusCode == 200) {
        setState(() => _output = response.body);
      } else {
        setState(() => _output = 'Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _output = 'Failed to connect to server: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dart Editor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _codeController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Dart code here...',
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _runCode,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Run Code'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black87,
                child: SingleChildScrollView(
                  child: Text(
                    _output,
                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
