import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_collabo/model/base_model.dart';

///
/// project: flutter_collabo
/// @package: model
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class Project extends BaseModel{

  static String cName = "name";
  static String cOwnerId = "ownerId";
  static String cFiles = "files";
  static String cInviteLink = "inviteLink";
  static String cCreatedOn = "createdOn";

  String name, ownerId, inviteLink;
  DocumentReference documentReference;
  String docId;
  List files;
  DateTime createdOn;

  @override
  createObjectFromSnapshot(DocumentSnapshot snapshot) {
    documentReference = snapshot.reference;
    docId = snapshot.documentID;
    name = snapshot.data[cName];
    ownerId = snapshot.data[cOwnerId];
    inviteLink = snapshot.data[inviteLink];
    files = snapshot.data[cFiles];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      cOwnerId: ownerId,
      cName: name,
      cInviteLink: inviteLink,
      cCreatedOn: createdOn,
    };
  }
}