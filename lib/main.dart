import 'dart:async';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
//import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:list_app/list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 最初に表示するWidget
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // アプリ名
      title: 'RandomApp',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  int buttonCounter = -1;

  String centerText = '1~45の範囲で\n乱数を生成します。';
  String centerSubText = '';
  String buttonText = '乱数生成';

  //初期化
  int min = 1;
  int max = 45;
  int dif = 0;

  double fontSize = 20;

  List data = [];
  List<String> stringdata = [];

  bool SaveDataExist = false;

  bool AtodeButtonEnabled = false;
  bool RirekiButtonEnabled = true;
  bool HozonButtonEnabled = true;
  bool YomikomiButtonEnabled = true;

  String _time = '';

  ///スライダーの調整
  var _start = '';
  var _end = '';
  var _rangeValues = RangeValues(1.0, 45.0);

  _updateLabels(RangeValues values) {
    _start = '${_rangeValues.start.round()}';
    _end = '${_rangeValues.end.round()}';
  }

//ローカルにデータを保存する関数
  void _setSaveDataPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('saveData_List', stringdata) ?? [];
    prefs.setInt('saveData_buttonCount', buttonCounter) ?? 0;
    prefs.setInt('saveData_max', max) ?? 45;
    prefs.setInt('saveData_min', min) ?? 1;
  }

//ローカルデータを読み込む関数
  void _getSaveDataPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    stringdata = [];
    stringdata = prefs.getStringList('saveData_List');
    buttonCounter = prefs.getInt('saveData_buttonCount');
    buttonCounter = buttonCounter - 1;
    max = prefs.getInt('saveData_max');
    min = prefs.getInt('saveData_min');
  }

