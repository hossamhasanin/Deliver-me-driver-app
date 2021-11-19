import 'package:auth/business_logic/login/controller.dart';
import 'package:auth/business_logic/login/login_datasource.dart';
import 'package:auth/business_logic/signup/fill_account_data/controller.dart';
import 'package:auth/business_logic/signup/register/register_controller.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:deliver_me_driver/data/auth/login/login_datasource_imp.dart';
import 'package:deliver_me_driver/data/auth/signup/sign_up_datasource_imp.dart';
import 'package:deliver_me_driver/data/map/location_datasource.dart';
import 'package:deliver_me_driver/data/map/map_datasource.dart';
import 'package:deliver_me_driver/data/splash/splash_datasource_imp.dart';
import 'package:deliver_me_driver/data/user/user_datasorce_imp.dart';
import 'package:deliver_me_driver/data/user/user_datasource.dart';
import 'package:get/get.dart';
import 'package:map/business_logic/controller.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/data/location_datasource.dart';
import 'package:splash/business_logic/controller.dart';
import 'package:splash/business_logic/splash_datasource.dart';

inject(){
  Get.put<UserDataSource>(UserDataSourceImp());
  Get.put<MapDataSource>(MapDataSourceImp(Get.find()));
  Get.put<LocationDataSource>(LocationDataSourceImp());
  Get.put<SplashDataSource>(SplashDataSourceImp(Get.find()));
  Get.put<LoginDataSource>(LoginDataSourceImp());
  Get.put<SignupDataSource>(SignUpDataSourceImp());
  Get.put(SplashController(Get.find()));
  Get.put(MapController(Get.find() , Get.find()));
  Get.put(LoginController(Get.find()));
  Get.put(RegisterController(Get.find()));
  Get.put(FillAccountDataController(Get.find()));
}