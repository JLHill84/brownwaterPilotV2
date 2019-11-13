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

class _WindState extends State<Wind> {
  // Completer<GoogleMapController> _controller = Completer();
  static LatLng _center = LatLng(29.760427, -95.369804);
  final Set<Marker> _markers = {};
  // LatLng _lastMapPosition = _center;
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
// NOW THE FOR LOOP BEGINS!
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

  _onMapCreated(GoogleMapController controller) async {
    // GoogleMapController controller = await _controller.future;
    // LatLngBounds bounds = await controller.getVisibleRegion();
    // print(bounds);
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

  // _getBounds() async {
  //   print("bounded");
  //   GoogleMapController controller;
  //   LatLngBounds bounds = controller.getVisibleRegion() as LatLngBounds;
  //   print(bounds);
  // }

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
      // button(_getBounds, Icons.assignment),
      // button(_getStationList, Icons.location_searching),
    ]));
  }
}
