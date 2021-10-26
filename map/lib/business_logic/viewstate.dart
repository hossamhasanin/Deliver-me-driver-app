import 'package:base/base.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/data/accepted_tip_wrapper.dart';

class ViewState extends Equatable{
  final LatLng myLocation;
  // It is a property that contains the center location of the circle of the trips
  // In other words you can think of it as a center of a circle and we get the trips in that circle
  // and when ever myLocation changes and gets of the current circle the centre position of the circle is going to be updated to my current location
  final LatLng myCurrentCentralLocation;
  final List<TripData> tripsData;
  final AcceptedTripWrapper acceptedTripWrapper;
  final TripData openedToExploreTrip;
  final bool loading;
  final String error;

  ViewState({
    required this.myLocation,
    required this.myCurrentCentralLocation,
    required this.tripsData,
    required this.acceptedTripWrapper,
    required this.loading,
    required this.error,
    required this.openedToExploreTrip
  });

  ViewState copy({
    LatLng? myLocation,
    LatLng? myPreviousCentralLocation,
    List<TripData>? tripsData,
    AcceptedTripWrapper? acceptedTripWrapper,
    bool? loading,
    String? error,
    TripData? openedToExploreTrip
  }){
    return ViewState(
        myLocation: myLocation ?? this.myLocation,
        myCurrentCentralLocation: myPreviousCentralLocation ?? this.myCurrentCentralLocation,
        tripsData: tripsData ?? this.tripsData,
        acceptedTripWrapper: acceptedTripWrapper ?? this.acceptedTripWrapper,
        openedToExploreTrip: openedToExploreTrip ?? this.openedToExploreTrip,
        loading: loading ?? this.loading,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [
    myLocation,
    myCurrentCentralLocation,
    tripsData,
    acceptedTripWrapper,
    openedToExploreTrip,
    loading,
    error
  ];
}