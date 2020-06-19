import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/pages/conversationScreen.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
    
  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return ChatRoomTile(
              userName: snapshot.data.documents[index].data["chatRoomId"]
              .toString().replaceAll("_", ""),
              chatRoomId: snapshot.data.documents[index].data["chatRoomId"]
            );
          }) : Container();
      },
    );
  }



  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    dataBaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
        print(
            "we got the data + ${chatRoomStream.toString()} this is name  ${Constants.myName}");
      });
    });
    setState(() {
      
    });
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
       title: Text('Chats', style: TextStyle(fontSize: 30,  color: Colors.pink),),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
          ));
          },
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black26,
        // elevation: 5.0,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("Chats"),
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text("Groups"),
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Profile"),
            ),
        ],),
      body: Container(child: chatRoomList()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
            ));
        },),
    );
  }
}

class ChatRoomTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;

  ChatRoomTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatRoomId : chatRoomId)
          ));
        },
          child: Container(
            margin: EdgeInsets.only(bottom: 2.0),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40.0)
              ),
              child: Text("${userName.substring(0,1)}".toUpperCase(), style: mediumTextStyle(),),
            ),
            SizedBox(width: 12.0),
            Text(userName, style: mediumTextStyle())
          ],
        )
      ),
    );
  }
}
