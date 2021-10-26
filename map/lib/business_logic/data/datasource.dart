import 'package:base/base.dart';

abstract class MapDataSource{
  Stream<List<TripData>> listenToRequestedTrips(Location location);

  Future acceptTheTrip(TripData trip , Location location);

  Future updateAcceptedTripLocation(Location location , String tripId);

  Stream<TripData?> listenToAcceptedTrip(String tripId);

  Future updateTripState(TripStates tripState , String tripId);

  Future<Direction> getDirectionRoute(Location initialLocation , Location destinationLocation);
}