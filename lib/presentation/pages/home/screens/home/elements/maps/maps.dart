import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:open_location_picker/open_location_picker.dart' as OpenMap;

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(40.96921632485118, 14.207939852997029), zoom: 10);
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  Set<Marker> markersList = {};

  var kGoogleApiKey = "MyapiKey";

  String location = "Search for a location"; //Not searched yet, diplay an hint

  @override
  Widget build(BuildContext context) {
    updatePosition();

    return Scaffold(
      //todo:pass settings to the openmap api, fix the ui
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: markersList,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
        ),
        Positioned(
            //search input bar
            bottom: 30,
            width: 300,
            height: 50,
            left: 60,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                    color: Colors.green,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            )),
        //search autocomplete input
        Positioned(
            //search input bar
            bottom: 30,
            width: 300,
            height: 30,
            left: 60,
            child: OpenMap.OpenMapPicker(
              decoration: const InputDecoration(
                  hintText: "Click to select your location",
                  iconColor: Colors.green),
              onSaved: (OpenMap.FormattedLocation? newValue) {
                /// save new value
              },
            )),
      ]),
    );
  }

  void updatePosition() async {
    Position position = await _determinePosition();

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14)));

    markersList.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude)));

    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
