import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp/model/message.dart';

class FirebaseFun {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  FirebaseFirestore database = FirebaseFirestore.instance;
  static int id;

  Future<void> signoutAccount() async {
    await mAuth.signOut();
  }

  Future<void> registerAccount(BuildContext context, Account newAccount) async {
    try {
      UserCredential user = await mAuth.createUserWithEmailAndPassword(
          email: newAccount.email, password: newAccount.password);

      if (user != null) {
        Map<String, dynamic> map = {
          "username": newAccount.username,
          "email": newAccount.email,
          "password": newAccount.password,
          "age": newAccount.age,
          "gender": newAccount.gender
        };
        await database.collection('users').doc(newAccount.email).set(map);
        Navigator.pushReplacementNamed(context, kLogin_screen);
      }
    } catch (e) {
      Alert(
              context: context,
              title: "ERROR",
              desc: "Your Information Not correct")
          .show();
    }
  }

  Future<Account> loginAccount(
      BuildContext context, String email, String password) async {
    Account loginAccount = Account();
    try {
      await mAuth.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot documentSnapshot =
          await database.collection('users').doc(email).get();
      loginAccount.username = documentSnapshot.get('username');
      loginAccount.password = documentSnapshot.get('password');
      loginAccount.age = documentSnapshot.get('age');
      loginAccount.gender = documentSnapshot.get('gender');
      loginAccount.email = documentSnapshot.get('email');
    } catch (e) {
      Alert(
              context: context,
              title: "ERROR",
              desc: "Your Username/Password Incorrect,Please Try Again")
          .show();
    }
    return loginAccount;
  }

  Future<List<Account>> getAccounts() async {
    List<Account> allAccounts = List<Account>();
    QuerySnapshot querySnapshot = await database.collection('users').get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      final Map<String, dynamic> map = documentSnapshot.data();
      final Account account = Account();
      print(map['email']);
      account.age = map['age'];
      account.email = map['email'];
      account.gender = map['gender'];
      account.username = map['username'];
      account.password = map['password'];
      try {
        account.urlProfilePicture =
            await downloadProfilePicture(account.username);
      } catch (e) {
        print('he dont have');
      }
      allAccounts.add(account);
    }

