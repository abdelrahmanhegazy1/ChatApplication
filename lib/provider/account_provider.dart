import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/account.dart';

class AccountProvider with ChangeNotifier {
  List<Account> accountsList = List<Account>();
  Account searchedProfile = Account();
  File profilePicture;
  String profilePic;
  void switchAccounts(List<Account> list, String s) {
    accountsList.clear();
    if (s != "") {
      for (int i = 0; i < list.length; i++) {
        if (list[i].username.contains(s)) {
          print(list[i].username);
          accountsList.add(list[i]);
        }
      }
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void setSearchedProfile(Account account) {
    searchedProfile = account;
    notifyListeners();
  }

  void changeProfile(String url) {
    profilePic = url;
    notifyListeners();
  }
}
