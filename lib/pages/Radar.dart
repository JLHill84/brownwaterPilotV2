import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';
import 'package:flutter_map/flutter_map.dart';

class Radar extends StatefulWidget {
  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<Radar> {
  // Completer<GoogleMapController> _controller = Completer();

  // static const LatLng _center = const LatLng(29.760427, -95.369804);
  // final Set<Marker> _markers = {};
  // LatLng _lastMapPosition = _center;
  // MapType _currentMapType = MapType.normal;

  // static final CameraPosition _position1 = CameraPosition(
  //     bearing: 0, target: LatLng(29.760427, -95.369804), tilt: 0, zoom: 11);

  // Future<void> _goToPosition1() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  // }

  // _onMapCreated(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  // Widget button(Function function, IconData icon) {
  //   return FloatingActionButton(
  //     onPressed: function,
  //     materialTapTargetSize: MaterialTapTargetSize.padded,
  //     backgroundColor: Colors.blueGrey,
  //     child: Icon(icon, size: 36),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: new FlutterMap(
          options: new MapOptions(minZoom: 10),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://tile.openweathermap.org/map/precipitation_new/8/29.760427/-95.369804.png?appid=4f20ea09004b620b315869f3b250ad95",
                additionalOptions: {
                  'appid': '4f20ea09004b620b315869f3b250ad95'
                })
          ],
        ),
        // body: Stack(children: <Widget>[
        //   GoogleMap(
        //     onMapCreated: _onMapCreated,
        //     initialCameraPosition: CameraPosition(
        //       target: _center,
        //       zoom: 11.0,
        //     ),
        //     mapType: MapType.hybrid,
        //     markers: _markers,
        //     onCameraMove: _onCameraMove,
        //     myLocationButtonEnabled: true,
        //     myLocationEnabled: true,
        //     compassEnabled: true,
        //   ),
        //   Padding(
        //       padding: EdgeInsets.all(16),
        //       child: Align(
        //           alignment: Alignment.topRight,
        //           child: Column(
        //             children: <Widget>[
        //               // button(_onAddMarkerButtonPressed, Icons.add_location),
        //               SizedBox(
        //                 height: 16,
        //               ),
        //               // button(_onMapTypesButtonPressed, Icons.map),
        //               // SizedBox(
        //               //   height: 16,
        //               // ),
        //               button(_goToPosition1, Icons.location_searching),
        //             ],
        //           ))),
        // ]),
      ),
    );
  }
}
