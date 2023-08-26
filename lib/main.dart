import 'package:flutter/material.dart';
import 'package:google_map_integration/AutoCompletePlaces.dart';
import 'package:google_map_integration/CustomMarker.dart';
import 'package:google_map_integration/Provider.dart';
import 'package:google_map_integration/customInfoWindow.dart/CustomInfoWindow.dart';
import 'package:google_map_integration/geocoder_usage.dart';
import 'package:google_map_integration/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<AddressCapture>(create: (context) {
        return
      AddressCapture();

      },
      child:GeoCoderScreen(),)
    );
  }
}


