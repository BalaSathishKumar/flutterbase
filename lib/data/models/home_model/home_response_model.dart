/// name : "Udhay"
/// userDetails : {"age":27,"email":"udhay@abserve.tech"}

class HomeResponseModel {
  HomeResponseModel({
      String? name, 
      UserDetails? userDetails,}){
    _name = name;
    _userDetails = userDetails;
}

  HomeResponseModel.fromJson(dynamic json) {
    _name = json['name'];
    _userDetails = json['userDetails'] != null ? UserDetails.fromJson(json['userDetails']) : null;
  }
  String? _name;
  UserDetails? _userDetails;
HomeResponseModel copyWith({  String? name,
  UserDetails? userDetails,
}) => HomeResponseModel(  name: name ?? _name,
  userDetails: userDetails ?? _userDetails,
);
  String? get name => _name;
  UserDetails? get userDetails => _userDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    if (_userDetails != null) {
      map['userDetails'] = _userDetails?.toJson();
    }
    return map;
  }

}

/// age : 27
/// email : "udhay@abserve.tech"

class UserDetails {
  UserDetails({
      int? age, 
      String? email,}){
    _age = age;
    _email = email;
}

  UserDetails.fromJson(dynamic json) {
    _age = json['age'];
    _email = json['email'];
  }
  int? _age;
  String? _email;
UserDetails copyWith({  int? age,
  String? email,
}) => UserDetails(  age: age ?? _age,
  email: email ?? _email,
);
  int? get age => _age;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['age'] = _age;
    map['email'] = _email;
    return map;
  }

}