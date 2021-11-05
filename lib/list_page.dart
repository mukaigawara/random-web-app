//’履歴’ボタン　=>　list_page

import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  List list;
  int counter;
  NextPage(this.list,this.counter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('生成履歴'),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: counter, //並べたい要素の数を指定する
            itemBuilder: (context, int index) { // index はこの ListView における要素の番号
              return _menuItem(index.toString(),list[index].toString());
              /*
              return Text(
                list[index].toString(),
                style: TextStyle(
                  fontSize: 30,
                ),// listItem の index 番目の要素を表示する
              );
              
               */
              
              
            },
          )
          /*
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Text(list[index]);
                }
                )
                */
        )
    );
  }

  Widget _menuItem(String index,String title) {
    return GestureDetector(
      child:Container(
          padding: EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
               // color: Colors.red,
                margin: EdgeInsets.fromLTRB(10,10,50,10),
                child: Text(
                  (int.parse(index)+1).toString()+'人目',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 18.0
                ),
              ),
            ],
          )
      ),
      onTap: () {
        print("onTap called.");
      },
    );
  }
}
