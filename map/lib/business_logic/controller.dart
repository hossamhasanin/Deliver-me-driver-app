import 'dart:async';

import 'package:base/base.dart';
import 'package:base/models/trip_data.dart';
import 'package:get/get.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/data/location_datasource.dart';
import 'package:map/business_logic/usecases/location_usecase.dart';
import 'package:map/business_logic/usecases/map_usecase.dart';
import 'package:map/business_logic/viewstate.dart';

class MapController extends GetxController {
  late final MapUseCase _useCase;
  late final LocationUseCase _locationUseCase;

  StreamSubscription? _tripsDataSubscription;
  StreamSubscription? _locationSubscription;

  Rx<ViewState> viewState = ViewState(
      myLocation: null,
      myCurrentCentralLocation: null,
      tripsData: List.empty(),
      acceptedTrip: const TripData(),
      loading: false,
      error: ""
  ).obs;

  MapController(MapDataSource _dataSource , LocationDataSource locationDataSource){
    _useCase = MapUseCase(_dataSource);
    _locationUseCase = LocationUseCase(locationDataSource);
  }

  listenToTheLocation(){
    _locationSubscription = _locationUseCase.listenToLocation().listen((location) {
      viewState.value = viewState.value.copy(myLocation: location);
      print("myCurrentCentralLocation :"+viewState.value.myCurrentCentralLocation.toString());
      print("tripsData :"+viewState.value.tripsData.toString());
      if (viewState.value.myCurrentCentralLocation == null){
        // Check if there is no myCurrentCentralLocation yet
        // which indicates we are initiating the search with the current location
        listenToTrips();
      } else {
        // If there is a myCurrentCentralLocation we calculate the distance between our current location
        // and the central last location and if it is higher than specific distance
        // we update the query of listening to trips
        var distance = _locationUseCase.calculateDistance(viewState.value.myCurrentCentralLocation!.latitude, viewState.value.myCurrentCentralLocation!.longitude, viewState.value.myLocation!.latitude, viewState.value.myLocation!.longitude);
        print("distance is "+distance.toString());
        if (distance > AREA_SEARCH_RADIUS){
          listenToTrips();
        }
      }

    });
  }

  listenToTrips(){
    if (_tripsDataSubscription != null){
      _tripsDataSubscription!.cancel();
    }
    _tripsDataSubscription = _useCase.listenToTheAvailableTrips(viewState.value).listen((viewState) {
      this.viewState.value = viewState;
    });
  }

  @override
  void onClose() {
    if (_tripsDataSubscription != null){
      _tripsDataSubscription!.cancel();
    }
    if (_locationSubscription != null){
      _locationSubscription!.cancel();
    }
    viewState.close();
    super.onClose();
  }

}