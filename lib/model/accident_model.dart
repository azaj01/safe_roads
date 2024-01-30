import 'package:cloud_firestore/cloud_firestore.dart';

class Accident{
  Accident({required this.date, required this.image, required this.time});
  String date;
  String image;
  String time;

  factory Accident.fromdb(DocumentSnapshot<Map<String,dynamic>> data) => Accident(date:data['date'],image: data['image'],time:data['time']);
}