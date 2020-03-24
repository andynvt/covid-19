class NetworkAPI {
  NetworkAPI._();

  static const NOVEL = 'https://corona.lmao.ninja';

  static const GET_COUNTRIES = '$NOVEL/countries';

  static const GET_WORLD = '$NOVEL/all';
  static const GET_MAP = '$NOVEL/jhucsse';

  static String getCountryByName(String country) {
    return '$GET_COUNTRIES/$country';
  }

}