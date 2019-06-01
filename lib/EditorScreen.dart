import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    _tabController = TabController(vsync: this, length: 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black54,),
        title: Text(
          "FinaleClass.dart",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0,
          ),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person_add), onPressed: () {},),
          IconButton(icon: Icon(Icons.more_vert,), onPressed: () {},),
        ],
      ),
      body: Container(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 6.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: List.generate(5, (index) {
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
                tabs: [
                  Tab(
                    child: Text('Containers'),
                  ),
                  Tab(
                    child: Text('Buttons'),
                  ),
                  Tab(
                    child: Text('Layout'),
                  ),
                  Tab(
                    child: Text('Forms'),
                  ),
                  Tab(
                    child: Text('Text'),
                  ),
                  Tab(
                    child: Text('Cupertino'),
                  )
                ],
              ),
            ),

            Container(
              height: 100.0,
              child: TabBarView(
                  controller: _tabController,
                  children: List.generate(6, (index) {
                    return _buildWidgetCatalogsContainer(index);
                  })),
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
    );
  }

  Widget _buildWidgetCatalogsContainer(int index) {

    return Container(
      child: GridView.builder(
        itemCount: 15,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .5,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            child: FlatButton(
                color: Colors.blueGrey.shade50,
                onPressed: () {
                  var newCode = "Column(children:<Widget>[])";
                  var pos = _textEditingController.selection.baseOffset;
                  print("Selection Begining: $pos");

                  var currentText = _textEditingController.text;
//                        currentText.sta
                  var newText = currentText.substring(0, pos);
                  var part2 = currentText.substring((pos));
                  newText = newText + newCode + part2;

                  _textEditingController.text = newText;
                },
                child: Text("Container $index", style: TextStyle(color: Colors.blueGrey, fontSize: 12.0,),)),
          );
        },
      ),
    );

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


}
