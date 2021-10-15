// 新建账户
import 'dart:math';

import 'package:wallet/pages/account/create/accountAdvanceOption.dart';
import 'package:wallet/service/index.dart';
import 'package:wallet/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/roundedButton.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class BackupAccountPage extends StatefulWidget {
  const BackupAccountPage(this.service);
  final AppService service;

  static final String route = '/account/backup';

  @override
  _BackupAccountPageState createState() => _BackupAccountPageState();
}

class _BackupAccountPageState extends State<BackupAccountPage> {
  // ignore: non_constant_identifier_names
  final int TotalConfirms = 5;
  AccountAdvanceOptionParams _advanceOptions = AccountAdvanceOptionParams();
  int _step = 0;
  int currentConfirmId = 0;

  List<String> _wordsSelected;
  List<String> _wordsLeft;
  List _randomNumbers;

  @override
  void initState() {
    // widget.service.account.generateAccount();
    // Set widget.service.store.account.newAccount.qskey
    widget.service.account.generateQSAccount("");
    super.initState();
  }

  void _resetWordsSelect() {
    setState(() => _wordsSelected = ['', '', '', '', '', '']);
    currentConfirmId = 0;
  }

  String _addNoForKey(String key) {
    if (key != "") {
      List<String> list = key.split(" ");
      List<String> newList = [];
      for (var i = 0; i < list.length; i++) {
        newList.add((i + 1).toString() + '.' + list[i]);
      }
      return newList.join("     ");
    } else {
      return null;
    }
  }

  List _getRandomList() {
    var rng = new Random();
    Set smm = new Set();
    while (smm.length < 24) smm.add(rng.nextInt(24));
    return smm.toList().sublist(0, TotalConfirms);
  }

  bool _checkKeys(String key) {
    final List<String> keyList = key.split(' ');
    bool result = true;
    for (var i = 0; i < TotalConfirms; i++) {
      if (_wordsSelected[i] == keyList[_randomNumbers[i]])
        continue;
      else {
        result = false;
        break;
      }
    }
    return result;
  }

  Widget _buildStep0(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');

    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(dic['create']),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 16),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        dic['create.warn3'],
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(dic['create.warn4']),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        _addNoForKey(
                                widget.service.store.account.newAccount.key) ??
                            dic['loading'],
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Divider(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        dic['create.warn12'],
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(dic['create.warn11']),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        // 显示助记词QS
                        _addNoForKey(widget
                                .service.store.account.newAccount.qskey) ??
                            dic['loading'],
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    AccountAdvanceOption(
                      api: widget.service.plugin.sdk.api.keyring,
                      seed: widget.service.store.account.newAccount.key ?? '',
                      onChange: (data) {
                        setState(() {
                          _advanceOptions = data;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: I18n.of(context)
                      .getDic(i18n_full_dic_ui, 'common')['next'],
                  onPressed: () {
                    if (_advanceOptions.error ?? false) return;
                    _resetWordsSelect();
                    setState(() {
                      _step = 1;
                      _wordsLeft = widget.service.store.account.newAccount.key
                          .split(' ');
                      _randomNumbers = _getRandomList();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(BuildContext context) {
    // 确认标准助记词
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['create']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              _step = 0;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Text(
                    dic['backup'],
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      dic['backup.confirm'],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            dic['backup.reset'],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        onTap: () {
                          _resetWordsSelect();
                          setState(() {
                            _wordsLeft = widget
                                .service.store.account.newAccount.key
                                .split(' ');
                            _randomNumbers = _getRandomList();
                          });
                        },
                      )
                    ],
                  ),
                  _buildConfirmBox(),
                  _buildWordsButtons(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text:
                    I18n.of(context).getDic(i18n_full_dic_ui, 'common')['next'],
                onPressed: () {
                  if (_checkKeys(widget.service.store.account.newAccount.key)) {
                    _resetWordsSelect();
                    setState(() {
                      _step = 2;
                      _wordsLeft = widget.service.store.account.newAccount.qskey
                          .split(' ');
                      _randomNumbers = _getRandomList();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    // 确认抗量子助记词
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['create']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              _step = 1;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Text(
                    dic['backupQS'],
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      dic['backup.confirm'],
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              dic['backup.reset'],
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          onTap: () {
                            _resetWordsSelect();
                            setState(() {
                              _wordsLeft = widget
                                  .service.store.account.newAccount.qskey
                                  .split(' ');
                              _randomNumbers = _getRandomList();
                            });
                          },
                        ),
                      ]),
                  _buildConfirmBox(),
                  _buildWordsButtons(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text:
                    I18n.of(context).getDic(i18n_full_dic_ui, 'common')['next'],
                onPressed: () => {
                  if (_checkKeys(widget.service.store.account.newAccount.qskey))
                    Navigator.of(context).pop(_advanceOptions)
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmBox() {
    List<Container> _containerList = [];
    // print(_randomNumbers);
    for (var i = 0; i < TotalConfirms; i++) {
      _containerList.add(
        new Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          padding: EdgeInsets.fromLTRB(16, 12, 16, 11),
          margin: EdgeInsets.all(5),
          width: 400,
          child: Text(
            (_randomNumbers[i] + 1).toString() +
                ". " +
                (_wordsSelected[i] ?? ''),
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      );
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _containerList);
  }

  Widget _buildWordsButtons() {
    if (_wordsLeft.length > 0) {
      _wordsLeft.sort();
    }

    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 2,
        runSpacing: 3,
        children: _wordsLeft
            .map((e) => Container(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: ElevatedButton(
                    child: Text(
                      e,
                    ),
                    onPressed: () {
                      setState(() {
                        if (currentConfirmId < TotalConfirms) {
                          _wordsLeft.remove(e);
                          _wordsSelected[currentConfirmId++] = e;
                        }
                        // print(_wordsSelected);
                      });
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildStep0(context);
      case 1:
        return _buildStep1(context);
      case 2:
        return _buildStep2(context);
      default:
        return Container();
    }
  }
}
