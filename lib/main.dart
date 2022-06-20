// ignore_for_file: prefer_function_declarations_over_variables, prefer_const_constructors

import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:art/fetch_file.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch(settings.name){
          case '/':
          return MaterialPageRoute(builder: (BuildContext context){return HomePage();});
          case '/artists':
          return MaterialPageRoute(builder: (BuildContext context){return ArtistPage();});

          default: return MaterialPageRoute(builder: (BuildContext context){return HomePage();}); 

        }
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget{
  static var route= '/';
  const HomePage({Key? key}): super(key: key);
  @override 
  _HomePageState createState()=> _HomePageState();
}



 final artData = (int count,dynamic artists)=>List<Widget>.generate(
    count, 
    (i){
      return ListTile(
        onTap: (){},
        leading: artists[i].name,
      );
  });

      


class _HomePageState extends State<HomePage>{

    Future<List<Artist>>readJson() async{
        final data = await fetchFileFromAssets('assets/artists.json');
        final artists = jsonDecode(data);
        return artists;
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(child:Column(children: [
        ListTile(leading: Text('Home'),trailing: IconButton(icon: Icon(Icons.arrow_right), onPressed: (){Navigator.of(context).pushNamed('/');}
        ),),
        ListTile(leading: Text('Artists'),trailing: IconButton(icon: Icon(Icons.arrow_right), onPressed:(){Navigator.of(context).pushNamed('/artists');},))
      ],)),
      body: Center(
        child : FutureBuilder(future: readJson(),
        builder: (context,data){
          if(data.hasError){
            return const  Center(child: Text('вышла оплошность'),);
          }
          else if(data.hasData){
            var items = data.data as List<Artist>;
            return ListView.builder(itemBuilder: (context,index){
              return Column(children: [
                ListTile(leading: Text(items[index].name),)
              ]);
            });
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }
        )
      ),
    ); 
  }

}


class ArtistPage extends StatefulWidget{
  static const  route = '/artists';
  const ArtistPage({Key? key}): super(key:key);
  @override 
  _ArtistPageState createState()=>_ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Artists'),),
      body: Column(children:  const [],),
    );
  }
}


class Artist{
  String name;
  String link;
  String about;

  Artist({
    required this.name,
    required this.link,
    required this.about
  });

  factory Artist.fromJson(Map<String,String> json){
    return Artist(
      name : json["name"] as String,
      link : json["link"] as String,
      about : json["about"] as String
    );
  }
}


