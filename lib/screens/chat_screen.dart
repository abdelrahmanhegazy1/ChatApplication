import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/components/animation_widget.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/provider/chat_provider.dart';
import 'package:whatsapp/provider/home_provider.dart';
import 'package:whatsapp/services/firebase.dart';

class ChatScreen extends StatelessWidget {
  final FirebaseAuth mAuth = FirebaseAuth.instance;
  final _picker = ImagePicker();
  final TextEditingController myController = TextEditingController();
  static final ScrollController controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final Account friendProfile = ModalRoute.of(context).settings.arguments;
    //int chatID;
    final FirebaseFun firebaseFun = FirebaseFun();
    //int myIndex;
    String message;
    //StreamBuilder(builder: null,)
    Timer(
      Duration(milliseconds: 100),
      () => controller.jumpTo(controller.position.maxScrollExtent),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(friendProfile.username),
        leading: GestureDetector(
          onTap: () async {
            Navigator.pop(context);
            await Provider.of<HomeProvider>(context, listen: false)
                .getMessages(mAuth.currentUser.email, context);
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back,
                size: 15.0,
              ),
              CircleAvatar(
                backgroundImage: friendProfile.urlProfilePicture != 'xx'
                    ? NetworkImage(friendProfile.urlProfilePicture)
                    : AssetImage('images/chat_icon.png'),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/chat_background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: firebaseFun
                        .getStream(Provider.of<ChatProvider>(context).id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }

                      Provider.of<ChatProvider>(context, listen: false)
                          .listOfMessages
                          .clear();
                      List<Message> allMessages =
                          firebaseFun.getMessageSnapShot(snapshot.data.docs);

                      return AnimatedList(
                        controller: controller,
                        key: Provider.of<ChatProvider>(context).listKey,
                        initialItemCount: allMessages.length,
                        itemBuilder: (context, index, animation) {
                          return MyAwesomeAnimation(
                            animation: animation,
                            myWidget: getMessageWidget(
                                allMessages[index], index, context),
                          );
                        },
                        shrinkWrap: true,
                      );
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.lightBlueAccent, width: 0.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: myController,
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          //Do something with the user input.
                          message = value;
                        },
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                            onTap: () async {
                              PickedFile image = await _picker.getImage(
                                  source: ImageSource.gallery);
                              File file = File(image.path);

                              Message currentMessage = Message(
                                  message: null,
                                  reciver: friendProfile.email,
                                  sender: mAuth.currentUser.email,
                                  filePath:
                                      await firebaseFun.uploadChatRoomImage(
                                          FirebaseFun.id, file));
                              await firebaseFun.sendMessage(
                                  currentMessage, FirebaseFun.id);
                              Provider.of<ChatProvider>(context, listen: false)
                                  .sendMessage(currentMessage);
                              controller.animateTo(
                                  controller.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeOut);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: GestureDetector(
                        onTap: () async {
                          Message currentMessage = Message(
                              message: message,
                              reciver: friendProfile.email,
                              sender: mAuth.currentUser.email,
                              hour: Timestamp.now().toDate().hour,
                              minute: Timestamp.now().toDate().minute);
                          print(friendProfile.email);
                          print(mAuth.currentUser.email);
                          Provider.of<ChatProvider>(context, listen: false)
                              .sendMessage(currentMessage);

                          myController.clear();
                          await firebaseFun.sendMessage(
                              currentMessage, FirebaseFun.id);
                          controller.animateTo(
                              controller.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeOut);
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.blue[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding getMessageWidget(myMessage, index, context) {
    //  List<Padding> list = List<Padding>();
    Message message = myMessage;
    Padding padding;

    if (message.message == null) {
      //File file = File(message.filePath);
      padding = Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: message.sender == mAuth.currentUser.email
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              decoration: BoxDecoration(
                  borderRadius: message.sender == mAuth.currentUser.email
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        )
                      : BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                  color: message.sender == mAuth.currentUser.email
                      ? Colors.green[200]
                      : Colors.white),
              child: Image.network(
                message.filePath,
                height: 250,
              ),
            ),
          ),
        ),
      );
    } else {
      // DateTime current = Timestamp.now().toDate();
      padding = Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: message.sender == mAuth.currentUser.email
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                '${message.message}  ${message.hour}:${message.minute}',
                style: TextStyle(fontSize: 14, fontFamily: 'Maven_Pro'),
              ),
              decoration: BoxDecoration(
                  borderRadius: message.sender == mAuth.currentUser.email
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        )
                      : BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                  color: message.sender == mAuth.currentUser.email
                      ? Colors.green[200]
                      : Colors.white),
            ),
          ),
        ),
      );
    }

    //Provider.of<ChatProvider>(context, listen: false).enableBottomChat();

    //  list.add(padding);
    //controller.jumpTo(controller.position.maxScrollExtent);
    return padding;

    // return list;
  }
}
