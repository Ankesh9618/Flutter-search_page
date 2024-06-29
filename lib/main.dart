import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum SearchType { web, image, news, shopping }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchPage(title: 'Search Page'),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _Form();
}

class _Form extends State<SearchPage> {
  final Map<String, dynamic> _searchForm = <String, dynamic>{
    'searchTerm': "",
    'searchType': SearchType.web,
    'safeSearchOn': true
  };

  final GlobalKey<FormState> _key = GlobalKey();

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('You saved the state'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Form(
          key: _key,
          //autovalidateMode : true
          child: Container(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _searchForm['searchTerm'],
                  decoration: const InputDecoration(labelText: 'Search terms'),
                  onChanged: (String val) => {
                    setState(
                      () {
                        _searchForm['searchTerm'] = val;
                      },
                    ),
                  },
                  onSaved: (val) {},
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter a keyword to search...';
                    }
                    return null;
                  },
                ),
                FormField(
                  builder: (FormFieldState<SearchType> state) {
                    return DropdownButton<SearchType>(
                        value: _searchForm['searchType'],
                        items: const <DropdownMenuItem<SearchType>>[
                          DropdownMenuItem<SearchType>(
                            value: SearchType.web,
                            child: Text('Web'),
                          ),
                          DropdownMenuItem<SearchType>(
                            value: SearchType.image,
                            child: Text('Image'),
                          ),
                          DropdownMenuItem<SearchType>(
                            value: SearchType.news,
                            child: Text('News'),
                          ),
                          DropdownMenuItem<SearchType>(
                            value: SearchType.shopping,
                            child: Text('Shopping'),
                          ),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _searchForm['searchType'] = val;
                          });
                        });
                  },
                  onSaved: (initialValue) {},
                ),
                FormField(
                  builder: (FormFieldState<bool> state) {
                    return Row(
                      children: [
                        Checkbox(
                            value: _searchForm['safeSearchOn'],
                            onChanged: (val) {
                              setState(() {
                                _searchForm['safeSearchOn'] = val;
                              });
                            }),
                        const Text('Safe-search on'),
                      ],
                    );
                  },
                  onSaved: (newValue) => {},
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
                        _showAlert(context);
                      }
                    },
                    child: const Text('Submit'))
              ],
            ),
          ),
        ));
  }
}
