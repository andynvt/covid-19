import 'package:covid/model/country_info.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'select_country_model.dart';

ChangeNotifierProvider<SelectCountryModel> createSelectCountry() {
  return ChangeNotifierProvider(
    create: (_) => SelectCountryModel(),
    child: _SelectCountryView(),
  );
}

class _SelectCountryView extends StatefulWidget {
  @override
  _SelectCountryViewState createState() => _SelectCountryViewState();
}

class _SelectCountryViewState extends State<_SelectCountryView> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SelectCountryModel>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace, color: Cl.black, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Cl.white,
        elevation: 1,
        title: Text('Select country to track', style: Style.ts_4),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Select country',
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: model.text.add,
              style: Style.ts_16_black,
            ),
          ),
          Container(
            height: 40,
            color: Cl.grey300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('COUNTRY', style: Style.ts_6),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text('CASES', style: Style.ts_6),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: model.listSearch.length,
              itemBuilder: (_, index) {
                return _renderCountryItem(model.listSearch[index]);
              },
              separatorBuilder: (_, __) {
                return Container(height: 1, color: Cl.grey300);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderCountryItem(CountryInfo info) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop(info);
      },
      leading: Image.asset(
        Id.getIdByCountry(info),
        width: 50,
      ),
      title: Text(info.name, style: Style.ts_6),
      subtitle: Text(info.code ?? ''),
      trailing: Text(TTString.shared().formatNumber(info.cases), style: Style.ts_15),
    );
  }
}
