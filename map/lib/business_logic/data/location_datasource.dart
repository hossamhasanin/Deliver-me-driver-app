import 'package:base/base.dart';

abstract class LocationDataSource{
  Stream<Location> listenToCurrentLocation();
}