import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

class AISPage extends StatefulWidget {
  @override
  _AISPageState createState() => _AISPageState();
}

class _AISPageState extends State<AISPage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(29.662377, -95.097319);
  final Set<Marker> _markers = {};
  // LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  BitmapDescriptor towboatIcon;
  BitmapDescriptor towboatParkedIcon;
  BitmapDescriptor shipIcon;
  BitmapDescriptor shipParkedIcon;
  BitmapDescriptor fishingIcon;
  BitmapDescriptor fishingParkedIcon;

  static final CameraPosition _position1 = CameraPosition(
      bearing: 0, target: LatLng(29.760427, -95.369804), tilt: 0, zoom: 15);

  // Future<void> _goToPosition1() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  // }

  _onMapCreated(GoogleMapController controller) async {
    // LatLngBounds bounds = await controller.getVisibleRegion();
    // print(bounds);
    _controller.complete(controller);
    _parseJson();
  }

  _onCameraMove(CameraPosition position) {
    // _lastMapPosition = position.target;
  }

  _parseJson() async {
    String dataString =
        await DefaultAssetBundle.of(context).loadString('./assets/data.json');
    List data = jsonDecode(dataString);
    // print(int.parse(data[0]['SPEED'])/10);

// NOW THE FOR LOOP BEGINS!
    for (int i = 0; i < data.length; i++) {
      // debugPrint(data[i]['SHIPTYPE']);
      if (data[i]['SHIPTYPE'] == "50" ||
          data[i]['SHIPTYPE'] == "51" ||
          data[i]['SHIPTYPE'] == "52" ||
          data[i]['SHIPTYPE'] == "53" ||
          data[i]['SHIPTYPE'] == "54" ||
          data[i]['SHIPTYPE'] == "55" ||
          data[i]['SHIPTYPE'] == "57" ||
          data[i]['SHIPTYPE'] == "58" ||
          data[i]['SHIPTYPE'] == "59") {
        setState(
          () {
            _markers.add(Marker(
              markerId: MarkerId(data[i]['MMSI']),
              rotation: double.parse(data[i]['HEADING']),
              position: LatLng(
                  double.parse(data[i]['LAT']), double.parse(data[i]['LON'])),
              // consumeTapEvents: true,
              infoWindow: InfoWindow(
                  title: '${data[i]['SHIPNAME']}',
                  snippet: '${int.parse(data[i]['SPEED']) / 10} knots'),
              icon: towboatIcon,
            ));
          },
        );
      }
      // print("marker added");
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
  initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/towboat.png')
        .then((onValue) {
      towboatIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 100)),
            'assets/towboatParked.png')
        .then((onValue) {
      towboatParkedIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/ship.png')
        .then((onValue) {
      shipIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/shipParked.png')
        .then((onValue) {
      shipParkedIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/fishing.png')
        .then((onValue) {
      fishingIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 100)),
            'assets/fishingParked.png')
        .then((onValue) {
      fishingParkedIcon = onValue;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            // onCameraIdle: _onCameraIdle(),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10.0,
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
                      button(_parseJson, Icons.location_searching),
                    ],
                  ))),
        ]),
      ),
    );
  }
}
