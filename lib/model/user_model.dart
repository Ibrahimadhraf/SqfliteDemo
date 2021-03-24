import 'package:flutter_app/helper/constants.dart';

class UserModel{
  int id;
  String name ,email, phone;

  UserModel({this.id, this.name, this.email, this.phone});
  toJson(){

   return{
     columnName :this.name,
     columnEmail:this.email ,
     'phone':this.phone
   };
  }
  UserModel.fromJson(Map<String ,dynamic> map){
    name =map[columnName];
    email=map[columnEmail];
    phone=map['phone'];
    id=map['id'];
  }
}