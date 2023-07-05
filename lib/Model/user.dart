class User {
  User({

    required this.patient_name,
    required this.address,
    required this.mobile_no,
    required this.email,
    required this.password,
    required this.height,
    required this.weight,
    required this.age,

  });


  late final String patient_name;
  late final String address;
  late final String mobile_no;
  late final String email;
  late final String password;
  late final String height;
  late final String weight;
  late final String age;
  User.fromJson(Map<String, dynamic> json){

    email = json['email'];
    patient_name = json['patient_name'];
    address= json['address'];
    mobile_no = json['mobile_no'];
    password = json['password'];
    height = json['height'];
    weight = json['weight'];
   age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data['email'] = email;
    _data['patient_name'] = patient_name;
    _data['address'] = address;
    _data['mobile_no'] = mobile_no;
    _data['password'] = password;
    _data['height'] = height;
    _data['weight'] = weight;
    _data['age'] = age;
    return _data;
  }
}