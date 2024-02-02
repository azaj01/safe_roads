import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe_roads/constants/colors.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/model/accident_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class AccidentWidget extends StatefulWidget {
  const AccidentWidget(
      {super.key, required this.accidentList, required this.machineId});

  final List<Accident> accidentList;
  final String machineId;
  @override
  State<AccidentWidget> createState() => _AccidentWidgetState();
}

class _AccidentWidgetState extends State<AccidentWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Map<int, String> mapOfVehicles = {
    0: 'person',
    1: 'bicycle',
    2: 'car',
    3: 'motorcycle',
    4: 'airplane',
    5: 'bus',
    6: 'train',
    7: 'truck',
    8: 'boat',
    9: 'traffic light',
    10: 'fire hydrant',
    11: 'stop sign',
    12: 'parking meter',
    13: 'bench',
    14: 'bird',
    15: 'cat',
    16: 'dog',
    17: 'horse',
    18: 'sheep',
    19: 'cow',
    20: 'elephant',
    21: 'bear',
    22: 'zebra',
    23: 'giraffe',
    24: 'backpack',
    25: 'umbrella',
    26: 'handbag',
    27: 'tie',
    28: 'suitcase',
    29: 'frisbee',
    30: 'skis',
    31: 'snowboard',
    32: 'sports ball',
    33: 'kite',
    34: 'baseball bat',
    35: 'baseball glove',
    36: 'skateboard',
    37: 'surfboard',
    38: 'tennis racket',
    39: 'bottle',
    40: 'wine glass',
    41: 'cup',
    42: 'fork',
    43: 'knife',
    44: 'spoon',
    45: 'bowl',
    46: 'banana',
    47: 'apple',
    48: 'sandwich',
    49: 'orange',
    50: 'broccoli',
    51: 'carrot',
    52: 'hot dog',
    53: 'pizza',
    54: 'donut',
    55: 'cake',
    56: 'chair',
    57: 'couch',
    58: 'potted plant',
    59: 'bed',
    60: 'dining table',
    61: 'toilet',
    62: 'tv',
    63: 'laptop',
    64: 'mouse',
    65: 'remote',
    66: 'keyboard',
    67: 'cell phone',
    68: 'microwave',
    69: 'oven',
    70: 'toaster',
    71: 'sink',
    72: 'refrigerator',
    73: 'book',
    74: 'clock',
    75: 'vase',
    76: 'scissors',
    77: 'teddy bear',
    78: 'hair drier',
    79: 'toothbrush',
    404: 'could-not-load'
  };
  Future<void> _saveImage(String url, String accidentId) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      final dir = await getTemporaryDirectory();
      var filename = "${dir.path}/${accidentId}.jpg";
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final filePath = await FlutterFileDialog.saveFile(params: params);
      if (filePath != null) {
        Fluttertoast.showToast(msg: "File saved to disk");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    widget.accidentList.sort(
        (a, b) => ("${b.date} ${b.time}").compareTo("${a.date} ${a.time}"));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: widget.accidentList.length,
          itemBuilder: (context, index) {
            return Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SelectableText("Source: ${widget.accidentList[index].camera}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'SouceSans3',
                          fontSize: (w < 1000) ? w / 40 : w / 60)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                              fontFamily: 'SourceSans3',
                              fontSize: (w < 1000) ? w / 30 : w / 60),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.accidentList[index].image,
                            height: (w < 1000) ? w / 4.25 : w / 10,
                            width: (w < 1000) ? w / 4.15 : w / 6.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: ${widget.accidentList[index].date}",
                              style: TextStyle(
                                  fontFamily: 'SourceSans3',
                                  fontSize: (w < 1000) ? w / 35 : w / 60),
                              textAlign: TextAlign.start,
                            ),
                            Text("Time: ${widget.accidentList[index].time}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'SourceSans3',
                                    fontSize: (w < 1000) ? w / 35 : w / 60)),
                            Text(
                                "Vehicles Involved: \n• ${mapOfVehicles[widget.accidentList[index].vehiclesInvolved[0]]}\n• ${mapOfVehicles[widget.accidentList[index].vehiclesInvolved[1]]}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'SourceSans3',
                                    fontSize: (w < 1000) ? w / 35 : w / 60)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () async {
                            (kIsWeb)
                                ? await FileSaver.instance.saveFile(
                                    name:
                                        "${widget.accidentList[index].id}.jpg",
                                    link: LinkDetails(
                                        link:
                                            "${widget.accidentList[index].image}"))
                                : _saveImage(
                                    "${widget.accidentList[index].image}",
                                    "${widget.accidentList[index].id}");
                          },
                          child: Container(
                              width: w / 10,
                              height: w / 10,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.download_outlined)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('machines')
                                .doc(widget.machineId)
                                .collection('accidents')
                                .doc(widget.accidentList[index].id)
                                .delete();
                            setState(() {
                              widget.accidentList.removeAt(index);
                            });
                          },
                          child: Container(
                              width: w / 10,
                              height: w / 10,
                              decoration: BoxDecoration(
                                  color: RED_BUTTON,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.delete_outlined)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
          }),
    );
  }
}
