import 'dart:async';
import 'dart:ui'as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker extends StatefulWidget {
  const CustomMarker({super.key});

  @override
  State<CustomMarker> createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> {
  Completer<GoogleMapController> _completer=Completer();
  CameraPosition initialCameraPosition=CameraPosition(target: LatLng(29.3897, 71.7133),
 zoom: 14.2);
 List<String> icons=
 ['assets/images/computer.png',
 'assets/images/delivery.png',
 'assets/images/deliverytruck.png',
 'assets/images/freewifi.png'  ];
 
 
  Future<Uint8List> getImagesData(String path,int height)async{
    ByteData data=await rootBundle.load(path);
    ui.Codec codec=await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: height);
    ui.FrameInfo info=await codec.getNextFrame();
    return (await info.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  List<Marker> markers = [
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(29.3897, 71.7133),
      ),
      
      
    ];
 List<LatLng> latlng=[
  LatLng(29.3897, 71.7133),LatLng(29.3945, 71.7074),
  LatLng(29.3920, 71.6939),LatLng(29.3972,71.6998)

 ];
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
      loadData();
  }
  loadData()async{
    for (var i = 0; i < latlng.length; i++) {
     final Uint8List uint8list=await getImagesData(icons[i],100);
      markers.add(
        Marker(
          markerId: MarkerId('$i'),
          position: latlng[i],
          icon: BitmapDescriptor.fromBytes(uint8list),
          infoWindow: InfoWindow(
            title: 'This is the $i'
          )

      ));
      setState(() {
        
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        top: true,
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          mapType: MapType.normal,
          markers: Set.from(markers),
          onMapCreated: (controller) {
            _completer.complete(controller);
          },
          compassEnabled: true,
          ),
      ),
    );
  }
}
