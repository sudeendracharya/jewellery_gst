import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_billing_screen.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  static const routeName = 'LogInPage';

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, dynamic> logIn = {};

  bool loading = true;

  void save() {
    // Get.toNamed(AddBillingScreen.routeName);
    var endDate = DateFormat('dd-MM-yyyy').format(DateTime(
      2022,
      07,
      23,
    ));
    var startDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    if (startDate == endDate) {
      Get.defaultDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: 'Alert',
        middleText:
            'Your trial period is over please contact the administrator',
        confirm: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Ok'),
        ),
      );
      return;
    }
    print(endDate);
    print(startDate);
    _formKey.currentState!.save();

    print(logIn);
    EasyLoading.show();
    Provider.of<Authenticate>(context, listen: false)
        .logIn(logIn)
        .then((value) {
      EasyLoading.dismiss();
      if (value == 200) {
        Get.toNamed(AddBillingScreen.routeName);
      }
    });
  }

  @override
  void initState() {
    wait();
    super.initState();
  }

  void wait() {
    Future.delayed(const Duration(seconds: 6)).then((value) {
      setState(() {
        loading = false;
        print('wait over');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: loading == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    semanticsLabel: 'Settings things up',
                    semanticsValue: 'Settings things up',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Settings things up')
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Card(
                      child: Container(
                        width: size.width * 0.4,
                        height: size.height * 0.5,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Log In',
                                style: ProjectStyles.headingStyle()
                                    .copyWith(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'User Name',
                                ),
                                onSaved: (value) {
                                  logIn['username'] = value;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                ),
                                onSaved: (value) {
                                  logIn['password'] = value;
                                },
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              SizedBox(
                                width: 150,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: save,
                                  child: Text(
                                    'Log In',
                                    style: ProjectStyles.invoiceheadingStyle()
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
