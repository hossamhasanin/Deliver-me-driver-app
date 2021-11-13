import 'package:deliver_me_driver/data/map/location_datasource.dart';
import 'package:deliver_me_driver/data/map/map_datasource.dart';
import 'package:deliver_me_driver/data/splash/splash_datasource_imp.dart';
import 'package:deliver_me_driver/data/user/user_datasorce_imp.dart';
import 'package:deliver_me_driver/data/user/user_datasource.dart';
import 'package:get/get.dart';
import 'package:map/business_logic/controller.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/data/location_datasource.dart';
import 'package:map/business_logic/usecases/location_usecase.dart';
import 'package:splash/business_logic/controller.dart';
import 'package:splash/business_logic/splash_datasource.dart';

inject(){
  Get.put<UserDataSource>(UserDataSourceImp());
  Get.put<MapDataSource>(MapDataSourceImp(Get.find()));
  Get.put<LocationDataSource>(LocationDataSourceImp());
  Get.put<SplashDataSource>(SplashDataSourceImp(Get.find()));
  Get.put(SplashController(Get.find()));
  Get.put(MapController(Get.find() , Get.find()));
}