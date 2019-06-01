
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseModel {

  Map<String, dynamic> toMap();

  createObjectFromSnapshot(DocumentSnapshot snapshot);

}