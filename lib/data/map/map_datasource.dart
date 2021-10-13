import 'package:base/base.dart';
import 'package:base/models/location.dart';
import 'package:base/models/trip_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:base/collections.dart';


class MapDataSourceImp extends MapDataSource {

  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;


  @override
  Stream<List<TripData>> listenToRequestedTrips(Location location, {double
  radius = AREA_SEARCH_RADIUS}) {
    GeoFirePoint driverLocation = geo.point(latitude: location.latitude!, longitude: location.longitude!);

    // get the collection reference or query
    var collectionReference = _firestore.collection(ASSIGN_CAR);

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
  Future acceptTheTrip(TripData trip, Location location) {
    throw UnimplementedError();
  }




}