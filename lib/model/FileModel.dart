import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_collabo/model/base_model.dart';

///
/// project: flutter_collabo
/// @package: model
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class FileModel extends BaseModel
{
  static String cName = "name";
  static String cOwnerId = "ownerId";
  static String cFileContent = "fileContent";
  static String cCreatedOn = "createdOn";
  static String cUpdatedOn = "updatedOn";

  String name, ownerId, fileContent, docId;
  DocumentReference documentReference;
  DateTime createdOn, updatedOn;


  FileModel({this.name, this.ownerId, this.fileContent});

  FileModel.fromSnapshot(DocumentSnapshot snapshot)
  {
    createObjectFromSnapshot(snapshot);
  }

  @override
  createObjectFromSnapshot(DocumentSnapshot snapshot) {
    documentReference = snapshot.reference;
    docId = snapshot.documentID;
    name = snapshot.data[cName];
    ownerId = snapshot.data[cOwnerId];
    fileContent = snapshot.data[cFileContent];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      cOwnerId: ownerId,
      cName: name,
      cCreatedOn: DateTime.now(),
      cUpdatedOn: DateTime.now(),
      cFileContent: "",
    };
  }

}