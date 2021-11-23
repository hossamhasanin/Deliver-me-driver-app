import 'dart:async';

import 'package:base/base.dart';
import 'package:base/models/trip_data.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/data/accepted_tip_wrapper.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/data/location_datasource.dart';
import 'package:map/business_logic/usecases/location_usecase.dart';
import 'package:map/business_logic/usecases/map_usecase.dart';
import 'package:map/business_logic/viewstate.dart';

class MapController extends GetxController {
  late final MapUseCase _useCase;
  late final LocationUseCase _locationUseCase;

  StreamSubscription? _tripsDataSubscription;
  StreamSubscription? _acceptedTripSubscription;
  StreamSubscription? _locationSubscription;

  Rx<ViewState> viewState = ViewState(
      myLocation: const LatLng(0.0 , 0.0),
      myCurrentCentralLocation: const LatLng(0.0, 0.0),
      tripsData: List.empty(),
      acceptedTripWrapper: AcceptedTripWrapper.init(),
      openedToExploreTrip: const TripData(),
      loading: false,
      error: ""
  ).obs;

  MapController(MapDataSource _dataSource , LocationDataSource locationDataSource){
    _useCase = MapUseCase(_dataSource);
    _locationUseCase = LocationUseCase(locationDataSource);
  }

  listenToTheLocation(){
    _locationSubscription = _locationUseCase.listenToLocation().listen((location) async {
      viewState.value = viewState.value.copy(myLocation: location);
      print("myLocation :"+viewState.value.myLocation.toString());
      print("myCurrentCentralLocation :"+viewState.value.myCurrentCentralLocation.toString());
      print("tripsData :"+viewState.value.tripsData.toString());
      if (viewState.value.acceptedTripWrapper.acceptedTrip.id == null){
        print("get trips");
        // if there is no accepted trip yet then normally listen to the trips
        if (viewState.value.myCurrentCentralLocation.latitude == 0.0){
          print("listen to trips");
          // Check if there is no myCurrentCentralLocation yet
          // which indicates we are initiating the search with the current location
          listenToTrips();
        } else {
          // If there is a myCurrentCentralLocation we calculate the distance between our current location
          // and the central last location and if it is higher than specific distance
          // we update the query of listening to trips
          var distance = _locationUseCase.calculateDistance(viewState.value.myCurrentCentralLocation.latitude, viewState.value.myCurrentCentralLocation.longitude, viewState.value.myLocation.latitude, viewState.value.myLocation.longitude);
          print("distance is "+distance.toString());
          if (distance > AREA_SEARCH_RADIUS){
            listenToTrips();
          }
        }
      } else {
        print("update location");
        // When there is an accepted trip
        // then just listen to it and send constantly the location to server
        updateLocationToAcceptedTrip();

        if (!viewState.value.acceptedTripWrapper.pickedUpTheClient){
          // measure the distance between the driver and pickup location
          // to determine if he has reached or not
          var distance = _locationUseCase.calculateDistance(viewState.value.myLocation.latitude, viewState.value.myLocation.longitude, viewState.value.acceptedTripWrapper.acceptedTrip.pickUpLocation!.latitude, viewState.value.acceptedTripWrapper.acceptedTrip.pickUpLocation!.longitude);
          distance = distance * 1000;

          print("pickup location "+ distance.toString());
          if (distance <= MINIMUM_CLOSE_DISTANCE){

            viewState.value = viewState.value.copy(acceptedTripWrapper: viewState.value.acceptedTripWrapper.copy(reachedPickUpLocation: true));
          }
        } else {
          // Measure the distance between the driver and the drop off location
          var distance = _locationUseCase.calculateDistance(viewState.value.myLocation.latitude, viewState.value.myLocation.longitude, viewState.value.acceptedTripWrapper.acceptedTrip.dropOffLocation!.latitude, viewState.value.acceptedTripWrapper.acceptedTrip.dropOffLocation!.longitude);
          distance = distance * 1000;

          if (distance <= MINIMUM_CLOSE_DISTANCE){

            // End the trip when we reach the drop off location
            viewState.value = await _useCase.endTrip(viewState.value);
            // cancel accepted trip stream subscription
            _acceptedTripSubscription!.cancel();

          }
        }



      }
    });
  }

  listenToTrips(){
    if (_tripsDataSubscription != null){
      _tripsDataSubscription!.cancel();
    }
    _tripsDataSubscription = _useCase.listenToTheAvailableTrips(viewState).listen((viewState) {
      this.viewState.value = viewState;
    });
  }

  openTripToExplore(TripData tripData){
    viewState.value = viewState.value.copy(openedToExploreTrip: tripData);

    print("koko open up : "+viewState.value.openedToExploreTrip.toString());
  }

  acceptTrip() async {
    viewState.value = viewState.value.copy(loading: true);
    viewState.value = await _useCase.acceptAtrip(viewState.value.openedToExploreTrip, viewState.value);
    _tripsDataSubscription!.cancel();
    print("koko map controller acceptTrip : "+viewState.value.acceptedTripWrapper.acceptedTrip.id.toString());
    print("koko map controller acceptTrip : "+viewState.value.openedToExploreTrip.id.toString());

    _listenToAcceptedTrip();
    _setDirectionRoute();
  }

  _listenToAcceptedTrip(){
    if (_acceptedTripSubscription != null){
      _acceptedTripSubscription!.cancel();
    }
    _acceptedTripSubscription = _useCase.listenToAcceptedTrip(viewState.value).listen((newState) {
      viewState.value = newState;
    });
  }

  updateLocationToAcceptedTrip() async {
    var s = await _useCase.updateMyCurrentLocationForAcceptedTrip(viewState.value);
    if (s.error.isNotEmpty){
      viewState.value = s;
    }

  }

  cancelTrip() async {
    viewState.value = await _useCase.cancelTrip(viewState.value);

    _acceptedTripSubscription!.cancel();
    listenToTrips();
  }

  pickUpTheClient() async {
    if (!viewState.value.acceptedTripWrapper.reachedPickUpLocation){
      return;
    }
    viewState.value = await _useCase.pickUpTheClient(viewState.value);
  }

  endTrip(){
    if (!viewState.value.acceptedTripWrapper.pickedUpTheClient){
      return;
    }

    viewState.value = viewState.value.copy(acceptedTripWrapper: AcceptedTripWrapper.init() , openedToExploreTrip: const TripData());
    listenToTrips();
  }

  _setDirectionRoute() async{
    viewState.value = viewState.value.copy(loading: true);
    viewState.value = await _useCase.getRouteToPickUpLocation(viewState.value);
  }

  setTheAcceptedTrip(TripData tripData) async {

    print("set trip "+tripData.toString());

    viewState.value = viewState.value.copy(
        myLocation: LatLng(tripData.driverLocation!.latitude!, tripData.driverLocation!.longitude!),
        acceptedTripWrapper: viewState.value.acceptedTripWrapper.copy(
            acceptedTrip: tripData,
            pickedUpTheClient: tripData.tripState! != TripStates.driverNotHere
        ),
        openedToExploreTrip: tripData
    );

    if (tripData.tripState! == TripStates.driverNotHere){
      _setDirectionRoute();
    }

  }

  @override
  void onClose() {
    if (_tripsDataSubscription != null){
      _tripsDataSubscription!.cancel();
    }
    if (_locationSubscription != null){
      _locationSubscription!.cancel();
    }
    if (_acceptedTripSubscription != null){
      _acceptedTripSubscription!.cancel();
    }
    viewState.close();
    super.onClose();
  }

}