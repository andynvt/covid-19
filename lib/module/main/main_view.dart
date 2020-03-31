import 'dart:ui';
import 'package:covid/model/model.dart';
import 'package:covid/module/module.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
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
    final isGlobal = model.isGlobal;
    final globalInfo = model.globalInfo;

    return Scaffold(
      backgroundColor: Cl.white,
      key: _scaffoldKey,
      drawer: _renderDrawer(),
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
                    color: isGlobal ? Cl.lightBlue : Cl.brownGrey,
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
                          !isGlobal
                              ? Hero(
                            tag: 'flag-${model.myCountry.id}',
                            child: Image.asset(
                              Id.getIdByCountry(model.myCountry),
                              width: 40,
                            ),
                          )
                              : Container(),
                          SizedBox(width: 16),
                          !isGlobal
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
                      _renderStatisticItem(
                        TypeEnum.CONFIRMED,
                        isGlobal ? globalInfo.cases : model.myCountry.cases,
                      ),
                      _renderStatisticItem(
                        TypeEnum.RECOVERED,
                        isGlobal
                            ? globalInfo.recovered
                            : model.myCountry.recovered,
                      ),
                      _renderStatisticItem(
                        TypeEnum.DEATH,
                        isGlobal ? globalInfo.deaths : model.myCountry.deaths,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 12),
          !isGlobal
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Row(
              children: <Widget>[
                _renderBoxInfo(
                  TypeEnum.CASE_TODAY,
                  model.myCountry.todayCases,
                ),
                _renderBoxInfo(
                  TypeEnum.DEATH_TODAY,
                  model.myCountry.todayDeaths,
                ),
                _renderBoxInfo(
                  TypeEnum.CRITICAL,
                  model.myCountry.critical,
                ),
              ],
            ),
          )
              : Container(),
          _renderAreaChart(),
        ],
      ),
    );
  }

  Widget _renderPieChart() {
    return Echarts(
        option: '''
        {
          tooltip: {
              trigger: 'item',
              formatter: '{d}%'
          },
          color: ['#9fdcba','#fd5047', '#17C5FA'],
          series: [
              {
                  type: 'pie',
                  selectedMode: 'single',
                  labelLine: {
                      show: false
                  },
                  label: {
                      show: false
                  },
                  data: [
                      {value: 335, name: 'item 0'},
                      {value: 310, name: 'item 1'},
                      {value: 234, name: 'ietm 2'},
                  ],
                  emphasis: {
                      itemStyle: {
                          shadowBlur: 10,
                          shadowOffsetX: 0,
                          shadowColor: 'rgba(0, 0, 0, 0.5)'
                      }
                  }
              }
          ]
        }
        ''',
        extraScript: '''
        document.getElementsByTagName("body")[0].style = 'position: fixed';
        ''',
    );
  }

  Widget _renderStatisticItem(TypeEnum type, int number) {
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
                    Text(typeEnumToStr(type), style: typeEnumToStyle(type)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '${TTString.shared().format(number ?? 0)}',
                        style: Style.ts_13,
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

  Widget _renderBoxInfo(TypeEnum type, int number) {
    return Expanded(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(typeEnumToStr(type), style: typeEnumToStyle(type)),
              SizedBox(height: 8),
              Text(
                '${TTString.shared().format(number)}',
                style: Style.ts_9,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderAreaChart() {
    return Expanded(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Echarts(
            option: '''
              {
                title: {
                    text: 'Case in week'
                },
                color: ['#9fdcba','#fd5047', '#17C5FA','#003ab2',],
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'cross',
                        label: {
                            backgroundColor: '#6a7985'
                        }
                    }
                },
                legend: {
                    data: ['name 1', 'name 2', 'name 3', 'name 4'],
                    top: 30,
                },
                
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    y: 80,
                    containLabel: true
                },
                xAxis: [
                    {
                        type: 'category',
                        boundaryGap: false,
                        data: ['1 oct', '2 oct', '3 oct', '4 oct', '5 oct', '6 oct']
                    }
                ],
                yAxis: [
                    {
                        type: 'value'
                    }
                ],
                series: [
                    {
                        name: 'name 1',
                        type: 'line',
                        stack: '1',
                        areaStyle: {},
                        data: [120, 132, 101, 134, 230, 210]
                    },
                    {
                        name: 'name 2',
                        type: 'line',
                        stack: '1',
                        areaStyle: {},
                        data: [220, 182, 191, 234, 330, 310]
                    },
                     {
                        name: 'name 3',
                        type: 'line',
                        stack: '1',
                        areaStyle: {},
                        data: [330, 100, 200, 300, 400, 500]
                    },
                    {
                        name: 'name 4',
                        type: 'line',
                        stack: '2',
                        label: {
                            normal: {
                                show: true,
                                position: 'top'
                            }
                        },
                        // areaStyle: {},
                        data: [670, 414, 492, 668, 960, 1020]
                    }
                ]
            }
            ''',
            extraScript: '''
            document.getElementsByTagName("body")[0].style = 'position: fixed;';
            ''',
          ),
        ),
      ),
    );
  }

  Widget _renderDrawer() {
    return Drawer(
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
    );
  }

  Widget _renderDrawerItem(IconData icon, String text) {
    return ListTile(
      onTap: () => _menuItemClick,
      leading: Icon(icon, color: Cl.white),
      title: Text(text, style: Style.ts_3),
    );
  }
}