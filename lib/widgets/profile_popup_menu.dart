import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/colors.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/functions/firebase_auth.dart';
import 'package:safe_roads/widgets/form_container_widget.dart';

class ProfilePopupMenu extends StatefulWidget {
  const ProfilePopupMenu({super.key, required this.machineId});
  final String machineId;

  @override
  State<ProfilePopupMenu> createState() => _ProfilePopupMenuState();
}

class _ProfilePopupMenuState extends State<ProfilePopupMenu> {
  TextEditingController _oldPass = TextEditingController();
  TextEditingController _newPass = TextEditingController();
  TextEditingController _retypedNewPass = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _oldPass.dispose();
    _newPass.dispose();
    _retypedNewPass.dispose();
    super.dispose();
  }

  var _changepasskey = GlobalKey<FormState>();
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
                    "Machine ID: ${widget.machineId}",
                    style: PRIMARY_TEXT_STYLE,
                    textAlign: TextAlign.center,
                  ))),
              PopupMenuItem(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Change Password"),
                              actions: [
                                Form(
                                  key: _changepasskey,
                                  child: Column(children: [
                                    FormContainerWidget(
                                      controller: _oldPass,
                                      hintText: "Old Password",
                                      isPasswordField: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FormContainerWidget(
                                      controller: _newPass,
                                      hintText: "New Password",
                                      isPasswordField: true,
                                      validator: (value) {
                                        if (value == null || value.length < 6) {
                                          return "Minimum length should be 6";
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FormContainerWidget(
                                      controller: _retypedNewPass,
                                      hintText: "Retype New Password",
                                      isPasswordField: true,
                                      validator: (value) {
                                        if (value != _newPass.text) {
                                          return "Does not match previous field";
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_changepasskey.currentState!
                                              .validate()) {
                                            changePassword(
                                                oldPass: _oldPass.text,
                                                newPass: _newPass.text);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text("Confirm"))
                                  ]),
                                )
                              ],
                            ));
                  },
                  enabled: true,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GREEN_BUTTON,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text("CHANGE PASSWORD", style: BUTTON_TEXT_STYLE),
                        ),
                      ),
                    ),
                  )),
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
