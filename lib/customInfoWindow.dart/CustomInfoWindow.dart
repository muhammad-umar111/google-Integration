
import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';


class CustomInfoWindow1 extends StatefulWidget {
  const CustomInfoWindow1({super.key});

  @override
  State<CustomInfoWindow1> createState() => _CustomInfoWindow1State();
}

class _CustomInfoWindow1State extends State<CustomInfoWindow1> {
   CameraPosition initialCameraPosition=CameraPosition(target: LatLng(29.3897, 71.7133),
 zoom: 14.5);
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
  Completer<GoogleMapController> completer=Completer();
Future<Uint8List> getNetworkImageData2(String url, ) async {
 final Completer _completer=await Completer<ImageInfo>();
  var img=NetworkImage(url);
  img.resolve(ImageConfiguration()).addListener(
    ImageStreamListener((image, synchronousCall) {
      _completer.complete(image);
    })
  );
  final ImageInfo imageInfo=await _completer.future;
  final  byteData=await imageInfo.image.toByteData(format:ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List(); 
}
  List<LatLng> latlng=[
  LatLng(29.3897, 71.7133),LatLng(29.3945, 71.7074),
  LatLng(29.3920, 71.6939),LatLng(29.3972,71.6998)

 ];
Set<Polygon> polygon=HashSet<Polygon>();
Set<Polyline> polyline={};
 List<LatLng> points=[
   LatLng(29.3897, 71.7133),
  LatLng(29.3920, 71.6939),LatLng(29.3972,71.6998),LatLng(29.3945, 71.7074),LatLng(29.3897, 71.7133)

 ];
 List<LatLng> point=[
   LatLng(29.3897, 71.7133),LatLng(29.3972,71.6998),
  LatLng(29.3920, 71.6939),
  LatLng(29.3945, 71.7074),

 ];
 
 
 List<Marker> markers=[];
 final CustomInfoWindowController _customInfoWindowController=CustomInfoWindowController();
 load()async{
  polygon.add(Polygon(
    polygonId: PolygonId('1'),
    points: points,
    geodesic: true,
    strokeColor: Colors.red,
    strokeWidth: 2,
    fillColor:Colors.red.withOpacity(0.3) ));
    
   //String url='https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fman-icon&psig=AOvVaw0eVZ-0Z5HvfG6M03aurkHo&ust=1692345943365000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCKi8tNyj44ADFQAAAAAdAAAAABAD';
  for (var i = 0; i < latlng.length; i++) {
    Uint8List uint8list1=await getImagesData(icons[i],100);
    // Uint8List uint8list=await getNetworkImageData2(url);
    // final ui.Codec codec=await instantiateImageCodec(uint8list.buffer.asUint8List(),targetHeight: 100,targetWidth: 100);
    // final ui.FrameInfo info=await codec.getNextFrame();
    // final ByteData? byteData=await info.image.toByteData(
    //   format: ui.ImageByteFormat.png
    // );
    // final Uint8List uint8list2=byteData!.buffer.asUint8List();
   
    markers.add(
    Marker(markerId:
     MarkerId(i.toString()),
     icon: BitmapDescriptor.fromBytes(uint8list1),
     position: latlng[i],
     onTap: () {
       _customInfoWindowController.addInfoWindow!(
        ListTile(leading: CircleAvatar(backgroundImage: AssetImage(icons[i],
        ),),
        title: Text('This is custom marker $i'),
        ),
        latlng[i]
       );
      
     },
     ));
     setState(() {
       
     });
      polyline.add(
        Polyline(polylineId: PolylineId('1'),
        points: point,
        color: Colors.black,
        startCap:Cap.buttCap
        ,endCap: Cap.roundCap
        ));
  }
 }
 String mapTheme='';
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
     DefaultAssetBundle.of(context).loadString('assets/images/theme/silver_theme.json').then((value) {
   mapTheme=value;
    });
  //  load();
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Info Window'),
        centerTitle: true,
        actions: [
         
         PopupMenuButton(itemBuilder: (context) =>
         [
          PopupMenuItem(onTap: () {
           completer.future.then((value) {
            DefaultAssetBundle.of(context).loadString('assets/images/theme/night_theme.json').then((string) {
           value.setMapStyle(string);});
         });
         },child: Text('Night')),
         
         PopupMenuItem(onTap: () {
            completer.future.then((value) {
          DefaultAssetBundle.of(context).loadString('assets/images/theme/silver_theme.json').then((mapTheme) {
            value.setMapStyle(mapTheme);
          
          
          });
           });
         },child: Text("Silver"))
         ]
    
         ,)
        ],
        backgroundColor: Colors.red,
      ),
      body: Stack(
  children: [
    GoogleMap(
      compassEnabled: true,
     markers: Set.of(markers),
      initialCameraPosition: initialCameraPosition,
     // polygons: polygon,
      //polylines: polyline,
      onMapCreated: (controller) {
        controller.setMapStyle(mapTheme);
        _customInfoWindowController.googleMapController=controller;
        
      },
      onTap: (argument) {
        _customInfoWindowController.hideInfoWindow!();
      },
      onCameraMove: (position) {
        _customInfoWindowController.onCameraMove!();
      },),
      CustomInfoWindow(controller: _customInfoWindowController,
      height: 60,
      width: 250,
      offset: 35
      ,)
    

    
  ]),

    );
   
   
  }
}