import 'package:flutter/material.dart';

class AddList extends StatefulWidget {
  @override
  _AddListState createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  String _subText='';
  String _mainText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新規保存'),
        ),
        body: Container(
          // 余白を付ける
          padding: EdgeInsets.all(64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_subText, style: TextStyle(color: Colors.blue)),
              // テキスト入力
              TextField(
                onChanged: (String value) {
                  // データが変更したことを知らせる（画面を更新する）
                  setState(() {
                    // データを変更
                    _mainText = value;
                    _subText = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                // 横幅いっぱいに広げる
                width: double.infinity,
                // リスト追加ボタン
                child: ElevatedButton(
                  onPressed: () {
                    if(_mainText != ''){

                      Navigator.of(context).pop(_mainText);
                    }else{
                      setState(() {
                        _subText='タイトルを入力してください。';
                      });
                    }
                  },
                  child: Text('リスト追加', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                // 横幅いっぱいに広げる
                width: double.infinity,
                // キャンセルボタン
                child: TextButton(
                  // ボタンをクリックした時の処理
                  onPressed: () {
                    Navigator.of(context).pop(_mainText);
                    // "pop"で前の画面に戻る
                  },
                  child: Text('キャンセル'),
                ),
              ),
            ],
          ),
        ));
  }
}
