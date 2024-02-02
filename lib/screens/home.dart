import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/model/accident_model.dart';
import 'package:safe_roads/model/machine_model.dart';
import 'package:safe_roads/widgets/accidents_widget.dart';
import 'package:safe_roads/widgets/profile_popup_menu.dart';
import 'package:safe_roads/widgets/settings_popup_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Accident> accidents = [];
  Machine machine = Machine(
      id: "fetching", status: "fetching", camera: "fetching", start: false);
  String? machineId;
  fetchMachineId() {
    try {
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
    } catch (e) {
      Fluttertoast.showToast(msg: "Firestore Error: $e");
    }
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

  Map<String, Color> statusColor = {
    "IDLE": Colors.amber,
    "ACTIVE": Colors.green,
    "CAMERA_SOURCE_ERROR": Colors.red,
    "FETCHING": Colors.blue,
    "MACHINE_ERROR": Colors.red,
    "MACHINE_DISCONNECTED": Color.fromARGB(255, 199, 123, 228),
  };
  @override
  Widget build(BuildContext context) {
    bool start = machine.start;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 225, 115),
          title: Text(
            "Safe Roads",
            style: SCAFFOLD_TEXT_STYLE,
          ),
          actions: [
            ElevatedButton.icon(
                onPressed:
                    (machine.status.toUpperCase() == 'MACHINE_DISCONNECTED')
                        ? null
                        : () {
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
                        color: (machine.status.toUpperCase() ==
                                'MACHINE_DISCONNECTED')
                            ? Colors.grey
                            : Colors.red,
                      ))
                    : (Icon(Icons.play_arrow,
                        color: (machine.status.toUpperCase() ==
                                'MACHINE_DISCONNECTED')
                            ? Colors.grey
                            : Colors.green)),
                label: (Text(start ? "STOP" : "START"))),
            SettingsPopupMenu(
              machineId: machineId ?? "",
              machine: machine,
            ),
            ProfilePopupMenu(
              machineId: machineId ?? "fetching...",
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/background_home.jpg'))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Detected Accidents",
                        style: TextStyle(fontFamily: 'Kreon', fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: (machineId != null)
                        ? AccidentWidget(
                            accidentList: accidents,
                            machineId: machineId!,
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: statusColor[machine.status.toUpperCase()],
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                              "Machine Status : ${machine.status.toUpperCase()}",
                              style: const TextStyle(
                                  fontFamily: 'Kreon', fontSize: 15))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
