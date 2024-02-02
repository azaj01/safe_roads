import 'package:cloud_firestore/cloud_firestore.dart';

class Machine {
  Machine({required this.id, required this.status, required this.camera,required this.start});
  String id;
  String status;
  String camera;
  bool start;

  factory Machine.fromdb(DocumentSnapshot<Map<String, dynamic>> data) =>
      Machine(id: data['id'], status: data['status'], camera: data['camera'], start:data['start']);
}
