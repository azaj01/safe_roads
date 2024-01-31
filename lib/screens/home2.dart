import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/colors.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/model/accident_model.dart';
import 'package:safe_roads/model/machine_model.dart';
import 'package:safe_roads/widgets/accidents_widget.dart';
import 'package:safe_roads/widgets/form_container_widget.dart';
import 'package:safe_roads/widgets/profile_popup_menu.dart';
import 'package:safe_roads/widgets/settings_popup_menu.dart';

class Home2Page extends StatefulWidget {
  const Home2Page({super.key});

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
  List<Accident> accidents = [];
  Machine machine = Machine(id: "fetching", status: "fetching");
  String? machineId;
  fetchMachineId() {
    FirebaseFirestore.instance
        .collection('clients')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .listen((event) {
      do {
        machineId = event['machine'];
      } while (machineId == null);
      fetchAccidentList();
      fetchMachineStatus();
    });
  }

  fetchMachineStatus() {
    FirebaseFirestore.instance
        .collection('machines')
        .doc(machineId)
        .snapshots()
        .listen((event) {
      setState(() {
        machine = Machine.fromdb(event);
      });
    });
  }

  fetchAccidentList() {
    print(machineId);
    FirebaseFirestore.instance
        .collection('machines')
        .doc(machineId)
        .collection('accidents')
        .snapshots()
        .listen((event) {
      accidents = [];
      event.docs.map((e) {
        setState(() {
          accidents.add(Accident.fromdb(e));
        });
      }).toList();
    });
  }

  @override
  void initState() {
    fetchMachineId();
    // TODO: implement initState

    super.initState();
  }

  bool start = false;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Safe Roads",
            style: PRIMARY_TEXT_STYLE,
          ),
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    start = !start;
                  });

                  FirebaseFirestore.instance
                      .collection('machines')
                      .doc(machineId)
                      .update({'start': start});
                },
                icon: start
                    ? (Icon(
                        Icons.stop,
                        color: Colors.red,
                      ))
                    : (Icon(Icons.play_arrow, color: Colors.green)),
                label: (Text(start ? "STOP" : "START"))),
            SettingsPopupMenu(),
            ProfilePopupMenu()
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('/images/background_home.jpg'))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text(
                            "Detected Accidents",
                            style: TextStyle(fontFamily: 'Kreon', fontSize: w/40),
                          ),
                          Spacer(),
                          Text("Machine Status: ${machine.status}",
                              style: TextStyle(fontFamily: 'Kreon', fontSize: w/40))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: (machineId != null)
                        ? AccidentWidget(
                            accidentList: accidents,
                            machineId: machineId!,
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
