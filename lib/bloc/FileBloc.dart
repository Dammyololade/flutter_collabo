import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_collabo/AppConfig.dart';
import 'package:flutter_collabo/model/FileModel.dart';
import 'package:flutter_collabo/model/Project.dart';
import 'package:rxdart/rxdart.dart';

///
/// project: flutter_collabo
/// @package: bloc
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class FileBloc
{
  PublishSubject<List<FileModel>> fileController = PublishSubject();
  Sink<List<FileModel>> get inFileModel => fileController.sink;
  Stream<List<FileModel>> get outFileModel => fileController.stream;
  List<FileModel> currentFileList = [];

  getProjectFiles(Project project)
  {
    Firestore.instance.collection(AppConfig.files)
        .where(FileModel.cOwnerId, isEqualTo: project.ownerId)
        .snapshots().listen((QuerySnapshot snapshot){
          currentFileList = [];
          for(DocumentSnapshot documentSnapshot in snapshot.documents){
            FileModel model = FileModel.fromSnapshot(documentSnapshot);
            currentFileList.add(model);
          }
          inFileModel.add(currentFileList);
    });
  }
}