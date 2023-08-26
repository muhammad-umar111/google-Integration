import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

//import 'Provider.dart';
import 'modelclasses.dart/placeSuggestion.dart';

class AutoCompletePlaces extends StatefulWidget {
  const AutoCompletePlaces({super.key});

  @override
  State<AutoCompletePlaces> createState() => _AutoCompletePlacesState();
}

class _AutoCompletePlacesState extends State<AutoCompletePlaces> {
  TextEditingController autoCompletePlacesController=TextEditingController();
  var uuid=Uuid();
  String seesionId='12345';
  List<dynamic> _placeList=[];
  List<PlaceSuggestion>? placeSuggestion;
  @override
  void initState() {
    super.initState();
    autoCompletePlacesController.addListener(() {
    onchange();
      
    });
  }
  @override
  void dispose() {
    autoCompletePlacesController.dispose();
    super.dispose();
  }
  onchange(){
    if (seesionId==null) {
      setState(() {
      seesionId==uuid.v4();
        
      });
    } else {
      getSuggestion(autoCompletePlacesController.text);
    }
  }
  getSuggestion(String input)async{
    String KPLACES_API_KEY='AIzaSyABTYt91YHxEJ6qqPY6FEF8vZy6YpRY6x0';
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
String request = '$baseURL?input=$input&key=$KPLACES_API_KEY&sessiontoken=$seesionId';
var response=await http.get(Uri.parse(request));
log(request);
log(response.statusCode.toString());

print(response.body.toString());
if (response.statusCode==200) {
  setState(() {
    _placeList=jsonDecode(response.body.toString())['predictions'];
  });
} else {
  
}


  }
  @override
  Widget build(BuildContext context) {
 //   AddressCapture addressCapture=Provider.of(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title:Text("Auto Complete Places"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFormField(
            controller: autoCompletePlacesController,
            decoration: InputDecoration(
              hintText: 'enter place'
            ),
          ),
     
     Expanded(child: ListView.builder(
      itemCount: _placeList.length,
      itemBuilder: (context, index) {
        log(index.toString());
       return ListTile(
        leading:Icon(Icons.person),
        title: Text(_placeList[index]['description']),
       );
     },))
       
      ]),
    );
  }
}