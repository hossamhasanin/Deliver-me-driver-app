import 'package:base/base.dart';

abstract class MapDataSource{
  Stream<List<TripData>> listenToRequestedTrips(Location location);

  Future acceptTheTrip(TripData trip , Location location);
}