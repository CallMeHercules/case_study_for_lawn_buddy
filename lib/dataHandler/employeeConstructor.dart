import 'dart:convert';
import 'dart:core' show Future, List, String;
import 'package:flutter/services.dart';

//local
import 'company.dart';
import 'employee.dart';

class EmployeeConstructor{
  EmployeeConstructor._privateConstructor();
  static final EmployeeConstructor instance = EmployeeConstructor._privateConstructor();

  Future<List<Employee>> readJson() async {

    final String employeeString = await rootBundle.loadString('data/employee_data.json');
    final String companyString = await rootBundle.loadString('data/company_data.json');
    var employees = json.decode(employeeString) as List;
    var companies = json.decode(companyString) as List;

    List<Company> companyList = companies.isNotEmpty
        ? companies.map((c) => Company.fromMap(c)).toList()
        : [];
    List<Employee> employeeList = employees.isNotEmpty
        ? employees.map((c) => Employee.fromMap(c,companyList)).toList()
        : [];
    return employeeList;
  }

  Future<List<Employee>> update(List<Employee> employee, String name, String company) async {

    for(var i = 0; i < employee.length; i++){

      if (
      (
          employee[i].firstName.toString().toLowerCase().contains(name.toLowerCase())
              || employee[i].lastName.toString().toLowerCase().contains(name.toLowerCase())
      ) && (
          employee[i].companyName.toString().toLowerCase().contains(company.toLowerCase())
              || company.isEmpty
      )
      ){
      } else {
        employee.removeAt(i);
      }
    }
    return employee;
  }

  Future<List<Employee>> updateByCompany(List<Employee> employee, String company) async {
    for(var i = 0; i < employee.length; i++){

      if (
      (
          employee[i].companyName.toString().toLowerCase().contains(company.toLowerCase())
              || company.isEmpty
      )
      ){
      } else {
        employee.removeAt(i);
      }
    }
    return employee;
  }
  Future<List<Employee>> getEmployees(Future<List<Employee>> employees) async {
    return employees;
  }

  Future<List<Employee>> updateByName(List<Employee> employee, String name) async {
    for(var i = 0; i < employee.length; i++){

      if (
      (
          employee[i].firstName.toString().toLowerCase().contains(name.toLowerCase())
              || employee[i].lastName.toString().toLowerCase().contains(name.toLowerCase())
      )
      ){
      } else {
        employee.removeAt(i);
      }
    }
    return employee;
  }



}