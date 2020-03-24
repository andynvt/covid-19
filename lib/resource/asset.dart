class Id {
  Id._();

  static String getIdByCountry(String country) {
    return "assets/images/flag/$country.png";
  }

  static const String unknown = "assets/images/flag/Unknown.png";
  static const String ic_world = "assets/images/ic_world.png";
}
