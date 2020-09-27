import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_app/globalconstants/constants.dart';

class DoctorDetails extends StatefulWidget {
  final String name;
  final int contact;
  final String specialization;
  final String clinic;
  final double latitude;
  final double longitude;

  // final GeoPoint location;

  DoctorDetails({this.name,
    this.contact,
    this.specialization,
    this.clinic,
    this.longitude,
    this.latitude});

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  var docs = [];
  Set<Marker> _markers = {};

  GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
        backgroundColor: lightGreen,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(widget.name),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("${widget.contact}"),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text(widget.specialization),
            ),
            ListTile(
              title: Text(widget.clinic),
              leading: Icon(Icons.local_hospital),
            ),
            Divider(color: Colors.black, thickness: 1),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.95,
              child: GoogleMap(
                markers: _markers,
                compassEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                onTap: (LatLng loc) {
                  CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 15,
                  );
                },
                onMapCreated: (controller) {
                  setState(() {
                    googleMapController = controller;
                    _markers.add(
                      Marker(
                        markerId: MarkerId('Clinic'),
                        position: LatLng(widget.latitude, widget.longitude),
                        infoWindow: InfoWindow(title: widget.name),
                      ),
                    );
                  });
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
