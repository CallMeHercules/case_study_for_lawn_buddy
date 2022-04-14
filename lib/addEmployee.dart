import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dataHandler/employee.dart';


class AddEmployee extends StatefulWidget {
  final String? companyName;

  const AddEmployee({
    Key? key,
    required this.companyName,
  }) : super(
    key: key,
  );

  @override
  State<StatefulWidget> createState()  => _AddEmployee();

}

  class _AddEmployee extends State<AddEmployee> {
    final firstNameTextController = TextEditingController();
    final lastNameTextController = TextEditingController();
    final emailTextController = TextEditingController();
    final companyTextController = TextEditingController();

    late Future<List<Employee>> companies;

    late String _mySelection = widget.companyName.toString();

    static List data = [];

    Future<String> getSWData() async {
      final String companyString = await rootBundle.loadString('data/company_data.json');
      var companies = json.decode(companyString) as List;

      setState(() {
        data = companies;
      });

      return "Sucess";
    }

    @override
    void initState() {
      super.initState();
      getSWData();
    }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title : const Text('Edit'),
        ),
        body: Column(
          children: <Widget>[
          SizedBox(
          width: 300,
            child: TextFormField(
              controller: firstNameTextController,
              onChanged: (value) {
                setState(() {
                  firstNameTextController.text = value;
                  firstNameTextController.selection = TextSelection.fromPosition(TextPosition(offset: firstNameTextController.text.length));
                });
              },
              autocorrect: false,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                labelText: "First Name",
                contentPadding: const EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            )
            ),
        SizedBox(
          width: 300,
            child: TextFormField(
              autocorrect: false,
              textAlign: TextAlign.center,
              controller: lastNameTextController,
              onChanged: (value) {
                setState(() {
                  lastNameTextController.text = value;
                  lastNameTextController.selection = TextSelection.fromPosition(TextPosition(offset: lastNameTextController.text.length));

                });
              },
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                labelText: "Last Name",
                contentPadding: const EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            )
        ),
            SizedBox(
                width: 300,child: TextFormField(
              autocorrect: false,
              controller: emailTextController,
              onChanged: (value) {
                setState(() {
                  emailTextController.text = value;
                  emailTextController.selection = TextSelection.fromPosition(TextPosition(offset: emailTextController.text.length));

                });
              },
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                labelText: "Email",
                contentPadding: const EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            )
            )

            ,Center(child: SizedBox(
              width: 300,
            child: DropdownButton(
              style: const TextStyle(
                fontSize: 24,
              ), items: data.map((item)  {
              return DropdownMenuItem(
                child: Text(item['company_name'],style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),),

                value: item['company_name'].toString(),
              );
            }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _mySelection = newVal.toString();
                  });
                  // ;
                },
              value: _mySelection,
            ),
            )
            )

            ,Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 50.0,
                  width: 100.0,
                  child: OutlinedButton(
                    style: TextButton.styleFrom(
                    primary: Colors.black,
                    alignment: const Alignment(0, 0),
                    ),
                  onPressed: () async {
                  print('first name: ' + firstNameTextController.text);
                  print('last name: ' + lastNameTextController.text);
                  print('email: ' + emailTextController.text);
                  print('company name: ' + _mySelection);
              },
              child: const Text('Add'),
            ),
            )
            )
          ],
        )
    );
  }
}