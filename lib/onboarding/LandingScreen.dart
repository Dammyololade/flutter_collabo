import 'package:flutter/material.dart';
import 'package:flutter_collabo/AppConfig.dart';
import 'package:flutter_collabo/onboarding/CreateProjectScreen.dart';
import 'package:flutter_collabo/ProjectDetailsScreen.dart';
import 'package:flutter_collabo/custom/CustomWidgets.dart';
import 'package:flutter_collabo/bloc/ProjectBloc.dart';
import 'package:flutter_collabo/model/Project.dart';
import 'package:flutter_collabo/onboarding/JoinScreen.dart';

///the main screen where the user starts the journey from
/// project: flutter_collabo
/// @package: onboarding
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class LandingScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LandingScreenState();
  }

}

class _LandingScreenState extends State<LandingScreen> {

  ValueNotifier<List<Project>> projectListNotifier = ValueNotifier([]);
  bool hasFetchedList = false;
  ProjectBloc projectBloc = ProjectBloc();

  @override
  void initState() {
    projectBloc.getProjects();
    super.initState();
    projectBloc.outProject.listen(onProjectSnapshot);
  }

  onProjectSnapshot(List<Project> newList)
  {
    hasFetchedList = true;
    projectListNotifier.value = newList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConfig.APP_BACKGROUND_COLOR,
        body: Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: <Widget>[
                  Text("Your projects",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.APP_PRIMARY_COLOR
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20,),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: projectListNotifier,
                builder: (context, List<Project> values, Widget child){
                  return hasFetchedList ? buildProjects(values) :
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 10,),

                          Text("Fetching your project"),
                        ],
                      ),
                    );
                }
              ),
            ),

            CustomWidgets.positiveButton("Create A Project", (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateProjectScreen()));
            }),

            SizedBox(height: 20,),

            Text("Or"),

            SizedBox(height: 20,),

            CustomWidgets.negativeButton("Join using a link", (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => JoinScreen()));
            }),

            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }

  Widget buildProjects(List<Project> projectList)
  {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: projectList.length,
      padding: EdgeInsets.all(20),
      itemBuilder: (context, index){
        Project project = projectList[index];
        return InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project)));
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text("${project.name}",
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