import 'package:base/base.dart';
import 'package:base/models/trip_data.dart';
import 'package:equatable/equatable.dart';

class AcceptedTripWrapper extends Equatable{

  final TripData acceptedTrip;
  final bool reachedPickUpLocation;
  final bool pickedUpTheClient;
  final bool isTripEnded;
  final Direction destinationToPickUpLocation;

  AcceptedTripWrapper({
    required this.acceptedTrip,
    required this.reachedPickUpLocation,
    required this.pickedUpTheClient,
    required this.isTripEnded,
    required this.destinationToPickUpLocation
  });

  @override
  List<Object?> get props => [
    acceptedTrip ,
    reachedPickUpLocation ,
    pickedUpTheClient,
    isTripEnded,
    destinationToPickUpLocation
  ];

  AcceptedTripWrapper copy({
    TripData? acceptedTrip,
    bool? reachedPickUpLocation,
    bool? pickedUpTheClient,
    bool? isTripEnded,
    Direction? destinationToPickUpLocation
  }){
    return AcceptedTripWrapper(
        acceptedTrip: acceptedTrip ?? this.acceptedTrip,
        reachedPickUpLocation: reachedPickUpLocation ?? this.reachedPickUpLocation,
        pickedUpTheClient: pickedUpTheClient ?? this.pickedUpTheClient,
        isTripEnded: isTripEnded ?? this.isTripEnded,
        destinationToPickUpLocation: destinationToPickUpLocation ?? this.destinationToPickUpLocation
    );
  }


}