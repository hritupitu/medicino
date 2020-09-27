import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/home/find_doctor.dart';
import 'package:hackathon_app/pages/pharmacy.dart';
import 'package:hackathon_app/pages/symptom_check.dart';
import 'package:hackathon_app/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final pageOptions = [
    FindDoctor(),
    SymptomCheck(),
    Pharmacy(),
    ProfilePage(),
  ];

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit '),
            content: Text('Are you sure you want to exit ?'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pageOptions[currentPage], //pageOptions[currentPage],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: SizedBox(
            height: 60,
            child: CupertinoTabBar(
              currentIndex: currentPage,
              activeColor: Colors.indigo[100],
              inactiveColor: Colors.white,
              iconSize: 35,
              backgroundColor: Colors.lightGreen,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home)),
                BottomNavigationBarItem(icon: Icon(Icons.error)),
                BottomNavigationBarItem(icon: Icon(Icons.explore)),
                BottomNavigationBarItem(icon: Icon(Icons.person)),
              ],
              onTap: (index) async {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
