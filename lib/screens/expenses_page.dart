import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_billing_screen.dart';

class ExpensesPage extends StatefulWidget {
  ExpensesPage({Key? key}) : super(key: key);
  static const routeName = '/ExpensesPage';
  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  int defaultRowsPerPage = 5;
  List expenseList = [];

  var customerId;

  var selectedDeductionType;

  var updateDetailsData;

  var selectedExpense;

  TextEditingController customerNameController = TextEditingController();
  TextEditingController creditBalanceController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();

  TextEditingController expenserController = TextEditingController();

  var selectedPayment;

  var expenseId;

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getExpenseList(token)
          .then((value) => null);
    });
    super.initState();
  }

  void getExpenses() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getExpenseList(token)
          .then((value) => null);
    });
  }

  GlobalKey<FormState> _customerKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  Map<String, dynamic> saveCustomerInvoice = {};
  void saveNewExpense() {
    Map<String, dynamic> newCustomer = {
      'Spender': expenserController.text,
      'Expense_Name': selectedExpense,
      'Expense': expenseAmountController.text,
      'Payment_Type': selectedPayment,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(newCustomer);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .addExpense(newCustomer, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 200) {
          Get.back();
          getExpenses();
          successSnackbar('Successfully Added New Expense');
        } else {
          failureSnackbar('Something Went Wrong Unable to add expense');
        }
      });
    });
  }

  void updateExpense() {
    Map<String, dynamic> newCustomer = {
      'Spender': expenserController.text,
      'Expense_Name': selectedExpense,
      'Expense': expenseAmountController.text,
      'Payment_Type': selectedPayment,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(newCustomer);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateExpense(expenseId, newCustomer, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 202) {
          Get.back();
          selectedExpenseData.clear();
          getExpenses();
          successSnackbar('Successfully updated New Expense');
        } else {
          failureSnackbar('Something Went Wrong Unable to add expense');
        }
      });
    });
  }

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

  bool selectedExpenseValidation = true;
  bool expenseAmountValidation = true;
  bool spenderNameValidation = true;
  bool selectedPaymentTypeValidation = true;

  String selectedExpenseValidationMessage = '';
  String expenseAmountValidationMessage = '';
  String spenderNameValidationMessage = '';
  String selectedPaymentTypeValidationMessage = '';

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

  void addExpense(Size size, Map<String, dynamic> editData) {
    var boxWidth = size.width * 0.38;
    double boxHeight = 500;
    print(boxHeight);
    selectedExpenseValidation = true;
    expenseAmountValidation = true;
    spenderNameValidation = true;
    selectedPaymentTypeValidation = true;

    if (editData.isNotEmpty) {
      expenseId = editData['Expense_Id'];
      selectedExpense = editData['Expense_Name'];
      expenseAmountController.text = editData['Cash_Expense'] != 0.000000
          ? editData['Cash_Expense'].toString()
          : editData['Online_Expense'].toString();
      expenserController.text = editData['Spender'];
      selectedPayment = editData['Payment_Type'];
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
                        'Add Expense',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: boxHeight * 0.06,
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
                            value: selectedExpense,
                            items: [
                              'Printing_And_Stationary',
                              'Travel',
                              'Food',
                              'Miscallenous_Expenses',
                              'Electricity',
                              'Wages',
                              'Rent',
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
                              'Select Expense',
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
                                selectedExpense = value as String;
                              });
                            },
                          ),
                        ),
                      ),

                      selectedExpenseValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  selectedExpenseValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.06,
                      ),
                      getField(
                        expenseAmountController,
                        'Expense Amount',
                        true,
                      ),
                      expenseAmountValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:
                                  getErrorField(expenseAmountValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.06,
                      ),
                      getField(
                        expenserController,
                        'Spender Name',
                        true,
                      ),
                      spenderNameValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:
                                  getErrorField(spenderNameValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.06,
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
                            value: selectedPayment,
                            items: ['Cash', 'Online']
                                .map<DropdownMenuItem<String>>((e) {
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
                            hint: Text(
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
                                selectedPayment = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      selectedPaymentTypeValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  selectedPaymentTypeValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.06,
                      ),
                      // SizedBox(
                      //   height: boxHeight * 0.04,
                      // ),
                      // getField(
                      //   addressController,
                      //   'Address',
                      //   true,
                      // ),
                      // SizedBox(
                      //   height: boxHeight * 0.04,
                      // ),
                      // getField(
                      //   openingBalanceController,
                      //   'Credit Balance',
                      //   true,
                      // ),
                      // SizedBox(
                      //   height: boxHeight * 0.08,
                      // ),
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
                                  if (selectedExpense == null) {
                                    selectedExpenseValidation = false;
                                    selectedExpenseValidationMessage =
                                        'Select expense type';
                                  } else {
                                    selectedExpenseValidation = true;
                                  }

                                  if (selectedPayment == null) {
                                    selectedPaymentTypeValidation = false;
                                    selectedPaymentTypeValidationMessage =
                                        'Select payment type';
                                  } else {
                                    selectedPaymentTypeValidation = true;
                                  }

                                  if (expenseAmountController.text.isNum !=
                                      true) {
                                    expenseAmountValidation = false;
                                    expenseAmountValidationMessage =
                                        'Enter a valid expense amount';
                                  } else {
                                    expenseAmountValidation = true;
                                  }
                                  if (expenserController.text.length > 15) {
                                    spenderNameValidation = false;
                                    spenderNameValidationMessage =
                                        'Spender name cannot be greater then 15 characters';
                                  } else if (expenserController.text == '') {
                                    spenderNameValidation = false;
                                    spenderNameValidationMessage =
                                        'Enter a valid Spender name';
                                  } else {
                                    spenderNameValidation = true;
                                  }

                                  if (selectedExpenseValidation == true &&
                                      expenseAmountValidation == true &&
                                      spenderNameValidation == true &&
                                      selectedPaymentTypeValidation == true) {
                                    if (editData.isEmpty) {
                                      saveNewExpense();
                                    } else {
                                      updateExpense();
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

  void delete(int id) {
    print(id);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .deleteExpense(id, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 204 || value == 202) {
          selectedExpenseData.clear();
          getExpenses();
          successSnackbar('Successfully deleted  Expense');
        } else {
          failureSnackbar('Something Went Wrong Unable to add expense');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    expenseList = Provider.of<ApiCalls>(context).expenseList;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Expenses',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          selectedExpenseData.length != 1
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ProjectColors.buttonColor)),
                      onPressed: () => addExpense(size, selectedExpenseData[0]),
                      icon: const Icon(Icons.edit, color: Colors.black),
                      label: const Text(
                        'Expense',
                        style: TextStyle(color: Colors.black),
                      )),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ProjectColors.buttonColor)),
                onPressed: () => addExpense(size, {}),
                icon: const Icon(Icons.add_box_outlined, color: Colors.black),
                label: const Text(
                  'Expense',
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
              width: size.width * 0.6,
              child: PaginatedDataTable(
                source: MySearchData(expenseList, (int data) {
                  setState(() {});
                }, delete),
                arrowHeadColor: ProjectColors.themeColor,

                columns: const [
                  DataColumn(
                      label: Text('Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Spender Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Expense Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Cash Amount',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Online Amount',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Action',
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
}

List selectedExpenseData = [];

class MySearchData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<int> reFresh;
  final ValueChanged<int> delete;

  MySearchData(
    this.data,
    this.reFresh,
    this.delete,
  );

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;
          reFresh(100);
          if (selectedExpenseData.isEmpty) {
            selectedExpenseData.add(data[index]);
          } else {
            if (value == true) {
              selectedExpenseData.add(data[index]);
            } else {
              selectedExpenseData.remove(data[index]);
            }
          }
          print(selectedExpenseData);
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
                // Get.toNamed(CustomerDetailsPage.routeName,
                //     arguments: 'Customer');
              },
              child: Text(DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(data[index]['Created_Date']))))),
          DataCell(Text(data[index]['Spender'].toString())),
          DataCell(Text(data[index]['Expense_Name'].toString())),
          DataCell(Text(data[index]['Cash_Expense'].toString())),
          DataCell(Text(data[index]['Online_Expense'].toString())),
          DataCell(
            IconButton(
              onPressed: () {
                delete(data[index]['Expense_Id']);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          // DataCell(Text(data[index]['Id_Proof'].toString())),
          // DataCell(Text(data[index]['Id_Number'].toString())),
          // DataCell(Text(data[index]['Payable'].toString())),
          // DataCell(Text(data[index]['Receivable'].toString())),
          // DataCell(ElevatedButton(
          //   onPressed: () {
          //     reFresh(data[index]);
          //   },
          //   child: const Text('Update'),
          // )),
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

var dat = [
  {
    'Name': 'data',
    'Date': 'data',
    'Cash_Amount': '',
    'Online_Amount': '',
  },
  {
    'Name': 'data',
    'Date': 'data',
    'Cash_Amount': '',
    'Online_Amount': '',
  }
];
