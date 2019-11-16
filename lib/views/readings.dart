import 'package:flutter/material.dart';
import 'package:kitty_mon_flutter/models/reading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Readings extends StatefulWidget {
  @override
  _ReadingsState createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {
  var _apiUrl = 'http://gonotes.net:9080/api/v1/l/8';
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(7.0),
            child: RaisedButton(
              child: new Text("Fetch Data"),
              onPressed: _fetchData,
            )),

        ConstrainedBox(
          constraints: BoxConstraints.tightForFinite(height: 100),
          child: DataTable(
            columnSpacing: 5,
            columns: [
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Temp")),
              DataColumn(label: Text("MeasuredAt")),
            ],
            rows: <DataRow>[
              for (var element in list)
                _buildDataRow(element),
            ],
          ),
        ),
      ],
    );
  }

  DataRow _buildDataRow(Reading r) {
    Icon statusIcon;

    var dte = DateTime.parse(
        r.MeasurementTimestamp.split('.')[0] + "Z").toLocal();

    if (DateTime.now().difference(dte).inMinutes > 30) {
      statusIcon = Icon(Icons.airline_seat_flat_angled);
    } else if(r.Status == "warm") {
      statusIcon = Icon(Icons.brightness_4);
    } else if(r.Status == "hot") {
      statusIcon = Icon(Icons.brightness_high);
    } else {
      statusIcon = Icon(Icons.check_circle_outline);
    }

    return DataRow(
      cells: [
        DataCell(statusIcon),
        DataCell(Text(r.Name)),
        DataCell(Text((r.Temp / 1000).toString())),
        DataCell(Text("${dte.hour}:${dte.minute}  ${dte.month}/${dte.day}")),
      ]
    );
  }
}
