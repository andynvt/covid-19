class GlobalInfo {
  int cases;
  int deaths;
  int recovered;
  int updated;
  int active;

  GlobalInfo(
      {this.cases, this.deaths, this.recovered, this.updated, this.active});

  factory GlobalInfo.fromJson(Map<String, dynamic> json) {
    return GlobalInfo(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
      updated: json['updated'],
      active: json['active'],
    );
  }
}
