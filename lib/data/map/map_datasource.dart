import 'dart:convert';

import 'package:base/base.dart';
import 'package:base/models/location.dart';
import 'package:base/models/trip_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_me_driver/data/user/user_datasource.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:base/collections.dart';
import 'package:http/http.dart' as http;



class MapDataSourceImp extends MapDataSource {

  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;
  final UserDataSource _userDataSource;

  MapDataSourceImp(this._userDataSource);

  @override
  Stream<List<TripData>> listenToRequestedTrips(Location location, {double
  radius = AREA_SEARCH_RADIUS}) {
    GeoFirePoint driverLocation = geo.point(latitude: location.latitude!, longitude: location.longitude!);

    // get the collection reference or query
    var collectionReference = _firestore.collection(ASSIGN_CAR).where("tripState" , isEqualTo: TripStates.noDriverAssigned.index);

    String field = 'pickUpLocationMap';


    Stream<List<DocumentSnapshot<Map<String , dynamic>>>> stream = geo.collection(collectionRef: collectionReference)
        .within(center: driverLocation, radius: radius, field: field);

    return stream.map((documents) {
      print("trips data : "+documents.length.toString());
      return documents.map((doc) => TripData.fromDocument(doc.data()!, (geoPoint) {
        return Location(latitude: (geoPoint as GeoPoint).latitude, longitude: geoPoint.longitude);
      })).toList();
    });

  }

  @override
  Future acceptTheTrip(TripData trip, Location location) async {
    var query = _firestore.collection(ASSIGN_CAR).doc(trip.id);
    GeoFirePoint driverLocation = geo.point(latitude: location.latitude!, longitude: location.longitude!);

    var user = await _userDataSource.userData().last;

    return query.update({
      "driverLocation" : driverLocation.data,
      "driverId": user.id,
      "driverName": user.name,
      "driverEmail" : user.email,
      "driverPhone" : user.phone,
      "driverImg": user.img,
      "tripState": TripStates.driverNotHere.index
    });

  }

  @override
  Stream<TripData?> listenToAcceptedTrip(String tripId) {
    DocumentReference<Map<String, dynamic>> query = _firestore.collection(ASSIGN_CAR).doc(tripId);
    return query.snapshots().map((snapshot) {
      if (snapshot.exists){

        return TripData.fromDocument(snapshot.data()!, (geoPoint) {
          return Location(latitude: (geoPoint as GeoPoint).latitude, longitude: geoPoint.longitude);
        });
      } else {
        return null;
      }
    });
  }

  @override
  Future updateAcceptedTripLocation(Location location , String tripId) {
    DocumentReference<Map<String, dynamic>> query = _firestore.collection(ASSIGN_CAR).doc(tripId);

    return query.update({"driverLocation" : GeoPoint(location.latitude! , location.longitude!)});
  }

  @override
  Future updateTripState(TripStates tripState , String tripId) {
    DocumentReference<Map<String, dynamic>> query = _firestore.collection(ASSIGN_CAR).doc(tripId);

    return query.update({"tripState" : tripState.index});
  }

  @override
  Future<Direction> getDirectionRoute(Location initialLocation, Location destinationLocation) async {
    final endpoint ="https://maps.googleapis.com/maps/api/directions/json?origin=${initialLocation.latitude},${initialLocation.longitude}&destination=${destinationLocation.latitude},${destinationLocation.longitude}&key=$mapApiKey";

    final response = jsonDecode((await http.get(Uri.parse(endpoint),)).body);

    return Direction(
    distanceText: response['routes'][0]['legs'][0]['distance']['text'],
    durationText: response['routes'][0]['legs'][0]['duration']['text'],
    distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
    durationValue: response['routes'][0]['legs'][0]['duration']['value'],
    encodedDirections: response['routes'][0]['overview_polyline']['points']
    );
  }




}