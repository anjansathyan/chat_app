
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationScreen({this.chatRoomId});


  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream<QuerySnapshot> chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data.documents[index].data["message"], 
              sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
          }) : Container();
      },
    );
  }

  sendMessage(){

    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
      "message" : messageController.text,
      "sendBy" : Constants.myName,
      "time" : DateTime.now().millisecondsSinceEpoch
    };
  
      dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap );
      
      setState(() {
        messageController.text = "";  
      });
    }
}

  List<SendMenuItems> menuItems = [
    SendMenuItems(text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contacts", icons: Icons.person, color: Colors.purple),
  ];

  void showModal() {
    showModalBottomSheet(
      context: context, builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height,
          color:Color(0xFF737373),
                  child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
            ),
           child: Column(
            children: <Widget>[
              Center(
               child: Container(
                 height: 4,
                 width: 50.0,
                 color: Colors.grey.shade800,
               ),
              ),
              ListView.builder(
                itemCount: menuItems.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: menuItems[index].color.shade50,
                        ),
                        height: 50.0,
                        width: 50.0,
                        child: Icon(menuItems[index].icons, size: 20, color: menuItems[index].color.shade400,),
                      ),
                      title: Text(menuItems[index].text),
                    ),
                  );
                },
              )
            ], 
           ), 
          ),
        );
      }
    );
  }

  @override
  void initState() {
    dataBaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    backgroundColor: Colors.transparent,
    title: Text('Konversation', style: TextStyle(fontStyle: FontStyle.italic),
    )  
  ),
      body: Container(
       child: Stack(
        children: <Widget>[
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white12,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showModal();
                      },

                                          child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 21.0),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type message ...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    )),
                    GestureDetector(
                        onTap: () {
                            sendMessage();
                          },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 30.0,
                        )),
                  ],
                ),
              ),
          ),
        ], 
       ), 
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool sendByMe;

  MessageTile({this.message, this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: sendByMe ? 0 : 10.0, right: sendByMe ? 10 : 0),
      margin: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width,
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
                ],
              ),
              borderRadius: sendByMe ? 
              BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                ) : 
              BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),)
            ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17
        )),
      ),
    );
  }
}