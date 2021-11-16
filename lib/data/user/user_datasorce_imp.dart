import 'package:base/models/user.dart';
import 'package:deliver_me_driver/data/user/user_datasource.dart';

class UserDataSourceImp extends UserDataSource{
  @override
  Stream<User?> userData() {
    // return Stream.value(User(
    //     id: "kokoDriver1",
    //     name: "kokoDriver",
    //     email: "kokoDriver@koko.com",
    //     phone: "123456789",
    //     img: "https://www.volvotrucks.com/content/dam/volvo-trucks/markets/master/home/services-updates/driver-support/driver-development/driver-support-steering-wheel.jpg"
    // )).asBroadcastStream();
    return Stream.value(null).asBroadcastStream();
  }

}