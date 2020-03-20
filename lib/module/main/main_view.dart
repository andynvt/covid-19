import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_model.dart';

ChangeNotifierProvider<MainModel> createMain() {
  return ChangeNotifierProvider(
    create: (_) => MainModel(),
    child: _MainView(),
  );
}

class _MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _menuItemClick() {}

  void _statisticClick(typeEnum type) {}

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Cl.mIndigo,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 56,
                  child: Text(
                    'COVID-19',
                    style: Style.s_01,
                  ),
                ),
                Divider(color: Cl.white),
                _renderDrawerItem(Icons.library_books, 'NEWS'),
                _renderDrawerItem(Icons.info, 'INFO'),
                _renderDrawerItem(Icons.help, 'SUPPORT'),
                _renderDrawerItem(Icons.phone, 'EMERGENCY CALL'),
                _renderDrawerItem(Icons.local_hospital, 'FIND HOSPITAL'),
                Divider(color: Cl.white),
                _renderDrawerItem(Icons.live_help, 'FAQ'),
                _renderDrawerItem(Icons.tag_faces, 'FUNNY MEME'),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Cl.mIndigo,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text('HOME', style: Style.s_02),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 4),
          Row(
            children: <Widget>[
              SizedBox(width: 4),
              _renderBoxInfo(typeEnum.CONFIRMED, 244553, variability: 15062),
              SizedBox(width: 4),
              _renderBoxInfo(typeEnum.RECOVERED, 244553, variability: -15),
              SizedBox(width: 4),
              _renderBoxInfo(typeEnum.DEATH, 244553, variability: 150),
              SizedBox(width: 4),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: <Widget>[
              SizedBox(width: 4),
              _renderBoxInfo(typeEnum.CASE_TODAY, 244553),
              SizedBox(width: 4),
              _renderBoxInfo(typeEnum.CRITICAL, 244553),
              SizedBox(width: 4),
              _renderBoxInfo(typeEnum.DEATH_TODAY, 244553),
              SizedBox(width: 4),
            ],
          ),
          _renderChart(),
        ],
      ),
    );
  }

  Widget _renderDrawerItem(IconData icon, String text) {
    return ListTile(
      onTap: _menuItemClick,
      leading: Icon(icon, color: Cl.white),
      title: Text(text, style: Style.s_07),
    );
  }

  Widget _renderBoxInfo(typeEnum type, int number, {int variability = 0}) {
    var color = Cl.white;
    var text = '';
    switch (type) {
      case typeEnum.CONFIRMED:
        color = Cl.mBlue;
        text = 'Confirmed';
        break;
      case typeEnum.RECOVERED:
        color = Cl.mGreen;
        text = 'Recovered';
        break;
      case typeEnum.DEATH:
        color = Cl.mRed;
        text = 'Deaths';
        break;
      case typeEnum.CRITICAL:
        color = Cl.mBlueGrey;
        text = 'Critical';
        break;
      case typeEnum.CASE_TODAY:
        color = Cl.mBlueGrey;
        text = 'Case today';
        break;
      case typeEnum.DEATH_TODAY:
        color = Cl.mBlueGrey;
        text = 'Death today';
        break;
    }

    return Expanded(
      child: InkWell(
        onTap: () => _statisticClick(type),
        child: Card(
          color: color,
          elevation: 3,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(text, style: Style.s_03),
                SizedBox(height: 8),
                Text('$number', style: Style.s_02),
                SizedBox(height: variability != 0 ? 8 : 0),
                variability != 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_upward,
                            size: 15,
                            color: Cl.white,
                          ),
                          Text('${variability.abs()}', style: Style.s_03),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderChart() {
    final myFakeDesktopData = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    var myFakeTabletData = [
      new LinearSales(0, 10),
      new LinearSales(1, 50),
      new LinearSales(2, 200),
      new LinearSales(3, 150),
    ];

    var myFakeMobileData = [
      new LinearSales(0, 15),
      new LinearSales(1, 75),
      new LinearSales(2, 80),
      new LinearSales(3, 225),
    ];

    final series = [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeDesktopData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeTabletData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeMobileData,
      ),
    ];

    return Expanded(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: charts.LineChart(
            series,
            defaultRenderer:
                charts.LineRendererConfig(includeArea: true, stacked: true),
            animate: true,
            behaviors: [
              charts.ChartTitle('Day',
                  behaviorPosition: charts.BehaviorPosition.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
