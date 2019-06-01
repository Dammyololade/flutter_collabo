import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_collabo/model/FileModel.dart';
import 'package:flutter_collabo/model/Project.dart';
import 'package:rxdart/rxdart.dart';

import '../AppConfig.dart';
import '../Utility.dart';


///
/// project: flutter_collabo
/// @package: custom
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class ProjectBloc
{
  PublishSubject<List<Project>> projectController = PublishSubject();
  Sink<List<Project>> get inProject => projectController.sink;
  Stream<List<Project>> get outProject => projectController.stream;
  List<Project> currentProjectList = [];

  getProjects()async
  {
    String deviceid = await Utility.getDeviceSerial();
    Firestore.instance.collection(AppConfig.projects)
        .where(Project.cOwnerId, isEqualTo: deviceid).snapshots()
        .listen((QuerySnapshot snapshot){
          currentProjectList = [];
          for(DocumentSnapshot documentSnapshot in snapshot.documents){
            Project project = Project.fromSnapshot(documentSnapshot);
            currentProjectList.add(project);
          }
          inProject.add(currentProjectList);
    });
  }
}