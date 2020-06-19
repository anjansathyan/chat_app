import 'package:chat_app/pages/chatRoomScreen.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/helperfunctions.dart';

class SignUp extends StatefulWidget {

   final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  signMeUp() async{
    if(formKey.currentState.validate()){
       
       Map<String, String> userInfoMap = {
            'name': usernameTextEditingController.text,
            'email' : emailTextEditingController.text
          };

          HelperFunctions.saveUsernameSharedPreference(usernameTextEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState((){
        isLoading = true;
      });

      await authMethods.signUpWithEmailAndPassword(
        emailTextEditingController.text, passwordTextEditingController.text).then((val) {
          // print('${val.uId}');

          dataBaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
            ));
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator()),
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
                            Text("Create Account,", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFae0000)),),
                            SizedBox(height: 6.0),
                            Text("Sign up to get started!", style: TextStyle(fontSize: 20.0, color: Colors.grey,)),
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
                                     return val.isEmpty || val.length < 2 ? "Please provide a valid Username" : null;
                                   },
                                controller: usernameTextEditingController,
                                  style: simpleTextStyle(),
                                  decoration: textFieldInputDecoration('Username')),
                              TextFormField(
                                validator: (val) {
                                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                                      null : "Please provide a valid email";
                                },
                                controller: emailTextEditingController,
                                  style: simpleTextStyle(),
                                  decoration: textFieldInputDecoration('Email')),
                              TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val.length > 6 ? null : "Please provide 6+ char password";
                                },
                                controller: passwordTextEditingController,
                                style: simpleTextStyle(),
                                decoration: textFieldInputDecoration('Password'),
                              ),
                               ], 
                              ),
                    ),
                    SizedBox(height: 20.0),
                    
                    GestureDetector(
                              onTap: () {
                                signMeUp();
                              },
                    child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Color(0xFF800000)),
                                child: Text(
                                  'Sign up',
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
                                'Sign up with Google',
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
                                Text("Already have an account? ", style: mediumTextStyle()),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggle();
                                  },
                                    child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('Sign in now', 
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
                       ],
                     ),
                                ),
              ),
      ),
    );
  }
}