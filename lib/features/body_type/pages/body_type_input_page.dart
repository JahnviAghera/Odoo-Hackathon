import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rewear/features/body_type/pages/body_type_results_page.dart';

class BodyTypeInputPage extends StatefulWidget {
  const BodyTypeInputPage({super.key});

  @override
  State<BodyTypeInputPage> createState() => _BodyTypeInputPageState();
}

class _BodyTypeInputPageState extends State<BodyTypeInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _analyzeBodyType() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // **GEMINI API INTEGRATION POINT**
    final url = Uri.parse('YOUR_BACKEND_FUNCTION_URL_HERE');
    const prompt = """
      Analyze the provided body measurements to determine the user's body shape.
      Provide the output in a structured JSON format.

      The JSON object should include the following keys:
      - "body_type": A string with the determined body shape (e.g., "Rectangle", "Pear").
      - "clothing_suggestions": An array of 5 strings with clothing recommendations.
    """;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'measurements': {
            'height': _heightController.text,
            'shoulder': _shoulderController.text,
            'waist': _waistController.text,
            'hips': _hipsController.text,
          }
        }),
      );

      if (response.statusCode == 200) {
        final analysisData = jsonDecode(response.body);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                BodyTypeResultsPage(analysisData: analysisData),
          ),
        );
      } else {
        _showError('Failed to analyze body type. Please try again.');
      }
    } catch (e) {
      _showError('An error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Type Analyzer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Your Measurements',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Provide your measurements for an accurate analysis. All data is kept private.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              _buildTextField('Height (cm)', _heightController),
              const SizedBox(height: 24),
              _buildTextField('Shoulder Width (cm)', _shoulderController),
              const SizedBox(height: 24),
              _buildTextField('Waist (cm)', _waistController),
              const SizedBox(height: 24),
              _buildTextField('Hips (cm)', _hipsController),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _analyzeBodyType,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004CFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Analyze My Body Type'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }
}