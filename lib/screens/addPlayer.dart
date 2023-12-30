import 'package:HLSA/models/category.dart';
import 'package:HLSA/services/supabaseFunc.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPlayerForm extends StatefulWidget {
  AddPlayerForm({super.key});

  @override
  State<AddPlayerForm> createState() => _AddPlayerFormState();
}

class _AddPlayerFormState extends State<AddPlayerForm> {
  PlayerCategory _selectedCategory = PlayerCategory.under12;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late DateTime _dob = DateTime.now();
  late DateTime _joiningDate = DateTime.now();
  late DateTime _endDate = DateTime.now();
  Supabase supabase = Supabase.instance;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _addPlayerToSupabase() async {
    try {
      SupabaseFunc().addPlayer(
        _fullNameController.text.toString(),
        _selectedCategory.name.toString(),
        _dob.toUtc().toIso8601String(),
        _joiningDate.toUtc().toIso8601String(),
        _endDate.toUtc().toIso8601String(),
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added player successfully!'),
        duration: Duration(seconds: 3),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding player: ${e}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        onDateSelected(pickedDate);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(_joiningDate.year),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        onDateSelected(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).scaffoldBackgroundColor
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
          title: const Text(
            'Add Player',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              height: height * 0.9,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Student Name",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextFormField(
                    controller: _fullNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter full name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date of Birth',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          child: Container(
                              alignment: Alignment.center,
                              width: width * 0.5,
                              child: Text('${_dob.toLocal()}'.split(' ')[0])),
                          onPressed: () =>
                              _selectDate(context, _dob, (date) => _dob = date),
                        ),
                      ]),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select a category",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: DropdownButton<PlayerCategory>(
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            value: _selectedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                            items: PlayerCategory.values.map((category) {
                              var dpText = "";
                              switch (category) {
                                case PlayerCategory.under12:
                                  dpText = 'Under 12';
                                  break;
                                case PlayerCategory.under14:
                                  dpText = 'Under 14';
                                  break;
                                case PlayerCategory.under17:
                                  dpText = 'Under 17';
                                  break;
                                case PlayerCategory.under19:
                                  dpText = 'Under 19';
                                  break;
                                case PlayerCategory.academy:
                                  dpText = 'Academy Players';
                                  break;
                              }
                              return DropdownMenuItem<PlayerCategory>(
                                  value: category,
                                  child: Text(
                                      dpText) //(category.toString().split('.').last),
                                  );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Joining Date',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        ElevatedButton(
                          child: Container(
                              alignment: Alignment.center,
                              width: width * 0.5,
                              child: Text(
                                  '${_joiningDate.toLocal()}'.split(' ')[0])),
                          onPressed: () => _selectDate(context, _joiningDate,
                              (date) => _joiningDate = date),
                        ),
                      ]),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'End Date',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          child: Container(
                              alignment: Alignment.center,
                              width: width * 0.5,
                              child:
                                  Text('${_endDate.toLocal()}'.split(' ')[0])),
                          onPressed: () => _selectEndDate(
                              context, _endDate, (date) => _endDate = date),
                        ),
                      ]),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addPlayerToSupabase();
                            }
                          },
                          label: Text("Submit"),
                          icon: Icon(Icons.check),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text("Cancel"),
                          icon: Icon(Icons.block),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
