import 'package:flutter/material.dart';
import 'package:whatsapp/model/account.dart';

import '../constants.dart';

class PersonSearch extends StatelessWidget {
  final int index;
  final List<Account> accountsList;
  PersonSearch({this.accountsList, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print(accountsList[index].username);
        Navigator.pushNamed(context, kProfile_friend,
            arguments: accountsList[index]);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0), color: Colors.grey[350]),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: accountsList[index].urlProfilePicture != 'xx'
                  ? NetworkImage(
                      accountsList[index].urlProfilePicture,
                    )
                  : AssetImage('images/chat_icon.png'),
              radius: 50,
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                accountsList[index].username,
                style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
