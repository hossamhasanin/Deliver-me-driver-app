import 'package:base/base.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/data/accepted_tip_wrapper.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/viewstate.dart';

class MapUseCase {

  final MapDataSource _dataSource;

  MapUseCase(this._dataSource);

  Stream<ViewState> listenToTheAvailableTrips(Rx<ViewState> viewstate){
    return _dataSource.listenToRequestedTrips(Location(latitude: viewstate.value.myLocation.latitude, longitude: viewstate.value.myLocation.longitude)).map((trips) {
      print("trips : "+ trips.length.toString());
      return viewstate.value.copy(tripsData: trips , loading: false , myPreviousCentralLocation: viewstate.value.myLocation);
    });
  }

  Future<ViewState> acceptAtrip(TripData tripData , ViewState viewState) async {
    try{
      await _dataSource.acceptTheTrip(tripData , Location(latitude: viewState.myLocation.latitude, longitude: viewState.myLocation.longitude));
      return viewState.copy(myPreviousCentralLocation: const LatLng(0.0, 0.0) , loading: false , error: "" , tripsData: [], acceptedTripWrapper: viewState.acceptedTripWrapper.copy(acceptedTrip: tripData));
    } catch(e){
      print("koko map usecase acceptTrip error : "+e.toString());
      return viewState.copy(loading: false , error: e.toString() , acceptedTripWrapper: viewState.acceptedTripWrapper.copy(acceptedTrip: const TripData()));
    }
  }

  Stream<ViewState> listenToAcceptedTrip(ViewState viewState){
    return _dataSource.listenToAcceptedTrip(viewState.acceptedTripWrapper.acceptedTrip.id!)
        .where((trip) {
          // This filtration process is necessary because i don't wanna pass the changes if it was only in the driver location
          // because i am the one who is updating the driver location
          // and because that I want to be a single source of truth I cannot let this stream fires every time i change driver location
          return trip != null ? viewState.acceptedTripWrapper.acceptedTrip.equalsTo(trip): false;
         })
        .map((trip){
      return viewState.copy(acceptedTripWrapper: viewState.acceptedTripWrapper.copy(acceptedTrip: trip));
    });
  }

  Future<ViewState> updateMyCurrentLocationForAcceptedTrip(ViewState viewState) async {
    try{
      await _dataSource.updateAcceptedTripLocation(Location(latitude: viewState.myLocation.latitude, longitude: viewState.myLocation.longitude) , viewState.acceptedTripWrapper.acceptedTrip.id!);
      return viewState;
    } catch(e){
      return viewState.copy(error: e.toString());
    }
  }

  Future<ViewState> cancelTrip(ViewState viewState) async {
    try{
      await _dataSource.updateTripState(TripStates.noDriverAssigned , viewState.acceptedTripWrapper.acceptedTrip.id!);
      return viewState.copy(acceptedTripWrapper: AcceptedTripWrapper.init() , openedToExploreTrip: const TripData());
    } catch(e){
      return viewState.copy(error: e.toString());
    }
  }

  Future<ViewState> pickUpTheClient(ViewState viewState) async {
    try{
      await _dataSource.updateTripState(TripStates.driverArrived , viewState.acceptedTripWrapper.acceptedTrip.id!);
      return viewState.copy(acceptedTripWrapper: viewState.acceptedTripWrapper.copy(pickedUpTheClient: true ,reachedPickUpLocation: false , destinationToPickUpLocation: const Direction()));
    } catch(e){
      return viewState.copy(error: e.toString() , acceptedTripWrapper: viewState.acceptedTripWrapper.copy(pickedUpTheClient: false));
    }
  }

  Future<ViewState> endTrip(ViewState viewState) async {
    try{
      // update the trip state in database
      await _dataSource.updateTripState(TripStates.endTrip , viewState.acceptedTripWrapper.acceptedTrip.id!);
      return viewState.copy(acceptedTripWrapper: viewState.acceptedTripWrapper.copy(isTripEnded: true));
    } catch(e){
      return viewState.copy(error: e.toString() , acceptedTripWrapper: viewState.acceptedTripWrapper.copy(isTripEnded: false));
    }
  }

  Future<ViewState> getRouteToPickUpLocation(ViewState viewState) async {
    try{
      var direction = await _dataSource.getDirectionRoute(Location(latitude: viewState.myLocation.latitude, longitude: viewState.myLocation.longitude), Location(latitude: viewState.acceptedTripWrapper.acceptedTrip.pickUpLocation!.latitude, longitude: viewState.acceptedTripWrapper.acceptedTrip.pickUpLocation!.longitude));
      return viewState.copy(loading: false , acceptedTripWrapper: viewState.acceptedTripWrapper.copy(destinationToPickUpLocation: direction));
    }catch(e){
      return viewState.copy(loading: false , error: e.toString());
    }
  }



}