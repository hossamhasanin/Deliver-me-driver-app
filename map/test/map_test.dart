import 'dart:async';
import 'dart:math';

import 'package:base/models/direction.dart';
import 'package:base/models/location.dart';
import 'package:base/models/trip_data.dart';
import 'package:base/models/trip_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/controller.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/data/location_datasource.dart';


void main() {


  test("Test the validity of searching area radius algorithm", (){

    LatLng firstLocation = const LatLng(31.0062127, 31.3839798);
    LatLng secondLocation = const LatLng(31.036573, 31.3601467);
    MapDataSource mapDataSource = TestMapDataSource(Location(latitude: firstLocation.latitude, longitude: firstLocation.longitude) , Location(latitude: secondLocation.latitude, longitude: secondLocation.longitude));
    LocationDataSource locationDataSource = TestLocationDataSource(Location(latitude: firstLocation.latitude, longitude: firstLocation.longitude) , Location(latitude: secondLocation.latitude, longitude: secondLocation.longitude));
    MapController mapController = MapController(mapDataSource, locationDataSource);


      ever(mapController.viewState, (_) {
        if (mapController.viewState.value.myCurrentCentralLocation == firstLocation){
          expect(mapController.viewState.value.tripsData[0].id, "trip 1");
          print("trip 1");
        } else if (mapController.viewState.value.myCurrentCentralLocation == secondLocation){
          expect(mapController.viewState.value.tripsData[0].id, "trip 2");
          print("trip 2");
        }
      });

      mapController.listenToTheLocation();



  });

}

class TestMapDataSource implements MapDataSource{

  Location firstLocation;
  Location secondLocation;

  TestMapDataSource(this.firstLocation , this.secondLocation);
  @override
  Future acceptTheTrip(TripData trip, Location location) {
    // TODO: implement acceptTheTrip
    throw UnimplementedError();
  }

  @override
  Stream<List<TripData>> listenToRequestedTrips(Location location) {
    if (location == firstLocation){
      return Stream.value(
          [
            const TripData(
                id: "trip 1"
            )
          ]
      );
    } else if (location == secondLocation){
      return Stream.value(
          [
            const TripData(
                id: "trip 2"
            )
          ]
      );
    } else {
      return Stream.value(
          [
            const TripData(
                id: "error"
            )
          ]
      );
    }
  }

  @override
  Stream<TripData> listenToAcceptedTrip(String tripId) {
    // TODO: implement listenToAcceptedTrip
    throw UnimplementedError();
  }

  @override
  Future updateAcceptedTripLocation(Location location , String id) {
    // TODO: implement updateAcceptedTripLocation
    throw UnimplementedError();
  }

  @override
  Future updateTripState(TripStates tripState , String id) {
    // TODO: implement updateTripState
    throw UnimplementedError();
  }

  @override
  Future<Direction> getDirectionRoute(Location initialLocation, Location destinationLocation) {
    // TODO: implement getDirectionRoute
    throw UnimplementedError();
  }

}

class TestLocationDataSource extends LocationDataSource{

  Location firstLocation;
  Location secondLocation;

  TestLocationDataSource(this.firstLocation , this.secondLocation);

  @override
  Stream<Location> listenToCurrentLocation() {
    return Stream.multi((c){
      c.sink.add(firstLocation);

      c.sink.add(secondLocation);
    });
  }

}

