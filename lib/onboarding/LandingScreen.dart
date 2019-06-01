import 'package:flutter/material.dart';
import 'package:flutter_collabo/AppConfig.dart';
import 'package:flutter_collabo/CreateProjectScreen.dart';
import 'package:flutter_collabo/custom/CustomWidgets.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.APP_BACKGROUND_COLOR,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox()
          ),

          CustomWidgets.positiveButton("Create A Project", (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateProjectScreen()));
          }),

          SizedBox(height: 20,),

          Text("Or"),

          SizedBox(height: 20,),

          CustomWidgets.negativeButton("Join using a link", (){

          }),

          SizedBox(height: 40,),
        ],
      ),
    );
  }

}