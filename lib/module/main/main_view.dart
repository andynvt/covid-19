import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid/model/model.dart';
import 'package:covid/module/module.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/util/util.dart';
import 'package:flutter/cupertino.dart';
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

  void _selectCountryClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => createSelectCountry()))
        .then((info) {
      if (info is CountryInfo) {
        final model = Provider.of<MainModel>(context, listen: false);
        model.logic.updateCountry(info);
      }
    });
  }

  void _menuItemClick() {}

  void _statisticClick(TypeEnum type) {}

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Cl.white,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 56,
                  child: Text(
                    'COVID-19',
                    style: Style.ts_0,
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
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Cl.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Cl.black),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text('Covid-19', style: Style.ts_1),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh, color: Cl.black),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 1, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => model.logic.selectGlobal(),
                  child: Image.asset(
                    Id.ic_world,
                    width: 45,
                    color: model.isGlobal ? Cl.lightBlue : Cl.brownGrey,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlineButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: _selectCountryClick,
                      borderSide: BorderSide(color: Cl.brownGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: <Widget>[
                          !model.isGlobal
                              ? Hero(
                                  tag: 'flag-${model.myCountry.id}',
                                  child: Image.asset(
                                    Id.getIdByCountry(model.myCountry),
                                    width: 40,
                                  ),
                                )
                              : Container(),
                          SizedBox(width: 16),
                          !model.isGlobal
                              ? Hero(
                                  tag: 'name-${model.myCountry.id}',
                                  child: Material(
                                    child: Text(
                                      model.myCountry.name,
                                      style: Style.ts_16_black,
                                    ),
                                  ),
                                )
                              : Text('Global', style: Style.ts_16_black),
                          Spacer(),
                          Container(width: 1, color: Cl.brownGrey, height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.chevron_right,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 240,
                    child: _renderPieChart(),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: <Widget>[
                      _renderStatisticItem(TypeEnum.CONFIRMED, 244553, 4455),
                      _renderStatisticItem(TypeEnum.RECOVERED, 244553, 4455),
                      _renderStatisticItem(TypeEnum.DEATH, 244553, 4455),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              _renderBoxInfo(TypeEnum.CASE_TODAY, 244553),
              _renderBoxInfo(TypeEnum.DEATH_TODAY, 244553),
              _renderBoxInfo(TypeEnum.CRITICAL, 244553),
            ],
          ),
          _renderChart(),
        ],
      ),
    );
  }

  Widget _renderStatisticItem(TypeEnum type, int number, int variability) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: typeEnumToColor(type)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 12),
              Container(
                width: 10,
                height: 40,
                decoration: BoxDecoration(
                  color: typeEnumToColor(type),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(typeEnumToStr(type), style: Style.ts_9),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '${TTString.shared().format(number)}',
                        style: typeEnumToStyle(type),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset(
                  Id.ic_arrow_right,
                  height: 10,
                  color: Cl.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderDrawerItem(IconData icon, String text) {
    return ListTile(
      onTap: () => _menuItemClick,
      leading: Icon(icon, color: Cl.white),
      title: Text(text, style: Style.ts_3),
    );
  }

  Widget _renderBoxInfo(TypeEnum type, int number) {
    return Expanded(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(typeEnumToStr(type), style: Style.ts_9),
              SizedBox(height: 8),
              Text(
                '${TTString.shared().format(number)}',
                style: typeEnumToStyle(type),
              ),
            ],
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

  Widget _renderPieChart() {
    final data = [
      GaugeSegment(100, Cl.lightBlue),
      GaugeSegment(75, Cl.shamrockGreen),
      GaugeSegment(50, Cl.rustyRed),
    ];

    final series = [
      charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.size.toString(),
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment segment, _) => segment.color,
        data: data,
      )
    ];
    return charts.PieChart(
      series,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
          ),
        ],
      ),
    );
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class GaugeSegment {
  final int size;
  final charts.Color color;

  GaugeSegment(this.size, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
