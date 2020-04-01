import 'dart:ui';
import 'package:covid/model/model.dart';
import 'package:covid/module/module.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/util/util.dart';
import 'package:covid/widget/widget.dart';
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
  PageController _pageController;

  void _selectCountryClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => createSelectCountry()))
        .then((info) {
      if (info is CountryInfo) {
        final model = Provider.of<MainModel>(context, listen: false);
        model.logic.selectGlobal(false);
        model.logic.updateCountry(info);
      }
    });
  }

  void _menuItemClick() {}

  void _statisticClick(TypeEnum type) {}

  @override
  void initState() {
    _pageController = PageController(keepPage: true, initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainModel>(context);

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
            onPressed: () {
              model.logic.loadData();
            },
            icon: Icon(Icons.refresh, color: Cl.black),
          )
        ],
      ),
      bottomNavigationBar: TTBottomBar(
        selectedIndex: model.pageIndex,
        showElevation: true,
        onItemSelected: (index) {
          model.pageIndex = index;
          model.refresh();
          _pageController.jumpToPage(index);
        },
        items: [
          TTBottomBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Cl.mBlue,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
            activeColor: Cl.mCyan,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Top'),
            activeColor: Cl.shamrockGreen,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.library_books),
            title: Text('News'),
            textAlign: TextAlign.center,
            activeColor: Cl.mRed,
          ),
        ],
      ),
      body: _renderBody(),
    );
  }

  Widget _renderBody() {
    final model = Provider.of<MainModel>(context);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) => model.pageIndex,
      children: <Widget>[
        _renderHomeTab(),
        Container(color: Colors.blue),
        Container(color: Colors.green),
        Container(color: Colors.red),
      ],
    );
  }

  Widget _renderHomeTab() {
    final model = Provider.of<MainModel>(context);
    final isGlobal = model.isGlobal;
    final globalInfo = model.globalInfo;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 1, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => model.logic.selectGlobal(!model.isGlobal),
                child: Image.asset(
                  Id.ic_world,
                  height: 35,
                  color: isGlobal ? Cl.lightBlue : Cl.brownGrey,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 35,
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
                            ? Image.asset(
                                Id.getIdByCountry(model.myCountry),
                                width: 30,
                              )
                            : Container(),
                        SizedBox(width: 16),
                        !isGlobal
                            ? Material(
                                color: Colors.transparent,
                                child: Text(
                                  model.myCountry.name,
                                  style: Style.ts_16_black,
                                ),
                              )
                            : Text('Global', style: Style.ts_16_black),
                        Spacer(),
                        Container(width: 1, color: Cl.brownGrey, height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.chevron_right,
                            size: 25,
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
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Update: ', style: Style.ts_19),
                          globalInfo.updated != null
                              ? TextSpan(
                                  text: TTString.shared()
                                      .formatDate(globalInfo.updated),
                                  style: Style.ts_19_bold,
                                )
                              : TextSpan(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 250,
                    alignment: Alignment.center,
                    child: isGlobal
                        ? _renderPieChart(
                            globalInfo.deaths,
                            globalInfo.recovered,
                            globalInfo.active,
                          )
                        : _renderPieChart(
                            model.myCountry.deaths,
                            model.myCountry.recovered,
                            model.myCountry.active,
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _renderStatisticItem(
                    TypeEnum.TOTAL,
                    isGlobal ? globalInfo.cases : model.myCountry.cases,
                  ),
                  _renderStatisticItem(
                    TypeEnum.ACTIVE,
                    isGlobal ? globalInfo.active : model.myCountry.active,
                  ),
                  _renderStatisticItem(
                    TypeEnum.RECOVERED,
                    isGlobal ? globalInfo.recovered : model.myCountry.recovered,
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
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              _renderBoxInfo(
                TypeEnum.CASE_TODAY,
                isGlobal ? -1 : model.myCountry.todayCases,
              ),
              _renderBoxInfo(
                TypeEnum.DEATH_TODAY,
                isGlobal ? -1 : model.myCountry.todayDeaths,
              ),
              _renderBoxInfo(
                TypeEnum.CRITICAL,
                isGlobal ? -1 : model.myCountry.critical,
              ),
            ],
          ),
        ),
        _renderAreaChart(),
      ],
    );
  }

  Widget _renderPieChart(int a, int b, int c) {
    return Echarts(
      option: '''
      {
        tooltip: {
            trigger: 'item',
            formatter: '{b}<br/>{c}<br/>{d}%'
        },
        color: ['#FA7B74','#9fdcba', '#17C5FA'],
        legend: {
            data: ['Death', 'Recovered', 'Active'],
            top: 10,
        },
        series: [
            {
                type: 'pie',
                radius: '93%',
                top: 40,
                selectedOffset : 5,
                hoverOffset: 0,
                selectedMode: 'single',
                label: {
                   show: false,
                },
                labelLine: {
                    show: false,
                },
                data: [
                    {value: $a, name: 'Death'},
                    {value: $b, name: 'Recovered'},
                    {value: $c, name: 'Active'},
                ],
                emphasis: {
                    itemStyle: {
                        shadowBlur: 3,
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
    final text =
        number == -1 ? '-' : TTString.shared().formatNumber(number ?? 0);
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: typeEnumToColor(type).withOpacity(0.15),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: <Widget>[
              Text(
                text,
                style: typeEnumToStyle(type),
              ),
              SizedBox(height: 4),
              Text(typeEnumToStr(type).toUpperCase(), style: Style.ts_20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderBoxInfo(TypeEnum type, int number) {
    final text =
        number == -1 ? '-' : TTString.shared().formatNumber(number ?? 0);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Cl.grey300),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: typeEnumToStyle(type),
            ),
            SizedBox(height: 4),
            Text(typeEnumToStr(type).toUpperCase(), style: Style.ts_20),
          ],
        ),
      ),
    );
  }

  Widget _renderAreaChart() {
    final model = Provider.of<MainModel>(context);
    final info = model.isGlobal ? model.globalHistorical : model.myHistorical;

    if (info == null || info.cases == null) {
      return Container();
    }
    return Expanded(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Echarts(
            option: '''
              {
                title: {
                    text: 'Montly chart'
                },
                color: ['#FA7B74','#17C5FA','#9fdcba','#003ab2'],
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
                    data: ['Death', 'Recovered', 'Active', 'Cases'],
                    top: 30,
                },
                
                grid: {
                    left: '2%',
                    right: '5%',
                    bottom: '3%',
                    y: 60,
                    containLabel: true
                },
                xAxis: [
                    {
                        type: 'category',
                        boundaryGap: false,
                        data: ${info.toDateList(count: 30)}
                    }
                ],
                yAxis: [
                    {
                        type: 'value'
                    }
                ],
                series: [
                    {
                        name: 'Death',
                        type: 'line',
                        stack: '1',
                        areaStyle: {},
                        data: ${info.toDataList(info.deaths, count: 30)}
                    },
                    {
                        name: 'Recovered',
                        type: 'line',
                        stack: '1',
                        areaStyle: {},
                        data: ${info.toDataList(info.recovered, count: 30)}
                    },
                     {
                        name: 'Active',
                        type: 'line',
                        stack: '1',
                        areaStyle: {},
                        data: ${info.toDataList(info.active, count: 30)}
                    },
                    {
                        name: 'Cases',
                        type: 'line',
                        stack: '2',
//                        label: {
//                            normal: {
//                                show: true,
//                                position: 'top'
//                            }
//                        },
                        data: ${info.toDataList(info.cases, count: 30)}
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