    return allAccounts;
  }

  Future<void> uploadProfilePicture(String username, File file) async {
    Reference ref = FirebaseStorage.instance.ref().child('$username.jpg');

    UploadTask task = ref.putFile(file);
  }

  Future<String> uploadChatRoomImage(int chatID, File file) async {
    String imageTimestamp = DateTime.now().microsecondsSinceEpoch.toString();
    String filePath = 'chatrooms/$chatID/$imageTimestamp';
    Reference ref = FirebaseStorage.instance.ref().child(filePath);
    await ref.putFile(file);
    String s = await ref.getDownloadURL();
    print('medaaa $s');
    return s;
  }

  Future<String> downloadProfilePicture(String username) async {
    String url;
    try {
      Reference ref = FirebaseStorage.instance.ref().child('$username.jpg');
      url = await ref.getDownloadURL();
    } catch (e) {
      url = 'xx';
    }

    return url;
  }

  Future<void> editAccount(Account account) async {
    Map<String, dynamic> map = {
      "email": account.email,
      "username": account.username,
      "password": account.password,
      "gender": account.gender,
      "age": account.age
    };

    try {
      await database.collection('users').doc(account.email).set(map);
    } catch (e) {
      print('Error');
    }
  }

  Future<void> sendMessage(Message message, int chatID) async {
    Map<String, dynamic> map = {
      "message": message.message,
      "sender": message.sender,
      "reciver": message.reciver,
      "timestamp": Timestamp.now().toString(),
      "filepath": message.filePath,
      "hour": message.hour,
      "minute": message.minute
    };

    // await database
    //     .collection('chats')
    //     .doc(message.sender)
    //     .collection(message.reciver)
    //     .doc()
    //     .set(map);
    // await database
    //     .collection('chats')
    //     .doc(message.reciver)
    //     .collection(message.sender)
    //     .doc()
    //     .set(map);
    Map<String, dynamic> firstMap = {
      "first": message.sender,
      "second": message.reciver
    };
    //print('abdooooo${message.filePath}');
    await database.collection('chats').doc(chatID.toString()).set(firstMap);
    await database
        .collection('chats')
        .doc(chatID.toString())
        .collection('messages')
        .doc()
        .set(map);
  }

  Future<int> getChatID(String senderEmail, String reciverEmail) async {
    int id;
    QuerySnapshot querySnapShot = await database.collection('chats').get();
    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapShot.docs) {
      if (queryDocumentSnapshot.get('first') == senderEmail &&
          queryDocumentSnapshot.get('second') == reciverEmail) {
        id = int.parse(queryDocumentSnapshot.id);
        break;
      } else if (queryDocumentSnapshot.get('second') == senderEmail &&
          queryDocumentSnapshot.get('first') == reciverEmail) {
        id = int.parse(queryDocumentSnapshot.id);
        break;
      }
    }
    return id;
  }

  Stream<QuerySnapshot> getStream(int chatID) {
    return database
        .collection('chats')
        .doc(chatID.toString())
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  List<Message> getMessageSnapShot(messages) {
    print('xo');
    List<Message> allMessages = List<Message>();
    for (var message in messages) {
      Message message2 = Message();
      print('what!!!!!!!!!!!!!!!!!!!!');
      print(message.get('message'));
      message2.sender = message.get('sender');
      message2.reciver = message.get('reciver');
      message2.message = message.get('message');
      message2.filePath = message.get('filepath');
      message2.hour = message.get('hour');
      message2.minute = message.get('minute');
      allMessages.add(message2);
    }

    return allMessages;
  }

  Future<List<Message>> messageStream(
      String senderEmail, String reciverEmail) async {
    bool flag = false;
    List<Message> listofMessages = List<Message>();
    QuerySnapshot querySnapShot = await database.collection('chats').get();
    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapShot.docs) {
      print('${queryDocumentSnapshot.get('first')}this is the first de7k');
      id = int.parse(queryDocumentSnapshot.id);
      if (queryDocumentSnapshot.get('first') == senderEmail &&
          queryDocumentSnapshot.get('second') == reciverEmail) {
        flag = true;
        await for (var snapshot in database
            .collection('chats')
            .doc(id.toString())
            .collection('messages')
            .orderBy('timestamp')
            .snapshots()) {
          for (QueryDocumentSnapshot queryDocumentSnapshot2 in snapshot.docs) {
            Message message = Message();
            message.sender = queryDocumentSnapshot2.get('sender');
            message.reciver = queryDocumentSnapshot2.get('reciver');
            message.message = queryDocumentSnapshot2.get('message');
            message.filePath = queryDocumentSnapshot2.get('filepath');
            message.hour = queryDocumentSnapshot2.get('hour');
            message.minute = queryDocumentSnapshot2.get('minute');
            listofMessages.add(message);
          }
        }

        break;
      } else if (queryDocumentSnapshot.get('first') == reciverEmail &&
          queryDocumentSnapshot.get('second') == senderEmail) {
        flag = true;
        await for (var snapshot in database
            .collection('chats')
            .doc(id.toString())
            .collection('messages')
            .orderBy('timestamp')
            .snapshots()) {
          for (QueryDocumentSnapshot queryDocumentSnapshot2 in snapshot.docs) {
            Message message = Message();
            message.sender = queryDocumentSnapshot2.get('sender');
            message.reciver = queryDocumentSnapshot2.get('reciver');
            message.message = queryDocumentSnapshot2.get('message');
            message.filePath = queryDocumentSnapshot2.get('filepath');
            message.hour = queryDocumentSnapshot2.get('hour');
            message.minute = queryDocumentSnapshot2.get('minute');
            listofMessages.add(message);
          }
        }
        break;
      }
    }
    if (!flag) {
      DocumentSnapshot documentSnapshot =
          await database.collection('lastChatID').doc('chat').get();
      id = documentSnapshot.get('chatID');
      print('here');
      print(id);
      id = id + 1;
      Map<String, dynamic> mp = {'chatID': id};
      await database.collection('lastChatID').doc('chat').set(mp);
    }
    return listofMessages;
  }

  // Future<List<Message>> getAllMessages(
  //     String senderEmail, String reciverEmail) async {
  //   List<Message> listofMessages = List<Message>();

  //   bool flag = false;
  //   QuerySnapshot querySnapShot = await database.collection('chats').get();
  //   print('this is the length ${querySnapShot.docs.length}');
  //   for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapShot.docs) {
  //     print('${queryDocumentSnapshot.get('first')}this is the first de7k');
  //     id = int.parse(queryDocumentSnapshot.id);
  //     if (queryDocumentSnapshot.get('first') == senderEmail &&
  //         queryDocumentSnapshot.get('second') == reciverEmail) {
  //       flag = true;
  //       QuerySnapshot querySnapShot2 = await database
  //           .collection('chats')
  //           .doc(id.toString())
  //           .collection('messages')
  //           .orderBy('timestamp')
  //           .get();

  //       for (QueryDocumentSnapshot queryDocumentSnapshot2
  //           in querySnapShot2.docs) {
  //         Message message = Message();
  //         message.sender = queryDocumentSnapshot2.get('sender');
  //         message.reciver = queryDocumentSnapshot2.get('reciver');
  //         message.message = queryDocumentSnapshot2.get('message');
  //         message.filePath = queryDocumentSnapshot2.get('filepath');
  //         message.hour = queryDocumentSnapshot2.get('hour');
  //         message.minute = queryDocumentSnapshot2.get('minute');
  //         listofMessages.add(message);
  //       }
  //       break;
  //     } else if (queryDocumentSnapshot.get('first') == reciverEmail &&
  //         queryDocumentSnapshot.get('second') == senderEmail) {
  //       flag = true;
  //       QuerySnapshot querySnapShot2 = await database
  //           .collection('chats')
  //           .doc(id.toString())
  //           .collection('messages')
  //           .orderBy('timestamp')
  //           .get();

  //       for (QueryDocumentSnapshot queryDocumentSnapshot2
  //           in querySnapShot2.docs) {
  //         Message message = Message();
  //         message.sender = queryDocumentSnapshot2.get('sender');
  //         message.reciver = queryDocumentSnapshot2.get('reciver');
  //         message.message = queryDocumentSnapshot2.get('message');
  //         message.filePath = queryDocumentSnapshot2.get('filepath');
  //         message.hour = queryDocumentSnapshot2.get('hour');
  //         message.minute = queryDocumentSnapshot2.get('minute');
  //         listofMessages.add(message);
  //       }
  //       break;
  //     }
  //   }
  //   if (!flag) {
  //     DocumentSnapshot documentSnapshot =
  //         await database.collection('lastChatID').doc('chat').get();
  //     id = documentSnapshot.get('chatID');
  //     print('here');
  //     print(id);
  //     id = id + 1;
  //     Map<String, dynamic> mp = {'chatID': id};
  //     await database.collection('lastChatID').doc('chat').set(mp);
  //   }
  //   return listofMessages;
  // }

  Future<List<Message>> getHomeChats(String email) async {
    List<Message> list = List<Message>();
    QuerySnapshot querySnapShot = await database.collection('chats').get();
    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapShot.docs) {
      if (queryDocumentSnapshot.get('first') == email ||
          queryDocumentSnapshot.get('second') == email) {
        QuerySnapshot querySnapShot2 = await database
            .collection('chats')
            .doc(queryDocumentSnapshot.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .get();
        Message message = Message();

        print('debughahaha ${querySnapShot2.docs.last.get('message')}');
        message.sender = querySnapShot2.docs.first.get('sender');
        message.reciver = querySnapShot2.docs.first.get('reciver');
        message.message = querySnapShot2.docs.first.get('message');
        message.filePath = querySnapShot2.docs.first.get('filepath');
        message.hour = querySnapShot2.docs.first.get('hour');
        message.minute = querySnapShot2.docs.first.get('minute');
        message.timestamp = querySnapShot2.docs.first.get('timestamp');

        list.add(message);
      }
    }
    return list;
  }

  Future<Account> getOneAccount(String email) async {
    DocumentSnapshot documentSnapshot =
        await database.collection('users').doc(email).get();
    Account account = Account();
    print('email is $email');
    account.username = documentSnapshot.get('username');
    account.age = documentSnapshot.get('age');
    account.email = documentSnapshot.get('email');
    account.password = documentSnapshot.get('password');
    account.gender = documentSnapshot.get('gender');
    return account;
  }
}
