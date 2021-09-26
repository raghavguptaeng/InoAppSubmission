import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comm_resources/constants.dart';
import 'package:comm_resources/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AddNewUserDetails extends StatefulWidget {
  static String id = '/newuserdetails';
  const AddNewUserDetails({Key key}) : super(key: key);

  @override
  _AddNewUserDetailsState createState() => _AddNewUserDetailsState();
}

class _AddNewUserDetailsState extends State<AddNewUserDetails> {
  String Name,City,Age,Country;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width * 0.70,
            child: TextField(
              onChanged: (value){
                Name = value;
              },
              decoration: new InputDecoration(
                fillColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: 'Enter your name',
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width * 0.70,
            child: TextField(
              onChanged: (value){
                Age = value;
              },
              decoration: new InputDecoration(
                fillColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: 'Age',
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width * 0.70,
            child: TextField(
              onChanged: (value){
                Country = value;
              },
              decoration: new InputDecoration(
                fillColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: 'Enter your country',
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.circular(15)),
              width: MediaQuery.of(context).size.width * 0.70,
              child: TextField(
                onChanged: (value){
                  City = value;
                },
                decoration: new InputDecoration(
                  fillColor: Colors.grey,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Enter Your City',
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).set(
                  {
                    'name':Name,
                    'age':Age,
                    'Country':Country,
                    'City':City,
                    'phno':FirebaseAuth.instance.currentUser.phoneNumber
                  });
              Navigator.pushReplacementNamed(context, MainScreen.id);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secolor,
                  border: Border.all(color: Colors.black,width: 2)
              ),
              width: 200,
              height: 50,
              child: Center(child: Text('Add Resource',style: kSubTextStyle,)),
            ),
          )
        ],
      ),
    );
  }
}
