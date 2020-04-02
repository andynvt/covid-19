import 'dart:ui';
import 'package:covid/model/model.dart';
import 'package:covid/module/module.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/service/service.dart';
import 'package:covid/util/util.dart';
import 'package:covid/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' show parse;
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
  TextEditingController _textController;

  void _selectCountryClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => createSelectCountry()))
        .then((info) {
      if (info is CountryInfo) {
        final model = Provider.of<MainModel>(context, listen: false);
        model.logic.selectGlobal(false);
        model.logic.updateCountry(info);
        model.logic.getNews();
      }
    });
  }

  void _tabItemClick(int index) {
    final model = Provider.of<MainModel>(context, listen: false);
    model.logic.changeTab(index);
    _pageController.jumpToPage(index);
  }

  void _statisticClick(TypeEnum type) {
    final model = Provider.of<MainModel>(context, listen: false);
    model.logic.moveToListTab(type);
    _pageController.jumpToPage(1);
  }

  void _menuItemClick() {}

  @override
  void initState() {
    _pageController = PageController(keepPage: true, initialPage: 2);
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
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
        title: Text(model.title, style: Style.ts_1),
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
        onItemSelected: _tabItemClick,
        items: [
          TTBottomBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Chart'),
            activeColor: Cl.mBlue,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
            textAlign: TextAlign.center,
            activeColor: Cl.mBlue,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Cl.mBlue,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
            activeColor: Cl.mBlue,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.library_books),
            title: Text('News'),
            textAlign: TextAlign.center,
            activeColor: Cl.mBlue,
            inactiveColor: Cl.grey,
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
        Container(color: Colors.blue),
        _renderTopTab(),
        _renderHomeTab(),
        Container(color: Colors.green),
        _renderNewsTab(),
      ],
    );
  }

  ///HOME TAB

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
        onTap: () => _statisticClick(type),
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
      child: InkWell(
        onTap: () => _statisticClick(type),
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

  ///NEWS TAB

  Widget _renderNewsTab() {
    final model = Provider.of<MainModel>(context);
    final myCountry = model.myCountry;
    if (myCountry.name == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  Image.asset(
                    Id.getIdByCountry(model.myCountry),
                    width: 30,
                  ),
                  SizedBox(width: 16),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      model.myCountry.name,
                      style: Style.ts_16_black,
                    ),
                  ),
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
        SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: myCountry.news.length,
            itemBuilder: (_, index) {
              return _renderNewsItem(myCountry.news[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _renderNewsItem(NewsInfo info) {
    String parseStr = parse(info.title).documentElement.text;
    double height = MediaQuery.of(context).size.height / 4 - 10;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          LaunchURL.launch(info.url);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Cl.grey300),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: TTNetworkImage(
                  height: height,
                  width: double.infinity,
                  boxFit: BoxFit.cover,
                  imageUrl: info.image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(parseStr, style: Style.ts_13),
                          SizedBox(height: 4),
                          Text(
                            TTString.shared().formatDate(info.time),
                            style: Style.ts_19,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///TOP TAB

  Widget _renderTopTab() {
    final model = Provider.of<MainModel>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    child: TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(
                        labelText: 'Select country',
                        labelStyle: Style.ts_101,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Cl.grey300),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Cl.mBlue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: model.text.add,
                      style: Style.ts_16_black,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => model.logic.sortFilter(),
                  child: Container(
                    height: 48,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Cl.grey300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Sort', style: Style.ts_101),
                        SizedBox(width: 8),
                        Image.asset(
                          model.sortFilter == SortType.DES
                              ? Id.ic_sort_des
                              : Id.ic_sort_acs,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  height: 48,
                  width: 130,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Cl.grey300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    value: typeEnumToStr(model.typeFilter),
                    underline: Container(),
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: [
                      TypeEnum.TOTAL,
                      TypeEnum.ACTIVE,
                      TypeEnum.RECOVERED,
                      TypeEnum.DEATH,
                      TypeEnum.CASE_TODAY,
                      TypeEnum.DEATH_TODAY,
                      TypeEnum.CRITICAL,
                    ].map((v) {
                      return DropdownMenuItem(
                        value: typeEnumToStr(v),
                        child: Material(
                          color: Colors.transparent,
                          child:
                              Text(typeEnumToStr(v), style: Style.ts_16_black),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      model.logic.typeFilter(v);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          _renderListTop(),
        ],
      ),
    );
  }

  Widget _renderListTop() {
    final model = Provider.of<MainModel>(context);
    if (model.listSearch.isEmpty) {
      return Container();
    }
    final ls = model.listSearch;
    return Expanded(
      child: ListView.separated(
        itemCount: ls.length,
        itemBuilder: (_, index) {
          return _renderTopItem(ls[index], model.typeFilter);
        },
        separatorBuilder: (_, __) {
          return Container(height: 1, color: Cl.grey300);
        },
      ),
    );
  }

  Widget _renderTopItem(CountryInfo info, TypeEnum type) {
    return ListTile(
      leading: Image.asset(
        Id.getIdByCountry(info),
        width: 50,
      ),
      title: Text(info.name, style: Style.ts_6),
      subtitle: Text(info.code ?? ''),
      trailing: Text(
        typeEnumToCasesStr(type, info),
        style: typeEnumToStyle(type),
      ),
    );
  }
}
