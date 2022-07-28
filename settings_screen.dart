import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final textController = TextEditingController();
  List<String> _mytodo = [];
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mytodo = (prefs.getStringList('saved') ?? []);
    });
  }

  _removeItemDialog(BuildContext context, index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Mark as Complete?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop();
                        _mytodo.removeAt(index);
                      });
                    },
                    child: Text('Complete'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('cancel'),
                  ),
                ],
              ));
        });
  }

  _displayDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final prefs = await SharedPreferences.getInstance();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add your to do'),
            content: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                        controller: textController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Container();

                          return setState(() {
                            Navigator.of(context).pop();

                            _mytodo.add(textController.text);
                            textController.clear();
                            prefs.setStringList('saved', _mytodo);
                          });
                        }
                      },
                      child: Text('add'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text('cancel'),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     // toolbarHeight: size.height * 0.10,
        title: Text(
          'ToDo List',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Row(
        children: [
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _mytodo.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_mytodo[index]),
                    trailing: GestureDetector(
                        onTap: () {
                          setState(() {
                            _removeItemDialog(context, index);
                          });
                        },
                        child: Icon(Icons.done)),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,    onPressed: () {
          _displayDialog(context);
          print(textController);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
