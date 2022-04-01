import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Album.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'List of Albums send by API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future <List<Album>> _getUsers() async {
    var data = await http.get(Uri.parse('http://jsonplaceholder.typicode.com/albums/'));
    var jsonData = json.decode(data.body);
    List<Album> albums = [];
    for(var u in jsonData){
      Album album = Album( id: u['id'], userId: u['userId'], title: u['title']);
      albums.add(album);
    }
    return albums;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data==null){
              return const Center(
                child:Text("Loading...")
              );
            }
            else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) => Card(
                    color: Colors.blue[100],
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      title: Text(snapshot.data[index].id.toString()+"- "+snapshot.data[index].title),
                    ),
                  ),
                );
            }
          }
        ),
      ),
    );
  }
}
