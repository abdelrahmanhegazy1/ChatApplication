import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/services/firebase.dart';

class HomeProvider with ChangeNotifier {
  List<Message> list = List<Message>();
  List<String> profilePictures = List<String>();
  FirebaseFun firebaseFun = FirebaseFun();
  // FirebaseFirestore database = FirebaseFirestore.instance;

  void setHomeChatMessage(List<Message> list) {
    this.list = list;
    notifyListeners();
  }

  void setProfilePictures(List<String> profilePictures) {
    this.profilePictures = profilePictures;
    notifyListeners();
  }

  Future<void> getMessages(
      String currentUserEmail, BuildContext context) async {
    list.clear();
    profilePictures.clear();
    list = await firebaseFun.getHomeChats(currentUserEmail);

    //print('hegzyyyyy ${listOfMessage[0].message}');
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    for (int i = 0; i < list.length; i++) {
      if (currentUserEmail == list[i].sender) {
        Account account = await firebaseFun.getOneAccount(list[i].reciver);
        String url = await firebaseFun.downloadProfilePicture(account.username);
        list[i].reciverUsername = account.username;
        //if (url == null) url = 'x';

        print('this is ${account.username} and his photo is $url');
        profilePictures.add(url);
      } else {
        Account account = await firebaseFun.getOneAccount(list[i].sender);
        String url = await firebaseFun.downloadProfilePicture(account.username);
        list[i].senderUsername = account.username;
        print(
            'this is ${account.username} and his photo is $url and the sender is ${list[i].sender}');
        // if (url == null) url = 'x';
        profilePictures.add(url);
      }
    }
    //print(list[0].message);
    print('wowwwwwwwww!!!!!!');
    notifyListeners();
  }
}
