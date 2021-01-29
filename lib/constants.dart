import 'package:flutter/material.dart';

const String kLogin_screen = 'login_screen';
const String kRegister_screen = 'register_screen';
const String kHome_screen = 'home_screen';
const String kSearch_screen = 'search_screen';
const String kProfile_friend = 'profile_friend';
const String kProfile_screen = 'profile_screen';
const String kChat_screen = 'chat_screen';
const kTextFieldPassword = InputDecoration(
  prefixIcon: Icon(Icons.vpn_key),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Enter Your Password',
  hintStyle: TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
  ),
);

const kTextFieldEmail = InputDecoration(
  prefixIcon: Icon(Icons.email),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Enter Your Email',
  hintStyle: TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
  ),
);
const kTextFieldAge = InputDecoration(
  prefixIcon: Icon(Icons.paste),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Enter Your Age',
  hintStyle: TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
  ),
);
const kTextFieldUsername = InputDecoration(
  prefixIcon: Icon(Icons.person),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Enter Your Username',
  hintStyle: TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
  ),
);

const kMainColorApp = 0xFF0C6C9F;
