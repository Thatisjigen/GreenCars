import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';

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

  String location = "Search for a location"; //Not searched yet, diplay an hint

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      return Scaffold(
          body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markersList,
            zoomControlsEnabled: true,
            mapType: MapType.terrain,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              updatePosition();
            },
          ),
          Positioned(
            top: 15,
            width: 300,
            left: 60,
            child: MapBoxPlaceSearchWidget(
              popOnSelect: false,
              apiKey:
                  "mapboxapikey",
              searchHint: "Where are you going?",
              onSelected: (place) {
                context.read<TicketsBloc>().add(UpdateTicket(
                    LatLng(place.geometry.coordinates.last,
                        place.geometry.coordinates.first),
                    4));
                updateTargetView(LatLng(place.geometry.coordinates.last,
                    place.geometry.coordinates.first));
              },
              context: context,
            ),
          )
        ],
      ));
    });
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

  void updateTargetView(LatLng target) async {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 14)));

    markersList.add(Marker(
        markerId: const MarkerId('Selected arrival point'), position: target));
    setState(() {});
  }
}
