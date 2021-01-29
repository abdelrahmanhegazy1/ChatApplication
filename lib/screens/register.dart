import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/provider/setting_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:whatsapp/services/firebase.dart';

class RegisterScreen extends StatelessWidget {
  final List genderList = ['Male', 'Female'];
  final int group = 1;
  final Account newAccount = Account();
  final FirebaseFun firebaseFun = new FirebaseFun();
  @override
  Widget build(BuildContext context) {
    newAccount.gender = 'Male';
    return ModalProgressHUD(
      inAsyncCall: Provider.of<SettingProvider>(context).swithProgress,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 100.0,
                          child: Image(
                            image: AssetImage('images/chat_icon.png'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 80,
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Color(kMainColorApp),
                          fontFamily: 'Maven_Pro',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      newAccount.username = value;
                    },
                    decoration: kTextFieldUsername,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      newAccount.email = value;
                    },
                    decoration: kTextFieldEmail,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      newAccount.password = value;
                    },
                    decoration: kTextFieldPassword,
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      newAccount.age = int.parse(value);
                    },
                    decoration: kTextFieldAge,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      iconEnabledColor: Color(kMainColorApp),
                      elevation: 5,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      style: TextStyle(
                        fontFamily: 'Maven_Pro',
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      dropdownColor: Color(kMainColorApp),
                      value: Provider.of<SettingProvider>(context, listen: true)
                          .selectedGender,
                      items: genderList.map((e) {
                        return DropdownMenuItem<String>(
                            child: Text(e), value: e);
                      }).toList(),
                      onChanged: (value) {
                        newAccount.gender = value;
                        Provider.of<SettingProvider>(context, listen: false)
                            .getGender(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                  child: Material(
                    elevation: 5.0,
                    color: Color(kMainColorApp),
                    borderRadius: BorderRadius.circular(30),
                    child: MaterialButton(
                      onPressed: () async {
                        Provider.of<SettingProvider>(context, listen: false)
                            .changeSwitch(true);
                        await firebaseFun.registerAccount(context, newAccount);
                        Provider.of<SettingProvider>(context, listen: false)
                            .changeSwitch(false);
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
