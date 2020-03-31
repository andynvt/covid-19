class NetworkAPI {
  NetworkAPI._();

  static const NOVEL = 'https://corona.lmao.ninja';

  static const GET_GLOBAL = '$NOVEL/all';
  static const GET_COUNTRIES = '$NOVEL/countries';
  static const GET_HISTORICAL = '$NOVEL/v2/historical/all';

  static const GET_MAP = '$NOVEL/jhucsse';

  static String getHistoricalByName(String country) {
    return '$NOVEL/v2/historical/$country';
  }

}