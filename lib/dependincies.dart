import 'package:deliver_me_driver/data/map/location_datasource.dart';
import 'package:deliver_me_driver/data/map/map_datasource.dart';
import 'package:get/get.dart';
import 'package:map/business_logic/controller.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/data/location_datasource.dart';
import 'package:map/business_logic/usecases/location_usecase.dart';

inject(){
  Get.put<MapDataSource>(MapDataSourceImp());
  Get.put<LocationDataSource>(LocationDataSourceImp());
  Get.put(MapController(Get.find() , Get.find()));
}