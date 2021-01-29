import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/provider/account_provider.dart';
import 'package:whatsapp/provider/chat_provider.dart';
import 'package:whatsapp/provider/home_provider.dart';
import 'package:whatsapp/provider/setting_provider.dart';
import 'package:whatsapp/screens/chat_screen.dart';
import 'package:whatsapp/screens/home.dart';
import 'package:whatsapp/screens/login.dart';
import 'package:whatsapp/screens/profile.dart';
import 'package:whatsapp/screens/register.dart';
import 'package:whatsapp/screens/search_profile.dart';
import 'package:whatsapp/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<SettingProvider>(context).themeData,
      initialRoute: kLogin_screen,
      routes: {
        kLogin_screen: (context) => LoginScreen(),
        kRegister_screen: (context) => RegisterScreen(),
        kHome_screen: (context) => HomeScreen(),
        kSearch_screen: (context) => SearchScreen(),
        kProfile_friend: (context) => SearchProfile(),
        kProfile_screen: (context) => ProfileScreen(),
        kChat_screen: (context) => ChatScreen(),
      },
    );
  }
}
