import 'package:flutter/material.dart';
import 'package:hackathon_app/api/auth_api.dart';
import 'package:hackathon_app/globalconstants/constants.dart';
import 'package:hackathon_app/notifier/auth_notifier.dart';
import 'package:hackathon_app/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
          backgroundColor: lightGreen,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  userNotifier.user.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  userNotifier.user.email,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: Icon(Icons.perm_identity),
                title: Text(userNotifier.user.gender),
              ),
              SizedBox(height: 10),
              _logoutButton(),
            ],
          ),
        ));
  }

  _logoutButton() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: errorColor,
      onPressed: () async {
        _logoutConfirmationBox(authNotifier);
      },
      child: Text(
        'Logout',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
      ),
    );
  }

  _logoutConfirmationBox(AuthNotifier authNotifier) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout now ?'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton(
            onPressed: () async {
              await signOut(authNotifier);
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
