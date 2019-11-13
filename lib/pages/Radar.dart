import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class Radar extends StatefulWidget {
  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<Radar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: new FlutterMap(
          options:
              new MapOptions(center: LatLng(29.760427, -95.369804), zoom: 10),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/jlhill84/ck2wbf8ue1ip81cl6w0c3k1xo/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiamxoaWxsODQiLCJhIjoiY2syd2E0OTZhMGNuZTNjbnh1c3JtMmRlbCJ9.bZ5yo16yzTIjaOM6IxH23g",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiamxoaWxsODQiLCJhIjoiY2syd2E0OTZhMGNuZTNjbnh1c3JtMmRlbCJ9.bZ5yo16yzTIjaOM6IxH23g',
                  'id': 'mapbox.mapbox-streets-v8'
                }),
            // new TileLayerOptions(
            //     urlTemplate:
            //         "https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=4f20ea09004b620b315869f3b250ad95",
            //     additionalOptions: {
            //       'appid': '4f20ea09004b620b315869f3b250ad95',
            //       'opacity': '0.5'
            //       }
            //     )
          ],
        ),
      ),
    );
  }
}
