import 'dart:convert';

import 'package:amplify/screens/home_screen.dart';
import 'package:amplify/utilities/snacbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'internet_bloc.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  final FacebookLogin _fbLogin = new FacebookLogin();
  final String defaultUserImageUrl =
      'https://www.oxfordglobal.co.uk/nextgen-omics-series-us/wp-content/uploads/sites/16/2020/03/Jianming-Xu-e5cb47b9ddeec15f595e7000717da3fe.png';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSigning = false;
  bool get isSigning => _isSigning;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorCode;
  String get errorCode => _errorCode;

  String _name;
  String get name => _name;

  String _gender;
  String get gender => _gender;

  String _trainingTime;
  String get trainingTime => _trainingTime;

  String _uid;
  String get uid => _uid;

  String _email;
  String get email => _email;

  String _imageUrl;
  String get imageUrl => _imageUrl;

  String _signInProvider;
  String get signInProvider => _signInProvider;

  String timestamp;

  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

  handleGoogleSignIn(_scaffoldKey, context) async {
    _isSignedIn = true;
    await signInWithGoogle().then((_) {
      if (hasError == true) {
        openSnacbar(_scaffoldKey,
            'something is wrong. please try ag=========ain.'.tr());
      } else {
        checkUserExists().then((value) {
          if (value == true) {
            getUserDatafromFirebase(uid).then((value) =>
                saveDataToSP().then((value) => setSignIn().then((value) {
                      handleAfterSignIn(context);
                    })));
          } else {
            saveToFirebase().then((value) =>
                saveDataToSP().then((value) => setSignIn().then((value) {
                      handleAfterSignIn(context);
                    })));
          }
        });
      }
    });
  }

  handleFacebbokLogin(scaffoldKey, context) async {
    final InternetBloc ib = Provider.of<InternetBloc>(context, listen: false);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      openSnacbar(scaffoldKey, 'check your internet connection!'.tr());
    } else {
      await signInwithFacebook().then((_) {
        if (hasError == true) {
          openSnacbar(scaffoldKey,
              'error fb login'.tr() + " error : " + errorCode.toString());
        } else {
          checkUserExists().then((value) {
            if (value == true) {
              getUserDatafromFirebase(uid).then((value) =>
                  saveDataToSP().then((value) => setSignIn().then((value) {
                        handleAfterSignIn(context);
                      })));
            } else {
              saveToFirebase().then((value) =>
                  saveDataToSP().then((value) => setSignIn().then((value) {
                        handleAfterSignIn(context);
                      })));
            }
          });
        }
      });
    }
  }

  handleAfterSignIn(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1000)).then((f) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (cc) => HomeScreen()), (route) => false);
    });
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoURL;
        this._uid = userDetails.uid;
        this._signInProvider = 'google';

        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future signInwithFacebook() async {
    try {
      User currentUser;
      final FacebookLoginResult facebookLoginResult =
          await _fbLogin.logIn(['email', 'public_profile']);
      //final FacebookLoginResult facebookLoginResult = await _fbLogin.logIn([]);

      if (facebookLoginResult.status == FacebookLoginStatus.cancelledByUser) {
        _hasError = true;
        _errorCode = 'cancel';
        notifyListeners();
      } else if (facebookLoginResult.status == FacebookLoginStatus.error) {
        _hasError = true;
        _errorCode = facebookLoginResult.errorMessage;
        notifyListeners();
      } else if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        print("facebookLoginResult: " + facebookLoginResult.toString());
        final FacebookAuthCredential credential =
            FacebookAuthProvider.credential(
                facebookLoginResult.accessToken.token);

        await _firebaseAuth.signInWithCredential(credential);

        String fbURl =
            "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}";

        var graphResponse = await http.get(fbURl);

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        assert(profile["email"] != null);
        assert(profile["name"] != null);

        currentUser = _firebaseAuth.currentUser;
        assert(currentUser.uid == currentUser.uid);

        this._name = profile["name"];
        this._email = profile["name"];
        this._imageUrl = "https://graph.facebook.com/" +
            profile["id"] +
            "/picture?type=large&width=720&height=720";
        this._uid = currentUser.uid;
        this._signInProvider = 'facebook';

        _hasError = false;
        notifyListeners();

        print("_errorCode :: " + _errorCode);
      } else {
        _hasError = true;
        _errorCode = "Facebook login option is not there";
        notifyListeners();
      }
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
    print("_errorCode :: " + _errorCode);
  }

  Future signUpwithEmailPassword(
      gender, trainingTime, userEmail, userPassword) async {
    try {
      print("signUpwithEmailPassword");
      final User user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      ))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      this._gender = gender;
      this._trainingTime = trainingTime;
      this._uid = user.uid;
      this._imageUrl = defaultUserImageUrl;
      this._email = user.email;
      this._signInProvider = 'email';

      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();

      print("_errorCode : " + _errorCode);
      notifyListeners();
    }
  }

  Future signInwithEmailPassword(userEmail, userPassword) async {
    try {
      final User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: userEmail, password: userPassword))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final User currentUser = _firebaseAuth.currentUser;
      this._uid = currentUser.uid;
      this._signInProvider = 'email';

      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await firestore.collection('users').doc(_uid).get();
    if (snap.exists) {
      print('User Exists');
      return true;
    } else {
      print('new user');
      return false;
    }
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    var userData = {
      'name': _name,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'timestamp': getTimestamp(),
      'gender': gender,
      'trainingTime': trainingTime,
    };
    await ref.set(userData);
  }

  String getTimestamp() {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
    return timestamp;
  }

  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('name', _name);
    await sp.setString('email', _email);
    await sp.setString('image_url', _imageUrl);
    await sp.setString('uid', _uid);
    await sp.setString('sign_in_provider', _signInProvider);
  }

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    _name = sp.getString('name');
    _email = sp.getString('email');
    _imageUrl = sp.getString('image_url');
    _uid = sp.getString('uid');
    _signInProvider = sp.getString('sign_in_provider');
    notifyListeners();
  }

  Future getUserDatafromFirebase(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap.data()['uid'];
      this._name = snap.data()['name'];
      this._email = snap.data()['email'];
      this._imageUrl = snap.data()['image url'];
      print(_name);
    });
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    print("setSignIn " + _isSignedIn.toString());
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    print("checkSignIn " + _isSignedIn.toString());
    notifyListeners();
  }

  Future userSignout() async {
    if (_signInProvider == 'apple') {
      await _firebaseAuth.signOut();
    } else if (_signInProvider == 'facebook') {
      await _firebaseAuth.signOut();
      await _fbLogin.logOut();
    } else if (_signInProvider == 'email') {
      await _firebaseAuth.signOut();
    } else {
      await _firebaseAuth.signOut();
      await _googlSignIn.signOut();
    }
  }

  Future afterUserSignOut() async {
    await userSignout().then((value) async {
      await clearAllData();
      _isSignedIn = false;
      _guestUser = false;
      notifyListeners();
    });
  }

  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
