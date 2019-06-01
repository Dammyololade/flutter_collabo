import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_collabo/AppConfig.dart';
import 'package:flutter_collabo/ProjectDetailsScreen.dart';
import 'package:flutter_collabo/Utility.dart';
import 'package:flutter_collabo/custom/CustomWidgets.dart';
import 'package:flutter_collabo/model/Project.dart';
import 'package:uuid/uuid.dart';

///Createn a project screen
/// project: flutter_collabo
/// @package: 
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class CreateProjectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateProjectScreenState();
  }

}

class _CreateProjectScreenState extends State<CreateProjectScreen> {

  var _nameController = TextEditingController();
  bool processing = false;
  final FocusNode nameFocus = FocusNode();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppConfig.APP_BACKGROUND_COLOR,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: (){Navigator.of(context).pop();},
                        icon: Icon(Icons.arrow_back, color: AppConfig.APP_ACCENT_COLOR,),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20),
                  child: Row(
                    children: <Widget>[
                      Text("Create a new project",
                        style: TextStyle(
                            color: AppConfig.APP_PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize: 25
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 70,),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      CustomWidgets.FormTextField("Project name", "", _nameController,
                        TextInputType.text, "enter a project name", borderColor: Colors.transparent,
                        context: context, hasBorder: false),

                      Container(color: Colors.black26, height: 1,)
                    ],
                  ),
                ),

                SizedBox(height: 150,),

                processing ? CircularProgressIndicator() :
                  CustomWidgets.positiveButton("Submit", (){
                    if(_formKey.currentState.validate()){
                      addProject();
                    }
                  }),

                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addProject()async
  {
    setState(() {
      processing = true;
    });
    String serial = await Utility().getDeviceSerial();
    DateTime date = DateTime.now();
    Uuid uuid = new Uuid();
    String inviteLink = _nameController.text + "-" + uuid.v1().substring(0, 5);
    Project project = Project(name: _nameController.text, ownerId: serial, inviteLink: inviteLink, createdOn: date);
    Firestore.instance.collection(AppConfig.projects).add(project.toMap()).then((docRef){
      project.documentReference = docRef;
      project.docId = docRef.documentID;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project)));
    }).catchError((error){
      setState(() {
        processing = false;
      });
    });
  }

}