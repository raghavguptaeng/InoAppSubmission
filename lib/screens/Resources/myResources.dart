import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comm_resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyResources extends StatefulWidget {
  static String id = '/my resources';
  const MyResources({Key key}) : super(key: key);

  @override
  _MyResourcesState createState() => _MyResourcesState();
}

class _MyResourcesState extends State<MyResources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name",
                  style: kHeadFontStyle,
                ),
                Text(
                  "Quantity",
                  style: kHeadFontStyle,
                ),
                Text(
                  "Info",
                  style: kHeadFontStyle,
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Cart").snapshots(),
            builder: (context, snapshot) {
              var data = [];
              for (int i = 0; i < snapshot.data.docs.length; ++i) {
                var temp = snapshot.data.docs[i];
                print(temp);
                print('\n');
                if (temp['vendor'] == FirebaseAuth.instance.currentUser.uid) {
                  data.add({
                    'name': temp['name'],
                    'req': temp['requirement'],
                    'phone': temp['phone'],
                    'reason': temp['reason']
                  });
                }
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: Text(data[index]['name']),width: MediaQuery.of(context).size.width*0.3,),
                          Text(data[index]['req'].toString()),
                          GestureDetector(
                            child: Container(
                              child: Center(
                                child: Text("See More"),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amberAccent
                              ),
                              width: 80,
                              height: 30,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