//init
  @override
  void initState() {
    _setMinMax();
    buttonCounter = 0;

    super.initState();

    Timer.periodic(Duration(seconds: 1), _onTimer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('乱数生成アプリ  :   ver1.4'),
          actions: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              //height: 37,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                _time,
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: IconButton(
                icon: Icon(Icons.announcement_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Ver1.4　に更新しました。2021/07/09"),
                        content: Text("\n\n"
                            "・乱数をシャッフルする部分のアルゴリズムを改修"
                            "\n"
                            "・UI調整"
                            "\n\n"
                            "**以下実装予定**"
                            "\n・アルゴリズム調整"
                            "\n・保存機能を複数データ保存できるように"
                            "\n・UIサイズ等レイアウト調整"
                            "\n・操作性の改善"
                            "\n\nCT2B　向川原悠貴(rpgmukai333@gmail.comまで)"),
                        actions: <Widget>[
                          // ボタン領域
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(50, 20, 50, 1),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  height: 250,
                  width: double.infinity,
                  //color: Colors.greenAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //CenterText///////////////////////////
                      Text(
                        //data[buttonCounter].toString(),
                        centerText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 120.0,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  //color: Colors.lightBlueAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: [
                            Text('min'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  min = min + 1;
                                  _notDuplicateRandom();
                                });
                              },
                              icon: Icon(Icons.arrow_drop_up_rounded),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                      text: min.toString(),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(labelText: '最小値'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      min = int.parse(value);
                                      _notDuplicateRandom();
                                    });
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  min = min - 1;
                                  _notDuplicateRandom();
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down_rounded),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Text('max'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  max = max + 1;
                                  _notDuplicateRandom();
                                });
                              },
                              icon: Icon(Icons.arrow_drop_up_rounded),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                      text: max.toString(),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(labelText: '最大値'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter';
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      max = int.parse(value);
                                      _notDuplicateRandom();
                                    });
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  max = max - 1;
                                  _notDuplicateRandom();
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.blue,
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: RangeSlider(
                    labels: RangeLabels(_start, _end),
                    values: _rangeValues,
                    min: -10,
                    max: 100,
                    divisions: 100,
                    onChanged: (values) {
                      _rangeValues = values;
                      setState(() {
                        _updateLabels(values);
                        min = (_rangeValues.start).toInt();
                        max = (_rangeValues.end).toInt();
                        _notDuplicateRandom();
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: double.infinity,
                  //color: Colors.orangeAccent,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: Text(
                              '履歴',
                            ),
                            onPressed: !RirekiButtonEnabled
                                ? null
                                : () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NextPage(
                                                  stringdata, buttonCounter)));
                                    });
                                  },
                          ),
                          ElevatedButton(
                            onPressed: !HozonButtonEnabled
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("注意！"),
                                          content: Text(
                                              "過去に保存したデータがあります。\n上書きしてもよろしいですか？"),
                                          actions: <Widget>[
                                            // ボタン領域
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () async {
                                                _setSaveDataPrefs();
                                                showProgressDialog();
                                                await Future.delayed(
                                                    Duration(seconds: 3));
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    setState(() {
                                      fontSize = 20;
                                      //centerText = 'データを保存しました\n' + stringdata.join(',') + '\n$buttonCounter';
                                      centerText = 'データを保存しました。\nお疲れ様でした。';
                                      YomikomiButtonEnabled = true;
                                    });
                                  },
                            child: Text(
                              '保存',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: !YomikomiButtonEnabled
                                ? null
                                : () async {
                                    _getSaveDataPrefs();

                                    showProgressDialog();
                                    await Future.delayed(Duration(seconds: 3));
                                    Navigator.of(context).pop();

                                    setState(() {
                                      fontSize = 20;
                                      //centerText = stringdata.join(',') + '\n$buttonCounter';
                                      centerText = '保存されたデータ\nを読み込みました。';
                                      HozonButtonEnabled = false;
                                      RirekiButtonEnabled = false;
                                      AtodeButtonEnabled = false;
                                      _rangeValues = RangeValues(
                                          min.toDouble(), max.toDouble());
                                      buttonText = '保存データより生成';
                                    });
                                  },
                            child: Text(
                              '読み込み',
                            ),
                          ),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text('後送りにする'),
                            onPressed: !AtodeButtonEnabled
                                ? null
                                : () {
                                    setState(() {
                                      _tikoku();
                                    });
                                    //何かEnableの時の処理
                                  },
                          )),
                      //乱数生成ボタン
                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _buttonCounterController();
                            });
                          },
                          child: Text(buttonText,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

////////////////////////////////////////////////////////////////////////////////////////
  //各変数初期化処理
  /*
  void _allInit() {
    data = [];
    stringdata = [];
    buttonCounter = 0;
    centerText = '0';
    buttonText = '重複なしで生成';
    min = 1;
    max = 45;
    dif = 0;
  }
  */

  void showProgressDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _onTimer(Timer timer) {
    //繰り返し
    /// 現在時刻を取得する
    var now = DateTime.now();

    /// 「時:分:秒」表記に文字列を変換するdateFormatを宣言する
    var dateFormat = DateFormat('MM月dd日  HH:mm');

    /// nowをdateFormatでstringに変換する
    var timeString = dateFormat.format(now);
    setState(() => {_time = timeString});
  }

  //difの個数リストに代入してシャッフルする
  void _setMinMax() {
    setState(() {
      //既存の配列を初期化
      data = [];
      stringdata = [];
      fontSize = 20;
      _difMinusCheck();
      int setlist;
      setlist = min;
      for (int i = 0; data.length <= dif; ++i) {
        //int型リスト data に代入
        data.add(setlist++);
        //string型リスト　stringdata　に代入
        stringdata.add(data[i].toString());
      }
      //dataをシャッフル
      data.shuffle();
      stringdata.shuffle();
    });
  }

//ボタンがおされた時の処理
  //リストの個数を超えてしまうとエラーになるため。
  void _buttonCounterController() {
    //初回処理
    if (buttonCounter == -1) {
      _setMinMax();
      buttonCounter++;
      return;
    }
    buttonText = '乱数を生成';
    //Button表示切り替え
    RirekiButtonEnabled = true;
    HozonButtonEnabled = true;
    AtodeButtonEnabled = true;

    if (buttonCounter < stringdata.length) {
      fontSize = 60;
      //centerText = data[buttonCounter].toString();
      centerText = stringdata[buttonCounter];
      buttonCounter++;
    } else {
      buttonCounter++;
      if (buttonCounter == stringdata.length + 1) {
        //Enable表示切り替え
        RirekiButtonEnabled = true;
        HozonButtonEnabled = false;
        AtodeButtonEnabled = false;

        fontSize = 20;
        centerText = '指定された範囲の乱数がすべて表示されました。';
        buttonText = '同じ範囲で生成';
        buttonCounter = 0;
        _setMinMax();
      }
    }
  }

//乱数を生成
  /*
  int _random() {
    var random = new math.Random();

    return min + random.nextInt((max - min) + 1);
  }

   */

  void _difMinusCheck() {
    dif = max - min;
    if (dif <= 0) {
      fontSize = 20;
      centerText = '範囲がありません。\n値を再指定してください。';
    }
  }

  //重複なし
  void _notDuplicateRandom() {
    //Enable表示切り替え
    RirekiButtonEnabled = false;
    HozonButtonEnabled = false;
    AtodeButtonEnabled = false;

    fontSize = 20;
    _difMinusCheck();
    if (dif > 0) {
      _setMinMax();
      buttonCounter = 0;
      centerText = '$min~$max\nで乱数を生成します。';
      buttonText = '乱数を生成(重複しません)';
    }
  }

//遅刻者をリストの末尾に追加する
  void _tikoku() {
    data.add(int.parse(centerText));
    stringdata.add(centerText);
    fontSize = 20;
    String box = centerText;
    centerText = box + 'は、最後に追加されました。';

    AtodeButtonEnabled = false;
  }
}
