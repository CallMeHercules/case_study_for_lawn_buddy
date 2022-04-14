class Company {
  final int? id;
  final String? companyName;
  final String? contactFirstName;
  final String? contactLastName;
  final String? email;

  Company({
    this.id
    , this.companyName
    , this.contactFirstName
    , this.contactLastName
    , this.email
  });

  factory Company.fromMap(Map<String, dynamic> json) => Company(
    id : json['id'],
    companyName : json['company_name'],
    contactFirstName : json['contact_first_name'],
    contactLastName : json['contact_last_name'],
    email : json['email'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'company_name' : companyName,
      'contact_first_name' : contactFirstName,
      'contact_last_name' : contactLastName,
      'email' : email,
    };
  }
  String test() {
    return companyName.toString();
  }
}