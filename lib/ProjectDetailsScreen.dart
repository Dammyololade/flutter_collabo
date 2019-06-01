import 'package:flutter/material.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

}