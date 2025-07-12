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

    final String geminiApiKey = 'AIzaSyDkVgKEu7J_cTfN8S_C7pd-cJjS7c8N_vM'; // ⚠️ Replace with your real key
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey');
    const prompt = """
      Analyze the provided body measurements to determine the user's body shape.
      Provide the output in a structured JSON format.

      The JSON object should include the following keys:
      - "body_type": A string with the determined body shape (e.g., "Rectangle", "Pear", "Hourglass", "Inverted Triangle").
      - "clothing_suggestions": An array of 5 strings with clothing recommendations tailored to the identified body type.
    """;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": """$prompt

                Measurements:
                Height: ${_heightController.text} cm
                Shoulder Width: ${_shoulderController.text} cm
                Waist: ${_waistController.text} cm
                Hips: ${_hipsController.text} cm
                """}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String responseText = decoded['candidates'][0]['content']['parts'][0]['text'];

        // Clean the response if it's wrapped in Markdown-style code block
        responseText = responseText.trim();
        if (responseText.startsWith("```json")) {
          responseText = responseText.replaceFirst("```json", "");
        }
        if (responseText.endsWith("```")) {
          responseText = responseText.substring(0, responseText.length - 3);
        }

        Map<String, dynamic> analysisData;
        try {
          analysisData = jsonDecode(responseText);
        } catch (e) {
          _showError("Invalid JSON format received: $responseText");
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                BodyTypeResultsPage(analysisData: analysisData),
          ),
        );
      } else {
        _showError('Failed to analyze body type: ${response.body}');
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
