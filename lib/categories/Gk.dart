// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TriviaApp extends StatefulWidget {
  @override
  _TriviaAppState createState() => _TriviaAppState();
}

class _TriviaAppState extends State<TriviaApp> {
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    _getTriviaQuestions();
  }

  Future<void> _getTriviaQuestions() async {
    final String apiUrl = 'https://opentdb.com/api.php?amount=10&type=multiple';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          questions = data['results'];
        });
      } else {
        print('Failed to load trivia questions');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia App'),
      ),
      body: questions.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questions[index]['question']),
                  subtitle: Text('Category: ${questions[index]['category']}'),
                );
              },
            ),
    );
  }
}
