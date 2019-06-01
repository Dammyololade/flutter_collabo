import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_collabo/AppConfig.dart';
import 'package:flutter_collabo/Utility.dart';
import 'package:flutter_collabo/model/FileModel.dart';
import 'package:flutter_collabo/model/WIdgetModel.dart';

import 'model/Project.dart';

class EditorScreen extends StatefulWidget {
  FileModel fileModel;
  Project project;

  EditorScreen(this.fileModel, this.project);

  @override
  State<StatefulWidget> createState() => _EditorScreenState(this.fileModel);
}

class _EditorScreenState extends State<EditorScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  TabController _tabController;
  FileModel fileModel;
  _EditorScreenState(this.fileModel);
  Firestore firestore = Firestore.instance;
  String deviceId;
  ValueNotifier<int> viewersNotifier;
  List<WidgetModel> widgetList = [];

  List<String> catList = [
    "Basic",
    "Layout",
    "Forms",
    "Buttons",
    "Text",
    "Material",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textEditingController = TextEditingController(text: fileModel.fileContent);
    _tabController = TabController(vsync: this, length: 6);
    _textEditingController.addListener(onTextChanged);
    updateOnlineStatus(true);
    getDeviceId();
    viewersNotifier = ValueNotifier(fileModel.onlineViewers);
    firestore.document("${AppConfig.files}/${fileModel.docId}").snapshots().listen(onFileModified);
  }

  updateOnlineStatus(bool online)
  {
    firestore.document("${AppConfig.files}/${fileModel.docId}").updateData(
      {FileModel.cOnlineViewers: online ? FieldValue.increment(1) : FieldValue.increment(-1)}
    );
  }


  onFileModified(DocumentSnapshot snapshot){
    FileModel model = FileModel.fromSnapshot(snapshot);
    viewersNotifier.value = model.onlineViewers;
    if(model.lastEditedBy != deviceId){
      _textEditingController.text = model.fileContent;
    }
  }

  onTextChanged()async
  {
    await Future.delayed(Duration(seconds: 1));
    firestore.document("${AppConfig.files}/${fileModel.docId}").updateData(
      {FileModel.cFileContent : _textEditingController.text,
        FileModel.cUpdatedOn : FieldValue.serverTimestamp(),
        FileModel.cLastEditedBy : deviceId}
      );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        updateOnlineStatus(false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black54,),
          title: Text(
            "${fileModel.name}",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.person_add), onPressed: () {},),
            IconButton(icon: Icon(Icons.more_vert,), onPressed: () {},),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
//        height: 0.0,
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,),
                      color: Colors.grey.shade50,
                      child: TextField(
                        controller: _textEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(fontFamily: "SourceCodePro"),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 12.0, ),
                          hintText: "Type to start collaboraing on codes...",
                          border: InputBorder.none,

                        ),
                      ),
                    ),
                  ),


                  /*RaisedButton(
                    onPressed: () {
                      _textEditingController.clear();
                      final code =
                          "Container(\n  child: FlatButton(\n    child: Text(\n\"Another\",\n)\n)\n),";
                      _textEditingController.text = code;
                    },
                    child: Text("Refresh"),
                  ),*/

                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: <Widget>[
                  ValueListenableBuilder(
                      valueListenable: viewersNotifier,
                      builder: (cont, int value, Widget child){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 6.0,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                  children: List.generate(value, (index) {
                                    return _buildOnlineDot();
                                  })
                              ),
                              Text(
                                "damola is editing...",
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 11.0,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        );
                      }
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.blue,
                        tabs: List.generate(catList.length, (index){
                          return Tab(text: catList[index],);
                        })
                    ),
                  ),

                  Container(
                    height: 100.0,
                    child: TabBarView(
                        controller: _tabController,
                        children: List.generate(catList.length, (index) {
                          return _buildWidgetCatalogsContainer(catList[index]);
                        })),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetCatalogsContainer(String catName) {

    return FutureBuilder(
      future: firestore.collection("widgets")
          .where(WidgetModel.cCategory, arrayContains: catName.toLowerCase())
          .getDocuments(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              height: 30, width: 30,
                child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            return Container(
              child: GridView.builder(
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .5,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =  snapshot.data.documents[index];
                  WidgetModel currentW = WidgetModel.fromMap(documentSnapshot);
                  return Container(
                    child: FlatButton(
                        color: Colors.blueGrey.shade50,
                        onPressed: () {
                          var newCode = currentW.value;
                          var pos = _textEditingController.selection.baseOffset;
                          print("Selection Begining: $pos");

                          var currentText = _textEditingController.text;
//                        currentText.sta
                          var newText = currentText.substring(0, pos);
                          var part2 = currentText.substring((pos));
                          newText = newText + newCode + part2;

                          _textEditingController.text = newText;
                        },
                        child: Text("${currentW.name}", style: TextStyle(color: Colors.blueGrey, fontSize: 12.0,),)),
                  );
                },
              ),
            );
        }
      });

  }


  Widget _buildOnlineDot() {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          4.0,
        ),
        color: Colors.green.shade100,
      ),
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.only(right: 3.0),
    );

  }

  void getDeviceId() async{
    deviceId = await  Utility().getDeviceSerial();
  }
  
  getCategoryWidgts(String catName)
  {
    firestore.collection("widgets")
      .where(WidgetModel.cCategory, arrayContains: catName)
        .getDocuments().then((QuerySnapshot snapshot){
          for(DocumentSnapshot documentSnapshot in snapshot.documents){
            WidgetModel model = WidgetModel.fromMap(documentSnapshot);
            widgetList.add(model);
          }
          setState(() {
          });
    });
  }


}
