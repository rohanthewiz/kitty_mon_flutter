import 'package:flutter/material.dart';
import 'package:kitty_mon_flutter/models/reading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Readings extends StatefulWidget {
  @override
  _ReadingsState createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {
  static const numOfReadings = 18;
  var _apiUrl = 'http://gonotes.net:9080/api/v1/l/$numOfReadings';
  var isLoading = false;
  List<Reading> list = List();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initNotification();
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  initNotification() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    var _ = showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
            title: Text("Payload"), content: Text("Payload: $payload"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.cloud_download),
                  Padding(
                      padding: EdgeInsets.only(left: 9.0),
                      child: Text("Fetch Data")
                  ),
                ],
              ),
              onPressed: _fetchData,
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add_alert),
                  Padding(
                      padding: EdgeInsets.only(left: 9.0),
                      child: Text("Fire Notification")
                  ),
                ],
              ),
              onPressed: _showNotificationWithDefaultSound,
            )),

        Expanded(
          //constraints: BoxConstraints(maxHeight: 500),
          child:
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 8,
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
        ),
      ],
    );
  }

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(_apiUrl);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => Reading.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load readings');
    }
  }

  DataRow _buildDataRow(Reading r) {
    Icon statusIcon;
    Color tColor;

    var dte = DateTime.parse(
        r.MeasurementTimestamp.split('.')[0] + "Z").toLocal();

    if (DateTime.now().difference(dte).inMinutes > 30) {
      tColor = Colors.blueGrey;
      statusIcon = Icon(Icons.airline_seat_flat_angled, color: tColor,);
    } else if(r.Status == "warm") {
      tColor = Colors.orange;
      statusIcon = Icon(Icons.brightness_4, color: tColor);
    } else if(r.Status == "hot") {
      tColor = Colors.red;
      statusIcon = Icon(Icons.brightness_high, color: tColor);
    } else {
      tColor = Colors.green;
      statusIcon = Icon(Icons.check_circle_outline, color: tColor);
    }

    return DataRow(
      cells: [
        DataCell(statusIcon),
        DataCell(Text(r.Name)),
        DataCell(Text((r.Temp / 1000).toString(),
                style: TextStyle(color: tColor)
        )),
        DataCell(Text(
            "${dte.hour < 10 ? '0${dte.hour}' : dte.hour}:${dte.minute < 10
                ? '0${dte.minute}'
                : dte.minute}  ${dte.month}/${dte.day}")),
      ]
    );
  }
}
