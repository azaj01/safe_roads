import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/model/machine_model.dart';
import 'package:safe_roads/widgets/form_container_widget.dart';

class StatusWidget extends StatefulWidget {
  const StatusWidget({super.key, required this.machine});
  final Machine machine;
  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green[200], borderRadius: BorderRadius.circular(20)),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "MACHINE ID: ",
                                style: GENERAL_BODY_TEXT_STYLE,
                              ),
                              SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Text(
                                    "${widget.machine.id}",
                                    style: GENERAL_BODY_TEXT_STYLE,
                                  ))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("STATUS: ", style: GENERAL_BODY_TEXT_STYLE),
                              Text(
                                "${widget.machine.status}".toUpperCase(),
                                style: GENERAL_BODY_TEXT_STYLE,
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
