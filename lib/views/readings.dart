import 'package:flutter/material.dart';
import 'package:kitty_mon_flutter/models/reading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Readings extends StatefulWidget {
  @override
  _ReadingsState createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {
  var _apiUrl = 'http://162.220.53.58:9080/api/v1/l/8';
  List<Reading> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get(_apiUrl);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Reading.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load readings');
    }
  }

  @override
  Widget build(BuildContext context) {
    var rows = <DataRow>[];
    list.forEach((element) {
      var row = DataRow(
        cells: [
          DataCell(
              element.Status == "good" ?
              Icon(Icons.check_circle_outline) :
              Icon(Icons.brightness_high)
          ),
          DataCell(Text(element.Name)),
          DataCell(Text((element.Temp / 1000).toString())),
          DataCell(Text(element.MeasurementTimestamp)),
        ],
      );
      rows.add(row);
    });

    return isLoading ?
    Center(child: CircularProgressIndicator()) :
    Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(6.0),
            child: RaisedButton(
              child: new Text("Fetch Data"),
              onPressed: _fetchData,
            )),

        ConstrainedBox(
          constraints: BoxConstraints.tightForFinite(height: 500),
          child: DataTable(
            columnSpacing: 5,
            columns: [
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Temp")),
              DataColumn(label: Text("MeasuredAt")),
            ],
            rows: rows,
          ),
          //          child: ListView.builder(
          //              itemCount: list.length,
          //              itemBuilder: (BuildContext context, int index) {
          //                return ListTile(
          //                  contentPadding: EdgeInsets.all(4.0),
          //                  title: new Text(list[index].Name),
          //                  trailing: new Text(list[index].Temp.toString()),
          //                );
          //              }),
        ),

      ],
    );
  }
}
