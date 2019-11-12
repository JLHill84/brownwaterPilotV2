import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
// import 'package:location/location.dart';

class AISPage extends StatefulWidget {
  @override
  _AISPageState createState() => _AISPageState();
}

class _AISPageState extends State<AISPage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(29.760427, -95.369804);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
      bearing: 0, target: LatLng(29.760427, -95.369804), tilt: 0, zoom: 15);

  Future<void> _goToPosition1() async {
    
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Future<void> _getShipList() async {
    try {
      var url =
          'https://services.marinetraffic.com/api/exportvessels/v:8/MARINETRAFFICAPIKEY/MINLAT:value/MAXLAT:value/MINLON:value/MAXLON:value/timespan:30/protocol:jsono';
      var response = await http.get(url);
      Map data = json.decode(response.body);

// AND NOW THE FOR LOOP BEGINS!
      for (int i = 0; i < data.length; i++) {
        var url = data2['observationStations'][i] +
            "/observations/latest?require_qc=false";

        http.Response loopResponse = await http.get(url, headers: {
          "token": "AhrYtjbSwpZXOuYdaeZRruodMZIOhjCS",
          "Accept": "application/json"
        });

        Map data3 = json.decode(loopResponse.body);

        if (data3['properties'] == null ||
            data3['properties']['windSpeed'] == null ||
            data3['properties']['windSpeed']['value'] == null ||
            data3['geometry']['coordinates'][1] == null ||
            data3['geometry']['coordinates'][0] == null ||
            data3['properties']['windDirection']['value'] == null) {
          // data3['geometry']['coordinates'][0] > bounds.southwest.longitude ||
          // data3['geometry']['coordinates'][1] < bounds.northeast.latitude) {
          continue;
        } else {
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId(data3['properties']['station']),
              rotation: data3['properties']['windDirection']['value'] + 0.0,
              position: LatLng(data3['geometry']['coordinates'][1] + 0.0,
                  data3['geometry']['coordinates'][0] + 0.0),
              // consumeTapEvents: true,
              infoWindow: InfoWindow(
                title:
                    '${data3['properties']['windSpeed']['value'].toString()} mph',
              ),
              icon: windIcon,
            ));
          });
          // print("marker added");
        }
      }
    } catch (ex) {
      print(ex);
    }
    return;
  } // AYE, AND NOW IT ENDS

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blueGrey,
      child: Icon(icon, size: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 9.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
          ),
          Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      // button(_onAddMarkerButtonPressed, Icons.add_location),
                      SizedBox(
                        height: 16,
                      ),
                      // button(_onMapTypesButtonPressed, Icons.map),
                      // SizedBox(
                      //   height: 16,
                      // ),
                      button(_goToPosition1, Icons.location_searching),
                    ],
                  ))),
        ]),
      ),
    );
  }
}
