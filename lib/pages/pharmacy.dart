import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_app/globalconstants/constants.dart';

class Pharmacy extends StatefulWidget {
  @override
  _PharmacyState createState() => _PharmacyState();
}

class _PharmacyState extends State<Pharmacy> {
  Set<Marker> _markers = {};

  GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine"),
        centerTitle: true,
        backgroundColor: lightGreen,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 0.95,
        child: GoogleMap(
          markers: _markers,
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              googleMapController = controller;
              _markers.addAll([
                Marker(
                  markerId: MarkerId('Clinic'),
                  position: LatLng(19.1163, 72.8339),
                  infoWindow: InfoWindow(title: "Sujay Chemist and Druggist"),
                ),
                Marker(
                  markerId: MarkerId('Clinic'),
                  position: LatLng(19.114427, 72.830602),
                  infoWindow: InfoWindow(title: "Nobel Chemist"),
                ),
                Marker(
                  markerId: MarkerId('Clinic'),
                  position: LatLng(19.110405, 72.834130),
                  infoWindow: InfoWindow(title: "New Amarson Chemist"),
                ),
              ]);
            });
          },
          initialCameraPosition:
              CameraPosition(target: LatLng(19.1143, 72.8335), zoom: 15),
        ),
      ),
    );
  }
}
