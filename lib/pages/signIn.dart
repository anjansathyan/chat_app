import 'package:chat_app/pages/forgotPassword.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  DataBaseMethods dataBaseMethods = DataBaseMethods();
  AuthMethods authMethods = AuthMethods();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  
  
  signIn() async{
    if(formKey.currentState.validate()){

      setState(() {
        isLoading = true;
      });
       
    await authMethods
    .signInWithEmailAndPassword(
      emailTextEditingController.text, passwordTextEditingController.text).then((val) async {
       if(val != null){
         QuerySnapshot snapshotUserInfo =
            await dataBaseMethods.getUserByEmail(emailTextEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);

          HelperFunctions.saveUsernameSharedPreference(snapshotUserInfo.documents[0].data["userName"]);

          HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data["userEmail"]);


          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
            ));
        } else{
          setState(() {
            isLoading = false;
          });
        }
      }); 
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000080),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator())
      ) : SingleChildScrollView(
              child: SafeArea(
                              child: Container(
                padding: EdgeInsets.only(left: 16.0, right:16,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50.0),
                        Text("Welcome,", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFae0000)),),
                        SizedBox(height: 6.0),
                        Text("Sign in to continue", style: TextStyle(fontSize: 20.0, color: Colors.grey,)),
                        ],
                          ), 
                           Container(
                          height: MediaQuery.of(context).size.height - 100,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Form(
                            key: formKey,
                              child: Column(
                              children: <Widget>[
                                TextFormField(
                                  validator: (val) {
                                     return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                                        null : "Please Enter Correct Email";
                                        },
                                  controller: emailTextEditingController,
                                    style: simpleTextStyle(),
                                    decoration: textFieldInputDecoration('Email')),
                              ],
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                              validator: (val) {
                                return val.length > 6 ? null : "Please provide 6+ char password";
                              },
                            controller: passwordTextEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration('Password'),
                          ),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                            },
                                child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      'Forgot Password?',
                                      style: simpleTextStyle(),
                                    ))),
                          ),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              signIn();
                            },
                              child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Color(0xFF800000)),
                              child: Text(
                                'Sign in',
                                style: mediumTextStyle(),
                              ),
                            ),
                          ),
                          SizedBox(height:16.0),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have account? ", style: mediumTextStyle()),
                              GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                  child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text('Register now', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    decoration: TextDecoration.underline,
                                  ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 50.0)
                        ],
            ),
          ),
        ),
                      ],
                    ),
                  
                  ),
              ),
      ),
    );
  }
}
