import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/model/accident_model.dart';

class AccidentWidget extends StatefulWidget {
  const AccidentWidget({super.key, required this.machineId});

  final String machineId;
  @override
  State<AccidentWidget> createState() => _AccidentWidgetState();
}

class _AccidentWidgetState extends State<AccidentWidget> {
  List<Accident> accidents = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('machines')
        .doc(widget.machineId)
        .collection('accidents')
        .snapshots()
        .listen((event) {
          print("2231: Init state of accident widget");
      accidents = [];
      event.docs.map((e) {
        setState(() {
          accidents.add(Accident.fromdb(e));
        });
      }).toList();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    accidents.sort(
        (a, b) => ("${b.date} ${b.time}").compareTo("${a.date} ${a.time}"));
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
          itemCount: accidents.length,
          itemBuilder: (context, index) {
            return Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${index + 1}",
                      style: GENERAL_BODY_TEXT_STYLE,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      accidents[index].image,
                      height: 200,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(accidents[index].date,style:GENERAL_BODY_TEXT_STYLE),
                        Text(accidents[index].time,style:GENERAL_BODY_TEXT_STYLE)
                      ],
                    ),
                  ),
                ],
              ),
            ));
          }),
    );
  }
}
