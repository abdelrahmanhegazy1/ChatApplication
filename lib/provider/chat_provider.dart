import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/screens/chat_screen.dart';
import 'package:whatsapp/services/firebase.dart';

class ChatProvider with ChangeNotifier {
  FirebaseFun firebaseFun = FirebaseFun();
  List<Message> listOfMessages = List<Message>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  int id;

  void setId(int id) {
    this.id = id;
    notifyListeners();
  }

  // Future<void> getMessages(String senderEmail, String reciverEmail) async {
  //   listOfMessages.clear();
  //   listOfMessages
  //       .addAll(await firebaseFun.getAllMessages(senderEmail, reciverEmail));

  //   notifyListeners();
  // }

  void enableBottomChat() {
    ChatScreen.controller.animateTo(
        ChatScreen.controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut);
  }

  void sendMessage(Message message) {
    listOfMessages.add(message);
    listKey.currentState.insertItem(listOfMessages.length - 1);

    notifyListeners();
  }
}
