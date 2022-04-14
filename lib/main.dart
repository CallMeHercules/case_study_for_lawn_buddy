import 'package:flutter/material.dart';

//local
import 'dataHandler/company.dart';
import 'companyDetail.dart';
import 'dataHandler/employee.dart';
import 'dataHandler/employeeConstructor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Case Study',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFE9A2AD, color),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final nameTextController = TextEditingController();
  final companyTextController = TextEditingController();

  //static data saved in state
  late Future<List<Employee>> employees;
  late Future<List<Company>> companies;
  late Future<List<Employee>> allEmployees;
  late Future<List<Employee>> initEmployees;
  late List<Employee> savedEmployees;
  late List<Employee> display;

  Future<List<Employee>> _getEmployees() async {
    if (savedEmployees.isEmpty) {
      setState(() {
        employees = _dataInit();
      });
      // savedEmployees = await employees;
    }
    if (savedEmployees.isEmpty) {
      setState(() {
        employees = _dataInit();
      });

      // savedEmployees = await employees;
    }
    return employees;
  }

  Future<List<Employee>> _getSavedEmployees() async {
    setState(()  {
      allEmployees = EmployeeConstructor.instance.readJson();
    });
    return allEmployees;
  }

  Future<List<Employee>> _update(List<Employee> employee, String name, String company) async {
    setState(() {
      employees = EmployeeConstructor.instance.update(employee,name, company);
    });
    return employees;
  }

  Future<List<Employee>> _updateByName(List<Employee> employee, String name) async {
    setState(() {
      employees = EmployeeConstructor.instance.updateByName(employee,name);
    });
    return employees;
  }

  Future<List<Employee>> _updateByCompany(List<Employee> employee, String company) async {
    setState(() {
      employees = EmployeeConstructor.instance.updateByCompany(employee,company);
    });
    return employees;
  }

  Future<List<Employee>> _dataInit() async {
    setState(() {
      employees = EmployeeConstructor.instance.readJson();
    });
    return employees;
  }

  Future<List<Employee>> _search(String name, String company, List<Employee>? employee) async {
    for(var i = 0; i < employee!.length; i++){

      if (
      (
          employee[i].firstName.toString().toLowerCase().contains(name.toLowerCase()) || employee[i].lastName.toString().toLowerCase().contains(name.toLowerCase())
      ) && (
          employee[i].companyName.toString().toLowerCase().contains(company.toLowerCase().toLowerCase()) || company.isEmpty
      )
      ){
      } else {
        employee.remove(employee[i]);
        employees = _update(employee,name ,company);
      }
      if (employee.isEmpty) {
        setState(() {
          employees = _getSavedEmployees();
        });
      }
    }
    return employee;
  }

  Future<List<Employee>> _searchByCompany(String company, List<Employee>? employee) async {
    for(var i = 0; i < employee!.length; i++){

      if (
      (
          employee[i].companyName.toString().contains(company)
      )
      ){
      } else {
        employee.remove(employee[i]);
        employees = _updateByCompany(employee ,company);
      }
      if (employee.isEmpty) {
      }
    }
    return employee;
  }

  Future<List<Employee>> _searchByName(String name, List<Employee>? employee) async {
    for(var i = 0; i < employee!.length; i++){

      if (
      (
          employee[i].firstName.toString().toLowerCase().contains(name.toLowerCase()) || employee[i].lastName.toString().toLowerCase().contains(name.toLowerCase())
      )
      ){
      } else {
        employee.remove(employee[i]);
        employees = _updateByName(employee,name);
      }
      if (employee.isEmpty) {
      }
    }
    return employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Case Study'),
      ),
      body: SingleChildScrollView(
          child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: WidgetsBinding.instance!.window.physicalSize.width/50),
              child: SizedBox(
                child: TextFormField(
                  decoration:  const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search by first or last name',
                  ),
                  controller: nameTextController,
                  onChanged: (value) {
                    setState(() {
                      nameTextController.text = value;
                      nameTextController.selection = TextSelection.fromPosition(TextPosition(offset: nameTextController.text.length));
                    });
                  },
                ),
              ),
            ),Padding(
              padding:  EdgeInsets.symmetric(vertical: 10.0, horizontal: WidgetsBinding.instance!.window.physicalSize.width/50),
              child: SizedBox(
                child: TextFormField(
                  decoration:  const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search by company name',
                  ),
                  controller: companyTextController,
                  onChanged: (value) {
                    setState(() {
                      companyTextController.text = value;
                      companyTextController.selection = TextSelection.fromPosition(TextPosition(offset: companyTextController.text.length));
                    });
                  },
                ),
              ),
            ),
          Center(
            child: FutureBuilder<List<Employee>>(
            future: _dataInit(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Employee>> snapshot) {
              if (!snapshot.hasData) {
                // _dataInit();
                return const Center(child: Text('loading...'));
              }
              if (snapshot.data!.isEmpty) {
                _dataInit();
              }
              if (snapshot.hasData && nameTextController.text.isNotEmpty || companyTextController.text.isNotEmpty) {
                if (nameTextController.text.isNotEmpty && companyTextController.text.isNotEmpty) {
                  _search(nameTextController.text, companyTextController.text,
                      snapshot.data);
                } else if (companyTextController.text.isNotEmpty) {
                  _searchByCompany(companyTextController.text,
                      snapshot.data);
                }
                else {
                  _searchByName(nameTextController.text,
                      snapshot.data);
                }
                return ListView(
                  children: snapshot.data!.map((employee) {
                    return SizedBox(
                      child: Card(
                          child :ListTile(
                            dense: true,
                            leading: Image.network(employee.avatar.toString(),
                              width: 50,
                              height: 50,
                            ),
                            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black, width: 1)
                                , borderRadius: BorderRadius.circular(3)),
                            title:  Center(
                                child: Text(employee.lastName.toString()
                                    + ', '
                                    + employee.firstName.toString()
                                    + '\n'
                                    + employee.email.toString()
                                    + '\n'
                                    + employee.companyName.toString()
                                  , style: const TextStyle(fontSize: 18)
                                  , textAlign: TextAlign.left,
                                )
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CompanyDetail(employees: employees
                                  , companyID: employee.companyID
                                  , companyName: employee.companyName
                                  , contactFirstName: employee.contactFirstName
                                  , contactLastName: employee.contactLastName
                                  , companyEmail: employee.companyEmail)
                                ),
                              )
                            },
                          )
                          ,margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: WidgetsBinding.instance!.window.physicalSize.width/50)
                      ),
                      height: WidgetsBinding.instance!.window.physicalSize.height/4,

                    );
                  }).toList(),
                  shrinkWrap: true,
                );
              }
              
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('error'))
                  : ListView(
                children: snapshot.data!.map((employee) {
                  return SizedBox(
                    child: Card(
                      child :ListTile(
                        dense: true,
                        leading: Image.network(employee.avatar.toString(),
                            width: 50,
                            height: 50,
                        ),
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black, width: 1)
                            , borderRadius: BorderRadius.circular(3)),
                        title:  Center(
                            child: Text(employee.lastName.toString()
                                + ', '
                                + employee.firstName.toString()
                                + '\n'
                                + employee.email.toString()
                                + '\n'
                                // + getName().toString()
                                + employee.companyName.toString()
                              , style: const TextStyle(fontSize: 18)
                              , textAlign: TextAlign.left,
                            )
                          ),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CompanyDetail(employees: employees
                                                                                , companyID: employee.companyID
                                                                                , companyName: employee.companyName
                                                                                , contactFirstName: employee.contactFirstName
                                                                                , contactLastName: employee.contactLastName
                                                                                , companyEmail: employee.companyEmail
                            )
                            ),
                          )
                        },
                        )
                      ,margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: WidgetsBinding.instance!.window.physicalSize.width/50)
                    ),
                    height: WidgetsBinding.instance!.window.physicalSize.height/10,

                  );
                }).toList(),
                shrinkWrap: true,
              );
            }),
        ),
          ]
      )
      ),
    );
  }
}

Map<int, Color> color =
{
  50:const Color.fromRGBO(233,162,173, .1),
  100:const Color.fromRGBO(233,162,173, .2),
  200:const Color.fromRGBO(233,162,173, .3),
  300:const Color.fromRGBO(233,162,173, .4),
  400:const Color.fromRGBO(233,162,173, .5),
  500:const Color.fromRGBO(233,162,173, .6),
  600:const Color.fromRGBO(233,162,173, .7),
  700:const Color.fromRGBO(233,162,173, .8),
  800:const Color.fromRGBO(233,162,173, .9),
  900:const Color.fromRGBO(233,162,173, 1),
};
