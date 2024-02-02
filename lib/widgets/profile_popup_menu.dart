import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/colors.dart';
import 'package:safe_roads/constants/text_styles.dart';

class ProfilePopupMenu extends StatelessWidget {
  const ProfilePopupMenu({super.key, required this.machineId});
  final String machineId;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
                    backgroundColor: PRIMARY_COLOR,
                    radius: 50,
                    child: Text(
                        FirebaseAuth.instance.currentUser!.email![0]
                            .toUpperCase(),
                        style: AVATAR_TEXT_STYLE_LARGE),
                  ))),
              PopupMenuItem(
                  enabled: false,
                  child: Center(
                      child: Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: PRIMARY_TEXT_STYLE,
                  ))),
              PopupMenuItem(
                  enabled: false,
                  child: Center(
                      child: SelectableText(
                    "Machine ID: ${machineId}",
                    style: PRIMARY_TEXT_STYLE,
                    textAlign: TextAlign.center,
                  ))),
              PopupMenuItem(
                  onTap: () {
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
            ]);
  }
}
