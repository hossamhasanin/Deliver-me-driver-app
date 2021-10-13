import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/data/location_datasource.dart';
import 'package:map/business_logic/viewstate.dart';
import 'dart:math';

class LocationUseCase{

  final LocationDataSource _locationDataSource;

  LocationUseCase(this._locationDataSource);


  Stream<LatLng> listenToLocation(){
    return _locationDataSource.listenToCurrentLocation().map((location) {
      return LatLng(location.latitude!, location.longitude!);
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

}