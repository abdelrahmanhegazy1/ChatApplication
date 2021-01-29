import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/provider/home_provider.dart';
import 'package:whatsapp/provider/setting_provider.dart';
import 'package:whatsapp/services/firebase.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  FirebaseFun firebaseFun = FirebaseFun();
  List<Message> listOfMessage;
  List<String> profilePhotos = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<SettingProvider>(context).swithProgress,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: Image(
                      image: AssetImage('images/chat_icon.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 45.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kTextFieldEmail,
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kTextFieldPassword,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 25.0),
                child: Material(
                  elevation: 5.0,
                  color: Color(kMainColorApp),
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    onPressed: () async {
                      Provider.of<SettingProvider>(context, listen: false)
                          .changeSwitch(true);
                      Account acc = await firebaseFun.loginAccount(
                          context, email, password);

                      if (acc.email != null) {
                        await Provider.of<HomeProvider>(context, listen: false)
                            .getMessages(acc.email, context);
                        print('hello');
                        acc.urlProfilePicture = await firebaseFun
                            .downloadProfilePicture(acc.username);

                        Provider.of<SettingProvider>(context, listen: false)
                            .changeSwitch(false);
                        Navigator.pushNamed(context, kHome_screen,
                            arguments: acc);
                      }
                      Provider.of<SettingProvider>(context, listen: false)
                          .changeSwitch(false);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
                child: Text(
                  'Forget your password?',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Maven_Pro',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: Row(
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Maven_Pro',
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, kRegister_screen);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 14.0,
                          fontFamily: 'Maven_Pro',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
