import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;


class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context)=> new ChangeCity())
    );

    if(results != null && results.containsKey('enter')){
      _cityEntered = results['enter'];
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic',
          style: new TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu, color: Colors.black,),
              onPressed: () {_goToNextScreen(context);})
        ],
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png', width: 490.0,
                    height: 1200.0,
                    fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text('${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),),
          ),

          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),

          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 310.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          ),

        ],
      ),
    );
  }


Widget updateTempWidget(String city){
  return new FutureBuilder(future: getWeather(util.apiId, city == null ? util.defaultCity : city) , 
    builder: (BuildContext contexte, AsyncSnapshot<Map> snapshot){

      if(snapshot.hasData){
        Map content = snapshot.data;
        return new Container(

          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(content['main']['temp'].toString() + " F",
                style: new TextStyle(color: Colors.white,
                  fontSize: 49.9, fontStyle: FontStyle.normal, fontWeight: FontWeight.w500),),
                  subtitle: new ListTile(
                    title: new Text("Humidity ${content['main']['humidity'].toString()}\n"
                    "Min: ${content['main']['temp_min'].toString()}\n"
                    "Max: ${content['main']['temp_max'].toString()}\n",
                    style: new TextStyle(color: Colors.white70)
                    )
                  ),
              ),
            ],
          ),
        );
      } else {
        return new Container();
      }

      });
}
  
Future<Map> getWeather(String apiId, String city) async {
    String apiURL = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId&units=imperial';

    http.Response response = await http.get(apiURL);

    return JSON.decode(response.body);
  }

}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          new Container(
            child: 
                new ListTile(
                   title: new TextField(
                      decoration: new InputDecoration(
                        hintText: 'Enter City',
                      ),
                     controller: _cityFieldController,
                     keyboardType: TextInputType.text,
                   ),

                ),
          ),

        new Container(
          margin: EdgeInsets.fromLTRB(0.0, 55.0, 0.0, 0.0),
            child: 
                new ListTile(
                   title: new FlatButton(
                      onPressed: ()=> Navigator.pop(context, {'enter': _cityFieldController.text} ),
                      textColor: Colors.white70,
                      color: Colors.redAccent,
                      child: new Text('Get Weather'),
                   ),
                   

                ),
          )
        ],
      ),
    );
  }
}


TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );
}

