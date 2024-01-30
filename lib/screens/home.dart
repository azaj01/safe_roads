import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/model/machine_model.dart';
import 'package:safe_roads/widgets/accidents_widget.dart';
import 'package:safe_roads/widgets/form_container_widget.dart';
import 'package:safe_roads/widgets/status_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? machineId;
  Machine? machine;
  @override
  void initState() {
    // TODO: implement initState
    print("Reached");
    FirebaseFirestore.instance
        .collection('clients')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      do{
      setState(() {
        machineId = value['machine'];
      });
      print(machineId);}
      while(machineId==null);
      FirebaseFirestore.instance
        .collection('machines')
        .doc(machineId)
        .snapshots()
        .listen((event) {
      setState(() {
        do{
          machine = Machine.fromdb(event);
        }
        while(machine==null);
        
      });
    });
    });
    //print(machineId);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (machine == null && machineId == null)
        ? Scaffold(
            body: Container(child:  LinearProgressIndicator()))
        : Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('/images/background_home.jpg'))),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              
                              color: Colors.black.withOpacity(.5)),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  radius: 80,
                                  child: Center(
                                      child: Text(
                                    (FirebaseAuth
                                        .instance.currentUser!.email!)[0],
                                    style: PRIMARY_TEXT_STYLE,
                                  )),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: StatusWidget(
                                    machine: machine!,
                                  ))
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color.fromARGB(255, 115, 161, 229)),
                                        child: Center(
                                            child: Text("EDIT MACHINE",
                                                style: BODY_TEXT_STYLE))),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color.fromARGB(255, 236, 160, 47)),
                                        child: Center(
                                            child: Text("DELETE",
                                                style: BODY_TEXT_STYLE))),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.red[300]),
                                        child: Center(
                                            child: Text("LOGOUT",
                                                style: BODY_TEXT_STYLE))),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(53),
                                    color: Colors.white.withOpacity(.5)),
                                child: Expanded(
                                    child: AccidentWidget(
                                  machineId: machineId!,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )));
  }
}
