import 'package:base/models/location.dart';
import 'package:base/models/trip_states.dart';
import 'package:base/models/user.dart';
import 'package:equatable/equatable.dart';

class TripData extends Equatable {
  final String? id;
  final String? destinationAddress;
  final String? pickUpAddress;
  final String? encodedPolyLinePoints;
  final Location? pickUpLocation;
  final Location? dropOffLocation;
  final Location? driverLocation;
  final User? driverPersonalData;
  final User? clintPersonalData;
  final TripStates? tripState;
  final double? cost;
  final String? paymentMethod;

  const TripData(
      {this.id,
       this.destinationAddress,
       this.encodedPolyLinePoints,
       this.pickUpAddress,
       this.pickUpLocation,
       this.dropOffLocation,
       this.driverLocation,
       this.driverPersonalData,
       this.clintPersonalData,
       this.tripState,
       this.cost,
        this.paymentMethod
      });


  @override
  List<Object?> get props => [
    id,
    destinationAddress,
    encodedPolyLinePoints,
    pickUpAddress,
    pickUpLocation,
    dropOffLocation,
    driverLocation,
    driverPersonalData,
    tripState,
    cost,
    paymentMethod
  ];

  static TripData fromDocument(Map<String , dynamic> doc , Location? Function(Object) geoPointToLocationAdapterFunction){
    return TripData(
        id: doc["id"],
        destinationAddress: doc["destinationAddress"],
        pickUpAddress: doc["pickUpAddress"],
        encodedPolyLinePoints: doc["encodedPolyLinePoints"],
        pickUpLocation: geoPointToLocationAdapterFunction(doc["pickUpLocationMap"]["geopoint"]),
        dropOffLocation: geoPointToLocationAdapterFunction(doc["dropOffLocation"]),
        driverLocation:  geoPointToLocationAdapterFunction(doc["driverLocation"]),
        driverPersonalData: User(
            id: doc["driverId"],
            name: doc["driverName"],
            email: doc["driverEmail"],
            phone: doc["driverPhone"],
            img: doc["driverImg"]),
        clintPersonalData: User(
            id: doc["clientId"],
            name: doc["clientName"],
            email: doc["clientEmail"],
            phone: doc["clientPhone"],
            img: doc["clientImg"]),
        tripState: TripStates.values[doc["tripState"]],
        paymentMethod: doc["paymentMethod"],
        cost: double.parse(doc["cost"].toString(),)
    );
  }

  bool equalsTo(TripData tripData){
    return id == tripData.id &&
        cost == tripData.cost &&
        paymentMethod == tripData.paymentMethod &&
        dropOffLocation == tripData.dropOffLocation &&
        tripState == tripData.tripState &&
        pickUpLocation == tripData.pickUpLocation &&
        encodedPolyLinePoints == tripData.encodedPolyLinePoints &&
        clintPersonalData == tripData.clintPersonalData &&
        pickUpAddress == tripData.pickUpAddress &&
        driverPersonalData == tripData.driverPersonalData &&
        destinationAddress == tripData.destinationAddress;
  }


}