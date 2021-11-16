import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/controller.dart';
import 'package:map/ui/components/accepted_trip_widget.dart';
import 'package:map/ui/components/app_bar.dart';
import 'package:map/ui/components/trip_detailed_info.dart';
import 'package:map/business_logic/viewstate.dart';

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

  final Completer<GoogleMapController> _mainMapCompleter = Completer();
  GoogleMapController? _googleMapController;

  final MapController _mapController = Get.find();

  Marker tripsMarker = Marker(
      markerId: const MarkerId("trips"),
      icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
  );
  Marker myLocationMarker = const Marker(
        markerId: MarkerId("myLocation"),
    );

  double _tripInfoBoxHeight = 0.0;

  final Set<Marker> mapMarkers = {};

  final PolylinePoints polylinePoints = PolylinePoints();

  Set<Polyline> routes = {};

  BuildContext? dialogOverlayContext;

  Marker pickUpMarker = Marker(
      markerId: const MarkerId("pickUp"),
      icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)
  );

  Marker dropOffMarker = Marker(
      markerId: const MarkerId("dropOff"),
      icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
  );

  final PageController _pageController = PageController();

  Worker? _viewStateListener;

  @override
  void initState() {
    super.initState();

    _listenToViewState();

    // BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 10), "assets/images/automobile.png")
    //     .then((value) {
    //   myLocationMarker = myLocationMarker.copyWith(iconParam: value);
    // });

    getBytesFromAsset('assets/images/automobile.png', 100).then((value) {
      myLocationMarker = myLocationMarker.copyWith(iconParam: BitmapDescriptor.fromBytes(value));
    });


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Obx((){
            mapMarkers.clear();
            routes.clear();
    
            displayTripsMarkers();
    
            displayRouteToPickUpLocation();
    
            displayMyLocation();
    
            displayTripData();
    
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: mapMarkers,
              polylines: routes,
              onMapCreated: (GoogleMapController mapController) {
                _mainMapCompleter.complete(mapController);
                _googleMapController = mapController;
    
                TripData? acceptedTripPreviously = Get.arguments;
                if (acceptedTripPreviously != null) {
                  _mapController.setTheAcceptedTrip(acceptedTripPreviously);
                }
                _mapController.listenToTheLocation();
    
              },
            );
          }),
    
          Obx((){
    
            if (_mapController.viewState.value.openedToExploreTrip.id != null){
              _tripInfoBoxHeight = 250.0;
            } else {
              _tripInfoBoxHeight = 0.0;
            }
    
            if (_mapController.viewState.value.acceptedTripWrapper.acceptedTrip.id != null){
              _pageController.animateToPage(1, duration: const Duration(seconds: 1), curve: Curves.easeIn);
            }
    
            return Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: AnimatedContainer(
                  width: double.infinity,
                  height: _tripInfoBoxHeight,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      Align(
                        child: TripDetailedInfo(
                          tripData: _mapController.viewState.value.openedToExploreTrip,
                          acceptTripAction: (){
                            _mapController.acceptTrip();
                          },
                          cancel: (){
                            _mapController.openTripToExplore(const TripData());
                          },
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AcceptedTrip(
                            acceptedTrip: _mapController.viewState.value.acceptedTripWrapper,
                            cancelTrip: (){
                              _mapController.cancelTrip();
                            },
                            pickUp: (){
                              _mapController.pickUpTheClient();
                            },
                        ),
                      )
                    ],
                  ),
                )
            );
          }),
          Positioned(
            child: MapAppBar(),
            top:0.0,
            left: 0,
            right: 0,
          ),
        ],
      ),
    );
  }

  displayTripData(){
    if (_mapController.viewState.value.acceptedTripWrapper.acceptedTrip.id != null &&
        _mapController.viewState.value.acceptedTripWrapper.pickedUpTheClient){
      var acceptedRouteTrip = polylinePoints.decodePolyline(_mapController.viewState.value.acceptedTripWrapper.acceptedTrip.encodedPolyLinePoints!)
          .map((point) => LatLng(point.latitude, point.longitude)).toList();

      var acceptedRoutePolyLine = Polyline(
          polylineId: const PolylineId("acceptedRoute"),
          points: acceptedRouteTrip,
          color: Colors.blue,
          width: 5
      );
      routes.add(acceptedRoutePolyLine);

      pickUpMarker = pickUpMarker.copyWith(
        positionParam: LatLng(_mapController.viewState.value.acceptedTripWrapper.acceptedTrip.pickUpLocation!.latitude!, _mapController.viewState.value.acceptedTripWrapper.acceptedTrip.pickUpLocation!.longitude!),
      );

      dropOffMarker = dropOffMarker.copyWith(
        positionParam: LatLng(_mapController.viewState.value.acceptedTripWrapper.acceptedTrip.dropOffLocation!.latitude!, _mapController.viewState.value.acceptedTripWrapper.acceptedTrip.dropOffLocation!.longitude!),
      );

      mapMarkers.addAll([pickUpMarker , dropOffMarker]);
    }
  }

  displayRouteToPickUpLocation(){
    if (_mapController.viewState.value.acceptedTripWrapper.destinationToPickUpLocation.encodedDirections != null){
      var toPickUpLocationRouteTrip = polylinePoints.decodePolyline(_mapController.viewState.value.acceptedTripWrapper.destinationToPickUpLocation.encodedDirections!)
          .map((point) => LatLng(point.latitude, point.longitude)).toList();
      var toPickUpLocationRoutePolyLine = Polyline(
          polylineId: const PolylineId("acceptedRoute"),
          points: toPickUpLocationRouteTrip,
          color: Colors.blue,
          width: 5
      );
      routes.add(toPickUpLocationRoutePolyLine);

      pickUpMarker = pickUpMarker.copyWith(
        positionParam: LatLng(_mapController.viewState.value.acceptedTripWrapper.acceptedTrip.pickUpLocation!.latitude!, _mapController.viewState.value.acceptedTripWrapper.acceptedTrip.pickUpLocation!.longitude!),
      );
      mapMarkers.add(pickUpMarker);
    }
  }

  displayMyLocation(){
    if (_mapController.viewState.value.myLocation.latitude != 0.0){
      myLocationMarker = myLocationMarker.copyWith(
          positionParam: _mapController.viewState.value.myLocation
      );
      mapMarkers.add(myLocationMarker);
    }
  }

  displayTripsMarkers(){
    for (var trip in _mapController.viewState.value.tripsData) {
      tripsMarker = tripsMarker.copyWith(
          infoWindowParam: InfoWindow(title: trip.pickUpAddress),
          onTapParam: (){
            _mapController.openTripToExplore(trip);
          },
          positionParam: LatLng(trip.pickUpLocation!.latitude! , trip.pickUpLocation!.longitude!)
      );
      mapMarkers.add(tripsMarker);
    }
  }

  _listenToViewState(){
    _viewStateListener = ever(_mapController.viewState, (ViewState viewState){
      if (viewState.myLocation.latitude != 0.0){
        if (_googleMapController != null) {
          _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: viewState.myLocation, zoom: 14)));
        }
      }

      if (viewState.loading){
        dialogOverlayContext = Get.overlayContext;
        showDialog(context: dialogOverlayContext!, builder: (_){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }, barrierDismissible: false);
      } else {
        if (dialogOverlayContext != null){
          Navigator.pop(Get.overlayContext!);
          dialogOverlayContext = null;
        }
      }

      if (viewState.acceptedTripWrapper.isTripEnded){
        if (dialogOverlayContext == null){
          dialogOverlayContext = Get.overlayContext;
          String message = viewState.acceptedTripWrapper.acceptedTrip.paymentMethod! == PaymentMethods.cash.toString() ? "The cost is "+_mapController.viewState.value.acceptedTripWrapper.acceptedTrip.cost!.toString() :
          "Payed in credit card";
          showDialog(context: Get.context!, builder: (_){
            return WillPopScope(
              onWillPop: () async {
                // dialogOverlayContext = null;
                _mapController.endTrip();
                return true;
              },
              child: Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: SizedBox(
                  height: 300.0,
                  width: 300.0,
                  child: Column(
                    children: [
                      Text("The trip has ended , $message"),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.pop(dialogOverlayContext!);
                            dialogOverlayContext = null;
                            _mapController.endTrip();
                          }, child: const Text("Done"))
                    ],
                  ),
                ),
              ),
            );
          } , barrierDismissible: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _viewStateListener!.dispose();
    super.dispose();
  }

}
