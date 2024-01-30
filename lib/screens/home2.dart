import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/colors.dart';
import 'package:safe_roads/constants/text_styles.dart';

class Home2Page extends StatefulWidget {
  const Home2Page({super.key});

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_CARD_COLOR,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          PopupMenuButton(
              icon: CircleAvatar(
                backgroundColor: PRIMARY_COLOR,
                child: Text(
                    FirebaseAuth.instance.currentUser!.email![0].toUpperCase(),
                    style: AVATAR_TEXT_STYLE),
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        enabled: false,
                        value: 0,
                        child: Center(
                            child: CircleAvatar(
                          child: Text(
                              FirebaseAuth.instance.currentUser!.email![0]
                                  .toUpperCase(),
                              style: AVATAR_TEXT_STYLE_LARGE),
                          backgroundColor: PRIMARY_COLOR,
                          radius: 50,
                        ))),
                    PopupMenuItem(
                        enabled: false,
                        child: Center(
                            child: Text(
                          FirebaseAuth.instance.currentUser!.email!,
                          style: PRIMARY_TEXT_STYLE,
                        ))),
                    PopupMenuItem(
                      onTap: (){
                        FirebaseAuth.instance.signOut();
                      },
                      enabled: true,
                        child: Center(
                      child: Container(
                      //  height: 50,
                      //  width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: RED_BUTTON,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("LOGOUT", style: BUTTON_TEXT_STYLE),
                          ),
                        ),
                      ),
                    ))
                  ]),
        ],
      ),
      body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('/images/background_home.jpg')))));
    
  }
}
