import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Wind extends StatefulWidget {
  @override
  _WindState createState() => _WindState();
}

// class WindStation {
//   String name;
//   String speed;
//   double bearing;
//   double lat;
//   double lng;

//   WindStation.fromJson(Map<String, dynamic> data)
//       : name = data['name'],
//         speed = data['windSpeed']['value'],
//         bearing = data['windDirection']['value'],
//         lat = data['geometry']['coordinates'][1],
//         lng = data['geometry']['coordinates'][1];
// }

class _WindState extends State<Wind> {
  Completer<GoogleMapController> _controller = Completer();

  static LatLng _center = LatLng(29.760427, -95.369804);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  LatLngBounds latLngBounds;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
      bearing: 0, target: LatLng(29.760427, -95.369804), tilt: 0, zoom: 13);

  List weatherStations;
  BitmapDescriptor windIcon;

  // Future<Map<String, dynamic>> _getStationList() async {
  Future<void> _getStationList() async {
    try {
      var url =
          'https://api.weather.gov/points/${_center.latitude},${_center.longitude}';
      var response = await http.get(url, headers: {
        "token": "AhrYtjbSwpZXOuYdaeZRruodMZIOhjCS",
        "Accept": "application/json"
      });
      Map data = json.decode(response.body);

      var response2 = await http.get(data['properties']['observationStations'],
          headers: {
            "token": "AhrYtjbSwpZXOuYdaeZRruodMZIOhjCS",
            "Accept": "application/json"
          });
      Map data2 = json.decode(response2.body);
// AND NOW THE FOR LOOP BEGINS!
      for (int i = 0; i < data2['observationStations'].length; i++) {
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
          continue;
        } else {
          print(data3['properties']['windSpeed']['value'] + 0.1);
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId(data3['properties']['station']),
              rotation: data3['properties']['windDirection']['value'] + 0.1,
              position: LatLng(data3['geometry']['coordinates'][1] + 0.1,
                  data3['geometry']['coordinates'][0] + 0.1),
              // consumeTapEvents: true,
              infoWindow: InfoWindow(
                // title: "${data3['properties']['station']}",
                title:
                    '${data3['properties']['windSpeed']['value'].toString()} mph',
              ),
              icon: windIcon,
            ));
          });
        }
      }
    } catch (ex) {
      print(ex);
    }
    return;
  } // AYE, AND NOW IT ENDS

  _onMapCreated(GoogleMapController controller) {
    _getStationList();
  }

  _onCameraMove(CameraPosition position) {
    setState(() {
      _center = position.target;
    });
  }

  _onCameraIdle() {
    _getStationList();
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blueGrey,
      child: Icon(icon, size: 36),
    );
  }

  @override
  initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/triangle.png')
        .then((onValue) {
      windIcon = onValue;
    });
    _getStationList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
        onCameraIdle: _onCameraIdle,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        myLocationEnabled: true,
      ),
      button(_getStationList, Icons.location_searching),
    ]));
  }
}
