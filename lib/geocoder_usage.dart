import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_integration/Provider.dart';
import 'package:provider/provider.dart';

class GeoCoderScreen extends StatefulWidget {
  const GeoCoderScreen({super.key});

  @override
  State<GeoCoderScreen> createState() => _GeoCoderScreenState();
}

class _GeoCoderScreenState extends State<GeoCoderScreen> {
 late TextEditingController streetNoController,cityController,latitudeController,longitudeController;
  @override
  void initState() {
    super.initState();
    streetNoController=TextEditingController();
    cityController=TextEditingController();
    latitudeController=TextEditingController();
    longitudeController=TextEditingController();
    
  }
  @override
  void dispose() {
    streetNoController.dispose();
    cityController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    AddressCapture address=Provider.of(context,listen: false);
   return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: Colors.blueAccent,
      body: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('Geo Coder',style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.w900,fontSize: 25),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: streetNoController,
                    decoration: InputDecoration(
                      hintText: 'Enter street No'
                      
                    ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      hintText: 'Enter City'
                      ),), ),
                Consumer<AddressCapture>(builder: (context, value, child) {
                    return value.latlong!=null? Text(
                    'Latitude: ${value.latlong!.latitude}\nLongitude: ${value.latlong!.longitude}'):Container();
                },),
               
                GestureDetector(
                  onTap: (){
                    address.getLatLong(context,streetNoController.text,cityController.text);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:35.0,right: 35,top: 15,bottom: 10),
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(173, 12, 199, 24)
                      ),
                      child: Center(
                        child: Text('Convert Address into Latitude'),),),
                  ),
                ),
                
             Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: latitudeController,
                    decoration: InputDecoration(
                      hintText: 'Enter Latitude'
                      
                    ),
                  ),
                ),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: longitudeController,
                    decoration: InputDecoration(
                      hintText: 'Enter Longitude'
                      
                    ),
                  ),
                ),
                  Selector<AddressCapture,Placemark?>(builder: (context, value, child) {
                  return value?.street!=null? Text(
                    'Street Addrees: ${value?.street}\nAdministrative Area: ${value?.administrativeArea}\nCountry: ${value?.country}'):Container();             
                },
                
              selector:(context,address)=>address.address ),
                 GestureDetector(
                  onTap: (){
                        double latitude=double.tryParse(latitudeController.text)??0;
              double longitude=double.tryParse(longitudeController.text)??0;
                    address.getAddress(context,latitude,longitude);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:35.0,right: 35,top: 15,bottom: 10),
                    
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(173, 12, 199, 24)
                      ),
                      child: Center(
                        child: Text('Convert into Address'),),),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}