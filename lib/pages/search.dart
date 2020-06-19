import 'package:chat_app/pages/conversationScreen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/constants.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String myName;


class _SearchScreenState extends State<SearchScreen> {


  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  

  initiateSearch() async{
    if(searchTextEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
    
    await dataBaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
          searchSnapshot = val;
          print("$searchSnapshot");
      setState(() {
        isLoading = false;
        haveUserSearched = true;
      });
    });
  }
}

Widget searchList() {
    return haveUserSearched ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return searchTile(
             searchSnapshot.documents[index].data["name"],
             searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  //create chatroom, send user to cnversation screen, push replacement
  createChatRoomandStartConversation( String userName) {


    List<String> users = [userName, Constants.myName];

    String chatRoomId = getChatRoomId(userName, Constants.myName);

    Map<String, dynamic> chatRoomMap = {
      "users" : users,
      "chatRoomId" : chatRoomId,
    };

    dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(
        chatRoomId: chatRoomId,
      )
      ));
  }

  Widget searchTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail,
                style: mediumTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomandStartConversation(
                userName
              );
            },
              child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text("Message", style: mediumTextStyle()),
            ),
          )
        ],
      ),
    );
  }

 
      

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
       title: Text('Search Friends ...', style: TextStyle(fontSize: 28,  color: Colors.pink),),
       ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Container(
        child: Column(
          children: <Widget>[ 
            SizedBox(height: 5),
            Container(
              color: Colors.white12,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'search username ...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  )),
                  GestureDetector(
                      onTap: () {
                        initiateSearch();
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      )),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}


   getChatRoomId(String a, String b) {
      if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return "$b\_$a";
      }else{
        return "$a\_$b";
      }
    }