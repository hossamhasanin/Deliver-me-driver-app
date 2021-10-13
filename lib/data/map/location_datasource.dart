import 'package:base/models/location.dart';
import 'package:map/business_logic/data/location_datasource.dart';
import 'package:geolocator/geolocator.dart';

class LocationDataSourceImp extends LocationDataSource {
  @override
  Stream<Location> listenToCurrentLocation() {
    return Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 10).map(
            (Position position) {
          return Location(latitude: position.latitude,longitude: position.longitude);
        });
  }

}