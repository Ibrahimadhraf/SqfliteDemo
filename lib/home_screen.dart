import 'package:flutter/material.dart';
import 'package:flutter_app/helper/database_helper.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> userList = [];
  String name, email, phoneNumber;
  bool flage=false;

  final GlobalKey<FormState> addFormFieldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        centerTitle: true,
      ),
      body: _getAllUsers(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => openAlertBox(null),
      backgroundColor: Colors.red,
      child: Icon(Icons.add),
    );
  }

  Future<List<UserModel>> _getData() async {
    var dataBaseHelper = DatabaseHelper.db;
    await dataBaseHelper.getAllUser().then((value) {
      print(value[0].phone);
      setState(() {
        userList = value;
      });
    });
    return userList;
  }

  _getAllUsers() {
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          return createListView(context, snapshot);
        });
  }
// buildItem(userList[index], index)
  createListView(BuildContext context, AsyncSnapshot snapshot) {
    userList = snapshot.data;
    if (userList != null) {
      return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: buildItem(userList[index], index),

                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => DatabaseHelper.db.deleteUser(userList[index].id),
                    ),

                  ],
                  secondaryActions: <Widget>[
                    // IconSlideAction(
                    //   caption: 'More',
                    //   color: Colors.black45,
                    //   icon: Icons.more_horiz,
                    //   onTap: () => _showSnackBar('More'),
                    // ),

                  ],
                );
          });
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  openAlertBox( UserModel userModel) {
    if(userModel !=null){
      name=userModel.name;
      phoneNumber=userModel.phone;
      email=userModel.email;
      flage=true;
    }else{
      name='';
      phoneNumber='';
      email='';
      flage=false;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 300,
              height: 300,
              child: Form(
                key: addFormFieldState,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                          helperText: 'Add Name',
                          fillColor: Colors.grey[300],
                          border: InputBorder.none),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (String value) {
                        name = value;
                      },
                    ),
                    TextFormField(
                      initialValue: phoneNumber,
                      decoration: InputDecoration(
                          helperText: 'Add PhoneNumber',
                          fillColor: Colors.grey[300],
                          border: InputBorder.none),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (String value) {
                        phoneNumber = value;
                      },
                      onFieldSubmitted: (trim) {
                        addFormFieldState.currentState.save();
                        print(phoneNumber);
                      },
                    ),
                    TextFormField(
                      initialValue: email,
                      decoration: InputDecoration(
                          helperText: 'Add email',
                          fillColor: Colors.grey[300],
                          border: InputBorder.none),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (String value) {
                        email = value;
                      },
                    ),
                    FlatButton(
                        onPressed: () {
                       flage? editUser(userModel.id) :  addUser();
                        },
                        child: Text(  flage? 'Edit User' :'Add User'))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void addUser() {
    addFormFieldState.currentState.save();
    var dbHelper = DatabaseHelper.db;
    print(UserModel(name: name, email: email, phone: phoneNumber).toJson());
    dbHelper
        .insertUser(UserModel(name: name, email: email, phone: phoneNumber))
        .then((value) {
      print('insert');

      Navigator.pop(context);
      setState(() {});
    });
  }

  buildItem(UserModel userList, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(

        child: ListTile(
          title: Row(
            children: [
              Column(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.brown,
                      child: Text(
                        userList.name.substring(0, 1).toLowerCase(),
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle),
                      Padding(padding: EdgeInsets.only(right: 8)),
                      Text(
                        userList.name,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Text(
                        userList.phone,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(Icons.email),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Text(
                        userList.email,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          trailing:  InkWell(child: Icon(Icons.edit) ,onTap: (){
            openAlertBox(userList);
          },) ,

        ),
      ),
    );
  }

  editUser( int userId) {
    addFormFieldState.currentState.save();
    var dbHelper = DatabaseHelper.db;

   // print(''+UserModel(name: name, email: email, phone: phoneNumber ,id: userId).toJson() +'yyyyyyyyyyy');
    UserModel model=UserModel(name: name, email: email, phone: phoneNumber ,id: userId);
    dbHelper
        .updateUser(model)
        .then((value) {
      print('update');

      Navigator.pop(context);
      setState(() {
        flage=false;
      });
    });
  }
}
