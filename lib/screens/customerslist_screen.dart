import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../providers/classes.dart';
import '../styles.dart';
import 'add_billing_screen.dart';

class CustomersListScreen extends StatefulWidget {
  CustomersListScreen({Key? key}) : super(key: key);

  static const routeName = '/CustomersListScreen';

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  List customersList = [];

  var customerId;

  var selectedDeductionType;

  var updateDetailsData;

  var selectedIdProof;

  var selectedPaymentType;

  var editablecusId;

  Map<String, dynamic> advance = {};

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getCustomersList(token, 'Customer')
          .then((value) => null);
    });
    super.initState();
  }

  TextEditingController customerNameController = TextEditingController();
  TextEditingController creditBalanceController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();

  bool nameValidation = true;
  String nameValidationMessage = '';
  bool mobileNumberValidation = true;
  String mobileNumberValidationMessage = '';
  bool selectedIdValidation = true;
  String selectedIdValidationMessage = '';
  bool idControllerValidation = true;
  String idControllerValidationMessage = '';
  bool addressControllerValidation = true;
  String addressControllerValidationMessage = '';
  bool openingBalanceControllerValidation = true;
  String openingBalanceControllerValidationMessage = '';

  Container getField(
      TextEditingController controller, String labelText, bool enabled) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        enabled: enabled,
        // maxLines: 3,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Container getErrorField(String labelText) {
    return Container(
        alignment: Alignment.centerLeft,
        width: 500,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 241, 237, 170)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          labelText,
          style: const TextStyle(color: Colors.black),
        ));
  }

  void fetch() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getCustomersList(token, 'Customer')
          .then((value) => null);
    });
  }

  Map<String, dynamic> saveCustomerInvoice = {};

  TextEditingController rateController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  void save() {
    saveCustomerInvoice = {
      'Customer_Id': customerId,
      'Customer_Name': customerNameController.text,
      'Deduct_From': selectedDeductionType.toString(),
      'Credit_Amount': creditBalanceController.text,
      'Paid_Amount': paidAmountController.text,
      'Payment_Type': selectedPaymentType,
      'Rate': rateController.text,
      'Weight': weightController.text,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };
    print(saveCustomerInvoice);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .addCustomerCreditInvoice(saveCustomerInvoice, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201) {
          selectedDeductionType = null;
          creditBalanceController.text = '';
          paidAmountController.text = '';
          selectedPaymentType = null;
          Get.back();
          successSnackbar(
            'Successfully Updated the credit balance ',
          );
          fetch();
        } else {
          failureSnackbar(
            'Something Went wrong unable to update the credit balance',
          );
        }
      });
    });
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  int defaultRowsPerPage = 5;
  bool selectedDeductedFromvalidation = true;
  bool paidAmountValidation = true;
  bool selectedPaymentTypevalidation = true;

  String selectedDeductedFromvalidationMessage = '';
  String paidAmountValidationMessage = '';
  String selectedPaymentTypevalidationMessage = '';

  void update(Map<String, dynamic> data) {
    customerId = data['Customer_Id'];
    customerNameController.text = data['Customer_Name'];
    // creditBalanceController.text = data['Credit_Balance'].toString();
    selectedDeductedFromvalidation = true;
    paidAmountValidation = true;
    selectedPaymentTypevalidation = true;
    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          return Container(
            width: size.width * 0.35,
            height: size.height * 0.6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credit Invoice',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      getField(customerNameController, 'Customer Name', false),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 500,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedDeductionType,
                            items: [
                              'Payable',
                              'Receivable',
                            ].map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: 415,
                                    child: Text(
                                      e,
                                      // style: TextStyle(
                                      //   fontSize: 14,
                                      //   color: Colors.black,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ),
                                ),
                                value: e,
                                onTap: () {
                                  if (e == 'Payable') {
                                    creditBalanceController.text =
                                        data['Payable'].toString();
                                    setState(() {});
                                  } else if (e == 'Receivable') {
                                    creditBalanceController.text =
                                        data['Receivable'].toString();
                                    setState(() {});
                                  }
                                  // firmId = e['Firm_Code'];
                                  // user['User_Role_Name'] = e['Role_Name'];
                                },
                              );
                            }).toList(),
                            hint: const Text(
                              'Deduct From',
                              // style: TextStyle(
                              //   fontSize: 14,
                              //   color: Colors.black,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),

                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            // alignment: Alignment.center,
                            onChanged: (value) {
                              setState(() {
                                selectedDeductionType = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      selectedDeductedFromvalidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  selectedDeductedFromvalidationMessage),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      getField(
                          creditBalanceController, 'Credit Balance', false),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: 500,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedPaymentType,
                            items: [
                              'Cash',
                              'Online',
                              'Gold_Bullion',
                              'Silver_Bullion',
                              'Old_Gold',
                              'Old_Silver',
                            ].map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: 415,
                                    child: Text(
                                      e,
                                      // style: TextStyle(
                                      //   fontSize: 14,
                                      //   color: Colors.black,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ),
                                ),
                                value: e,
                                onTap: () {
                                  if (e == 'Cash') {
                                    setState(() {});
                                  } else if (e == 'Online') {
                                    setState(() {});
                                  }
                                  // firmId = e['Firm_Code'];
                                  // user['User_Role_Name'] = e['Role_Name'];
                                },
                              );
                            }).toList(),
                            hint: const Text(
                              'Payment Type',
                              // style: TextStyle(
                              //   fontSize: 14,
                              //   color: Colors.black,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),

                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            // alignment: Alignment.center,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentType = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      selectedPaymentTypevalidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  selectedPaymentTypevalidationMessage),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedPaymentType == 'Cash' ||
                              selectedPaymentType == 'Online'
                          ? const SizedBox()
                          : getField(rateController, 'Rate', true),
                      selectedPaymentType == 'Cash' ||
                              selectedPaymentType == 'Online'
                          ? const SizedBox()
                          : const SizedBox(
                              height: 20,
                            ),
                      selectedPaymentType == 'Cash' ||
                              selectedPaymentType == 'Online'
                          ? const SizedBox()
                          : getField(weightController, 'Weight', true),
                      selectedPaymentType == 'Cash' ||
                              selectedPaymentType == 'Online'
                          ? const SizedBox()
                          : const SizedBox(
                              height: 20,
                            ),
                      getField(paidAmountController, 'Amount', true),
                      paidAmountValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(paidAmountValidationMessage),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedDeductionType == null) {
                                selectedDeductedFromvalidation = false;
                                selectedDeductedFromvalidationMessage =
                                    'Select deduct From';
                              } else {
                                selectedDeductedFromvalidation = true;
                              }

                              if (selectedPaymentType == null) {
                                selectedPaymentTypevalidation = false;
                                selectedPaymentTypevalidationMessage =
                                    'Select Payment Type';
                              } else {
                                selectedPaymentTypevalidation = true;
                              }

                              if (paidAmountController.text.isNum != true) {
                                paidAmountValidation = false;
                                paidAmountValidationMessage =
                                    'Enter a valid amount';
                              } else {
                                paidAmountValidation = true;
                              }

                              if (selectedDeductedFromvalidation == true &&
                                  selectedPaymentTypevalidation == true &&
                                  paidAmountValidation == true) {
                                save();
                              } else {
                                setState(
                                  () {},
                                );
                                return;
                              }
                            },
                            child: Text(
                              'Save',
                              style: ProjectStyles.invoiceheadingStyle()
                                  .copyWith(color: Colors.white),
                            ),
                          ),
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
    ));
  }

  GlobalKey<FormState> _customerKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController idProffController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();

  void saveNewCustomer() {
    Map<String, dynamic> newCustomer = {
      'Creditor_Type': 'Customer',
      'Customer_Name': nameController.text,
      'Mobile_Number': mobileNumberController.text,
      'Id_Proof': selectedIdProof,
      'Id_Number': idProffController.text,
      'Address': addressController.text,
      'Receivable': openingBalanceController.text,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(newCustomer);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .addNewCustomer(newCustomer, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 200) {
          Get.back();
          successSnackbar('Successfully Added New Customer');
        } else {
          failureSnackbar('Something Went Wrong Unable to Add Customer');
        }
      });
    });
  }

  void editCustomer() {
    Map<String, dynamic> newCustomer = {
      'Creditor_Type': 'Customer',
      'Customer_Name': nameController.text,
      'Mobile_Number': mobileNumberController.text,
      'Id_Proof': selectedIdProof,
      'Id_Number': idProffController.text,
      'Address': addressController.text,
      'Receivable': openingBalanceController.text,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(newCustomer);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateCustomer(editablecusId, newCustomer, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 202) {
          Get.back();
          selectedCustomerData.clear();
          fetch();
          successSnackbar('Successfully updated New Customer');
        } else {
          failureSnackbar('Something Went Wrong Unable to Add Customer');
        }
      });
    });
  }

  void addCustomer(Size size, Map<String, dynamic> oldData) {
    var boxWidth = size.width * 0.38;
    double boxHeight = 580;
    nameValidation = true;
    mobileNumberValidation = true;
    selectedIdValidation = true;
    idControllerValidation = true;
    addressControllerValidation = true;
    openingBalanceControllerValidation = true;
    if (oldData.isNotEmpty) {
      editablecusId = oldData['Customer_Id'];
      nameController.text = oldData['Customer_Name'];
      mobileNumberController.text = oldData['Mobile_Number'];
      selectedIdProof = oldData['Id_Proof'];
      idProffController.text = oldData['Id_Number'];
      addressController.text = oldData['Address'];
    }
    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _customerKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Customer',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: boxHeight * 0.06,
                      ),
                      getField(
                        nameController,
                        'Customer Name',
                        true,
                      ),

                      nameValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(nameValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        mobileNumberController,
                        'Mobile Number',
                        true,
                      ),
                      mobileNumberValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:
                                  getErrorField(mobileNumberValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),

                      Container(
                        width: 500,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedIdProof,
                            items: [
                              'Aadhar Card',
                              'Voter Id',
                              'Pan Card',
                              'Driving License',
                              'Other'
                            ].map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: 415,
                                    child: Text(
                                      e,
                                      // style: TextStyle(
                                      //   fontSize: 14,
                                      //   color: Colors.black,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ),
                                ),
                                value: e,
                                onTap: () {
                                  // purchaseDetailsData['Id_Proof'] = e;
                                  // firmId = e['Firm_Code'];
                                  // user['User_Role_Name'] = e['Role_Name'];
                                },
                              );
                            }).toList(),
                            hint: const Text(
                              'Select Id Proof',
                              // style: TextStyle(
                              //   fontSize: 14,
                              //   color: Colors.black,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),

                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            // alignment: Alignment.center,
                            onChanged: (value) {
                              setState(() {
                                selectedIdProof = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      selectedIdValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(selectedIdValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        idProffController,
                        'Id Number',
                        true,
                      ),
                      idControllerValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:
                                  getErrorField(idControllerValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        addressController,
                        'Address',
                        true,
                      ),
                      addressControllerValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  addressControllerValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        openingBalanceController,
                        'Credit Balance',
                        true,
                      ),
                      openingBalanceControllerValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  openingBalanceControllerValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.08,
                      ),
                      // DropdownButtonFormField(
                      //     isExpanded: true,
                      //     items: customerList
                      //         .map<DropdownMenuItem<String>>(
                      //             (e) => DropdownMenuItem(
                      //                   child: Text(e),
                      //                   value: e,
                      //                 ))
                      //         .toList(),
                      //     onChanged: (value) {}),

                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: boxWidth * 0.18,
                            height: boxHeight * 0.1,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.length > 15) {
                                    nameValidation = false;
                                    nameValidationMessage =
                                        'customer name cannot be greater then 15 characters';
                                  } else if (nameController.text == '') {
                                    nameValidation = false;
                                    nameValidationMessage =
                                        'Enter a valid name';
                                  } else {
                                    nameValidation = true;
                                  }
                                  if (mobileNumberController.text.length !=
                                      10) {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else if (mobileNumberController
                                          .text.isNum !=
                                      true) {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else if (mobileNumberController
                                          .text.length >
                                      10) {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else if (mobileNumberController.text ==
                                      '') {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else {
                                    mobileNumberValidation = true;
                                  }

                                  if (selectedIdProof == null) {
                                    selectedIdValidation = false;
                                    selectedIdValidationMessage =
                                        'Select id proof';
                                  } else {
                                    selectedIdValidation = true;
                                  }

                                  if (idProffController.text == '') {
                                    idControllerValidation = false;
                                    idControllerValidationMessage =
                                        'Enter a valid id proof';
                                  } else {
                                    idControllerValidation = true;
                                  }
                                  if (addressController.text.length > 30) {
                                    addressControllerValidation = false;
                                    addressControllerValidationMessage =
                                        'Address cannot be greater then 30 characters';
                                  } else if (addressController.text == '') {
                                    addressControllerValidation = false;
                                    addressControllerValidationMessage =
                                        'Address cannot be empty';
                                  } else {
                                    addressControllerValidation = true;
                                  }
                                  if (openingBalanceController.text.isNum !=
                                      true) {
                                    openingBalanceControllerValidation = false;
                                    openingBalanceControllerValidationMessage =
                                        'credit balance cannot be empty either it should be zero or a valid integer';
                                  } else if (openingBalanceController.text ==
                                      '') {
                                    openingBalanceControllerValidation = false;
                                    openingBalanceControllerValidationMessage =
                                        'credit balance cannot be empty either it should be zero or a valid integer';
                                  } else {
                                    openingBalanceControllerValidation = true;
                                  }

                                  if (nameValidation == true &&
                                      mobileNumberValidation == true &&
                                      selectedIdValidation == true &&
                                      idControllerValidation == true &&
                                      addressControllerValidation == true &&
                                      openingBalanceControllerValidation ==
                                          true) {
                                    if (oldData.isEmpty) {
                                      saveNewCustomer();
                                    } else {
                                      editCustomer();
                                    }
                                  } else {
                                    setState(() {});
                                    return;
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: ProjectStyles.invoiceheadingStyle()
                                      .copyWith(color: Colors.white),
                                )),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    customersList = Provider.of<ApiCalls>(context).allCustomerList;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Customers',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          selectedCustomerData.length != 1
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ProjectColors.buttonColor)),
                      onPressed: () =>
                          addCustomer(size, selectedCustomerData[0]),
                      icon: const Icon(Icons.edit, color: Colors.black),
                      label: const Text(
                        'Customer',
                        style: TextStyle(color: Colors.black),
                      )),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ProjectColors.buttonColor)),
                onPressed: () => addCustomer(size, {}),
                icon: const Icon(Icons.add_box_outlined, color: Colors.black),
                label: const Text(
                  'Customers',
                  style: TextStyle(color: Colors.black),
                )),
          ),
          const SizedBox(
            width: 40,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            Container(
              width: size.width * 0.95,
              child: PaginatedDataTable(
                source: MySearchData(customersList, update, (value) {
                  setState(() {});
                }, addAdvance, fetchAdvance),
                arrowHeadColor: ProjectColors.themeColor,

                columns: const [
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Mobile Number',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Address',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Id Proof',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Id Number',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Gold Stock',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Silver Stock',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Merchant Cash Balance',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('payable',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Receivable',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Update',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Add',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  // DataColumn(
                  //     label: Text('Edit',
                  //         style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                onRowsPerPageChanged: (index) {
                  setState(() {
                    defaultRowsPerPage = index!;
                  });
                },
                availableRowsPerPage: const <int>[
                  3,
                  5,
                  10,
                  20,
                  40,
                  60,
                  80,
                ],
                columnSpacing: 20,
                //  horizontalMargin: 10,
                rowsPerPage: defaultRowsPerPage,
                showCheckboxColumn: true,
                // addEmptyRows: false,
                checkboxHorizontalMargin: 30,
                // onSelectAll: (value) {},
                showFirstLastButtons: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addAdvance(int id) {
    TextEditingController dateController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    var selectedPaymentType;
    var selectedDate;
    void datePicker() {
      showDatePicker(
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: ProjectColors.themeColor, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.red, // button text color
                  ),
                ),
              ),
              child: child!);
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2025),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        // _startDate = pickedDate.millisecondsSinceEpoch;
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        selectedDate = DateFormat("yyyy-MM-dd").format(pickedDate);

        // setState(() {});
      });
    }

    void save() {
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .addAdvance(
                id,
                {
                  'Customer_Id': id,
                  'Advance_Payment_Date': selectedDate,
                  'Advance_Amount': amountController.text,
                  'Payment_Type': 'Cash'
                },
                token)
            .then((value) {
          if (value == 201 || value == 200) {
            fetch();
            Get.back();
            successSnackbar('Successfully added amount');
          } else {
            failureSnackbar('Something went wrong unable to add advance');
          }
        });
      });
    }

    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          return Container(
            width: size.width * 0.25,
            height: size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Add Advance',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: datePicker,
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.15,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                enabled: false,
                                controller: dateController,
                                decoration: const InputDecoration(
                                    hintText: 'Choose Date',
                                    border: InputBorder.none),
                                validator: (value) {
                                  // if (value!.isEmpty) {
                                  //   // showError('FirmCode');
                                  //   return 'Name cannot be empty';
                                  // }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: IconButton(
                                onPressed: datePicker,
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: ProjectColors.themeColor,
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: size.width * 0.15,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: TextFormField(
                            enabled: true,
                            controller: amountController,
                            decoration: const InputDecoration(
                                hintText: 'Enter Amount',
                                border: InputBorder.none),
                            validator: (value) {
                              // if (value!.isEmpty) {
                              //   // showError('FirmCode');
                              //   return 'Name cannot be empty';
                              // }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          ProjectColors.themeColor,
                        ),
                      ),
                      onPressed: save,
                      child: const Text('Save'),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  void fetchAdvance(int id) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      print(id);
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getcusPaymentSheet(id, token)
          .then((value) {});
    });
    Map<String, dynamic> cusPaymentSheet = {};
    List<CustomerAdvance> customerAdvanceDetails = [];
    List<CustomerInvoiceTotal> customerInvoiceTotal = [];
    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          customerInvoiceTotal =
              Provider.of<ApiCalls>(context).customerInvoiceItemDetails;
          customerAdvanceDetails =
              Provider.of<ApiCalls>(context).customerAdvanceDetailsData;
          cusPaymentSheet = Provider.of<ApiCalls>(context).cusPaymentSheetData;
          return Container(
            width: size.width * 0.8,
            height: size.height * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: size.width * 0.7,
                      height: size.height * 0.6,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: SingleChildScrollView(
                        child: DataTable(columns: [
                          DataColumn(
                            label: Container(
                              width: size.width * 0.12,
                              alignment: Alignment.center,
                              child: const Text('Date'),
                            ),
                          ),
                          const DataColumn(
                              label: VerticalDivider(
                            color: Colors.black,
                          )),
                          DataColumn(
                            label: Container(
                              width: size.width * 0.12,
                              alignment: Alignment.center,
                              child: const Text('Mode'),
                            ),
                          ),
                          const DataColumn(
                              label: VerticalDivider(
                            color: Colors.black,
                          )),
                          DataColumn(
                            label: Container(
                              width: size.width * 0.12,
                              alignment: Alignment.center,
                              child: const Text('Amount'),
                            ),
                          ),
                        ], rows: [
                          for (var data in customerAdvanceDetails)
                            DataRow(cells: [
                              DataCell(Container(
                                  alignment: Alignment.center,
                                  width: size.width * 0.12,
                                  child: Text(data.date.toString()))),
                              const DataCell(VerticalDivider(
                                color: Colors.black,
                              )),
                              DataCell(Container(
                                  alignment: Alignment.center,
                                  width: size.width * 0.12,
                                  child: Text(data.mode))),
                              const DataCell(VerticalDivider(
                                color: Colors.black,
                              )),
                              DataCell(Container(
                                  alignment: Alignment.center,
                                  width: size.width * 0.12,
                                  child: Text(data.amount)))
                            ])
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}

List selectedCustomerData = [];

class MySearchData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;
  final ValueChanged<int> select;
  final ValueChanged<int> advance;
  final ValueChanged<int> fetchDetails;
  MySearchData(
    this.data,
    this.reFresh,
    this.select,
    this.advance,
    this.fetchDetails,
  );

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;
          select(100);
          if (selectedCustomerData.isEmpty) {
            selectedCustomerData.add(data[index]);
          } else {
            if (value == true) {
              selectedCustomerData.add(data[index]);
            } else {
              selectedCustomerData.remove(data[index]);
            }
          }
          print(selectedCustomerData);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                var pref = await SharedPreferences.getInstance();
                if (pref.containsKey('Customer_Id')) {
                  pref.remove('Customer_Id');
                }
                var userData = json.encode({
                  'Customer_Id': data[index]['Customer_Id'],
                });

                pref.setString('Customer_Id', userData);
                fetchDetails(data[index]['Customer_Id']);
                // Get.toNamed(CustomerDetailsPage.routeName,
                //     arguments: 'Customer');
              },
              child: Text(data[index]['Customer_Name']))),
          DataCell(Text(data[index]['Mobile_Number'].toString())),
          DataCell(Text(data[index]['Address'].toString())),
          DataCell(Text(data[index]['Id_Proof'].toString())),
          DataCell(Text(data[index]['Id_Number'].toString())),
          DataCell(Text(data[index]['Customer_Gold_Stock'].toString())),
          DataCell(Text(data[index]['Customer_Silver_Stock'].toString())),
          DataCell(Text(data[index]['Customer_excess_cash'].toString())),
          DataCell(Text(data[index]['Payable'].toString())),
          DataCell(Text(data[index]['Receivable'].toString())),
          DataCell(ElevatedButton(
            onPressed: () {
              reFresh(data[index]);
            },
            child: const Text('Update'),
          )),
          DataCell(ElevatedButton(
            onPressed: () {
              advance(data[index]['Customer_Id']);
            },
            child: const Text('Add Advance'),
          )),
          // DataCell(IconButton(
          //     onPressed: () {
          //       reFresh(data[index]);
          //     },
          //     icon: Icon(
          //       Icons.edit_note_outlined,
          //       color: ProjectColors.themeColor,
          //     ))),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  // void downloadExcelSheet(List activityDataList, var id) {
  //   final Workbook workbook = Workbook();
  //   final Worksheet sheet = workbook.worksheets[0];
  //   Range range = sheet.getRangeByName('A1');
  //   range.setText('Age in Days');
  //   range = sheet.getRangeByName('B1');
  //   range.setText('Activity');
  //   range = sheet.getRangeByName('C1');
  //   range.setText('Notification Days');

  //   List exportActivityList = [];

  //   for (var data in activityDataList) {
  //     exportActivityList.add([
  //       data['Age'],
  //       data['Activity_Name'],
  //       data['Notification_Prior_To_Activity'],
  //     ]);
  //   }

  //   for (int i = 0; i < exportActivityList.length; i++) {
  //     sheet.importList(exportActivityList[i], i + 2, 1, false);
  //   }
  //   final List<int> bytes = workbook.saveAsStream();

  //   // File file=File();

  //   // file.writeAsBytes(bytes);

  //   // _localFile.then((value) {
  //   //   final file = value;
  //   //   file.writeAsBytes(bytes);
  //   // });
  //   // save(bytes, 'Activity$id.xlsx');

  //   // final blob = html.Blob([bytes], 'application/vnd.ms-excel');
  //   // final url = html.Url.createObjectUrlFromBlob(blob);
  //   // html.window.open(url, "_blank");
  //   // html.Url.revokeObjectUrl(url);
  //   workbook.dispose();
  // }

  // void save(Object bytes, String fileName) {
  //   js.context.callMethod("saveAs", <Object>[
  //     html.Blob(<Object>[bytes]),
  //     fileName
  //   ]);
  // }
}
