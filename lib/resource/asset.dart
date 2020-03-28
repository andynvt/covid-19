
import 'package:covid/model/model.dart';

class Id {
  Id._();
  static String getIdByCountry(CountryInfo info) {
    var name = info.code == null ? info.name : info.code;
    if(name.contains(' ')) {
      name = name.replaceAll(' ', '_');
    }
    if(name == 'Curaçao') {
      name = 'Curacao';
    }
    return "assets/images/flag/$name.png";
  }

  static const String unknown = "assets/images/flag/Unknown.png";
  static const String ic_vn = "assets/images/flag/VN.png";

  static const String ic_arrow_down = "assets/images/ic_arrow_down.png";
  static const String ic_arrow_right = "assets/images/ic_arrow_right.png";
  static const String ic_death = "assets/images/ic_death.png";
  static const String ic_gps = "assets/images/ic_gps.png";
  static const String ic_virus = "assets/images/ic_virus.png";
  static const String ic_world = "assets/images/ic_world.png";
}
