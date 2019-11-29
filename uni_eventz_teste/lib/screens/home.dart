import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:uni_eventz_teste/utils/customclipper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  var lat;
  var lng;
  var coordinates;
  String endString;
  String cep;

  String _uid;

  @override
  void initState() { 
    super.initState();
    _loadUser();
    _getLocation();
  }

  Future _loadUser() async{
    var result = await FirebaseAuth.instance.currentUser();
    setState(() {
      _uid = result.uid;
    });
  }

  void _getLocation() async {

    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      if(position == null){
        print("Unknown location");
      }else {
        lat = position.latitude;
        lng = position.longitude;
        _getAddress(lat, lng);
      }
    });

    if(cep != null){
      positionStream.cancel();
    }

  }

  void _getAddress(lat,lgn) async {
    coordinates = Coordinates(lat,lng);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    var splitCep;
    endString = first.addressLine;
    splitCep = endString.split(',');
    var _cep = splitCep[3];
    setState(() {
      cep = _cep;

    });
    print(_cep);
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 420,
              child: Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: TopClipper(),
                    child: Container(
                      height: 370.00,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 10.0),
                            blurRadius: 10.0
                          )
                        ]
                      ),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Image.network("https://enem2020.me/wp-content/uploads/local-enem-2020-825x510.png",
                              fit: BoxFit.fill, width: double.infinity),
                          ),
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0x00000000),
                                  Color(0xD9333333)
                                ],
                                stops: [
                                  0.0,
                                  0.9
                                ],
                                begin: FractionalOffset(0.0,0.0),
                                end: FractionalOffset(0.0,0.0)
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 120.0, left: 95.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "$cep",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontFamily: "SF-Pro-Display-Bold"
                                    ),
                                  ),
                                  Text(
                                    "Descubra eventos proximo",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 45.0,
                                        fontFamily: "SF-Pro-Display-Bold"),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 370.0,
                    right: 20.0,
                    child: FractionalTranslation(
                      translation: Offset(0.0, -0.5),
                      child: Row(
                        children: <Widget>[
                          FloatingActionButton(
                            onPressed: () => _getLocation(),
                            child: Icon(Icons.navigation),
                            backgroundColor: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}