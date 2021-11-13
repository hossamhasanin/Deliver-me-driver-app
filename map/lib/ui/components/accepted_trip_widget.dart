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
    return acceptedTrip.acceptedTrip.id != null ? SingleChildScrollView(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(acceptedTrip.acceptedTrip.clintPersonalData!.img!),
                    radius: 25.0,
                  ),
                  const SizedBox(width: 10.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            acceptedTrip.acceptedTrip.clintPersonalData!.name!,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                        const SizedBox(height: 8.0,),
                        Text(
                          !acceptedTrip.reachedPickUpLocation ?
                          acceptedTrip.acceptedTrip.pickUpAddress! : acceptedTrip.acceptedTrip.destinationAddress!,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
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
      ),
    ) : Container();
  }
}
