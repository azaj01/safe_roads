import 'package:cloud_firestore/cloud_firestore.dart';

class Machine{
  Machine({required this.id, required this.status});
  String id;
  String status;

  factory Machine.fromdb(DocumentSnapshot<Map<String,dynamic>> data) => Machine(id:data['id'],status: data['status']);
}