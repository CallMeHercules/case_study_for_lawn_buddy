import 'package:flutter/material.dart';

//local
import 'addEmployee.dart';
import 'dataHandler/employee.dart';
import 'dataHandler/employeeConstructor.dart';


class CompanyDetail extends StatefulWidget {

  final Future<List<Employee>> employees;
  final int? companyID;
  final String? companyName;
  final String? contactFirstName;
  final String? contactLastName;
  final String? companyEmail;

  const CompanyDetail({Key? key,
              required this.employees,
              required this.companyID,
              required this.companyName,
              required this.contactFirstName,
              required this.contactLastName,
              required this.companyEmail}) : super(key: key);

  @override
  State<CompanyDetail> createState() => _CompanyDetail();

}


class _CompanyDetail extends State<CompanyDetail> {
  final nameTextController = TextEditingController();

  //static data saved in state
  late Future<List<Employee>> employees;
  late Future<List<Employee>> fullList;
  late Future<List<Employee>> companyEmployeeList;
  late List<Employee> listEmployees;
  get companyName => widget.companyName;


  Future<List<Employee>> _updateByCompany(List<Employee> employee, String company) async {
    setState(() async {
      listEmployees = await EmployeeConstructor.instance.updateByCompany(employee,company);
      employees = EmployeeConstructor.instance.updateByCompany(employee,company);
    });
    return employees;
  }

  Future<List<Employee>> _getEmployeesInit() async {
    setState(() {
      employees = EmployeeConstructor.instance.readJson();

    });
    return employees;
  }

  Future<List<Employee>> _getAllEmployees() async {
    setState(() {
      employees = fullList;
    });
    return employees;
  }

  Future<List<Employee>> _getFullList() async {

    setState(() async {
      employees = widget.employees;
      var emp = await employees;
      employees = _updateByCompany(emp,widget.companyName.toString());
    });
    return employees;
  }

  Future<List<Employee>> _update(List<Employee> employee, String name, String company) async {
    setState(() {
      employees = EmployeeConstructor.instance.update(employee,name, company);
    });
    return employees;
  }

  Future<List<Employee>> _search(String name, String company, List<Employee>? employee) async {
    for(var i = 0; i < employee!.length; i++){
      if (
      (
          employee[i].firstName.toString().toUpperCase().contains(name.toUpperCase()) || employee[i].lastName.toString().toUpperCase().contains(name.toUpperCase())
      ) && (
          employee[i].companyName.toString().toUpperCase().contains(company.toUpperCase()) || company.isEmpty
      )
      ){
      } else {
        employee.remove(employee[i]);
        employees = _update(employee,name ,company);
      }

      if (employee.isEmpty) {
        setState(() {
          employees = _getAllEmployees();
        });
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
        actions: <Widget>[
          FlatButton.icon(onPressed: () => {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployee(companyName: widget.companyName.toString(),)
            ),
          )}
              , icon: const Icon(Icons.add_box, size: (50))
              , label: const Text('')),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0,
                      horizontal: WidgetsBinding.instance!.window.physicalSize
                          .width / 5),
                  child: SizedBox(
                    child: Text(widget.companyName.toString()
                        + ' details'
                        + '\n'
                        + 'Contact Name: '
                        + widget.contactLastName.toString()
                        + ', '
                        + widget.contactFirstName.toString()
                        + '\n'
                        + 'Email: '
                        + widget.companyEmail.toString()
                      , style: const TextStyle(fontSize: 24)
                      , textAlign: TextAlign.left,
                    )
                  ),
                ), Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0,
                      horizontal: WidgetsBinding.instance!.window.physicalSize
                          .width / 5),
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
                          // _getEmployees();
                        });
                      },
                    ),
                  ),
                ),
                Center(
                  child: FutureBuilder<List<Employee>>(
                      future: _getEmployeesInit(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Employee>> snapshot) {
                        if (snapshot.hasData) {
                          _search(nameTextController.text,
                              widget.companyName.toString(),
                              snapshot.data);
                        }
                        if (snapshot.data!.isEmpty) {
                          _getEmployeesInit();
                        }
                        if (nameTextController.text.isNotEmpty) {
                          _search(nameTextController.text,
                              widget.companyName.toString(),
                              snapshot.data);
                        } else if (nameTextController.text.isEmpty) {
                          _getFullList();
                          // _searchByCompany(widget.companyName.toString());
                        }
                        if (snapshot.hasData) {
                          return ListView(
                            children: snapshot.data!.map((employee) {
                              return SizedBox(
                                child: Card(
                                    child: ListTile(
                                      dense: true,
                                      leading: Image.network(
                                        employee.avatar.toString(),
                                        width: 50,
                                        height: 50,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.black, width: 1)
                                          ,
                                          borderRadius: BorderRadius.circular(
                                              3)),
                                      title: Center(
                                          child: Text(
                                            employee.lastName.toString()
                                                + ', '
                                                + employee.firstName.toString()
                                                + '\n'
                                                + employee.email.toString()
                                                + '\n'
                                                +
                                                employee.companyName.toString()
                                            ,
                                            style: const TextStyle(fontSize: 18)
                                            , textAlign: TextAlign.left,
                                          )
                                      ),
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 10.0,
                                        horizontal: WidgetsBinding.instance!
                                            .window.physicalSize.width / 5)
                                ),
                                height: WidgetsBinding.instance!.window
                                    .physicalSize.height / 4,
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
                                  child: ListTile(
                                    dense: true,
                                    leading: Image.network(
                                      employee.avatar.toString(),
                                      width: 50,
                                      height: 50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.black, width: 1)
                                        ,
                                        borderRadius: BorderRadius.circular(3)),
                                    title: Center(
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
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 10.0,
                                      horizontal: WidgetsBinding.instance!
                                          .window.physicalSize.width / 5)
                              ),
                              height: WidgetsBinding.instance!.window
                                  .physicalSize.height / 4,
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

  Map<int, Color> color =
  {
    50: const Color.fromRGBO(233, 162, 173, .1),
    100: const Color.fromRGBO(233, 162, 173, .2),
    200: const Color.fromRGBO(233, 162, 173, .3),
    300: const Color.fromRGBO(233, 162, 173, .4),
    400: const Color.fromRGBO(233, 162, 173, .5),
    500: const Color.fromRGBO(233, 162, 173, .6),
    600: const Color.fromRGBO(233, 162, 173, .7),
    700: const Color.fromRGBO(233, 162, 173, .8),
    800: const Color.fromRGBO(233, 162, 173, .9),
    900: const Color.fromRGBO(233, 162, 173, 1),
  };
}