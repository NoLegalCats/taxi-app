import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapDriver extends StatefulWidget {
  const MapDriver({Key? key}) : super(key: key);

  @override
  State<MapDriver> createState() => _MapDriverState();
}

class _MapDriverState extends State<MapDriver> {
  late Marker _marker;
  late Timer _timer;
  int _markerIndex = 0;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        location.getLocation().then((p) {
          _marker = Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(51.672, 39.1843),
            child:  Icon(Icons.directions_car),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    if (_marker == null) {
      return new Container();
    }

    return Scaffold(
      appBar: new AppBar(title: new Text("Карта")),
      body: FlutterMap(
        options: new MapOptions(
          initialCenter: _marker.point,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c'],
            
      ),
        MarkerLayer(markers: <Marker>[_marker]),],
      ),
    );
  }
}
