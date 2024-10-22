import 'package:flutter/material.dart';
import 'package:flutter_local_storage/Services/database_services.dart';
import 'package:flutter_local_storage/models/libraryModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  bool isNull = false;
  final TextEditingController _customerfirstName = TextEditingController();
  final TextEditingController _customerlastName = TextEditingController();
  final TextEditingController _customermobileNo = TextEditingController();
  final TextEditingController _customerid = TextEditingController();
  final tableName='Library.db';

  List<Librarymodel> _users=[];

  bool checkNull(
      TextEditingController _customerfirstName,
      TextEditingController _customerlastName,
      TextEditingController _customermobileNo) {
    if (_customerfirstName.text.isEmpty ||
        _customerlastName.text.isEmpty ||
        _customermobileNo.text.isEmpty) {
      return true;
    }
    return false;
  }

  Future<void> insertData() async{
    await _databaseService.insert(tableName, 
      {
        'firstName':_customerfirstName.text,
        'lastName':_customerlastName.text,
        'mobileNo':_customermobileNo.text
      }
    );
    display();
  }

  Future<List<Librarymodel>> display() async{
    List<Map<String,dynamic>> userMaps=await _databaseService.query(_databaseService.tableName);
    List<Librarymodel> users=userMaps.map((map)=> Librarymodel.fromJson(map)).toList();

    setState(() {
      _users=users;
    });
    print('data : $_users.firstName');
    return _users;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Expanded(child: Container(child: _addDataList())),
          _deleteData(),
          Container(child: _addButton())
        ],
      )),
    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Add Data'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _customerfirstName,
                        onChanged: (value) {
                          setState(() {
                            _customerfirstName.text = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'add first name',
                        ),
                      ),

                      TextField(
                        controller: _customerlastName,
                        onChanged: (value) {
                          setState(() {
                            _customerlastName.text = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'add last name',
                        ),
                      ),

                      TextField(
                        controller: _customermobileNo,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            _customermobileNo.text = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'add mobile number',
                        ),
                      ),

                      MaterialButton(
                        onPressed: () async {
                          // await _databaseService.getDatabase();
                          if (!checkNull(_customerfirstName, _customerlastName,
                              _customermobileNo)) {
                            insertData();
                          }
                          
                          setState(() {
                            _customerfirstName.clear();
                            _customerlastName.clear();
                            _customermobileNo.clear();
                          });
                        },
                        color: Theme.of(context).colorScheme.primary,
                        child: const Text('Click'),
                      )
                    ],
                  ),
                ));
      },
      child: const Text('+', style: TextStyle(fontSize: 25)),
    );
  }

  Widget _addDataList() {
    return FutureBuilder<List<Librarymodel>>(
        future:display(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              var user=_users[index];
              return const Card(
                child: Column(
                  children: [
                    Text('user.firstName')
                  ],
                ),
              );
            },
            itemCount: _users.length,
          );
        });
  }

  Widget _deleteData(){
    return Container(
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _customerid,
            onChanged: (value) {
              setState(() {
                _customerid.text=value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder()
            ),
          ),

          const SizedBox(height: 10),
          TextButton(onPressed: (){
            _databaseService.delete(_databaseService.tableName);
          }, child: const Text('CLick Here to delete item'))
        ],
      ),
    );
  }
}

