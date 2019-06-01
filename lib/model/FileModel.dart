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
  static String cProjectId = "projectId";
  static String cFileContent = "fileContent";
  static String cCreatedOn = "createdOn";
  static String cUpdatedOn = "updatedOn";
  static String cLastEditedBy = "lastEdittedBy";
  static String cOnlineViewers = "onlineViewers";

  String name, projectId, fileContent, docId;
  DocumentReference documentReference;
  DateTime createdOn, updatedOn;
  String lastEditedBy;
  int onlineViewers;


  FileModel({this.name, this.projectId, this.fileContent});

  FileModel.fromSnapshot(DocumentSnapshot snapshot)
  {
    createObjectFromSnapshot(snapshot);
  }

  @override
  createObjectFromSnapshot(DocumentSnapshot snapshot) {
    documentReference = snapshot.reference;
    docId = snapshot.documentID;
    name = snapshot.data[cName];
    projectId = snapshot.data[cProjectId];
    fileContent = snapshot.data[cFileContent];
    lastEditedBy = snapshot.data[cLastEditedBy];
    onlineViewers = snapshot.data[cOnlineViewers];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      cProjectId: projectId,
      cName: name,
      cCreatedOn: DateTime.now(),
      cUpdatedOn: DateTime.now(),
      cFileContent: "",
    };
  }

}