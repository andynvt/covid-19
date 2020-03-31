class GlobalInfo {
  int cases;
  int deaths;
  int recovered;
  DateTime updated;
  int active;

  GlobalInfo(
      {this.cases, this.deaths, this.recovered, this.updated, this.active});

  factory GlobalInfo.fromJson(Map<String, dynamic> json) {
    return GlobalInfo(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
      updated: DateTime.fromMillisecondsSinceEpoch(json['updated']),
      active: json['active'],
    );
  }
}
