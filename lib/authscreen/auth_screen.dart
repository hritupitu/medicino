import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/api/auth_api.dart';
import 'package:hackathon_app/globalconstants/constants.dart';
import 'package:hackathon_app/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';

enum AuthType { SignIn, SignUp }

class AuthScreen extends StatefulWidget {
  final AuthType authType;

  const AuthScreen({this.authType});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthType authType = AuthType.SignIn;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _alertFormKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isEmailVerified = false;
  String passwordResetEmail = '';
  String forgotPasswordError = '';
  bool resend = false;
  String gender;
  String selectedDropdown;
  List<String> genderList = ["Male", "Female", "Others"];

  @override
  void initState() {
    super.initState();
    selectedDropdown = 'Male';
  }

  switchForm() {
    setState(() {
      authType =
          (authType == AuthType.SignIn ? AuthType.SignUp : AuthType.SignIn);
    });
  }

  validateAndSendMail(String resetEmail) async {
    if (!_alertFormKey.currentState.validate()) {
      return;
    }
    try {
      await sendResetPasswordEmail(email);
      setState(() => forgotPasswordError = '');
    } catch (error) {
      setState(() => forgotPasswordError = handleForgotPasswordErrors(error));
    }
    Navigator.pop(context);
    showForgotPasswordDialog(context);
  }

  validateAndSubmitForm() async {
    if (!_formKey.currentState.validate())
      return;
    else {
      AuthNotifier authNotifier =
          Provider.of<AuthNotifier>(context, listen: false);
      if (authType == AuthType.SignUp) {
        await signUp(email, password, name, gender, authNotifier);
        if (authNotifier.error.isEmpty) {
          showEmailLinkSentAfterSignUpDialog(context);
          switchForm();
        } else
          showErrorDialog(context);
      } else if (authType == AuthType.SignIn) {
        await login(email, password, authNotifier);
        if (authNotifier.error.isEmpty) {
          Navigator.pop(context);
        } else {
          showErrorDialog(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(greenColor)),
            )
          : SingleChildScrollView(
              child: _buildBody(),
            ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: lightGreen,
      title: Text(authType == AuthType.SignIn ? 'Sign In' : 'Sign Up'),
      elevation: 0.0,
      centerTitle: true,
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            authType == AuthType.SignIn ? SizedBox(height: 100) : Container(),
            authType == AuthType.SignUp
                ? _buildTextFormField('Enter your Name', Icons.person, false)
                : Container(),
            _buildTextFormField('Enter your Email', Icons.email, false),

            _buildTextFormField('Enter your Password', Icons.lock, true),
            authType == AuthType.SignUp
                ? _buildTextFormField('Confirm your Password', Icons.lock, true)
                : Container(),
            authType == AuthType.SignIn
                ? _buildForgotPasswordButton(context)
                : Container(),
            authType == AuthType.SignUp
                ? _buildGenderDropDown()
                : Container(),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  _buildGenderDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.person),
          SizedBox(width: 10),
          DropdownButton<String>(
            hint: Text("Select Gender"),
            style: TextStyle(
                fontSize: 18,
                color: greenColor,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500),
            value: selectedDropdown,
            items: <String>['Male', 'Female', 'Others'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value, style: TextStyle(color: greenColor),),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                selectedDropdown = val;
                gender = val;
              });
            },
          )
        ],
      ),
    );
  }

  _buildTextFormField(String hintText, IconData icon, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: TextFormField(
        initialValue:
        authType == AuthType.SignIn && hintText
            .split(' ')
            .last == 'Email'
            ? email
            : '',
        validator: (val) {
          if (val.trim().isEmpty) {
            return "${hintText.split(' ').last} can't be empty";
          } else if (obscureText && val.trim().length <= 6) {
            return 'Password has to be more than 6 characters long';
          } else if (confirmPassword != password &&
              hintText.split(' ').first == 'Confirm' &&
              authType == AuthType.SignUp) {
            return "Password's don't match";
          } else {
            return null;
          }
        },
        onChanged: (val) {
          String varCheck = hintText.split(' ').last;
          if (varCheck == 'Email') {
            email = val.trim();
          } else if (varCheck == 'Name') {
            name = val.trim();
          } else if (hintText.split(' ').first == 'Confirm') {
            confirmPassword = val.trim();
          } else {
            password = val.trim();
          }
        },
        obscureText: obscureText,
        style: TextStyle(
            fontSize: obscureText ? 25 : 18,
            color: greenColor,
            letterSpacing: 0.5,
            fontWeight: obscureText ? FontWeight.bold : FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          prefixIcon: Icon(
            icon,
            size: 25,
          ),
        ),
      ),
    );
  }

  _buildForgotPasswordButton(BuildContext parentContext) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Align(
        child: GestureDetector(
          onTap: () => showResetPasswordDialog(parentContext),
          child: Text(
            'Forgot Password ?',
            style: TextStyle(
                fontSize: 16.5, color: lightGreen, fontWeight: FontWeight.w600),
          ),
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  showForgotPasswordDialog(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text(
          'Alert',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(forgotPasswordError.isEmpty
            ? 'Email has been sent to your account.'
            : forgotPasswordError),
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

  showEmailLinkSentAfterSignUpDialog(BuildContext parentContext) {
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

  showErrorDialog(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text(
          'Alert',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Consumer<AuthNotifier>(
            builder: (context, notifier, child) => Text(notifier.error)),
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

  showResetPasswordDialog(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _alertFormKey,
          child: TextFormField(
            initialValue: email,
            autofocus: true,
            autovalidate: true,
            onChanged: (val) => email = val.trim(),
            validator: (val) =>
                val.isEmpty ? "Please enter a valid email" : null,
            style: TextStyle(color: greenColor),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.mail),
            ),
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: <Widget>[
          _buildAlertButton(context, 'Send'),
          _buildAlertButton(context, 'Cancel'),
        ],
      ),
    );
  }

  _buildAlertButton(BuildContext context, String text) {
    return FlatButton(
      onPressed: () =>
          text == 'Send' ? validateAndSendMail(email) : Navigator.pop(context),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.3, vertical: 18),
        color: lightGreen,
        onPressed: () => validateAndSubmitForm(),
        child: Consumer<AuthNotifier>(
          builder: (context, notifier, child) => !notifier.isLoading
              ? Text(
                  'Continue'.toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 2.5,
                ),
        ),
      ),
    );
  }

  _buildAuthProviderButton(String filePath, String buttonType) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return MaterialButton(
      padding: EdgeInsets.all(16),
      onPressed: () async {
        if (buttonType == "google") {
          await googleSignIn(authNotifier, gender);
          if (authNotifier.error.isEmpty) {
            Navigator.pop(context);
          } else {
            showErrorDialog(context);
          }
        }
      },
      shape: CircleBorder(
          side: BorderSide(
              color: Theme.of(context).secondaryHeaderColor, width: 1.0)),
      child: Image.asset(
        filePath,
        fit: BoxFit.fitHeight,
        height: 30,
      ),
    );
  }

  _buildAuthProviderLogo() {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildAuthProviderButton('assets/google_logo.png', 'google'),
        ],
      ),
    );
  }

  _buildFooterText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: GestureDetector(
        onTap: () => switchForm(),
        child: Text(
          authType == AuthType.SignIn
              ? "Don't have an account yet? Sign Up"
              : "Already have an account? Sign in",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: lightGreen, fontSize: 17.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  _buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildAuthProviderLogo(),
        _buildFooterText(),
      ],
    );
  }
}
