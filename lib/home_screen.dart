import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_integration/Provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 GoogleMapController? _googleMapController;
 Completer<GoogleMapController> _completer=Completer();
 CameraPosition initialCameraPosition=CameraPosition(target: LatLng(29.3897, 71.7133),
 zoom: 14.5);
  
 @override
  void initState() {
    super.initState();
  }


   @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
            AddressCapture address=Provider.of(context,listen: false);

    return Scaffold(
      
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Consumer<AddressCapture>(builder: (context, value, child) {
                return
                GoogleMap(
                  mapType: MapType.normal,
                  markers:Set.of(value.markers) ,
                  onMapCreated: (controller) {
                    _completer.complete(controller);
                  },
                   compassEnabled: true,
                  initialCameraPosition:initialCameraPosition);
              },
                
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ButtonBar(
        children:[ 
          FloatingActionButton(child:Icon(Icons.cabin) ,onPressed: () async{
          await address.getCurrentPosition(context).then((value) async{
              _googleMapController=await _completer.future;
               _googleMapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 14.5,
                  target:LatLng(value!.latitude,value.longitude) )));
            });
            
          },),
          FloatingActionButton(child: Icon(Icons.location_disabled_outlined),onPressed: ()async {
          _googleMapController=await _completer.future;
             _googleMapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 14,
                  target:LatLng(48.8566, 2.3522) ))).then((value) {
                  
                  
                  });
                  
         
         
        },),
      ]),
    );
  }
}