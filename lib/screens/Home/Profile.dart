import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comm_resources/constants.dart';
import 'package:comm_resources/screens/Login/login.dart';
import 'package:comm_resources/screens/Resources/myResources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool changePhoneNum = false;
  String newNum = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TopProfileBar(),
            ProfileInfoSection(context)
          ],
        ),
      ),
    );
  }

  Container ProfileInfoSection(BuildContext context) {
    return Container(
            height: MediaQuery.of(context).size.height ,
            color: Colors.grey,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Text(
                          "Your Profile",
                          style: kHeadFontStyle.copyWith(fontSize: 40),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/help.png',
                          height: 150,
                        ),
                      ),
                      Text(
                        "Name - ${snapshot.data.data()['name']}",
                        style: kHeadFontStyle,
                      ),
                      Text(
                        "Age - ${snapshot.data.data()['age']}",
                        style: kHeadFontStyle,
                      ),
                      Text(
                        "City - ${snapshot.data.data()['City']}",
                        style: kHeadFontStyle,
                      ),
                      Text(
                        "Country - ${snapshot.data.data()['Country']}",
                        style: kHeadFontStyle,
                      ),
                      Row(
                        children: [
                          (!changePhoneNum)?Text(
                            "Contact Info - ${snapshot.data.data()['phno']}",
                            style: kHeadFontStyle,
                          ):Container(
                            width: 300,
                            child: TextField(
                              keyboardType:TextInputType.number,
                              onChanged: (value){
                                newNum = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter new contact Info",
                                hintStyle: TextStyle(color: Colors.black)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                changePhoneNum = !changePhoneNum;
                                if(changePhoneNum == false){
                                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
                                    "phno":newNum
                                  });
                                }
                              });
                            },
                            child: (!changePhoneNum)?Icon(Icons.edit):Icon(Icons.add_ic_call_sharp),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      SizedBox(height: 150,)
                    ],
                  ),
                );
              },
            ),
          );
  }
}

class TopProfileBar extends StatelessWidget {
  const TopProfileBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              print(pref.getString('uid'));
              pref.remove('uid');
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, Login.id);
            },
            child: Text(
              'Logout',
              style: kHeadFontStyle.copyWith(color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, MyResources.id);
            },
            child: Row(
              children: [
                Text('My Requests',style: kHeadFontStyle.copyWith(color: Colors.black),),
                Icon(Icons.arrow_forward_ios_sharp)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
