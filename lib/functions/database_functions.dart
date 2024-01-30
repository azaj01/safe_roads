import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


addClient(String email, String machineId){
  FirebaseFirestore.instance.collection('clients').doc(email).set({'email':email,'machine':machineId});
}