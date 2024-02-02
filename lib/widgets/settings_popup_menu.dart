import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/model/machine_model.dart';
import 'package:safe_roads/widgets/form_container_widget.dart';

class SettingsPopupMenu extends StatefulWidget {
  const SettingsPopupMenu(
      {super.key, required this.machineId, required this.machine});
  final String machineId;
  final Machine machine;
  @override
  State<SettingsPopupMenu> createState() => _SettingsPopupMenuState();
}

class _SettingsPopupMenuState extends State<SettingsPopupMenu> {
  final TextEditingController _machineIdController = TextEditingController();
  final TextEditingController _sourceIdController = TextEditingController();

  @override
  void dispose() {
    _machineIdController.dispose();
    _sourceIdController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _sourceIdController.text = widget.machine.camera;

    return PopupMenuButton(
        icon: const Icon(Icons.settings_outlined),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.edit_document),
                  title: Text("Edit Machine ID"),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Edit Machine"),
                            actions: [
                              Form(
                                key: _formKey,
                                child: FormContainerWidget(
                                  hintText: "Machine ID",
                                  controller: _machineIdController,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                  "This is a critical action and will need you to sign in again"),
                              const SizedBox(
                                height: 10,
                              ),
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
                                      Navigator.of(context).pop();
                                      FirebaseAuth.instance.signOut();
                                    }
                                  },
                                  child: const Text("Confirm"))
                            ],
                          ));
                },
              ),
              PopupMenuItem(
                enabled: !widget.machine.start,
                child: const ListTile(
                  leading: Icon(Icons.photo_camera_rounded),
                  title: Text("Edit Camera Source"),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Edit Camera Source"),
                            actions: [
                              Form(
                                key: _formKey,
                                child: FormContainerWidget(
                                  hintText: "Source",
                                  controller: _sourceIdController,
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "Source can't be empty";
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                  "CCTV IP Address and Youtube links are supported."),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      FirebaseFirestore.instance
                                          .collection('machines')
                                          .doc(widget.machineId)
                                          .update({
                                        'camera': _sourceIdController.text
                                      });
                                      Navigator.of(context).pop();
                                      //FirebaseAuth.instance.signOut();
                                    }
                                  },
                                  child: const Text("Confirm"))
                            ],
                          ));
                },
              )
            ]);
  }
}
