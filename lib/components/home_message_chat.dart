import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/provider/chat_provider.dart';
import 'package:whatsapp/provider/home_provider.dart';
import 'package:whatsapp/services/firebase.dart';

class HomeMessageChat extends StatelessWidget {
  final FirebaseFun firebaseFun = FirebaseFun();
  final int index;
  final List<Message> listOfMessage;
  final List<String> profilePhotos;
  final FirebaseAuth mAuth = FirebaseAuth.instance;

  final String currentUserEmail;
  HomeMessageChat(
      {this.currentUserEmail,
      this.index,
      this.listOfMessage,
      this.profilePhotos});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String email = listOfMessage[index].sender == mAuth.currentUser.email
            ? listOfMessage[index].reciver
            : listOfMessage[index].sender;
        Account account = await firebaseFun.getOneAccount(email);
        account.urlProfilePicture =
            await firebaseFun.downloadProfilePicture(account.username);
        //await Provider.of<ChatProvider>(context, listen: false)
        //  .getMessages(mAuth.currentUser.email, account.email);
        Provider.of<ChatProvider>(context, listen: false).setId(
            await firebaseFun.getChatID(
                mAuth.currentUser.email, account.email));
        Navigator.pushNamed(context, kChat_screen, arguments: account);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35.0,
                  backgroundImage: profilePhotos[index] != 'xx'
                      ? NetworkImage(profilePhotos[index])
                      : AssetImage('images/chat_icon.png'),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listOfMessage[index].sender == currentUserEmail
                        ? Text(
                            listOfMessage[index].reciverUsername,
                            style: TextStyle(
                                fontFamily: 'Maven_Pro',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        : Text(
                            listOfMessage[index].senderUsername,
                            style: TextStyle(
                                fontFamily: 'Maven_Pro',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                    listOfMessage[index].sender == currentUserEmail
                        ? Text(
                            listOfMessage[index].message ?? 'Photo 📷',
                            style: TextStyle(
                                color: Color(kMainColorApp),
                                fontFamily: 'Maven_Pro',
                                fontSize: 17.0),
                          )
                        : Text(
                            listOfMessage[index].message ?? 'Photo 📷',
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Maven_Pro',
                                fontSize: 17.0),
                          ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            child: Divider(
              thickness: 2.0,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
