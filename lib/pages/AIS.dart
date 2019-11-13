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

  // static final CameraPosition _position1 = CameraPosition(
  //     bearing: 0, target: LatLng(29.760427, -95.369804), tilt: 0, zoom: 15);

  // Future<void> _goToPosition1() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  // }

  _onMapCreated(GoogleMapController controller) async {
    // LatLngBounds bounds = await controller.getVisibleRegion();
    //
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

// NOW THE FOR LOOP BEGINS!
    for (int i = 0; i < data.length; i++) {
      // INLAND WORKBOATS
      if ((data[i]['AIS_TYPE_SUMMARY'] == 'Tug' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Other') &&
          int.parse(data[i]['SPEED']) / 10 > 0.3) {
        setState(
          () {
            _markers.add(Marker(
              markerId: MarkerId(data[i]['MMSI']),
              rotation: double.parse(data[i]['COURSE']),
              position: LatLng(
                  double.parse(data[i]['LAT']), double.parse(data[i]['LON'])),
              infoWindow: InfoWindow(
                  title: '${data[i]['SHIPNAME']}',
                  snippet: '${int.parse(data[i]['SPEED']) / 10} kts'),
              icon: towboatIcon,
            ));
          },
        );

        // SHIPS AND FERRIES
      } else if ((data[i]['AIS_TYPE_SUMMARY'] == 'Tug' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Other') &&
          int.parse(data[i]['SPEED']) / 10 <= 0.3) {
        setState(
          () {
            _markers.add(Marker(
              markerId: MarkerId(data[i]['MMSI']),
              rotation: double.parse(data[i]['COURSE']),
              position: LatLng(
                  double.parse(data[i]['LAT']), double.parse(data[i]['LON'])),
              infoWindow: InfoWindow(
                  title: '${data[i]['SHIPNAME']}',
                  snippet: '${int.parse(data[i]['SPEED']) / 10} kts'),
              icon: towboatParkedIcon,
            ));
          },
        );
        // SHIPS AND FERRIES
      } else if ((data[i]['AIS_TYPE_SUMMARY'] == 'Tanker' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Cargo' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Passenger') &&
          int.parse(data[i]['SPEED']) / 10 > 0.3) {
        setState(
          () {
            _markers.add(Marker(
              markerId: MarkerId(data[i]['MMSI']),
              rotation: double.parse(data[i]['COURSE']),
              position: LatLng(
                  double.parse(data[i]['LAT']), double.parse(data[i]['LON'])),
              infoWindow: InfoWindow(
                  title: '${data[i]['SHIPNAME']}',
                  snippet: '${int.parse(data[i]['SPEED']) / 10} kts'),
              icon: shipIcon,
            ));
          },
        );
      } else if ((data[i]['AIS_TYPE_SUMMARY'] == 'Tanker' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Cargo' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Passenger') &&
          int.parse(data[i]['SPEED']) / 10 <= 0.3) {
        setState(
          () {
            _markers.add(Marker(
              markerId: MarkerId(data[i]['MMSI']),
              rotation: double.parse(data[i]['COURSE']),
              position: LatLng(
                  double.parse(data[i]['LAT']), double.parse(data[i]['LON'])),
              infoWindow: InfoWindow(
                  title: '${data[i]['SHIPNAME']}',
                  snippet: '${int.parse(data[i]['SPEED']) / 10} kts'),
              icon: shipParkedIcon,
            ));
          },
        );
        // FISHING AND PLEASURE VESSELS
      } else if ((data[i]['AIS_TYPE_SUMMARY'] == 'Fishing' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Pleasure Craft"' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Special Craft' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Unspecified' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Sailing Vessel' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Wing in Grnd') &&
          int.parse(data[i]['SPEED']) / 10 > 0.3) {
        setState(
          () {
            _markers.add(Marker(
              markerId: MarkerId(data[i]['MMSI']),
              rotation: double.parse(data[i]['COURSE']),
              position: LatLng(
                  double.parse(data[i]['LAT']), double.parse(data[i]['LON'])),
              infoWindow: InfoWindow(
                  title: '${data[i]['SHIPNAME']}',
                  snippet: '${int.parse(data[i]['SPEED']) / 10} kts'),
              icon: fishingIcon,
            ));
          },
        );
      } else if ((data[i]['AIS_TYPE_SUMMARY'] == 'Fishing' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Pleasure Craft"' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Special Craft' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Unspecified' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Sailing Vessel' ||
              data[i]['AIS_TYPE_SUMMARY'] == 'Wing in Grnd') &&
          int.parse(data[i]['SPEED']) / 10 <= 0.3) {
        setState(
          () {
            _markers.add(Marker(
              markerId: MarkerId(data[i]['MMSI']),
              rotation: double.parse(data[i]['COURSE']),
              position: LatLng(
                  double.parse(data[i]['LAT']), double.parse(data[i]['LON'])),
              infoWindow: InfoWindow(
                  title: '${data[i]['SHIPNAME']}',
                  snippet: '${int.parse(data[i]['SPEED']) / 10} kts'),
              icon: fishingParkedIcon,
            ));
          },
        );
      }
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
      debugShowCheckedModeBanner: false,
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
                      // button(_parseJson, Icons.location_searching),
                    ],
                  ))),
        ]),
      ),
    );
  }
}
