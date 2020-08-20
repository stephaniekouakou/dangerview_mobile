import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "badEvent",
      theme: ThemeData(
        primaryColor: Colors.yellow[800],
      ),
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String selectedcontry;
  //list des pays
  List data = List();

  Future getAllPays() async {
    var response = await http.post("http://192.168.42.96/fichier/viewall.php");
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = json.decode(jsonBody);

      setState(() {
        data = jsonData;
      });
    }
    print(data);

    return "success";
  }

//declaration de la liste ville
  List datavile = List();
  String _myCity;

  Future getAllville() async {
    var response = await http.post("http://192.168.42.96/fichier/getcites.php",
        body: {"pays": selectedcontry});
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = json.decode(jsonBody);

      setState(() {
        datavile = jsonData;
      });
    }
    print(datavile);
    return "success";
  }

  @override
  void initState() {
    getAllPays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("badEvent"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            color: Colors.yellow[700],
            child: Column(
              children: <Widget>[
                //===============================================PAYS
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1.0),
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.only(
                      bottom: 0, top: 15.0, left: 40.0, right: 40.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: DropdownButton(
                        isExpanded: true,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        value: selectedcontry,
                        hint: Text('  pays'),
                        onChanged: (value) {
                          setState(() {
                            selectedcontry = value;
                            getAllville();
                            print(selectedcontry);
                          });
                        },
                        items: data?.map(
                              (item) {
                                return DropdownMenuItem(
                                    value: item['nom'],
                                    child: new Text(item['nom']));
                              },
                            )?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
                //===============================================VILLE
                new Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1.0),
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.only(
                      bottom: 5, top: 15.0, left: 40.0, right: 40.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        isExpanded: true,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        value: _myCity,
                        hint: Text('ville'),
                        onChanged: (value) {
                          setState(() {
                            _myCity = value;
                            print(_myCity);
                          });
                        },
                        items: datavile?.map(
                              (item) {
                                return DropdownMenuItem(
                                    value: item['ville'],
                                    child: new Text(item['ville']));
                              },
                            )?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
                new Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text("RECHERCHE"),
                          onPressed: _changeText,
                          color: Colors.red[800],
                          textColor: Colors.yellow[50],
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          splashColor: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_changeText() {}
