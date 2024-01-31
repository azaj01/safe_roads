import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/widgets/form_container_widget.dart';

class SettingsPopupMenu extends StatefulWidget {
  const SettingsPopupMenu({super.key});

  @override
  State<SettingsPopupMenu> createState() => _SettingsPopupMenuState();
}

class _SettingsPopupMenuState extends State<SettingsPopupMenu> {
  TextEditingController _machineIdController = TextEditingController();
  TextEditingController _sourceIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(Icons.settings_outlined),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.edit_document),
                  title: Text("Edit Machine ID"),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Edit Machine"),
                            actions: [
                              Form(
                                key: _formKey,
                                child: FormContainerWidget(
                                  hintText: "Machine ID",
                                  controller: _machineIdController,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("This is a critical action and will need you to sign in again"),
                              SizedBox(height: 10,),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      FirebaseFirestore.instance
                                          .collection('clients')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email)
                                          .update({
                                        'machine': _machineIdController.text
                                      });
                                      FirebaseAuth.instance.signOut();
                                    }
                                  },
                                  child: Text("Confirm"))
                            ],
                          ));
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.photo_camera_rounded),
                  title: Text("Edit Camera Source"),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Edit Camera Source"),
                            actions: [
                              Form(
                                key: _formKey,
                                child: FormContainerWidget(
                                  hintText: "Source",
                                  controller: _sourceIdController,
                                ),
                              ),
                              SizedBox(height: 10,),
                             // Text("This is a critical action and will need you to sign in again"),
                             // SizedBox(height: 10,),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      FirebaseFirestore.instance
                                          .collection('clients')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email)
                                          .update({
                                        'camera': _sourceIdController.text
                                      });
                                      //FirebaseAuth.instance.signOut();
                                    }
                                  },
                                  child: Text("Confirm"))
                            ],
                          ));
                },
              )
            ]);
  }
}
