import 'package:base/base.dart';
import 'package:flutter/material.dart';

class TripDetailedInfo extends StatelessWidget {

  final TripData tripData;
  final Function() acceptTripAction;

  const TripDetailedInfo({required this.tripData , required this.acceptTripAction});

  @override
  Widget build(BuildContext context) {
    return tripData.clintPersonalData != null ? SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(tripData.clintPersonalData!.img!),
              ),
              const SizedBox(width: 10.0,),
              Text(tripData.clintPersonalData!.name!)
            ],
          ),
          ElevatedButton(
              onPressed: (){
                acceptTripAction();
              },
              child: const Text("Accept")
          )
        ],
      ),
    ) : Container();
  }
}
