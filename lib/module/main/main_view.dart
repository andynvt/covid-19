import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:covid/model/model.dart';
import 'package:covid/module/module.dart';
import 'package:covid/module/root/root_model.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/service/service.dart';
import 'package:covid/util/util.dart';
import 'package:covid/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  ScrollController _scrollController;
  PageController _pageController;
  TextEditingController _textController;

  void _tabItemClick(int index) {
    FocusScope.of(context).unfocus();
    final model = Provider.of<MainModel>(context, listen: false);
    model.logic.changeTab(index);
    _pageController.jumpToPage(index);
  }

  void _selectCountryClick(int sourceIndex) {
    FocusScope.of(context).unfocus();
    final model = Provider.of<MainModel>(context, listen: false);
    model.sourceIndex = sourceIndex;
    model.logic.moveToListTab(TypeEnum.TOTAL);
    _pageController.jumpToPage(1);
  }

  void _statisticClick(TypeEnum type) {
    FocusScope.of(context).unfocus();
    final model = Provider.of<MainModel>(context, listen: false);
    model.sourceIndex = 2;
    model.logic.moveToListTab(type);
    _pageController.jumpToPage(1);
  }

  void _topItemClick(CountryInfo info) {
    FocusScope.of(context).unfocus();
    final model = Provider.of<MainModel>(context, listen: false);
    model.logic.selectGlobal(false);
    if (model.sourceIndex == 2) {
      model.logic.moveToPage(info, 2);
    } else if (model.sourceIndex == 0) {
      model.logic.moveToPage(info, 0);
    }
    model.logic.updateCountry(info);
    _pageController.jumpToPage(model.sourceIndex);
  }

  void _chartClick() {
    final model = Provider.of<MainModel>(context, listen: false);
    model.pageIndex = 0;
    model.refresh();
    _pageController.jumpToPage(0);
  }

  @override
  void initState() {
    _pageController = PageController(keepPage: true, initialPage: 2);
    _textController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final root = Provider.of<RootModel>(context);
    final model = Provider.of<MainModel>(context);
    root.logic.showLoading(this.toString());
    if (model.countries.isNotEmpty) {
      root.logic.hideLoading(this.toString());
    }

    return Scaffold(
      backgroundColor: Cl.white,
      key: _scaffoldKey,
      bottomNavigationBar: TTBottomBar(
        backgroundColor: Cl.white,
        selectedIndex: model.pageIndex,
        showElevation: true,
        onItemSelected: _tabItemClick,
        items: [
          TTBottomBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Chart'),
            activeColor: Cl.salmon,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
            textAlign: TextAlign.center,
            activeColor: Cl.salmon,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Cl.salmon,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.library_books),
            title: Text('News'),
            textAlign: TextAlign.center,
            activeColor: Cl.salmon,
            inactiveColor: Cl.grey,
          ),
          TTBottomBarItem(
            icon: Icon(Icons.settings),
            title: Text('Setting'),
            activeColor: Cl.salmon,
            inactiveColor: Cl.grey,
          ),
        ],
      ),
      body: _renderBody(),
    );
  }

  Widget _renderBody() {
    final model = Provider.of<MainModel>(context);
    return SafeArea(
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) => model.pageIndex,
        children: <Widget>[
          _renderChart(),
          _renderTopTab(),
          _renderHomeTab(),
          _renderNewsTab(),
          _renderSetting(),
        ],
      ),
    );
  }

  ///HOME TAB

  Future<void> _onRefresh() async {
    final model = Provider.of<MainModel>(context, listen: false);
    final root = Provider.of<RootModel>(context, listen: false);
    root.logic.showLoading(this.toString());
    model.logic.reloadData(() {
      root.logic.hideLoading(this.toString());
    });
    return Future.value();
  }

  Widget _renderHomeTab() {
    final model = Provider.of<MainModel>(context);
    final isGlobal = model.isGlobal;
    final info = isGlobal ? model.globalInfo : model.myCountry;

    return RefreshIndicator(
      color: Cl.salmon,
      onRefresh: _onRefresh,
      child: ListView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => model.logic.selectGlobal(!model.isGlobal),
                  child: Icon(
                    Icons.language,
                    size: 40,
                    color: isGlobal ? Cl.black : Cl.grey,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlineButton(
                      padding: const EdgeInsets.all(6),
                      onPressed: () => _selectCountryClick(2),
                      borderSide: BorderSide(color: Cl.brownGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            isGlobal
                                ? Id.ic_world
                                : Id.getIdByCountry(model.myCountry),
                            width: 45,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: !isGlobal
                                ? Material(
                                    color: Colors.transparent,
                                    child: AutoSizeText(
                                      model.myCountry.name,
                                      style: Style.ts4,
                                      maxLines: 2,
                                      minFontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : Text('Global', style: Style.ts4),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12, left: 8),
                            child: Icon(Icons.search, size: 32),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            child: _renderPieChart(isGlobal),
          ),
          SizedBox(height: 8),
          Container(
            height: 58,
            margin: const EdgeInsets.only(bottom: 32),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Cl.white,
              boxShadow: [
                BoxShadow(
                  color: Cl.cloudyBlue18,
                  offset: Offset(-1, 3),
                  blurRadius: 7,
                )
              ],
            ),
            child: Text(info.name ?? 'Global', style: Style.ts2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                _renderStatisticItem(TypeEnum.TOTAL, info.cases),
                SizedBox(width: 20),
                _renderStatisticItem(TypeEnum.ACTIVE, info.active),
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                _renderStatisticItem(TypeEnum.RECOVERED, info.recovered),
                SizedBox(width: 20),
                _renderStatisticItem(TypeEnum.DEATH, info.deaths),
              ],
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                _renderBoxInfo(TypeEnum.CASE_TODAY, info.todayCases),
                _renderBoxInfo(TypeEnum.DEATH_TODAY, info.todayDeaths),
                _renderBoxInfo(TypeEnum.CRITICAL, info.critical),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Cl.tealish)),
                      onPressed: _chartClick,
                      icon: Icon(Icons.insert_chart),
                      label: Text('Chart', style: Style.ts3),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Cl.tealish)),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => createMap()),
                        );
                      },
                      icon: Icon(Icons.map),
                      label: Text('Map', style: Style.ts3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Update: ', style: Style.ts_19),
                    info.updated != null
                        ? TextSpan(
                            text: TTString.shared().formatDate(info.updated),
                            style: Style.ts_19_bold,
                          )
                        : TextSpan(),
                    TextSpan(text: ' - WHO, JHU', style: Style.ts_19),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderPieChart(bool isGlobal) {
    final model = Provider.of<MainModel>(context);
    final info = isGlobal ? model.globalInfo : model.myCountry;

    return Echarts(
      option: '''
      {
        tooltip: {
            trigger: 'item',
            formatter: '{b}<br/>{c}<br/>{d}%'
        },
        color: ['#327589','#75FAD7', '#ED6F61'],
        legend: {
            orient: 'vertical',
            right: 10,
            itemGap: 35,
            itemWidth: 10,
            itemHeight: 24,
            top: 'middle',
            data: ['Active', 'Recovered', 'Death'],
            textStyle: {
                fontSize: 14,
                padding: [0,20],
            }
        },
        series: [
            {
                type: 'pie',
                radius: '90%',
                top: 5,
                bottom: 5,
                left: 0,
                right: '35%',
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
                    {value: ${info.active}, name: 'Active'},
                    {value: ${info.recovered}, name: 'Recovered'},
                    {value: ${info.deaths}, name: 'Death'},
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
    final left = (MediaQuery.of(context).size.width / 2) - 160;
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () => _statisticClick(type),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 7),
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: typeEnumToColor(type)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(text, style: Style.ts_total_20),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Cl.white,
                width: left + 60,
                height: 10,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(typeEnumToStr(type), style: Style.ts5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderBoxInfo(TypeEnum type, int number) {
    final text = TTString.shared().formatNumber(number ?? 0);
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () => _statisticClick(type),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Cl.brownGreyTwo.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: <Widget>[
              Text(text, style: typeEnumToStyle(type)),
              SizedBox(height: 8),
              Text(typeEnumToStr(type), style: Style.ts6),
            ],
          ),
        ),
      ),
    );
  }

  ///NEWS TAB

  Widget _renderSelectCountry(int sourceIndex) {
    final model = Provider.of<MainModel>(context);
    final isGlobal = model.isGlobal;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => model.logic.selectGlobal(!model.isGlobal),
            child: Icon(
              Icons.language,
              size: 40,
              color: isGlobal ? Cl.black : Cl.grey,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlineButton(
                padding: const EdgeInsets.all(6),
                onPressed: () => _selectCountryClick(0),
                borderSide: BorderSide(color: Cl.brownGrey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      isGlobal
                          ? Id.ic_world
                          : Id.getIdByCountry(model.myCountry),
                      width: 45,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: !isGlobal
                          ? Material(
                              color: Colors.transparent,
                              child: AutoSizeText(
                                model.myCountry.name,
                                style: Style.ts4,
                                maxLines: 2,
                                minFontSize: 13,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : Text('Global', style: Style.ts4),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(Icons.search, size: 32),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderNewsTab() {
    final model = Provider.of<MainModel>(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ChangeNotifierProvider.value(
            value: CountryService.shared(),
            child: Consumer<CountryService>(builder: (_, service, __) {
              if (service.listNews.isEmpty) {
                return Container();
              }
              final ls = service.listNews;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) {
                        return _renderNewsItem(ls[index]);
                      },
                      childCount: ls.length,
                      semanticIndexCallback: (_, index) {
                        if (index == ls.length - 5) {
                          model.logic.getNews();
                        }
                        return index;
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _renderNewsItem(NewsInfo info) {
//    String parseStr = parse(info.title).documentElement.text;
    double width = MediaQuery.of(context).size.width / 2.8;
    double height = (width * 3 / 4);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => createNewsDetail(info)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Cl.grey300),
            borderRadius: BorderRadius.circular(10),
          ),
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: TTNetworkImage(
                  height: double.infinity,
                  width: width,
                  boxFit: BoxFit.cover,
                  imageUrl: info.urlToImage,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          info.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Style.ts_16_black,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.access_time, size: 15),
                            SizedBox(width: 4),
                            Text(
                              TTString.shared().formatTimeAgo(info.publishedAt,
                                  isShort: true),
                              style: Style.ts_21,
                            ),
                            SizedBox(width: 4),
                            Text('•', style: Style.ts_21_tealish),
                            SizedBox(width: 4),
                            Expanded(
                              child:
                                  Text(info.source, style: Style.ts_21_tealish),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
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
                        labelText: 'Search country',
                        labelStyle: Style.ts_101,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Cl.grey300),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Cl.tealish),
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
          return Container(height: 1, color: Cl.cloudyBlue18);
        },
      ),
    );
  }

  Widget _renderTopItem(CountryInfo info, TypeEnum type) {
    return ListTile(
      onTap: () => _topItemClick(info),
      leading: Image.asset(
        Id.getIdByCountry(info),
        width: 50,
      ),
      title: Text(info.name, style: Style.ts_total_18),
      subtitle: Text(info.code ?? ''),
      trailing: Text(
        typeEnumToCasesStr(type, info),
        style: typeEnumToStyle(type),
      ),
    );
  }

  Widget _renderChart() {
    final model = Provider.of<MainModel>(context);
    final info = model.isGlobal ? model.globalHistorical : model.myHistorical;
    if (info == null || info.cases == null) {
      return Container();
    }
    return Column(
      children: <Widget>[
        _renderSelectCountry(0),
        SizedBox(height: 8),
        Expanded(
          child: Echarts(
            option: '''
            {
              tooltip: {
                  trigger: 'axis',
              },
              toolbox: {
                  feature: {
                      restore: {},
                  }
              },
              color: ['#ED6F61','#75FAD7','#327589','#faa700'],
              legend: {
                  left: 10,
                  data: ['Death', 'Recovered', 'Active', 'Total'],
              },
              grid: {
                  containLabel: true,
                  left: 8,
                  right: 25,
                  top: 40,
                  bottom: 50,
              },
              xAxis: {
                  type: 'category',
                  boundaryGap: false,
                  data: ${info.toDateList()},
              },
              yAxis: {
                  type: 'value',
                  axisLabel: {
                      formatter: function (num, index) {
                          function shortenLargeNumber(num, digits) {
                              var units = ['k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'], decimal;
                              for(var i=units.length-1; i>=0; i--) {
                                  decimal = Math.pow(1000, i+1);
                                  if(num <= -decimal || num >= decimal) {
                                      return +(num / decimal).toFixed(digits) + units[i];
                                  }
                              }
                              return num;
                          }
                          return shortenLargeNumber(num, 1);
                      }
                  }
              },
              dataZoom: [{
                  type: 'inside',
                  start: 90,
                  end: 100
              }, {
                  start: 90,
                  end: 100,
                  handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                  handleSize: '80%',
                  handleStyle: {
                      color: '#fff',
                      shadowBlur: 3,
                      shadowColor: 'rgba(0, 0, 0, 0.6)',
                      shadowOffsetX: 2,
                      shadowOffsetY: 2
                  }
              }],
              series: [
                  {
                      name: 'Death',
                      type: 'line',
                      smooth: true,
                      stack: '2',
                      sampling: 'average',
                      areaStyle: {},
                      data: ${info.toDataList(info.deaths)}
                  },
                  {
                      name: 'Recovered',
                      type: 'line',
                      smooth: true,
                      stack: '2',
                      sampling: 'average',
                      areaStyle: {},
                      data: ${info.toDataList(info.recovered)}
                  },
                  {
                      name: 'Active',
                      type: 'line',
                      smooth: true,
                      stack: '2',
                      sampling: 'average',
                      areaStyle: {},
                      data: ${info.toDataList(info.active)}
                  },
                  {
                      name: 'Total',
                      type: 'line',
                      smooth: true,
                      stack: '1',
                      sampling: 'average',
                      data: ${info.toDataList(info.cases)}
                  },
              ]
            }
            ''',
            extraScript: '''
            document.getElementsByTagName("body")[0].style = 'position: fixed';
            ''',
          ),
        ),
      ],
    );
  }

  ///SETTING

  Widget _renderSetting() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 32),
          Image.asset(Id.ic_virus),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Text('COVID-19', style: Style.ts2),
                SizedBox(height: 4),
                Text('Version: ${CS.APP_VERSION}', style: Style.ts5),
              ],
            ),
          ),
          SizedBox(height: 32),
          Container(width: double.infinity, height: 1, color: Cl.grey300),
          _renderSettingItem(Icons.help, 'Support', null),
          _renderSettingItem(Icons.phone, 'Emergency Call', null),
          _renderSettingItem(Icons.live_help, 'FAQ', null),
          SizedBox(height: 32),
          Container(width: double.infinity, height: 1, color: Cl.grey300),
          _renderSettingItem(Icons.language, 'Change Language', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => createChangeLanguage()),
            );
          }),
          _renderSettingItem(Icons.feedback, 'Send Feedback', () {
            LaunchURL.launch(CS.FORM_FEEDBACK);
          }),
          SizedBox(height: 32),
          Text('Data source: WHO, JHU', style: Style.ts_19),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () {
                LaunchURL.launch(NetworkAPI.NOVEL);
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Statistics API: ', style: Style.ts_19),
                    TextSpan(text: 'NovelCOVID', style: Style.ts_19_tealish),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              LaunchURL.launch(CS.NEWS_API);
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'News API: ', style: Style.ts_19),
                  TextSpan(text: 'NewsAPI', style: Style.ts_19_tealish),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSettingItem(IconData icon, String text, Function onClick) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Cl.grey300),
        ),
      ),
      child: ListTile(
        onTap: onClick,
        leading: Icon(icon, color: Cl.tealish),
        title: Text(text, style: Style.ts3),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
