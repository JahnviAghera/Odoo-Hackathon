import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rewear/color_analysis_results_page.dart';

class PersonalColorAnalysisPage extends StatefulWidget {
  const PersonalColorAnalysisPage({super.key});

  @override
  State<PersonalColorAnalysisPage> createState() =>
      _PersonalColorAnalysisPageState();
}

class _PersonalColorAnalysisPageState extends State<PersonalColorAnalysisPage> {
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // **GEMINI API INTEGRATION POINT**
    // This is where you call your backend service, which in turn calls the Gemini API.
    // You should NOT call the Gemini API directly from the app.

    // 1. Define the URL for your backend function (e.g., a Supabase Edge Function)
    //    Replace this with your actual function URL.
    final url = Uri.parse('YOUR_BACKEND_FUNCTION_URL_HERE');

    // 2. Encode the image to base64
    final bytes = await _imageFile!.readAsBytes();
    final imageBase64 = base64Encode(bytes);

    // 3. Construct the prompt for Gemini
    const prompt = """
      Analyze the provided image to determine the user's personal color analysis.
      Provide the output in a structured JSON format.

      The JSON object should include the following keys:
      - "conclusion": A string with the final seasonal palette (e.g., "Warm Autumn").
      - "skin_tone": An object with "name" (e.g., "Warm Ivory") and "hex" (e.g., "#F3D9C4").
      - "eye_color": An object with "name" (e.g., "Hazel") and "hex" (e.g., "#9B8A3E").
      - "hair_color": An object with "name" (e.g., "Auburn") and "hex" (e.g., "#A52A2A").
      - "seasonal_palette": An array of 5 hex color strings.
      - "clothing_suggestions": An array of 3 hex color strings.
      - "makeup_suggestions": An array of 3 hex color strings.
      - "hair_recommendations": An array of 2 hex color strings.
      - "jewelry_suggestions": An array of 2 hex color strings for "Gold" and "Bronze" or "Silver" and "Platinum".
      - "colors_to_avoid": An array of 3 hex color strings.
    """;

    try {
      // 4. Make the request to your backend
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'image': imageBase64,
        }),
      );

      if (response.statusCode == 200) {
        // 5. Parse the response and navigate to the results page
        final analysisData = jsonDecode(response.body);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ColorAnalysisResultsPage(
              imageFile: _imageFile!,
              // You would pass the real analysisData here
            ),
          ),
        );
      } else {
        _showError('Failed to analyze image. Please try again.');
      }
    } catch (e) {
      _showError('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Color Analysis'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Find Your Perfect Colors',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Upload a clear, well-lit photo of your face for the best results.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.photo_camera_back_outlined,
                        size: 80, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Select Photo'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _analyzeImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004CFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Analyze My Colors',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}