import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_billing_screen.dart';
import 'customer_details_page.dart';

class SupplierListScreen extends StatefulWidget {
  SupplierListScreen({Key? key}) : super(key: key);
  static const routeName = '/SupplierListScreen';
  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  List customersList = [];

  var customerId;

  var selectedDeductionType;

  var selectedIdProof;

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getCustomersList(token, 'Supplier')
          .then((value) => null);
    });
    super.initState();
  }

  TextEditingController customerNameController = TextEditingController();
  TextEditingController creditBalanceController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();

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

  void fetch() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getCustomersList(token, 'Supplier')
          .then((value) => null);
    });
  }

  Map<String, dynamic> saveCustomerInvoice = {};

  void save() {
    saveCustomerInvoice = {
      'Customer_Id': customerId,
      'Customer_Name': customerNameController.text,
      'Deduct_From': selectedDeductionType.toString(),
      'Credit_Amount': creditBalanceController.text,
      'Paid_Amount': paidAmountController.text,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(saveCustomerInvoice);

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .addCustomerCreditInvoice(saveCustomerInvoice, token)
          .then((value) {
        if (value == 201) {
          Get.back();
          successSnackbar('Successfully Updated the credit balance ');
          fetch();
        } else {
          failureSnackbar(
              'Something Went wrong unable to update the credit balance');
        }
      });
    });
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  int defaultRowsPerPage = 5;
  void update(Map<String, dynamic> data) {
    customerId = data['Customer_Id'];
    customerNameController.text = data['Customer_Name'];
    creditBalanceController.text = data['Credit_Balance'].toString();

    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          return Container(
            width: size.width * 0.35,
            height: size.height * 0.5,
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
                            hint: Text(
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
                      const SizedBox(
                        height: 20,
                      ),
                      getField(
                          creditBalanceController, 'Credit Balance', false),
                      const SizedBox(
                        height: 20,
                      ),
                      getField(paidAmountController, 'Paid Amount', true),
                      const SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: save,
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
      'Creditor_Type': 'Supplier',
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
      Provider.of<ApiCalls>(context, listen: false)
          .addNewCustomer(newCustomer, token)
          .then((value) {
        if (value == 201 || value == 200) {
          Get.back();
          successSnackbar('Successfully Added New Customer');
        } else {
          failureSnackbar('Something Went Wrong Unable to Add Customer');
        }
      });
    });
  }

  void addCustomer(Size size) {
    var boxWidth = size.width * 0.38;
    double boxHeight = 580;
    print(boxHeight);
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
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        mobileNumberController,
                        'Mobile Number',
                        true,
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
                            hint: Text(
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
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        idProffController,
                        'Id Number',
                        true,
                      ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        addressController,
                        'Address',
                        true,
                      ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        openingBalanceController,
                        'Credit Balance',
                        true,
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
                                onPressed: saveNewCustomer,
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
          'Suppliers',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () => addCustomer(size),
              icon: const Icon(Icons.add_box_outlined),
              label: const Text('Supplier')),
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
              width: size.width * 0.9,
              child: PaginatedDataTable(
                source: MySearchData(customersList, update),
                arrowHeadColor: ProjectColors.themeColor,

                columns: const [
                  DataColumn(
                      label: Text('Customer Name',
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
                      label: Text('Payable',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Receivable',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Update',
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

class MySearchData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  MySearchData(
    this.data,
    this.reFresh,
  );

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        // onSelectChanged: (value) {
        //   data[index]['Is_Selected'] = value;
        //   // reFresh(100);
        //   if (selectedActivityCodes.isEmpty) {
        //     selectedActivityCodes.add(data[index]['Activity_Id']);
        //   } else {
        //     if (value == true) {
        //       selectedActivityCodes.add(data[index]['Activity_Id']);
        //     } else {
        //       selectedActivityCodes.remove(data[index]['Activity_Id']);
        //     }
        //   }
        //   print(selectedActivityCodes);
        // },
        // selected: data[index]['Is_Selected'],
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
                Get.toNamed(CustomerDetailsPage.routeName,
                    arguments: 'Supplier');
              },
              child: Text(data[index]['Customer_Name']))),
          DataCell(Text(data[index]['Mobile_Number'].toString())),
          DataCell(Text(data[index]['Address'].toString())),
          DataCell(Text(data[index]['Id_Proof'].toString())),
          DataCell(Text(data[index]['Id_Number'].toString())),
          DataCell(Text(data[index]['Payable'].toString())),
          DataCell(Text(data[index]['Receivable'].toString())),
          DataCell(ElevatedButton(
            onPressed: () {
              reFresh(data[index]);
            },
            child: const Text('Update'),
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
