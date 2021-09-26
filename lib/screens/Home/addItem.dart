import 'package:comm_resources/constants.dart';
import 'package:comm_resources/screens/Login/AddNewUserDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class addItem extends StatefulWidget {
  const addItem({Key key}) : super(key: key);

  @override
  _addItemState createState() => _addItemState();
}

class _addItemState extends State<addItem> {
  final firestore = FirebaseFirestore.instance;
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  String name, price, quantity;
  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width * 0.70,
            child: TextField(
              onChanged: (value) {
                name = value;
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
                hintText: 'Resource Name',
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(15)),
          width: MediaQuery.of(context).size.width * 0.70,
          child: TextField(
            onChanged: (value) {
              quantity = value;
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
              hintText: 'Quantity',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(15)),
          width: MediaQuery.of(context).size.width * 0.70,
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              price = value;
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
              hintText: 'Price Per Unit',
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            FirebaseFirestore.instance.collection('Medicines').doc().set({
              'name': name,
              'qty': quantity,
              'avgPrice': price,
              'vendor': FirebaseAuth.instance.currentUser.uid
            });
            final snackBar = SnackBar(
              content: Text('Resource Added Successfully'),
            );
            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secolor,
                border: Border.all(color: Colors.black, width: 2)),
            width: 200,
            height: 50,
            child: Center(
                child: Text(
              'Add Resource',
              style: kSubTextStyle,
            )),
          ),
        )
      ],
    ));
  }
}
