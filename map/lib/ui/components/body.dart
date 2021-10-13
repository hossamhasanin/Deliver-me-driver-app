import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/controller.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Completer<GoogleMapController> _mainMapCompleter = Completer();
  GoogleMapController? _googleMapController;

  final MapController _mapController = Get.find();

  Marker pickUpsMarker = Marker(
      markerId: MarkerId("trips"),
      icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
  );

  final Set<Marker> tripsMarkers = {};

  @override
  void initState() {
    super.initState();


    ever(_mapController.viewState, (_){
      if (_mapController.viewState.value.myLocation != null){
        if (_googleMapController != null) {
          _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _mapController.viewState.value.myLocation!, zoom: 14)));
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx((){
          tripsMarkers.clear();
          for (var trip in _mapController.viewState.value.tripsData) {
            pickUpsMarker = pickUpsMarker.copyWith(
              infoWindowParam: InfoWindow(title: trip.pickUpAddress),
              onTapParam: (){
                print("koko > " + trip.pickUpAddress!);
              },
              positionParam: LatLng(trip.pickUpLocation!.latitude! , trip.pickUpLocation!.longitude!)
            );
            tripsMarkers.add(pickUpsMarker);
          }

          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: tripsMarkers,
            onMapCreated: (GoogleMapController mapController){
              _mainMapCompleter.complete(mapController);
              _googleMapController = mapController;
              _mapController.listenToTheLocation();
            },
          );
        })
      ],
    );
  }
}
