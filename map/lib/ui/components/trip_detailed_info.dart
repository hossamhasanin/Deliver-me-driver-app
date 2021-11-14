import 'package:base/base.dart';
import 'package:flutter/material.dart';

class TripDetailedInfo extends StatelessWidget {

  final TripData tripData;
  final Function() acceptTripAction;
  final Function() cancel;

  const TripDetailedInfo({required this.tripData , required this.acceptTripAction , required this.cancel});

  @override
  Widget build(BuildContext context) {
    return tripData.clintPersonalData != null ? SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(tripData.clintPersonalData!.img!),
                      radius: 25.0,
                    ),
                    const SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tripData.clintPersonalData!.name!,
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 8.0,),
                          Text(
                            "Take me from : "+ tripData.pickUpAddress!,
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ),
              Positioned(
                child: IconButton(
                  onPressed: (){
                    cancel();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
                top: -5.0,
                left: -5.0,
              ),
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
