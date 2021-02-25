import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textFieldControler = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String inputMessegesText;

  @override
  void initState() {
    super.initState();
    getuser();
  }

  getuser() {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        loggedInUser = currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  // getMessege() async {
  //   final messegesData = await _firestore.collection('messeges').get();
  //   for (var messeges in messegesData.docs) {
  //     print(messeges.data);
  //   }
  // }

  getMessegeStream() async {
    await for (var snapshot in _firestore.collection('messeges').snapshots()) {
      for (var messeges in snapshot.docs) {
        print(messeges.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getMessegeStream();
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messeges').snapshots(),
              builder: (context, snapshot) {
                List<MessegeBubble> messegesTextWidget = [];
                if (snapshot.hasData) {
                  final messeges = snapshot.data.docs.reversed;
                  for (var messege in messeges) {
                    final messegeText = messege.data()['text'];
                    final messegeSender = messege.data()['sender'];

                    final messegeData = MessegeBubble(
                      messegeText: messegeText,
                      messegeSender: messegeSender,
                      isMe: loggedInUser.email == messegeSender ? true : false,
                    );

                    // final messegeData = Text(
                    //     "$messegeText from $messegeSender ${messege.data()['alias'] == null ? '' : messege.data()['alias']}");
                    messegesTextWidget.add(messegeData);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messegesTextWidget,
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldControler,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        //Do something with the user input.
                        inputMessegesText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textFieldControler.clear();
                      //Implement send functionality.
                      _firestore.collection('messeges').add({
                        'sender': loggedInUser.email,
                        'text': inputMessegesText,
                        'alias': 'goku',
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessegeBubble extends StatelessWidget {
  MessegeBubble({this.messegeText, this.messegeSender, this.alias, this.isMe});

  final String messegeText;
  final String messegeSender;
  final String alias;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messegeSender,
            style: TextStyle(fontSize: 11.0),
          ),
          Material(
            borderRadius: isMe == true
                ? BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0))
                : BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
            elevation: 5.5,
            color: isMe == true ? Colors.amberAccent : Colors.orangeAccent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                "$messegeText  ${alias == null ? '' : alias}",
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
