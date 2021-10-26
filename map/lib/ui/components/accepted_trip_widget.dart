import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:map/business_logic/data/accepted_tip_wrapper.dart';

class AcceptedTrip extends StatelessWidget {

  final AcceptedTripWrapper acceptedTrip;
  final Function() cancelTrip;
  final Function() pickUp;

  const AcceptedTrip({
    required this.acceptedTrip ,
    required this.cancelTrip ,
    required this.pickUp,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(acceptedTrip.acceptedTrip.clintPersonalData!.img!),
              ),
              const SizedBox(width: 10.0,),
              Text(acceptedTrip.acceptedTrip.clintPersonalData!.name!)
            ],
          ),

          acceptedTrip.reachedPickUpLocation ? ElevatedButton(
            onPressed: (){
              pickUp();
            },
            child: const Text("Pick up"),
            style: ElevatedButton.styleFrom(
                primary: Colors.green
            ),
          ) : Container(),

          !acceptedTrip.pickedUpTheClient ? ElevatedButton(
            onPressed: (){
              cancelTrip();
            },
            child: const Text("Cancel trip"),
            style: ElevatedButton.styleFrom(
                primary: Colors.red
            ),
          ) : Container()
        ],
      ),
    );
  }
}
