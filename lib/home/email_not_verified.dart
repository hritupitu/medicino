import 'package:flutter/material.dart';
import 'package:hackathon_app/api/auth_api.dart';
import 'package:hackathon_app/globalconstants/constants.dart';
import 'package:hackathon_app/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';

class EmailNotVerifiedPage extends StatefulWidget {
  @override
  _EmailNotVerifiedPageState createState() => _EmailNotVerifiedPageState();
}

class _EmailNotVerifiedPageState extends State<EmailNotVerifiedPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightGreen,
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => signOut(authNotifier))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildClippedContainer(height * 0.2),
            SizedBox(height: height * 0.15),
            _buildBody(authNotifier),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  _buildFloatingActionButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () => checkEmailVerification(),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      icon: Consumer<AuthNotifier>(
        builder: (context, notifier, child) => notifier.isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )
            : Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.white,
              ),
      ),
      color: lightGreen,
      label: Text(
        'Proceed',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  _buildBody(AuthNotifier authNotifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to the App,',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            (authNotifier.user.displayName != null ||
                    authNotifier.user.displayName.isNotEmpty)
                ? "${authNotifier.user.displayName} :)"
                : "User :)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(height: 15),
          Text(
            'Please verify your email to proceed...',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: errorColor,
            ),
          ),
        ],
      ),
    );
  }

  checkEmailVerification() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    bool isVerified = await checkEmailVerifiedFromFirebase(authNotifier);
    if (!isVerified) showEmailVerifyAlert(context);
  }

  showEmailVerifyAlert(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text(
          'Verify Email',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Please verify your email before proceeding.'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: <Widget>[
          _buildEmailVerifyAlertButton(context, 'RESEND'),
          _buildEmailVerifyAlertButton(context, 'OK'),
        ],
      ),
    );
  }

  _buildEmailVerifyAlertButton(BuildContext context, String text) {
    return FlatButton(
      onPressed: () {
        if (text == 'RESEND') {
          resendEmail();
          Navigator.pop(context);
          showEmailLinkSentConfirmationDialog(context);
        } else
          Navigator.pop(context);
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  showEmailLinkSentConfirmationDialog(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text(
          'Check Mail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
            'An email has been sent to your account. Please verify link to proceed.'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  _buildClippedContainer(double height) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(color: lightGreen),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Medicino',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
