import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  String reciver;
  String message;
  String filePath;
  int hour;
  int minute;
  String timestamp;
  String senderUsername;
  String reciverUsername;

  Message(
      {this.message,
      this.reciver,
      this.sender,
      this.filePath,
      this.minute,
      this.hour,
      this.timestamp});
}
