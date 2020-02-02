import 'package:flutter/material.dart';
import 'package:kitty_mon_flutter/views/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [], //ChangeNotifierProvider(builder: (_) => Counter(0)),
      child: MaterialApp(
          title: 'Kitty Monitor',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
          home: MyHomePage()
      ),
    );
  }
}
