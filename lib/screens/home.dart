import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/components/home_message_chat.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/provider/home_provider.dart';
import 'package:whatsapp/services/firebase.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseFun firebaseFun = FirebaseFun();
  final List<Message> homeMessages = List<Message>();

  @override
  Widget build(BuildContext context) {
    final Account currentProfile = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat App',
          style: TextStyle(fontFamily: 'Maven_Pro'),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, kSearch_screen);
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: CircleAvatar(
                      backgroundImage: currentProfile.urlProfilePicture != 'xx'
                          ? NetworkImage(currentProfile.urlProfilePicture)
                          : AssetImage('images/chat_icon.png'),
                      radius: 30,
                    ),
                  ),
                  Text(
                    '${currentProfile.username}',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Maven_Pro',
                        color: Colors.white),
                  ),
                  Text(
                    '${currentProfile.email}',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Maven_Pro',
                        color: Colors.white),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(kMainColorApp),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, kProfile_screen,
                    arguments: currentProfile);
              },
              leading: Icon(Icons.person),
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                // Update the state of the app
                // ...
                // Then close the drawer
                await firebaseFun.signoutAccount();
                Navigator.popUntil(context, ModalRoute.withName(kLogin_screen));
              },
              leading: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: Provider.of<HomeProvider>(context).list.length,
        itemBuilder: (context, index) {
          return HomeMessageChat(
            currentUserEmail: currentProfile.email,
            index: index,
            listOfMessage:
                Provider.of<HomeProvider>(context, listen: true).list,
            profilePhotos: Provider.of<HomeProvider>(context, listen: true)
                .profilePictures,
          );
        },
      ),
    );
  }

  Future<void> getChatsHome(String email) async {}
}
