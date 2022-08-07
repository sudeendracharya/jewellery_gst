import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate with ChangeNotifier {
  var baseUrl = 'https://jewelleryinvoiceapp.herokuapp.com/';
  // var baseUrl = 'http://127.0.0.1:8000/';

  List _signupException = [];
  var _token;
  var _userName;
  var _expiryDate;
  var _errorMessage;

  get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userData')) {
      prefs.remove('userData');
    }

    Get.offAllNamed('/');
  }

  Future<int> logIn(var data) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/login/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        _token = responseData['key'];
        // _userId = responseData['agent']['uId'];
        _expiryDate = DateTime.now().add(
          const Duration(days: 60),
        );
        //_autoLogOut();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'userName': data['username'],
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        prefs.setString('userData', userData);
      }

      if (response.statusCode == 403) {
        logOut();
      }

      if (response.statusCode == 400) {
        // _errorMessage = responseData['non_field_errors'][0];
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _signupException.clear();
        responseData.forEach((key, value) {
          _signupException.add(value);
        });

        Get.defaultDialog(
            title: 'Log In Failed',
            middleText: responseData['non_field_errors'][0],
            confirm: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Ok')));
        notifyListeners();
        return response.statusCode;
        // throw HttpException(responseData['error']['message']);
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: 'Something Went Wrong Please try Again',
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    // logout();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('no token');
      return false;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extratedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    if (extratedUserData["token"] == null) {
      return false;
    }
    log(extratedUserData["token"]);
    _token = extratedUserData["token"];
    _userName = extratedUserData["userName"];
    _expiryDate = expiryDate;
    notifyListeners();
    // _autoLogOut();
    return true;
  }
}
