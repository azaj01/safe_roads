import 'package:cloud_firestore/cloud_firestore.dart';

class Accident {
  Accident(
      {required this.date,
      required this.image,
      required this.time,
      required this.id,
      required this.VehiclesInvolved});
  String date;
  String image;
  String time;
  String id;
  String VehiclesInvolved;

  factory Accident.fromdb(DocumentSnapshot<Map<String, dynamic>> data) =>
      Accident(
          date: data['date'],
          image: data['image'],
          time: data['time'],
          id: data['id'],
          VehiclesInvolved: data['id']);
}
