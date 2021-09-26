import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comm_resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../constants.dart';

class ResourceInfo extends StatefulWidget {
  ResourceInfo({this.index, this.image});
  int index;
  var image;
  @override
  _ResourceInfoState createState() => _ResourceInfoState();
}

class _ResourceInfoState extends State<ResourceInfo> {
  int requirement = 0;
  String reason = '', contact;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Medicines').snapshots(),
            builder: (context, snapshot) {
              var data = snapshot.data.docs[widget.index];
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: TopImage(
                        image: widget.image,
                      ),
                    ),
                    Center(
                      //Following is the Resource Name
                      child: Text(
                        data['name'],
                        style: kHeadFontStyle.copyWith(fontSize: 35),
                      ),
                    ),
                    RequirementRow(),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 2)),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          onChanged: (value) {
                            reason = value;
                          },
                          decoration: InputDecoration(
                            labelText: "Reason for Requirement",
                            labelStyle:
                                TextStyle(fontSize: 25, color: Colors.black),
                          ),
                          maxLines: 5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (requirement.toInt() > 0 && reason != '') {
                            FirebaseFirestore.instance
                                .collection('Cart')
                                .doc()
                                .set({
                              'vendor': data['vendor'],
                              'requirement': requirement,
                              'reason': reason,
                              'name': data['name'],
                              'index': widget.index,
                              'phone':
                                  FirebaseAuth.instance.currentUser.phoneNumber,
                              'taker': FirebaseAuth.instance.currentUser.uid
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 250,
                          height: 50,
                          decoration: BoxDecoration(
                              color: secolor,
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              "Post your Requirement",
                              style: kHeadFontStyle,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Row RequirementRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Your Requirement",
          style: TextStyle(
              fontFamily: "BebasNeue",
              fontWeight: FontWeight.w300,
              fontSize: 25),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (requirement > 0) {
                    requirement--;
                  }
                });
              },
              child: Icon(
                Icons.remove,
                color: Colors.red,
                size: 40,
              ),
            ),
            Text(
              requirement.toString(),
              style: TextStyle(fontSize: 25),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  requirement++;
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.green,
                size: 40,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class TopImage extends StatelessWidget {
  TopImage({this.image});
  var image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.blue),
            padding: EdgeInsets.zero,
          ),
          Hero(tag: 'img', child: image)
        ],
      ),
    );
  }
}
// {
// 'vendor':data['vendor'],
// 'requirement':requirement,
// 'reason':reason,
// 'name':data['name'],
// 'index':widget.index,
// 'phone':FirebaseAuth.instance.currentUser.phoneNumber,
// 'taker':FirebaseAuth.instance.currentUser.uid
// }
