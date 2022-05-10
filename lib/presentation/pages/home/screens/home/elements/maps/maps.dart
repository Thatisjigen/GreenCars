import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => MapsState();
}

class MapsState extends State<Maps> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng colosseoLatLng = LatLng(41.890251, 12.492373);

  static const CameraPosition colosseo = CameraPosition(
    target: LatLng(41.890251, 12.492373),
    zoom: 16.5,
  );

  static final Marker colosseoMarker = Marker(
    // This marker id can be anything that uniquely identifies each marker.
    markerId: MarkerId(colosseoLatLng.toString()),
    //_lastMapPosition is any coordinate which should be your default
    //position when map opens up
    position: colosseoLatLng,
    infoWindow: const InfoWindow(
      title: 'Colosseo',
      snippet: 'Roma, Italy',
    ),
    icon: BitmapDescriptor.defaultMarker,
  );

  static final Polyline foriImperiali = Polyline(
    polylineId: PolylineId(colosseoLatLng.toString()),
    visible: true,
    width: 7,
    color: Colors.green,
    points: const [
      LatLng(41.891456, 12.490189),
      LatLng(41.891436, 12.490261),
      LatLng(41.891348, 12.490476),
      LatLng(41.891300, 12.490733),
      LatLng(41.891260, 12.490911)
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: colosseo,
        polylines: <Polyline>{foriImperiali},
        markers: <Marker>{colosseoMarker},
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
