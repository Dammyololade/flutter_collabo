import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_collabo/EditorScreen.dart';
import 'package:flutter_collabo/bloc/FileBloc.dart';
import 'package:flutter_collabo/custom/CustomWidgets.dart';
import 'package:flutter_collabo/model/FileModel.dart';

import 'AppConfig.dart';
import 'model/Project.dart';
import 'package:share/share.dart';

///
/// project: flutter_collabo
/// @package: 
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class ProjectDetailsScreen extends StatefulWidget {

  Project project;
  ProjectDetailsScreen(this.project);

  @override
  State<StatefulWidget> createState() {
    return _ProjectDetailsScreenState(this.project);
  }

}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {

  Project project;

  _ProjectDetailsScreenState(this.project);
  var _nameController = TextEditingController();
  bool processing = false;
  final FocusNode nameFocus = FocusNode();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  FileBloc fileBloc = FileBloc();
  bool filesFetched = false;
  ValueNotifier<List<FileModel>> fileLoadedNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    fileBloc.getProjectFiles(project);
    fileBloc.outFileModel.listen(onFilesFetched);
  }

  onFilesFetched(List<FileModel> files)
  {
    fileLoadedNotifier.value = files;
    filesFetched = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${project.name}"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share("Use this link to collaborate with me on Collabo, ${project.inviteLink}");
            }
          )

        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20,),

          Expanded(
            child: ValueListenableBuilder(
                valueListenable: fileLoadedNotifier,
                builder: (context, List<FileModel> values, Widget child){
                  return filesFetched ? buildFiles(values) :
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),

                        Text("Fetching your files"),
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showBottomShett();
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  showBottomShett(){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text("Enter File name"),
                SizedBox(height: 20,),

                CustomWidgets.FormTextField("File name", "", _nameController,
                    TextInputType.text, "enter a file name", borderColor: Colors.transparent,
                    context: context, hasBorder: false),

                Container(color: Colors.black26, height: 1,),

                SizedBox(height: 70,),

                processing ? CircularProgressIndicator() :
                CustomWidgets.positiveButton("Submit", (){
                  if(_formKey.currentState.validate()){
                    addFile();
                  }
                }),

                SizedBox(height: 20,),
              ],
            ),
          ),
        );
      }
    );
  }

  void addFile() 
  {
    setState(() {
      processing = true;
    });
    FileModel model = FileModel(name: _nameController.text, ownerId: project.ownerId, fileContent: "");
    Firestore.instance.collection(AppConfig.files).add(model.toMap()).then((docRef){
      project.documentReference.updateData({Project.cFiles : FieldValue.arrayUnion([docRef])});
      Navigator.of(context).pop();
    });
  }

  buildFiles(List<FileModel> values)
  {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: values.length,
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index){
          FileModel model = values[index];
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorScreen()));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("${model.name}",
                        style: TextStyle(

                        ),
                      )),

                      Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 20,),
                    ],
                  ),
                ),

                Divider(height: 1,),
              ],
            ),
          );
        }
    );

  }

}