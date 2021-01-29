import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/provider/account_provider.dart';
import 'package:whatsapp/provider/setting_provider.dart';
import 'package:whatsapp/services/firebase.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final _picker = ImagePicker();
  File file;
  FirebaseFun firebaseFun = FirebaseFun();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Account currentProfile = ModalRoute.of(context).settings.arguments;
    print(currentProfile.email);
    userNameController.text = currentProfile.username;
    emailController.text = currentProfile.email;
    ageController.text = currentProfile.age.toString();
    genderController.text = currentProfile.gender;

    return ModalProgressHUD(
      inAsyncCall: Provider.of<SettingProvider>(context).swithProgress,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(fontFamily: 'Maven_Pro'),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.check,
                ),
                onPressed: () async {
                  Provider.of<SettingProvider>(context, listen: false)
                      .changeSwitch(true);
                  await firebaseFun.editAccount(currentProfile);
                  Provider.of<SettingProvider>(context, listen: false)
                      .changeSwitch(false);

                  //TODO:save data;
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: CircleAvatar(
                  backgroundImage: currentProfile.urlProfilePicture == null
                      ? AssetImage('images/chat_icon.png')
                      : NetworkImage(
                          currentProfile.urlProfilePicture,
                        ),
                  radius: 75.0,
                ),
              ),
              FlatButton(
                onPressed: () async {
                  //TODO: add picture from device
                  Provider.of<SettingProvider>(context, listen: false)
                      .changeSwitch(true);
                  PickedFile image =
                      await _picker.getImage(source: ImageSource.gallery);
                  file = File(image.path);
                  await firebaseFun.uploadProfilePicture(
                      currentProfile.username, file);
                  // setState(() {
                  //   currentProfile.urlProfilePicture = file.path;
                  // });
                  currentProfile.urlProfilePicture = await firebaseFun
                      .downloadProfilePicture(currentProfile.username);
                  Provider.of<SettingProvider>(context, listen: false)
                      .changeSwitch(true);
                  setState(() {});
                },
                child: Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    color: Color(kMainColorApp),
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: TextField(
                  onChanged: (value) {
                    currentProfile.username = value;
                  },
                  controller: userNameController,
                  style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(kMainColorApp),
                  ),
                  decoration: InputDecoration(
                    hintText: 'username',
                    hintStyle: TextStyle(fontFamily: 'Maven_Pro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: TextField(
                  onChanged: (value) {
                    currentProfile.email = value;
                  },
                  enabled: false,
                  controller: emailController,
                  style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'email',
                    hintStyle: TextStyle(fontFamily: 'Maven_Pro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: TextField(
                  onChanged: (value) {
                    currentProfile.gender = value;
                  },
                  controller: genderController,
                  style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(kMainColorApp),
                  ),
                  decoration: InputDecoration(
                    hintText: 'gender',
                    hintStyle: TextStyle(fontFamily: 'Maven_Pro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: TextField(
                  onChanged: (value) {
                    currentProfile.age = int.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  style: TextStyle(
                    fontFamily: 'Maven_Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(kMainColorApp),
                  ),
                  decoration: InputDecoration(
                    hintText: 'age',
                    hintStyle: TextStyle(fontFamily: 'Maven_Pro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
