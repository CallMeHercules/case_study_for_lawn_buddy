import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';

//local
import 'company.dart';

class CompanyConstructor{
  CompanyConstructor._privateConstructor();
  static final CompanyConstructor instance = CompanyConstructor._privateConstructor();

  Future<List<Company>> readJson() async {
    final String response = await rootBundle.loadString('data/company_data.json');
    var companies = json.decode(response) as List;
    List<Company> companyList = companies.isNotEmpty
        ? companies.map((c) => Company.fromMap(c)).toList()
        : [];
    return companyList;
  }
}