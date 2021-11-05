import 'package:flutter/material.dart';
import 'package:list_app/add_savelist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:list_app/main.dart';

class SavePage extends StatefulWidget {
  @override
  _SavePageState createState() => _SavePageState();
  List data;
  List saveList;
  int counter;

  SavePage(this.data,this.saveList);
}

class _SavePageState extends State<SavePage> {
  int _counter;
  List saveList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '保存',
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              //padding: EdgeInsets.all(30),
              // color: Colors.greenAccent,
              child: Text(
                'リスト一覧画面',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: saveList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(saveList[index]),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              //color: Colors.red,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // "push"で新規画面に遷移
                        final receivetext = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            // 遷移先の画面としてリスト追加画面を指定
                            return AddList();
                          }),
                        );
                        if (receivetext != null) {
                          setState(() {
                            saveList.add(receivetext);
                          });
                        }
                      },
                      child: Text('新規追加'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('キャンセル'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
