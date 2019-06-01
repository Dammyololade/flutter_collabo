import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_collabo/model/base_model.dart';

///
/// project: flutter_collabo
/// @package: model
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class WidgetModel extends BaseModel
{
  static String cName = "name";
  static String cCategory = "category";
  static String cValue = "value";

  String name, value;

  WidgetModel.fromMap(DocumentSnapshot snapshot)
  {
    createObjectFromSnapshot(snapshot);
  }


  @override
  createObjectFromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data[cName];
    value = snapshot.data[cValue];
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }

}