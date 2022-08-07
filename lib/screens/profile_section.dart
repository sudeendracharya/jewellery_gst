import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_billing_screen.dart';
import 'converted_list.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/ProfilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> convertDetails = {};
  GlobalKey<FormState> _formKey = GlobalKey();

  var selectedDate;

  Map<String, dynamic> profileData = {};

  var selectedMeasure;

  var selectedConversionTo;

  @override
  void initState() {
    EasyLoading.show();
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getProfileData(token)
          .then((value) {
        EasyLoading.dismiss();
      });
    });

    super.initState();
  }

  void getProfile() {
    getToken().then((value) {});
    Provider.of<ApiCalls>(context, listen: false).getProfileData(token);
  }

  var token;
  Future<void> getToken() async {
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      token = Provider.of<Authenticate>(context, listen: false).token;
    });
  }

  void savePurchase() {
    _formKey.currentState!.save();
    convertDetails['Created_Date'] =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    print(convertDetails);
    getToken().then((value) {
      Provider.of<ApiCalls>(context, listen: false)
          .convertOldItem(convertDetails, token)
          .then((value) {
        if (value == 201 || value == 200) {
          Get.back();
          Get.showSnackbar(const GetSnackBar(
            title: 'Success',
            message: 'Successfully saved the data',
            duration: Duration(seconds: 4),
          ));
          getProfile();
        } else {
          Get.showSnackbar(const GetSnackBar(
            title: 'Failed',
            message: 'Something went wrong unable to add data',
            duration: Duration(seconds: 4),
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var formWidth = size.width * 0.25;
    var bottomPadding = size.height * 0.02;
    var dialogFormWidth = size.width * 0.4;
    var formheight = size.height * 0.05;
    profileData = Provider.of<ApiCalls>(context).profileData;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Old Inventory',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          // ElevatedButton.icon(
          //     onPressed: () {},
          //     icon: const Icon(Icons.add),
          //     label: const Text('Convert Old Gold/Silver'))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04, vertical: size.height * 0.02),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Card(
                child: Container(
                  width: size.width * 0.3,
                  height: size.height * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Cash In Hand: ',
                      //       style: ProjectStyles.headingStyle()
                      //           .copyWith(color: Colors.black),
                      //     ),
                      //     Text(
                      //       profileData['cashInHand'] == null
                      //           ? ''
                      //           : profileData['cashInHand'].toString(),
                      //       style: ProjectStyles.headingStyle()
                      //           .copyWith(color: Colors.black),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Pure Gold: ',
                      //       style: ProjectStyles.headingStyle()
                      //           .copyWith(color: Colors.black),
                      //     ),
                      //     Text(
                      //       '${profileData['PureGold'] == null ? '' : profileData['PureGold'].toString()} (g)',
                      //       style: ProjectStyles.headingStyle()
                      //           .copyWith(color: Colors.black),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Old Gold: ',
                            style: ProjectStyles.headingStyle()
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            '${profileData['OldGold'] == null ? '' : profileData['OldGold'].toString()} (g)',
                            style: ProjectStyles.headingStyle()
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Pure Silver: ',
                      //       style: ProjectStyles.headingStyle()
                      //           .copyWith(color: Colors.black),
                      //     ),
                      //     Text(
                      //       '${profileData['PureSilver'] == null ? '' : profileData['PureSilver'].toString()} (g)',
                      //       style: ProjectStyles.headingStyle()
                      //           .copyWith(color: Colors.black),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Old Silver: ',
                            style: ProjectStyles.headingStyle()
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            ' ${profileData['OldSilver'] == null ? '' : profileData['OldSilver'].toString()} (g)',
                            style: ProjectStyles.headingStyle()
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Get.toNamed(ConvertedList.routeName);
                      },
                      child: const Text('View Converted List')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.dialog(
                          Dialog(
                            child: StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                return Container(
                                  width: size.width * 0.5,
                                  height: size.height * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02,
                                      vertical: size.height * 0.02,
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Convert Old Gold/Silver',
                                              style:
                                                  ProjectStyles.headingStyle()
                                                      .copyWith(
                                                          color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.03,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: dialogFormWidth,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Item Name'),
                                                      TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: dialogFormWidth,
                                                  height: formheight,
                                                  // alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        value: selectedDate,
                                                        items: [
                                                          'Gold',
                                                          'Silver',
                                                        ].map<
                                                            DropdownMenuItem<
                                                                String>>((e) {
                                                          return DropdownMenuItem(
                                                            child: Text(
                                                              e,
                                                              style: ProjectStyles
                                                                      .invoiceheadingStyle()
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            value: e,
                                                            onTap: () {
                                                              convertDetails[
                                                                      'Metal_Type'] =
                                                                  e.toString();

                                                              // firmId = e['Firm_Code'];
                                                              // user['User_Role_Name'] = e['Role_Name'];
                                                            },
                                                          );
                                                        }).toList(),
                                                        hint: Text(
                                                          'Select Item',
                                                          style: ProjectStyles
                                                                  .invoiceheadingStyle()
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        style: ProjectStyles
                                                                .invoiceheadingStyle()
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                        iconDisabledColor:
                                                            Colors.black,
                                                        iconEnabledColor:
                                                            Colors.black,
                                                        dropdownColor:
                                                            Colors.white,
                                                        alignment:
                                                            Alignment.center,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedDate =
                                                                value as String;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding: const EdgeInsets.symmetric(
                                                  //       horizontal: 12, vertical: 6),
                                                  //   child: TextFormField(
                                                  //     decoration: const InputDecoration(
                                                  //         hintText: 'Enter Item Name',
                                                  //         border: InputBorder.none),
                                                  //     validator: (value) {
                                                  //       if (value!.isEmpty) {
                                                  //         // showError('FirmCode');
                                                  //         return 'Item Name cannot be empty';
                                                  //       }
                                                  //     },
                                                  //     onSaved: (value) {
                                                  //       purchaseDetails['Item_Name'] =
                                                  //           value;
                                                  //     },
                                                  //   ),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: dialogFormWidth,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              'Gross Weight (g)'),
                                                      TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: dialogFormWidth,
                                                  height: formheight,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Enter Gross Weight',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          // showError('FirmCode');
                                                          return 'Gross Amount cannot be empty';
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        convertDetails[
                                                                'Gross_Weight'] =
                                                            value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: size.height * 0.03,
                                            // ),
                                            // Column(
                                            //   mainAxisSize: MainAxisSize.min,
                                            //   children: [
                                            //     Container(
                                            //       width: dialogFormWidth,
                                            //       padding:
                                            //           const EdgeInsets.only(
                                            //               bottom: 12),
                                            //       child: const Text.rich(
                                            //         TextSpan(children: [
                                            //           TextSpan(
                                            //               text:
                                            //                   'Measure Wastage'),
                                            //           TextSpan(
                                            //               text: '*',
                                            //               style: TextStyle(
                                            //                   color:
                                            //                       Colors.red))
                                            //         ]),
                                            //       ),
                                            //     ),
                                            //     Container(
                                            //       width: dialogFormWidth,
                                            //       height: formheight,
                                            //       // alignment: Alignment.center,
                                            //       decoration: BoxDecoration(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 8),
                                            //         color: Colors.white,
                                            //         border: Border.all(
                                            //             color: Colors.black26),
                                            //       ),
                                            //       child: Padding(
                                            //         padding:
                                            //             const EdgeInsets.all(
                                            //                 8.0),
                                            //         child:
                                            //             DropdownButtonHideUnderline(
                                            //           child: DropdownButton(
                                            //             value: selectedMeasure,
                                            //             items: [
                                            //               'Percentage',
                                            //               'Gram',
                                            //             ].map<
                                            //                 DropdownMenuItem<
                                            //                     String>>((e) {
                                            //               return DropdownMenuItem(
                                            //                 child: Text(
                                            //                   e,
                                            //                   style: ProjectStyles
                                            //                           .invoiceheadingStyle()
                                            //                       .copyWith(
                                            //                           fontSize:
                                            //                               14,
                                            //                           color: Colors
                                            //                               .black),
                                            //                 ),
                                            //                 value: e,
                                            //                 onTap: () {
                                            //                   convertDetails[
                                            //                           'Wastage_Measure'] =
                                            //                       e.toString();

                                            //                   // firmId = e['Firm_Code'];
                                            //                   // user['User_Role_Name'] = e['Role_Name'];
                                            //                 },
                                            //               );
                                            //             }).toList(),
                                            //             hint: Text(
                                            //               'Select Measure',
                                            //               style: ProjectStyles
                                            //                       .invoiceheadingStyle()
                                            //                   .copyWith(
                                            //                       fontSize: 14,
                                            //                       color: Colors
                                            //                           .black),
                                            //             ),
                                            //             style: ProjectStyles
                                            //                     .invoiceheadingStyle()
                                            //                 .copyWith(
                                            //                     fontSize: 14,
                                            //                     color: Colors
                                            //                         .black),
                                            //             iconDisabledColor:
                                            //                 Colors.black,
                                            //             iconEnabledColor:
                                            //                 Colors.black,
                                            //             dropdownColor:
                                            //                 Colors.white,
                                            //             alignment:
                                            //                 Alignment.center,
                                            //             onChanged: (value) {
                                            //               setState(() {
                                            //                 selectedMeasure =
                                            //                     value as String;
                                            //               });
                                            //             },
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       // Padding(
                                            //       //   padding: const EdgeInsets.symmetric(
                                            //       //       horizontal: 12, vertical: 6),
                                            //       //   child: TextFormField(
                                            //       //     decoration: const InputDecoration(
                                            //       //         hintText: 'Enter Item Name',
                                            //       //         border: InputBorder.none),
                                            //       //     validator: (value) {
                                            //       //       if (value!.isEmpty) {
                                            //       //         // showError('FirmCode');
                                            //       //         return 'Item Name cannot be empty';
                                            //       //       }
                                            //       //     },
                                            //       //     onSaved: (value) {
                                            //       //       purchaseDetails['Item_Name'] =
                                            //       //           value;
                                            //       //     },
                                            //       //   ),
                                            //       // ),
                                            //     ),
                                            //   ],
                                            // ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: dialogFormWidth,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Wastage %'),
                                                      TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: dialogFormWidth,
                                                  height: formheight,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Enter Wastage',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      validator: (value) {},
                                                      onSaved: (value) {
                                                        convertDetails[
                                                            'Wastage'] = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: dialogFormWidth,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              'Net Weight (g)'),
                                                      TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: dialogFormWidth,
                                                  height: formheight,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Enter Net Weight',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          // showError('FirmCode');
                                                          return 'Net Amount cannot be empty';
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        convertDetails[
                                                                'Net_Weight'] =
                                                            value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.03,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: dialogFormWidth,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Convert To'),
                                                      TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: dialogFormWidth,
                                                  height: formheight,
                                                  // alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        value:
                                                            selectedConversionTo,
                                                        items: [
                                                          'Gold_Bullion',
                                                          'Silver_Bullion',
                                                          'Gold_Ornament',
                                                          'Silver_Ornament',
                                                        ].map<
                                                            DropdownMenuItem<
                                                                String>>((e) {
                                                          return DropdownMenuItem(
                                                            child: Text(
                                                              e,
                                                              style: ProjectStyles
                                                                      .invoiceheadingStyle()
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            value: e,
                                                            onTap: () {
                                                              convertDetails[
                                                                      'Convert_To'] =
                                                                  e.toString();

                                                              // firmId = e['Firm_Code'];
                                                              // user['User_Role_Name'] = e['Role_Name'];
                                                            },
                                                          );
                                                        }).toList(),
                                                        hint: Text(
                                                          'Select Measure',
                                                          style: ProjectStyles
                                                                  .invoiceheadingStyle()
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        style: ProjectStyles
                                                                .invoiceheadingStyle()
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                        iconDisabledColor:
                                                            Colors.black,
                                                        iconEnabledColor:
                                                            Colors.black,
                                                        dropdownColor:
                                                            Colors.white,
                                                        alignment:
                                                            Alignment.center,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedConversionTo =
                                                                value as String;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding: const EdgeInsets.symmetric(
                                                  //       horizontal: 12, vertical: 6),
                                                  //   child: TextFormField(
                                                  //     decoration: const InputDecoration(
                                                  //         hintText: 'Enter Item Name',
                                                  //         border: InputBorder.none),
                                                  //     validator: (value) {
                                                  //       if (value!.isEmpty) {
                                                  //         // showError('FirmCode');
                                                  //         return 'Item Name cannot be empty';
                                                  //       }
                                                  //     },
                                                  //     onSaved: (value) {
                                                  //       purchaseDetails['Item_Name'] =
                                                  //           value;
                                                  //     },
                                                  //   ),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: dialogFormWidth,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Loss Amount'),
                                                      TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: dialogFormWidth,
                                                  height: formheight,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Enter Amount',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          // showError('FirmCode');
                                                          return 'Amount cannot be empty';
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        convertDetails[
                                                                'Loss_Amount'] =
                                                            value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: dialogFormWidth,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Description'),
                                                      // TextSpan(
                                                      //     text: '*',
                                                      //     style: TextStyle(color: Colors.red))
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: dialogFormWidth,
                                                  height: formheight + 20,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Enter Description',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      validator: (value) {},
                                                      onSaved: (value) {
                                                        convertDetails[
                                                                'Description'] =
                                                            value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.04,
                                            ),
                                            Container(
                                              width: dialogFormWidth,
                                              height: formheight,
                                              child: ElevatedButton(
                                                onPressed: savePurchase,
                                                child: const Text('Save'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text('Convert Old Gold/Silver'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

var data = {
  'Name': 'Gold/Silver',
  'Net_Weight': 'data',
  'Wastage_Measure': 'Percentage/Grams',
  'Wastage': 'data',
  'Gross_Weight': 'data',
  'Loss_Amount': 'data',
};

var data1 = {
  "Gold_Bullion": [
    {
      "Gold_Bullion_Stock_Id": 63,
      "Opening_Weight": "1000.00",
      "Rate": "4000.00",
      "Amount": "0.00",
      "Sales": "150.00",
      "Purchases": "500.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1350.00",
      "created_Date": "2022-05-18T11:53:10.717791"
    }
  ],
  "Gold_Ornament": [
    {
      "Gold_Ornament_Stock_Id": 26,
      "Opening_Weight": "1000.00",
      "Rate": "4500.00",
      "Amount": "4500000.00",
      "Sales": "50.00",
      "Purchases": "150.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1100.00",
      "created_Date": "2022-05-18T11:53:12.997611"
    }
  ],
  "Silver_Bullion": [
    {
      "Silver_Bullion_Stock_Id": 27,
      "Opening_Weight": "1000.00",
      "Rate": "63.70",
      "Amount": "6370.00",
      "Sales": "150.00",
      "Purchases": "500.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1350.00",
      "created_Date": "2022-05-18T11:53:11.852490"
    }
  ],
  "Silver_Oranament": [
    {
      "Silver_Ornament_Stock_Id": 23,
      "Opening_Weight": "100.00",
      "Rate": "63.70",
      "Amount": "6370.00",
      "Sales": "50.00",
      "Purchases": "200.00",
      "Item_Name": "",
      "Converted_Weight": "0.00",
      "Closing_Weight": "250.00",
      "created_Date": "2022-05-18T11:53:14.138277"
    }
  ],
  "Old_Gold ": [
    {
      "Old_Gold_Id": 23,
      "Old_Gold_Opening_Stock": "0.00",
      "Old_Gold_Weight": "50.00",
      "Old_Gold_Closing_Stock": "50.00",
      "Exchange_Weight": "0.00",
      "Converted_Weight": "0.00",
      "created_Date": "2022-05-18T11:53:15.283694"
    }
  ],
  "Old_Silver": [
    {
      "Old_Silver_Id": 25,
      "Old_Silver_Opening_Stock": "0.00",
      "Old_Silver_Weight": "50.00",
      "Old_Silver_Closing_Stock": "50.00",
      "Exchange_Weight": "0.00",
      "Converted_Weight": "0.00",
      "created_Date": "2022-05-18T11:53:16.419264"
    }
  ]
};

var dfata = {
  "Gold_Bullion": [
    {
      "Gold_Bullion_Stock_Id": 63,
      "Opening_Weight": "1000.00",
      "Rate": "4000.00",
      "Amount": "0.00",
      "Sales": "300.00",
      "Purchases": "500.00",
      "Converted_Weight": "50.00",
      "Closing_Weight": "1250.00",
      "created_Date": "2022-05-18T11:53:10.717791"
    }
  ],
  "Gold_Ornament": [
    {
      "Gold_Ornament_Stock_Id": 26,
      "Opening_Weight": "1000.00",
      "Rate": "4500.00",
      "Amount": "4500000.00",
      "Sales": "100.00",
      "Purchases": "150.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1050.00",
      "created_Date": "2022-05-18T11:53:12.997611"
    }
  ],
  "Silver_Bullion": [
    {
      "Silver_Bullion_Stock_Id": 27,
      "Opening_Weight": "1000.00",
      "Rate": "63.70",
      "Amount": "6370.00",
      "Sales": "300.00",
      "Purchases": "500.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1200.00",
      "created_Date": "2022-05-18T11:53:11.852490"
    }
  ],
  "Silver_Oranament": [
    {
      "Silver_Ornament_Stock_Id": 23,
      "Opening_Weight": "100.00",
      "Rate": "63.70",
      "Amount": "6370.00",
      "Sales": "100.00",
      "Purchases": "200.00",
      "Item_Name": "",
      "Converted_Weight": "0.00",
      "Closing_Weight": "200.00",
      "created_Date": "2022-05-18T11:53:14.138277"
    }
  ],
  "Old_Gold ": [
    {
      "Old_Gold_Id": 23,
      "Old_Gold_Opening_Stock": "0.00",
      "Old_Gold_Weight": "200.00",
      "Old_Gold_Closing_Stock": "150.00",
      "Exchange_Weight": "0.00",
      "Converted_Weight": "50.00",
      "created_Date": "2022-05-18T11:53:15.283694"
    }
  ],
  "Old_Silver": [
    {
      "Old_Silver_Id": 25,
      "Old_Silver_Opening_Stock": "0.00",
      "Old_Silver_Weight": "200.00",
      "Old_Silver_Closing_Stock": "200.00",
      "Exchange_Weight": "0.00",
      "Converted_Weight": "0.00",
      "created_Date": "2022-05-18T11:53:16.419264"
    }
  ]
};

var t = {
  "Gold_Bullion": [
    {
      "Gold_Bullion_Stock_Id": 63,
      "Opening_Weight": "1000.00",
      "Rate": "4000.00",
      "Amount": "0.00",
      "Sales": "300.00",
      "Purchases": "500.00",
      "Converted_Weight": "50.00",
      "Closing_Weight": "1250.00",
      "created_Date": "2022-05-18T11:53:10.717791"
    }
  ],
  "Gold_Ornament": [
    {
      "Gold_Ornament_Stock_Id": 26,
      "Opening_Weight": "1000.00",
      "Rate": "4500.00",
      "Amount": "4500000.00",
      "Sales": "100.00",
      "Purchases": "150.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1050.00",
      "created_Date": "2022-05-18T11:53:12.997611"
    }
  ],
  "Silver_Bullion": [
    {
      "Silver_Bullion_Stock_Id": 27,
      "Opening_Weight": "1000.00",
      "Rate": "63.70",
      "Amount": "6370.00",
      "Sales": "300.00",
      "Purchases": "500.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1200.00",
      "created_Date": "2022-05-18T11:53:11.852490"
    }
  ],
  "Silver_Oranament": [
    {
      "Silver_Ornament_Stock_Id": 23,
      "Opening_Weight": "100.00",
      "Rate": "63.70",
      "Amount": "6370.00",
      "Sales": "100.00",
      "Purchases": "200.00",
      "Item_Name": "",
      "Converted_Weight": "0.00",
      "Closing_Weight": "200.00",
      "created_Date": "2022-05-18T11:53:14.138277"
    }
  ],
  "Old_Gold ": [
    {
      "Old_Gold_Id": 23,
      "Old_Gold_Opening_Stock": "0.00",
      "Old_Gold_Weight": "200.00",
      "Old_Gold_Closing_Stock": "150.00",
      "Exchange_Weight": "0.00",
      "Converted_Weight": "50.00",
      "created_Date": "2022-05-18T11:53:15.283694"
    }
  ],
  "Old_Silver": [
    {
      "Old_Silver_Id": 25,
      "Old_Silver_Opening_Stock": "0.00",
      "Old_Silver_Weight": "200.00",
      "Old_Silver_Closing_Stock": "200.00",
      "Exchange_Weight": "0.00",
      "Converted_Weight": "0.00",
      "created_Date": "2022-05-18T11:53:16.419264"
    }
  ]
};
