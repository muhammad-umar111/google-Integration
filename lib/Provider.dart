import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'modelclasses.dart/placeSuggestion.dart';
import 'package:http/http.dart' as http;


class AddressCapture extends ChangeNotifier{
   Placemark? _placemark;
   Location? _location;
   Position? _position;
   Position? get position=>_position;
   List<Marker> get markers=>_list;
   List<Marker> _list=[
  const Marker(
    markerId: MarkerId('1'),
    infoWindow: InfoWindow(title: 'Satellite Town'),
    position: LatLng(29.3897, 71.7133)
  ),
  const Marker(
    markerId: MarkerId('2'),
    infoWindow: InfoWindow(title: 'Darbar Mahal'),
    position: LatLng(29.3972, 71.6998)
  ),
   const Marker(
    markerId: MarkerId('3'),
    infoWindow: InfoWindow(title: 'Paris'),
    position: LatLng(48.8566, 2.3522)
  ),
 ];
    get latlong=>_location;
   Placemark? get address=>_placemark;
  Future<Placemark?> getAddress(BuildContext context,double latitude1,double longitude1)async{
    print(latitude1);

    try {
    List<dynamic> placemarks=await  placemarkFromCoordinates(latitude1,longitude1 );
     if (placemarks != null && placemarks.isNotEmpty) {
        _placemark = placemarks[0];
       log('dkcfvlgklg');
        notifyListeners();
        print(_placemark);
      } else {
        print('No placemarks found');
      }
    return _placemark;
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print(e.toString());
    }
    return null;


  }
  Future<Location?> getLatLong(BuildContext context,String streetNo,String city)async{

    try {
       List<Location> locations=
    await locationFromAddress("$streetNo,$city");
     _location=locations.first;
    notifyListeners();
    return _location;

  
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
    }
    


Future<Position?> getCurrentPosition(BuildContext context)async{
    await Geolocator.requestPermission().then((value) {
      
    });
    _position=await Geolocator.getCurrentPosition();
    _list.add( Marker(
      markerId: const MarkerId('5'),
    infoWindow: InfoWindow(title: 'Current location'),
      position: LatLng(_position!.latitude,_position!.longitude),
      icon: BitmapDescriptor.defaultMarker,
      
    ));
    notifyListeners();
    log(_position!.latitude.toString());
    return _position;
}
//for practice of http.................. 
  fetch(String query)async{
   var url='https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyCr5bxJeyoAHmZwp8Azr8AH7lsEfD6M7ns';
 // var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyC0UNNx_LxprrfRwloS5vQuE9O1y0lCAK4';
   var response=await http.get(Uri.parse(url));
   log(response.statusCode.toString());
   if (response.statusCode==200) {
    log(response.body);
    return await jsonDecode(response.body) ;
    
    
   } else {
     return null;
   }
  }
Future<List<PlaceSuggestion>> getSuggestion(String query)async{
     var map=await fetch(query) ;
     
     return map.map((map) => PlaceSuggestion.fromMap(map)).toList() ;
    
      
   }
  
}



  
  