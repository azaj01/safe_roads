import 'package:cloud_firestore/cloud_firestore.dart';

class Accident {
  Accident(
      {required this.date,
      required this.image,
      required this.time,
      required this.id,
      required this.vehiclesInvolved,
      required this.camera});
  String date;
  String image;
  String time;
  String id;
  String camera;
  List<dynamic> vehiclesInvolved;

  factory Accident.fromdb(DocumentSnapshot<Map<String, dynamic>> data) {
    return Accident(
        date: data['date'],
        image: data['image'],
        time: data['time'],
        id: data['id'],
        camera: data['camera'],
        vehiclesInvolved: data['vehicles_involved']);
  }
}
