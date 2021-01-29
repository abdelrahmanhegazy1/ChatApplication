import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/provider/chat_provider.dart';
import 'package:whatsapp/services/firebase.dart';

class SearchProfile extends StatelessWidget {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  FirebaseFun firebaseFun = FirebaseFun();
  @override
  Widget build(BuildContext context) {
    final Account friendProfile = ModalRoute.of(context).settings.arguments;
    print(friendProfile.email);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontFamily: 'Maven_Pro'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              GestureDetector(
                onTap: () {
                  //Upload photo
                },
                child: CircleAvatar(
                  backgroundImage: friendProfile.urlProfilePicture != 'xx'
                      ? NetworkImage(
                          friendProfile.urlProfilePicture,
                        )
                      : AssetImage('images/chat_icon.png'),
                  radius: 75.0,
                ),
              ),
              SizedBox(
                width: 30.0,
              ),
              Expanded(
                child: Text(
                  friendProfile.username,
                  style: TextStyle(
                      fontFamily: 'Maven_Pro',
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Color(kMainColorApp)),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () async {
                    Provider.of<ChatProvider>(context, listen: false).setId(
                        await firebaseFun.getChatID(
                            mAuth.currentUser.email, friendProfile.email));

                    Navigator.pushNamed(context, kChat_screen,
                        arguments: friendProfile);
                  })
            ]),
            SizedBox(
              child: Divider(
                thickness: 3.0,
                color: Colors.grey[350],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Text(
                'Email: ${friendProfile.email}',
                style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Color(kMainColorApp)),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Text(
                'Age: ${friendProfile.age}',
                style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Color(kMainColorApp)),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Text(
                'Gender: ${friendProfile.gender}',
                style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Color(kMainColorApp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
