import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_collabo/AppConfig.dart';
import 'package:flutter_collabo/ProjectDetailsScreen.dart';
import 'package:flutter_collabo/Utility.dart';
import 'package:flutter_collabo/custom/CustomWidgets.dart';
import 'package:flutter_collabo/model/Project.dart';

///
/// project: flutter_collabo
/// @package: onboarding
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class JoinScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JoinScreenState();
  }

}

class _JoinScreenState extends State<JoinScreen> {

  var _nameController = TextEditingController();
  bool processing = false;
  final FocusNode nameFocus = FocusNode();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();


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
                      Text("Collaborate on a project",
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

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppConfig.APP_PRIMARY_COLOR)
                  ),
                  child:  CustomWidgets.FormTextField("", "Enter the project link", _nameController,
                      TextInputType.text, "enter a link", borderColor: Colors.transparent,
                      context: context, hasBorder: false),

                ),

                SizedBox(height: 150,),

                processing ? CircularProgressIndicator() :
                CustomWidgets.positiveButton("Submit", (){
                  if(_formKey.currentState.validate()){
                    findProject();
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

  void findProject() async
  {
    setState(() {
      processing = true;
    });
    QuerySnapshot snapshot = await Firestore.instance.collection(AppConfig.projects)
        .where(Project.cInviteLink, isEqualTo: _nameController.text)
        .getDocuments();
    if(snapshot.documents.length > 0){
      Project project = Project.fromSnapshot(snapshot.documents[0]);
      addUserToProject(project);
    } else{
      setState(() {
        processing = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(content:
        Text("Cant find a project with this link"),backgroundColor: Colors.red,));
    }
  }

  void addUserToProject(Project project)async
  {
    String serial = await Utility().getDeviceSerial();
    var value = await project.documentReference.updateData({Project.cUsers: FieldValue.arrayUnion([serial])});
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project)));
  }

}