import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hackathon_app/api/auth_api.dart';
import 'package:hackathon_app/authscreen/auth_screen.dart';
import 'package:hackathon_app/globalconstants/constants.dart';
import 'package:hackathon_app/globalconstants/loading.dart';
import 'package:hackathon_app/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoading = true;

  @override
  void initState() {
    _initializeCurrentUser();
    super.initState();
  }

  _initializeCurrentUser() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    await initializeCurrentUser(authNotifier);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return _isLoading ? Loading() : Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildClippedContainer(height),
            SizedBox(height: height * 0.15),
            _buildBody(),
            SizedBox(height: height * 0.22),
            _buildFooterButtons(context),
          ],
        ),
      ),
    );
  }

  _buildFooterButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildFooterButton(context, 'Continue', AuthType.SignIn),
        ],
      ),
    );
  }

  _buildFooterButton(BuildContext context, String text, AuthType auth) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
      elevation: 5.0,
      color: greenColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        print(auth);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                AuthScreen(
                  authType: auth,
                )));
      },
      child: Text(
        text,
        style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        Text(
          'Welcome To',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: greenColor,
          ),
        ),
        Text(
          'Medicino',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: greenColor,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Find your medicine!',
          style: TextStyle(
            fontSize: 18,
            color: greenColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  _buildClippedContainer(double height) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: height * 0.3,
        decoration: BoxDecoration(color: lightGreen),
        child: Center(
          child: Text(
            'Medicino',
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
