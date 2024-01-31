import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/colors.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/model/accident_model.dart';

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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(fontFamily:'SourceSans3',fontSize: w/30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      widget.accidentList[index].image,
                      height: w/6,
                      width: w/6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(widget.accidentList[index].date,
                            style:TextStyle(fontFamily:'SourceSans3',fontSize: w/30)),
                        Text(widget.accidentList[index].time,
                            style: TextStyle(fontFamily:'SourceSans3',fontSize: w/30))
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: ()async {
                              await FileSaver.instance.saveFile(
                                  name: "${widget.accidentList[index].id}.jpg",
                                  link: LinkDetails(
                                      link: "${widget.accidentList[index].image}"));
                            },
                            
                          child: Container(
                            width: w/10,
                            height: w/10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20)
                        
                            ),
                            child: Icon(Icons.download_outlined)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
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
                            width: w/10,
                            height: w/10,
                            decoration: BoxDecoration(
                              color: RED_BUTTON,
                              borderRadius: BorderRadius.circular(20)
                        
                            ),
                            child: Icon(Icons.delete_outlined)
                          ),
                        ),
                      ),
                      
                      
                    ],
                  )
                ],
              ),
            ));
          }),
    );
  }
}
