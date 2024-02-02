import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

addClient(String email, String machineId) {
  try {
    FirebaseFirestore.instance
        .collection('clients')
        .doc(email)
        .set({'email': email, 'machine': machineId});
  } catch (e) {
    Fluttertoast.showToast(msg: "Firestore Error: $e");
  }
}
