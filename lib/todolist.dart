import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

class ListItem<T>{
  bool isSelected =false;
  T data;
  ListItem(this.data);
}


class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _todocon = TextEditingController();
  StreamController<List<ListItem<String>>> streamController = StreamController(); // 데이터를 받아들이는 스트림.
  List<ListItem<String>> list = [];


  Widget _buildListTile (List<ListItem<String>> list, int index) { // 리스트 뷰에 들어갈 타일(작은 리스트뷰)를 만든다.

    int num = list.length-1-index;

    return GestureDetector(

        child: Padding(

          padding: EdgeInsets.all(10.0),
          child:Column(
            children: list[num].isSelected ? <Widget>[
              Text(list[num].data, style: TextStyle(decoration: TextDecoration.lineThrough)
              ),
            ] : <Widget>[
              Text(list[num].data)
            ]
          ),

        ),
        onTap: (){
          setState(() {
            list[num].isSelected = true;
          });

        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Todo List")),
        body: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller:  _todocon,
                    validator: (String value){
                      if(value.isEmpty){
                        debugPrint("empty");
                        return "again";
                      }else{
                        debugPrint("not");
                      }
                    },

                  )
                ],
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text("추가"),
                color: Colors.lightBlueAccent,
                textColor: Colors.white,
                onPressed: () { // 버튼을 누르면 서버에서 데이터를 가져옴
                  if(_formkey.currentState.validate()){
                    debugPrint(_todocon.text.toString());
                   // list.insert(0,_todocon.text.toString());
                    list.add(ListItem<String>(_todocon.text.toString()));
                    _todocon.text = "";
                  }
                    streamController.add(list); // 스트림 컨트롤러에 데이터가 추가된다.
                },
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: streamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ListView.builder(
                    itemCount: list.length, // 스냅샷의 데이터 크기만큼 뷰 크기를 정한다.
                    itemBuilder: (context, index) => _buildListTile(list,index),
                  );
                },
              ),
            ),
          ],
        ));
  }
}