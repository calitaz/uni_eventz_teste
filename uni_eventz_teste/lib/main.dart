import 'package:flutter/material.dart';
import 'package:uni_eventz_teste/screens/front.dart';
import 'package:uni_eventz_teste/screens/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/front':
            return MaterialPageRoute(builder: (context)=> FrontPage());
            break;
          case '/home':
            return MaterialPageRoute(builder: (context) => HomePage());
            break;
          default:
            return null;
        }
      },
      home: FrontPage(),
    );
  }
}

