  
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text("UNDER CONSTRUCTION !!!", style: TextStyle(color: Colors.white, fontSize: 20.0),),
          ),
          SizedBox(width: 8.0),
          Container(
           child: Icon(Icons.warning, color: Colors.red, size: 40,), 
          )
        ],
        
      )
    );
  }
}