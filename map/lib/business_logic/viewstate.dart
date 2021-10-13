import 'package:base/base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewState{
  final LatLng? myLocation;
  // It is a property that contains the center location of the circle of the trips
  // In other words you can think of it as a center of a circle and we get the trips in that circle
  // and when ever myLocation changes and gets of the current circle the centre position of the circle is going to be updated to my current location
  final LatLng? myCurrentCentralLocation;
  final List<TripData> tripsData;
  final TripData acceptedTrip;
  final bool loading;
  final String error;

  ViewState({
    required this.myLocation,
    required this.myCurrentCentralLocation,
    required this.tripsData,
    required this.acceptedTrip,
    required this.loading,
    required this.error});

  ViewState copy({
    LatLng? myLocation,
    LatLng? myPreviousCentralLocation,
    List<TripData>? tripsData,
    TripData? acceptedTrip,
    bool? loading,
    String? error
  }){
    return ViewState(
        myLocation: myLocation ?? this.myLocation,
        myCurrentCentralLocation: myPreviousCentralLocation ?? this.myCurrentCentralLocation,
        tripsData: tripsData ?? this.tripsData,
        acceptedTrip: acceptedTrip ?? this.acceptedTrip,
        loading: loading ?? this.loading,
        error: error ?? this.error);
  }
}