import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> _savedTexts = [];
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedTexts();
  }

  void _loadSavedTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedTexts = prefs.getStringList('savedTexts') ?? [];
    });
  }

  void _saveTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedTexts', _savedTexts);
  }

  void _addText(String text) {
    setState(() {
      _savedTexts.add(text);
      _saveTexts();
    });
  }

  void _removeText(int index) {
    setState(() {
      _savedTexts.removeAt(index);
      _saveTexts();
    });
  }

  void _navigateToOutputScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutputScreen(savedTexts: _savedTexts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Texts'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter Text',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                filled: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),

                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(10.0),
                )

              ),
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _addText(_textController.text);
                      _textController.clear();
                    }
                  },
                  child: Text('Add Text'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _savedTexts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(_savedTexts[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeText(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _navigateToOutputScreen(context);
                },
                child: Text('View Saved Texts'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _textController.clear();
          setState(() {
            _savedTexts.clear();
            _saveTexts();
          });
        },
        child: Icon(Icons.clear),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class OutputScreen extends StatelessWidget {
  final List<String> savedTexts;

  OutputScreen({required this.savedTexts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Texts'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Saved Texts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: savedTexts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(savedTexts[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
