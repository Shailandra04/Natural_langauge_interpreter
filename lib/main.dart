import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Correct import

void main() {
  runApp(TranslationApp());
}

class TranslationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: Brightness.dark,
          secondary: Colors.tealAccent,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.teal.shade900,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          hintStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.tealAccent),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.tealAccent),
      ),
      home: TranslationScreen(),
    );
  }
}

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();
  String translatedText = '';
  String extractedText = '';
  String speechText = '';
  String sourceLanguage = 'en';
  String targetLanguage = 'es';
  bool _isListening = false;

  Future<void> translateText() async {
    String inputText = _textController.text;
    final url = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2?key=Google_key'); // Write Your Google Key
    final response = await http.post(url, body: {
      'q': inputText,
      'source': sourceLanguage,
      'target': targetLanguage,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        translatedText = data['data']['translations'][0]['translatedText'];
      });
    } else {
      setState(() {
        translatedText = 'Error in translation';
      });
    }
  }

  void startListening() async {
    _isListening = await _speech.initialize();
    if (_isListening) {
      _speech.listen(onResult: (result) {
        setState(() {
          speechText = result.recognizedWords;
          _textController.text = speechText;
        });
      });
    }
  }

  void stopListening() {
    _speech.stop();
  }

  void speakTranslatedText() async {
    await _flutterTts.setLanguage(targetLanguage);
    await _flutterTts.speak(translatedText);
  }

  Future<void> scanImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);  // Correct usage of InputImage
      final textRecognizer = TextRecognizer();  // Create textRecognizer instance
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        extractedText = recognizedText.text;
      });
      if (extractedText.isNotEmpty) {
        _textController.text = extractedText;
        translateText();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side (Input and Controls)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source language dropdown with white text and button color
                  DropdownButton<String>(
                    value: sourceLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        sourceLanguage = newValue!;
                        translateText();
                      });
                    },
                    items: <String>['en', 'es', 'fr', 'de', 'it', 'hi']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                    iconEnabledColor: Colors.white,
                    iconDisabledColor: Colors.white70,
                    style: TextStyle(color: Colors.white),
                  ),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Enter text to translate',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        translateText();
                      }
                    },
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                        onPressed: () {
                          if (_isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }
                        },
                        color: Colors.tealAccent,
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: scanImage,
                        color: Colors.tealAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right side (Translated text output)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Target language dropdown with white text and button color
                  DropdownButton<String>(
                    value: targetLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        targetLanguage = newValue!;
                        translateText();
                      });
                    },
                    items: <String>['en', 'es', 'fr', 'de', 'it', 'hi']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                    iconEnabledColor: Colors.white,
                    iconDisabledColor: Colors.white70,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 100,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.tealAccent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        translatedText.isEmpty
                            ? 'Translated text will appear here.'
                            : translatedText,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: speakTranslatedText,
                    color: Colors.tealAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
