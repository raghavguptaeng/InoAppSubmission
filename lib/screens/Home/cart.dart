import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../constants.dart';

class Cart extends StatefulWidget {
  const Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Text(
              "Cart",
              style: kHeadFontStyle.copyWith(
                fontSize: 40,
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Name",
                      style: kHeadFontStyle,
                    ),
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Text(
                    "Quantity",
                    style: kHeadFontStyle,
                  ),
                  Text(
                    "Remove",
                    style: kHeadFontStyle,
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Cart').snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(snapshot.data.docs[index]['name'],
                                    style: kHeadFontStyle),
                                width: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Text(
                                snapshot.data.docs[index]['requirement']
                                    .toString(),
                                style: kHeadFontStyle,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .runTransaction(
                                          (Transaction myTransaction) async {
                                    myTransaction.delete(
                                        snapshot.data.docs[index].reference);
                                  });
                                },
                                child: Icon(
                                  Icons.do_disturb_on_outlined,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
