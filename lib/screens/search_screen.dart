import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/components/person_search.dart';
import 'package:whatsapp/constants.dart';
import 'package:whatsapp/model/account.dart';
import 'package:whatsapp/provider/account_provider.dart';
import 'package:whatsapp/services/firebase.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseFun firebaseFun = FirebaseFun();
  List<Account> accountsList = List<Account>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retriveAccounts();
  }

  void retriveAccounts() async {
    accountsList = await firebaseFun.getAccounts();
    print('hello');
  }

  // List<Container> accountsWidget(List<Account> accountsList) {
  //   List<Container> finalWidgets = List<Container>();
  //   for (int i = 0; i < accountsList.length; i++) {
  //     Container container = Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10.0),
  //       margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(30.0), color: Colors.grey[350]),
  //       child: Row(
  //         children: [
  //           Image.asset(
  //             'images/chat_icon.png',
  //             height: 75.0,
  //           ),
  //           SizedBox(
  //             width: 20.0,
  //           ),
  //           Expanded(
  //             child: Text(
  //               accountsList[i].username,
  //               style: TextStyle(
  //                   fontFamily: 'Maven_Pro',
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  //     finalWidgets.add(container);
  //   }
  //   return finalWidgets;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'images/chat_icon.png',
        ),
        title: Text(
          'ChatApp',
          style: TextStyle(fontFamily: 'Maven_Pro'),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) {
                Provider.of<AccountProvider>(context, listen: false)
                    .switchAccounts(accountsList, value);
              },
              style: TextStyle(fontFamily: 'Maven_Pro'),
              decoration: InputDecoration(
                hintText: 'Search for people',
                hintStyle: TextStyle(fontFamily: 'Maven_Pro'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              // children: accountsWidget(
              //     Provider.of<AccountProvider>(context).accountsList),

              itemCount:
                  Provider.of<AccountProvider>(context).accountsList.length,
              itemBuilder: (context, index) {
                return PersonSearch(
                  accountsList:
                      Provider.of<AccountProvider>(context).accountsList,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
