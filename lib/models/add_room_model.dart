import 'package:meta/meta.dart';
import 'package:smart_home_app/models/add_device_model.dart';

class AddRoom {
  final String? roomName;
  final List<AddDevice>? rDeviceList;

  const AddRoom({@required this.roomName, @required this.rDeviceList});
}
