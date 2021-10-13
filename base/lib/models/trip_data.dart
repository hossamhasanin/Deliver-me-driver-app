import 'package:base/models/location.dart';
import 'package:base/models/trip_states.dart';
import 'package:base/models/user.dart';
import 'package:equatable/equatable.dart';

class TripData extends Equatable {
  final String? id;
  final String? destinationAddress;
  final String? pickUpAddress;
  final Location? pickUpLocation;
  final Location? dropOffLocation;
  final Location? driverLocation;
  final User? driverPersonalData;
  final User? clintPersonalData;
  final TripStates? tripState;

  const TripData(
      {this.id,
       this.destinationAddress,
       this.pickUpAddress,
       this.pickUpLocation,
       this.dropOffLocation,
       this.driverLocation,
       this.driverPersonalData,
       this.clintPersonalData,
       this.tripState});


  @override
  List<Object?> get props => [
    id,
    destinationAddress,
    pickUpAddress,
    pickUpLocation,
    dropOffLocation,
    driverLocation,
    driverPersonalData,
    tripState
  ];

  static TripData fromDocument(Map<String , dynamic> doc , Location Function(Object) geoPointToLocationAdapterFunction){
    return TripData(
        id: doc["id"],
        destinationAddress: doc["destinationAddress"],
        pickUpAddress: doc["pickUpAddress"],
        pickUpLocation: geoPointToLocationAdapterFunction(doc["pickUpLocationMap"]["geopoint"]),
        dropOffLocation: geoPointToLocationAdapterFunction(doc["dropOffLocation"]),
        driverLocation: null,
        driverPersonalData: null,
        clintPersonalData: User(
            id: doc["clientId"],
            name: doc["clientName"],
            email: doc["clientEmail"],
            phone: doc["clientPhone"],
            img: doc["clientImg"]),
        tripState: TripStates.values[doc["tripState"]]);
  }


}