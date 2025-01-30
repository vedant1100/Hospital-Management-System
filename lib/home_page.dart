import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_storage/Services/database_services.dart';
import 'package:flutter_local_storage/models/Users.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final tableName = 'Library';

  List<Users> _users = [];

  int generateRandomId() {
    Random random = Random();
    return random.nextInt(1000000);
  }
  // bool checkNull(
  //     TextEditingController _customerfirstName,
  //     TextEditingController _customerlastName,
  //     TextEditingController _customermobileNo) {
  //   if (_customerfirstName.text.isEmpty ||
  //       _customerlastName.text.isEmpty ||
  //       _customermobileNo.text.isEmpty) {
  //     return true;
  //   }
  //   return false;
  // }

  Future<void> displayResults() async {
    try {
      _users = await _databaseService.display();
      setState(() {});
    } catch (e) {
      debugPrint('Users data not retrieved with exception : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    displayResults();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    displayResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        title: const Text('Users Page'),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Active customer Data', textAlign: TextAlign.start),
              const SizedBox(height: 10),
              Expanded(child: Container(child: _addDataList())),
              Container(child: _addButton())
            ],
          )),
    );
  }

  Widget _addButton() {
    final TextEditingController _customerfirstName = TextEditingController();
    final TextEditingController _customerlastName = TextEditingController();
    final TextEditingController _customermobileNo = TextEditingController();
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
                          Users library = Users(
                              id: generateRandomId(),
                              firstName: _customerfirstName.text,
                              lastName: _customerlastName.text,
                              mobileNo:
                                  int.tryParse(_customermobileNo.text) ?? 0);

                          await DatabaseService.instance.insert(library);
                          displayResults();
                          Navigator.pop(context);
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
    return ListView.builder(
      itemBuilder: (context, index) {
        var user = _users[index];
        return Card(
          child: ListTile(
            leading: Column(
              children: [
                Text('First Name : ${user.firstName}'),
                Text('Last Name : ${user.lastName}'),
                Text('Mobile Number : ${user.mobileNo.toString()}'),
              ],
            ),
            trailing: SizedBox(
              width: 128,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Edit button
                  _updateDataList(user),
                  // delete button
                  TextButton(
                      onPressed: () async {
                        await DatabaseService.instance.delete(user.id);
                        displayResults();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      child: const Icon(Icons.delete))
                ],
              ),
            ),
          ),
        );
      },
      itemCount: _users.length,
    );
  }

  Widget _updateDataList(Users user) {
    final TextEditingController _customerfirstName = TextEditingController();
    final TextEditingController _customerlastName = TextEditingController();
    final TextEditingController _customermobileNo = TextEditingController();
    return TextButton(
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
                            Users library = Users(
                                id: user.id,
                                firstName: _customerfirstName.text.isNotEmpty
                                    ? _customerfirstName.text
                                    : user.firstName,
                                lastName: _customerlastName.text.isNotEmpty
                                    ? _customerlastName.text
                                    : user.lastName,
                                mobileNo: _customermobileNo.text.isNotEmpty
                                    ? int.tryParse(_customermobileNo.text) ??
                                        user.mobileNo
                                    : user.mobileNo);
                            await DatabaseService.instance.updatebyId(library);
                            displayResults();
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).colorScheme.primary,
                          child: const Text('Click'),
                        )
                      ],
                    ),
                  ));
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
        child: const Icon(Icons.edit));
  }
}
