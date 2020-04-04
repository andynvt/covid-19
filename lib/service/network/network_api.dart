class NetworkAPI {
  NetworkAPI._();

  static const NOVEL = 'https://corona.lmao.ninja';

  static const GET_GLOBAL = '$NOVEL/all';
  static const GET_COUNTRIES = '$NOVEL/countries';
  static const GET_HISTORICAL = '$NOVEL/v2/historical/all';

  static const GET_MAP = '$NOVEL/jhucsse';

  static const GET_NEWS = 'https://thevirustracker.com/free-api';

  static String getHistoricalByName(String country) {
    return '$NOVEL/v2/historical/$country';
  }

  static String getNewsByPage(int page) {
    return 'https://newsapi.org/v2/everything?q=covid&sortBy=publishedAt&language=en&pageSize=20&page=$page&apiKey=baf9798fd0c54452a42800b12f20e2f0';
  }

}