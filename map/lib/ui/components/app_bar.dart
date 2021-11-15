import 'package:base/models/trip_states.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:map/business_logic/controller.dart';

class MapAppBar extends StatelessWidget {
  final MapController _controller = Get.find();

  MapAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8)
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon:const Icon(Icons.menu , color: Colors.white,)
          ),
          const SizedBox(width: 20.0,),
          const Text(
            "Welcome driver",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}