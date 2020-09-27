import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/api/user_api.dart';
import 'package:hackathon_app/globalconstants/constants.dart';
import 'package:hackathon_app/models/doctor.dart';
import 'package:hackathon_app/notifier/auth_notifier.dart';
import 'package:hackathon_app/notifier/user_notifier.dart';
import 'package:hackathon_app/pages/doctor_detail.dart';
import 'package:provider/provider.dart';

class FindDoctor extends StatefulWidget {
  @override
  _FindDoctorState createState() => _FindDoctorState();
}

class _FindDoctorState extends State<FindDoctor> {
  Map<int, Doctor> _searchedDocs = {};
  bool _foundDoc = true;
  bool _isLoading = false;
  Map<int, Doctor> docList;

  @override
  void initState() {
    setUser();
    super.initState();
  }

  setUser() async {
    setState(() {
      _isLoading = true;
    });
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    await getUserFromFirestore(authNotifier.user, userNotifier);
    docList = await getDoctorsFromFirestore();
    setState(() {
      _isLoading = false;
    });
  }

  _buildLoadingIndicator() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: _isLoading
            ? _buildLoadingIndicator()
            : [
                Column(
                  children: <Widget>[
                    _buildAppBar(height, width),
                    _isLoading ? _buildLoadingIndicator() : _buildSearchList()
                  ],
                ),
                Positioned(
                  top: -27,
                  child: _buildSearchField(height, width),
                ),
              ],
      ),
    );
  }

  _buildAppBar(double height, double width) {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    return Container(
      height: height * 0.20,
      width: width,
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hey,",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: width * 0.15),
                child: Text(
                  userNotifier.user.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildSearchField(double height, double width) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.2, left: width * 0.1),
      width: width * 0.8,
      child: TextField(
        onChanged: (val) {
          setState(() {
            _searchedDocs = {};
          });
          if (val.isNotEmpty) {
            docList.forEach((key, doc) {
              if (doc.name.contains(val.trim()) ||
                  doc.name.toUpperCase().contains(val.trim()) ||
                  doc.name.toLowerCase().contains(val.trim())) {
                setState(() {
                  _searchedDocs[key] = docList[key];
                  print(_searchedDocs[key].name);
                });
              }
            });
            if (_searchedDocs.isEmpty) {
              setState(() {
                _foundDoc = false;
              });
            }
          }
        },
        style: TextStyle(fontSize: 18, color: lightGreen),
        decoration: InputDecoration(
          hintText: "Search Doctor",
          hintStyle: TextStyle(color: Theme.of(context).accentColor),
          suffixIcon: Icon(
            Icons.search,
            size: 30,
            color: Theme.of(context).accentColor,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  _buildSearchList() {
    return Expanded(
      child: _foundDoc
          ? ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        itemCount:
        _searchedDocs.isEmpty ? docList.length : _searchedDocs.length,
        itemBuilder: (context, index) =>
            _buildDoctorListItem(
                (_searchedDocs.isEmpty ? docList : _searchedDocs), index),
        separatorBuilder: (context, index) => SizedBox(height: 20),
      )
          : Center(
        child: Text("No Doctors found with that name"),
      ),
    );
  }

  _buildDoctorListItem(Map<int, Doctor> docs, int index) {
    print(docs[index].name);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DoctorDetails(
                      name: docs[index].name,
                      contact: docs[index].contact,
                      specialization: docs[index].specialization,
                      clinic: docs[index].clinic,
                      latitude: docs[index].latitude,
                      longitude: docs[index].longitude,
                    )));
      },
      child: Container(
        height: 80,
        child: Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: ListTile(
              title: Text(
                docs[index].name,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                docs[index].specialization,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }
}
