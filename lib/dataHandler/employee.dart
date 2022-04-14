import 'package:case_study/dataHandler/companyConstructor.dart';

import 'company.dart';

class Employee {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final int? companyID;
  final String? companyName;
  final String? contactFirstName;
  final String? contactLastName;
  final String? companyEmail;

  Employee({
     this.id
    , this.firstName
    , this.lastName
    , this.email
    , this.avatar
    , this.companyID
    , required this.companyName
    , required this.contactFirstName
    , required this.contactLastName
    , required this.companyEmail
  });

  factory Employee.fromMap(Map<String, dynamic> employeeJson
                          ,List<Company> companyJson ) => Employee(
    id : employeeJson['id'],
    firstName : employeeJson['first_name'],
    lastName : employeeJson['last_name'],
    email : employeeJson['email'],
    avatar : employeeJson['avatar'],
    companyID : employeeJson['company_id'],
    companyName : companyJson[employeeJson['company_id']-1].companyName,
    contactFirstName : companyJson[employeeJson['company_id']-1].contactFirstName,
    contactLastName : companyJson[employeeJson['company_id']-1].contactLastName,
    companyEmail : companyJson[employeeJson['company_id']-1].email,
  );

  factory Employee.searchByCompany(String value
      ,Map<String, dynamic> employeeJson ) => Employee(
    id : employeeJson['id'],
    firstName : employeeJson['first_name'],
    lastName : employeeJson['last_name'],
    email : employeeJson['email'],
    avatar : employeeJson['avatar'],
    companyID : employeeJson['company_id'],
    companyName : employeeJson['company_name'],
    contactFirstName : employeeJson['contact_first_name'],
    contactLastName : employeeJson['contact_last_name'],
    companyEmail : employeeJson['company_email'],
  );

  static Employee toList(Map<String, dynamic> json) => Employee(
    id : json['id'],
    firstName : json['first_name'],
    lastName : json['last_name'],
    email : json['email'],
    avatar : json['avatar'],
    companyID : json['company_id'],
    companyName: json['company_name'],
    contactFirstName : json['contact_first_name'],
    contactLastName : json['contact_last_name'],
    companyEmail : json['company_email'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'first_name' : firstName,
      'last_name' : lastName,
      'email' : email,
      'avatar' : avatar,
      'company_id' : companyID,
      'company_name' : companyName,
      'contact_first_name' : contactFirstName,
      'contact_last_name' : contactLastName,
      'company_email' : companyEmail,
    };
  }
}