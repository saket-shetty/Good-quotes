import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class ConfigurePostScreen extends StatefulWidget {
  final String postData;
  const ConfigurePostScreen({Key key, @required this.postData}) : super(key: key);
  @override
  _ConfigurePostScreenState createState() => _ConfigurePostScreenState();
}

class _ConfigurePostScreenState extends State<ConfigurePostScreen> {
  List data = [
    0xFFfaf2da,
    0xFF9fe6a0,
    0xFFffb26b,
    0xFFfffbdf,
    0xFFe7d4b5,
    0xFFeca3f5,
    0xFFFFEBEE,
  ];

  List<int> fontSize = [15, 17, 19, 21, 23, 25];

  int selectedColor = 0xFFfaf2da;
  int selectedFontSize = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar("Configure Post Style"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.send),
      ),
      body: Column(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  widget.postData,
                  style: TextStyle(fontSize: selectedFontSize.toDouble()),
                ),
              ),
              color: Color(selectedColor),
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.width - 10,
            ),
          ),
          Text(
            "Select Color",
            style: TextStyle(fontSize: 18.0),
          ),
          Expanded(
            child: ScrollSnapList(
              onItemFocus: (index) {
                setState(() {
                  selectedColor = data[index];
                });
              },
              itemSize: 70.0 + 10,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Container(
                          color: Color(data[index]),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: data.length,
              reverse: false,
              dynamicItemSize: true,
            ),
          ),
          Text(
            "Select Font Size",
            style: TextStyle(fontSize: 18.0),
          ),
          Expanded(
            child: ScrollSnapList(
              onItemFocus: (index) {
                setState(() {
                  selectedFontSize = fontSize[index];
                });
              },
              itemSize: 50.0 + 15,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.deepPurpleAccent,
                          child: Center(
                            child: Text(
                              fontSize[index].toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: fontSize.length,
              reverse: false,
              dynamicItemSize: true,
            ),
          ),
        ],
      ),
    );
  }
}
