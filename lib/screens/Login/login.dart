import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comm_resources/constants.dart';
import 'package:comm_resources/screens/Login/AddNewUserDetails.dart';
import 'package:comm_resources/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  static String id = '/login';
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int currIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();
  void verifyPhoneNumber() async {
    initpref();
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar(
          "Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackbar(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };
    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackbar("verification code: " + verificationId);
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: ${e}");
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  SharedPreferences pref ;
  void initpref()async{
    pref = await SharedPreferences.getInstance();
  }
  void signInWithPhoneNumber() async {
    try {
      await Firebase.initializeApp();
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      var firestore = FirebaseFirestore.instance;
      DocumentSnapshot docSnapshot = await firestore.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get();
      bool isDocExists = docSnapshot.exists;
      pref.setString('uid', FirebaseAuth.instance.currentUser.uid);
      if(!isDocExists)
        Navigator.pushNamed(context, AddNewUserDetails.id);
      else {
        Navigator.pushReplacementNamed(context, MainScreen.id);
      }
    } catch (e) {
      showSnackbar("Failed to sign in: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
          child: IndexedStack(
        index: currIndex,
        children: [
          GetPhoneNumber(context),
          OTP(context)
        ],
      )),
    );
  }

  Container GetPhoneNumber(BuildContext context) {
    return Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                TopGreetingAnimation(),
                SizedBox(height: 10,),
                Image.asset(
                  'assets/help.png',
                  width: 154,
                ),
                SizedBox(height: 15,),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your Phone Number To Get Started',
                        filled: true,
                        fillColor: Colors.blue,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: ()async{
                    verifyPhoneNumber();
                    setState(() {
                      currIndex++;
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    child: Center(child: Text("GET OTP",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                    decoration: BoxDecoration(
                      color: Color(0xFFFDBA36),
                      border: Border.all(color: Colors.black,width: 2),
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                )
              ],
            ),
          ),
        );
  }

  Container OTP(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.2,),
            TopGreetingAnimation(),
            SizedBox(height: 10,),
            Image.asset(
              'assets/help.png',
              width: 154,
            ),
            SizedBox(height: 15,),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: _smsController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter OTP',
                    filled: true,
                    fillColor: Colors.blue,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: ()async{
                signInWithPhoneNumber();
              },
              child: Container(
                width: 150,
                height: 40,
                child: Center(child: Text("Sign In",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                decoration: BoxDecoration(
                    color: Color(0xFFFDBA36),
                    border: Border.all(color: Colors.black,width: 2),
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                setState(() {
                  currIndex--;
                });
              },
              child: Text("Go Back",style: kHeadFontStyle,),
            )
          ],
        ),
      ),
    );
  }
}

class TopGreetingAnimation extends StatelessWidget {
  const TopGreetingAnimation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(width: 20.0, height: 100.0),
          const Text(
            'Stay',
            style: TextStyle(fontSize: 43.0),
          ),
          const SizedBox(width: 20.0, height: 100.0),
          SizedBox(
            width: 240,
            child: DefaultTextStyle(
              style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Horizon',
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
              child: AnimatedTextKit(animatedTexts: [
                RotateAnimatedText('SAFE'),
                RotateAnimatedText('OPTIMISTIC'),
                RotateAnimatedText('DIFFERENT'),
                RotateAnimatedText('CONNECTED')
              ]),
            ),
          ),
        ],
      ),
      height: 100,
    );
  }
}
