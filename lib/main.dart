import 'package:flutter/material.dart';
import 'package:kitty_mon_flutter/views/readings.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [], //ChangeNotifierProvider(builder: (_) => Counter(0)),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: Readings(),
      ),
    );
  }
}
