import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';

class PurchaseDetailsPage extends StatefulWidget {
  PurchaseDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/PurchaseDetailsPage';

  @override
  State<PurchaseDetailsPage> createState() => _PurchaseDetailsPageState();
}

class _PurchaseDetailsPageState extends State<PurchaseDetailsPage> {
  var _purchaseId;

  Map<String, dynamic> singlePurchaseData = {};

  TextEditingController itemNameController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController grossWeightController = TextEditingController();
  TextEditingController wastageController = TextEditingController();
  TextEditingController netWeightController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  var purchaseId;

  var purchaseItemId;

  var amountSaved;

  @override
  void initState() {
    getPurchaseId().then((value) {
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .getSinglePurchaseInvoice(_purchaseId, token)
            .then((value) => null);
      });
    });
    super.initState();
  }

  void fetchUpdatedData() {
    getPurchaseId().then((value) {
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .getSinglePurchaseInvoice(_purchaseId, token)
            .then((value) => null);
      });
    });
  }

  Future<void> getPurchaseId() async {
    var pref = await SharedPreferences.getInstance();

    if (pref.containsKey('Purchase_Id')) {
      final extratedUserData =
          //we should use dynamic as a another value not a Object
          json.decode(pref.getString('Purchase_Id')!) as Map<String, dynamic>;

      _purchaseId = extratedUserData['Purchase_Id'];
    }
  }

  Padding getRow(String heading, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              heading,
              style: ProjectStyles.invoiceheadingStyle().copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          Container(
            width: 180,
            child: Text(
              data,
              style: ProjectStyles.invoiceContentStyle(),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox gap() {
    return const SizedBox(
      height: 20,
    );
  }

  int defaultRowsPerPage = 3;

  void saveEditedItems() {
    double sum = 0;
    for (var data in singlePurchaseData['Item_Details']) {
      if (data['Purchase_Item_Id'] != purchaseItemId) {
        sum = sum + double.parse(data['Rate'].toString());
      }
      print(sum);
    }
    double averageRate = 0;
    if (sum != 0) {
      averageRate = (sum + double.parse(rateController.text)) / 2;
    } else {
      averageRate = double.parse(rateController.text);
    }

    print('Average rate $averageRate');
    Map<String, dynamic> editedItem = {
      'Product_Type': singlePurchaseData['Purchase_Details']['Product_Type'],
      'Purchase_Item_Id': purchaseItemId,
      'Rate': rateController.text,
      'Amount': amountController.text,
      'Net_Weight': netWeightController.text,
      'Wastage': wastageController.text,
      'Gross_Weight': grossWeightController.text,
      'Item_Name': itemNameController.text,
      'Purchase_Id': purchaseId,
      'Average_Rate': averageRate,
    };
    print(editedItem);
    if (amountSaved != amountController.text) {
      double savedAmount = double.parse(amountSaved);
      double editedAmount = double.parse(amountController.text);
      if (savedAmount > editedAmount) {
        double balanceAmount = savedAmount - editedAmount;
        double totalAmount = double.parse(singlePurchaseData['Purchase_Details']
                    ['Total_Amount']
                .toString()) -
            balanceAmount;
        updateBothDetails(totalAmount, editedItem);
        print(totalAmount);
      } else {
        double balanceAmount = editedAmount - savedAmount;
        double totalAmount = double.parse(singlePurchaseData['Purchase_Details']
                    ['Total_Amount']
                .toString()) +
            balanceAmount;

        print(totalAmount);
        updateBothDetails(totalAmount, editedItem);
      }
    } else {
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        EasyLoading.show();
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .updateSinglePurchaseInvoiceItems(purchaseItemId, editedItem, token)
            .then((value) {
          EasyLoading.dismiss();
          if (value == 201 || value == 202) {
            Get.back();
            fetchUpdatedData();
            successSnackbar('Successfully Updated the data');
          } else {
            failureSnackbar('Something Went Wrong Unable to Update the data');
          }
        });
      });
    }

    // print(editedItem);
  }

  void updateBothDetails(var totalAmount, Map<String, dynamic> editedItem) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateSinglePurchaseInvoiceItems(purchaseItemId, editedItem, token)
          .then((value) {
        if (value == 201 || value == 202) {
          Provider.of<ApiCalls>(context, listen: false)
              .updateSinglePurchaseInvoiceDetails(
                  purchaseId, {'Total_Amount': totalAmount}, token)
              .then((value) {
            EasyLoading.dismiss();
            if (value == 201 || value == 202) {
              Get.back();
              fetchUpdatedData();
              successSnackbar('Successfully Updated the data');
            } else {
              failureSnackbar('Something Went wrong unable to update the data');
            }
          });
        }
      });
    });
  }

  void editItemDetails(Map<String, dynamic> data) {
    purchaseId = data['Purchase_Id'];
    purchaseItemId = data['Purchase_Item_Id'];
    itemNameController.text = data['Item_Name'];
    rateController.text = data['Rate'].toString();
    grossWeightController.text = data['Gross_Weight'].toString();
    wastageController.text = data['Wastage'].toString();
    netWeightController.text = data['Net_Weight'].toString();
    amountController.text = data['Amount'].toString();
    amountSaved = data['Amount'].toString();
    print('update data $data');
    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          var formWidth = size.width * 0.3;
          double formHeight = 40;
          return Container(
            width: size.width * 0.4,
            height: size.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.03,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Edit Item',
                          style: ProjectStyles.invoiceheadingStyle()
                              .copyWith(fontSize: 22),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    getField(size, formWidth, formHeight, 'Item Name',
                        'Enter Item Name', itemNameController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Rate', 'Enter Rate',
                        rateController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Gross Weight',
                        'Enter Gross Weight', grossWeightController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Wastage',
                        'Enter Wastage', wastageController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Net Weight',
                        'Enter Net Weight', netWeightController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Amount',
                        'Enter Amount', amountController),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      width: formWidth,
                      height: formHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: saveEditedItems,
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
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

  Column getField(var size, var formWidth, var formHeight, var heading,
      var helpText, TextEditingController controller) {
    return Column(
      children: [
        Container(
          width: formWidth,
          height: formHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              heading,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: formWidth,
          height: formHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: helpText,
              ),
              onChanged: (value) {
                if (heading == 'Amount') {}
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    singlePurchaseData =
        Provider.of<ApiCalls>(context).individualPurchaseInvoice;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Purchase Invoice',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: ElevatedButton.icon(
              onPressed: () {
                convertPdf(
                    singlePurchaseData['Purchase_Details'],
                    singlePurchaseData['Item_Details'],
                    singlePurchaseData['Exchange_Details']);
              },
              label: const Text('Print'),
              icon: const Icon(Icons.print),
            ),
          )
        ],
      ),
      // drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
          child: singlePurchaseData.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getRow(
                        'Bill Number',
                        singlePurchaseData['Purchase_Details']['Bill_Number'] ??
                            ''),
                    gap(),
                    getRow(
                      'Purchase Date',
                      DateFormat('dd-MM-yyyy').format(
                        DateTime.parse(singlePurchaseData['Purchase_Details']
                            ['Created_Date']),
                      ),
                    ),
                    // gap(),
                    // getRow(
                    //     'Creditor Type',
                    //     singlePurchaseData['Purchase_Details']
                    //             ['Creditor_Type'] ??
                    //         ''),
                    gap(),
                    getRow(
                        'Creditor Name',
                        singlePurchaseData['Purchase_Details']
                                ['Creditor_Name'] ??
                            ''),
                    gap(),
                    getRow(
                        'Product Type',
                        singlePurchaseData['Purchase_Details']
                                ['Product_Type'] ??
                            ''),
                    gap(),

                    getRow(
                        'Payment Type',
                        singlePurchaseData['Purchase_Details']
                                ['Payment_Type'] ??
                            ''),
                    gap(),
                    getRow(
                        'Merchant Credit Balance',
                        singlePurchaseData['Purchase_Details']
                                    ['Merchant_Credit_Balance'] ==
                                null
                            ? ''
                            : double.parse(
                                    singlePurchaseData['Purchase_Details']
                                        ['Merchant_Credit_Balance'])
                                .toStringAsFixed(2)),
                    gap(),
                    getRow(
                        'Customer Credit Balance',
                        singlePurchaseData['Purchase_Details']
                                    ['Customer_Credit_Balance'] ==
                                null
                            ? ''
                            : double.parse(
                                    singlePurchaseData['Purchase_Details']
                                        ['Customer_Credit_Balance'])
                                .toStringAsFixed(2)),
                    gap(),
                    getRow(
                        'Gold Stock',
                        singlePurchaseData['Purchase_Details']
                                    ['Customer_Gold_Stock'] ==
                                null
                            ? ''
                            : double.parse(
                                    singlePurchaseData['Purchase_Details']
                                        ['Customer_Gold_Stock'])
                                .toStringAsFixed(2)),
                    gap(),
                    getRow(
                        'Silver Stock',
                        singlePurchaseData['Purchase_Details']
                                    ['Customer_Silver_Stock'] ==
                                null
                            ? ''
                            : double.parse(
                                    singlePurchaseData['Purchase_Details']
                                        ['Customer_Silver_Stock'])
                                .toStringAsFixed(2)),

                    gap(),
                    getRow(
                      'Paid Amount',
                      singlePurchaseData['Purchase_Details']['Total_Amount'] ==
                              null
                          ? ''
                          : double.parse(singlePurchaseData['Purchase_Details']
                                      ['Total_Amount']
                                  .toString())
                              .toStringAsFixed(2),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Item Details',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.8,
                            child: PaginatedDataTable(
                              source: MyItemList(
                                  singlePurchaseData['Item_Details'] ?? [],
                                  editItemDetails),
                              arrowHeadColor: ProjectColors.themeColor,

                              columns: const [
                                DataColumn(
                                    label: Text('Item Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                // DataColumn(
                                //     label: Text('Item Qty',
                                //         style:
                                //             TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Rate',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Gross Weight',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Melt',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Wastage',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('%',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                  label: Text(
                                    'Net Weight',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Amount',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Edit',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
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
                    const SizedBox(
                      height: 60,
                    ),
                    singlePurchaseData['Item_Details'] != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: Text(
                              'Exchange Details',
                              style: ProjectStyles.headingStyle()
                                  .copyWith(color: Colors.black),
                            ),
                          )
                        : const SizedBox(),
                    singlePurchaseData['Item_Details'] == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.8,
                                  child: PaginatedDataTable(
                                    source: MyExchangeItemList(
                                        singlePurchaseData[
                                                'Exchange_Details'] ??
                                            [],
                                        (Map<String, dynamic> data) {}),
                                    arrowHeadColor: ProjectColors.themeColor,

                                    columns: const [
                                      DataColumn(
                                          label: Text('Item Name',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),

                                      DataColumn(
                                          label: Text('Gross Wt',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Wastage %',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                        label: Text(
                                          'Net Wt',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Amount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
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
                  ],
                ),
        ),
      ),
    );
  }
}

class MyItemList extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  MyItemList(
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
          DataCell(Text(data[index]['Item_Name'])),
          // DataCell(Text(data[index]['Item_Qty'].toString())),
          DataCell(Text(double.parse(data[index]['Rate']).toStringAsFixed(2))),
          DataCell(Text(double.parse(data[index]['Gross_Weight'].toString())
              .toStringAsFixed(2))),
          DataCell(Text(
              double.parse(data[index]['Melt'].toString()).toStringAsFixed(2))),
          DataCell(Text(double.parse(data[index]['Wastage'].toString())
              .toStringAsFixed(2))),
          DataCell(Text(double.parse(data[index]['Total_Percentage'].toString())
              .toStringAsFixed(2))),
          DataCell(Text(double.parse(data[index]['Net_Weight'].toString())
              .toStringAsFixed(2))),
          DataCell(Text(double.parse(data[index]['Amount'].toString())
              .toStringAsFixed(2))),
          DataCell(
            IconButton(
              onPressed: () {
                reFresh(data[index]);
              },
              icon: const Icon(Icons.edit),
            ),
          ),
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

class MyExchangeItemList extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  MyExchangeItemList(
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
          DataCell(Text(data[index]['Exchange_Item'])),

          DataCell(Text(data[index]['Gross_Weight'].toString())),
          DataCell(Text(data[index]['Percentage'].toString())),
          DataCell(Text(data[index]['Net_Weight'].toString())),
          DataCell(Text(data[index]['Amount'].toString())),
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

Future<void> convertPdf(Map<String, dynamic> purchaseDetails, List itemDetails,
    List exchangeDetails) async {
  final PdfDocument document = PdfDocument();
  // Add a new page to the document.
  final PdfPage page = document.pages.add();
  page.graphics.drawString(
      'Prathiba Jewellers', PdfStandardFont(PdfFontFamily.helvetica, 16),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.37, 0, 250, 20));

  page.graphics.drawString(
      'Purchase Invoice', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.42,
          page.getClientSize().height * 0.03, 250, 20));
  page.graphics.drawString('Invoice Id: ${purchaseDetails['Bill_Number']}',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.05, 250, 20));
  page.graphics.drawString(
      'Customer Name: ${purchaseDetails['Creditor_Name'] ?? purchaseDetails['Customer_Name']}',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.075, 250, 20));
  page.graphics.drawString(
      'Date of Purchase: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(purchaseDetails['Created_Date']))}',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.67,
          page.getClientSize().height * 0.05, 250, 20));
  page.graphics.drawString(
      'Payment Type: ${purchaseDetails['Payment_Type'] ?? ''}',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.67,
          page.getClientSize().height * 0.075, 250, 20));
  page.graphics.drawString(
      'Item Details', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.42,
          page.getClientSize().height * 0.12, 150, 20));

  page.graphics.drawString('O/B', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.66,
          page.getClientSize().height * 0.15, 150, 20));

  final PdfGrid oldBalanceGrid = PdfGrid();

  oldBalanceGrid.columns.add(count: 2);
  PdfGridRow row = oldBalanceGrid.rows.add();
  row.cells[0].value = purchaseDetails['Product_Type'] == 'Gold_Bullion' ||
          purchaseDetails['Product_Type'] == 'Gold_Ornament'
      ? double.parse(purchaseDetails['Customer_Old_Gold_Stock'] ??
              purchaseDetails['Customer_Gold_Stock'])
          .toStringAsFixed(2)
      : double.parse(purchaseDetails['Customer_Old_Silver_Stock'] ??
              purchaseDetails['Customer_Silver_Stock'])
          .toStringAsFixed(2);

  row.cells[1].value = purchaseDetails['Merchant_Credit_Balance'] == '0.000000'
      ? double.parse(purchaseDetails['Customer_Credit_Balance'])
          .toStringAsFixed(2)
      : double.parse(purchaseDetails['Merchant_Credit_Balance'])
          .toStringAsFixed(2);

  oldBalanceGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);
  PdfLayoutResult oldBalanceGridResult = oldBalanceGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(
        page.getClientSize().width * 0.72,
        page.getClientSize().height * 0.15,
        page.getClientSize().width,
        page.getClientSize().height,
      )) as PdfLayoutResult;

  final PdfGrid grid = PdfGrid();
// Specify the grid column count.
  grid.columns.add(count: 7);

  final PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].value = 'Item Name';
  headerRow.cells[1].value = 'Gross Weight (g)';
  headerRow.cells[2].value = 'Melt';
  headerRow.cells[3].value = 'wastage';
  headerRow.cells[4].value = 'Percentage %';
  headerRow.cells[5].value = 'Net Weight';
  // headerRow.cells[6].value = 'Rate';
  headerRow.cells[6].value = 'Amount';

  headerRow.style.font =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
  double grossWeight = 0;
  double fineWeight = 0;
  double totalAmount = 0;
  for (var data in itemDetails) {
    grossWeight = grossWeight + double.parse(data['Gross_Weight'].toString());
    fineWeight = fineWeight + double.parse(data['Net_Weight'].toString());
    data['Amount'] == null
        ? const SizedBox()
        : totalAmount = totalAmount + double.parse(data['Amount'].toString());
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = data['Item_Name'];
    row.cells[1].value =
        double.parse(data['Gross_Weight'].toString()).toStringAsFixed(2);
    row.cells[2].value =
        double.parse(data['Melt'].toString()).toStringAsFixed(2);
    row.cells[3].value =
        double.parse(data['Wastage'].toString()).toStringAsFixed(2);
    row.cells[4].value =
        double.parse(data['Total_Percentage'].toString()).toStringAsFixed(2);
    row.cells[5].value =
        double.parse(data['Net_Weight'].toString()).toStringAsFixed(2);
    // row.cells[6].value =
    //     double.parse(data['Rate'].toString()).toStringAsFixed(2);
    row.cells[6].value = data['Amount'] == null
        ? ''
        : double.parse(data['Amount'].toString()).toStringAsFixed(2);
  }

  PdfGridRow finalRow = grid.rows.add();
  finalRow.cells[0].value = 'Total';
  finalRow.cells[1].value = grossWeight.toStringAsFixed(2);
  finalRow.cells[2].value = '';

  finalRow.cells[3].value = '';
  finalRow.cells[4].value = 'Fine';
  finalRow.cells[5].value = fineWeight.toStringAsFixed(2);
  finalRow.cells[6].value = totalAmount.toStringAsFixed(2);
  grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
  PdfLayoutResult result = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0,
          page.getClientSize().height * 0.19,
          page.getClientSize().width,
          page.getClientSize().height)) as PdfLayoutResult;

  final PdfGrid finalRateGrid = PdfGrid();
  finalRateGrid.columns.add(count: 3);
  PdfGridRow finalRateRow = finalRateGrid.rows.add();
  finalRateRow.cells[0].value = 'Rate';
  finalRateRow.cells[1].value = itemDetails[0]['Rate'] == null
      ? ''
      : double.parse(itemDetails[0]['Rate']).toStringAsFixed(2);
  finalRateRow.cells[2].value = purchaseDetails['Total_Amount'] == null
      ? ''
      : double.parse(purchaseDetails['Total_Amount']).toStringAsFixed(2);
  finalRateGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);
  PdfLayoutResult finalRateResult = finalRateGrid.draw(
    page: page,
    bounds: Rect.fromLTWH(
      page.getClientSize().width * 0.5715,
      result.bounds.bottom + 0.3,
      page.getClientSize().width,
      page.getClientSize().height,
    ),
  ) as PdfLayoutResult;

  final PdfGrid netBalanceGrid = PdfGrid();
  netBalanceGrid.columns.add(count: 3);
  PdfGridRow netBalanceRow = netBalanceGrid.rows.add();
  netBalanceRow.cells[0].value = 'Net Bal';
  netBalanceRow.cells[1].value = purchaseDetails['Payment_Type'] == 'Cash' ||
          purchaseDetails['Payment_Type'] == null
      ? purchaseDetails['Product_Type'] == 'Gold_Ornament' ||
              purchaseDetails['Product_Type'] == 'Gold_Bullion'
          ? double.parse(purchaseDetails['Customer_Gold_Stock'])
              .toStringAsFixed(2)
          : double.parse(purchaseDetails['Customer_Silver_Stock'])
              .toStringAsFixed(2)
      : purchaseDetails['Net_Metal_Weight'] == null
          ? ''
          : double.parse(purchaseDetails['Net_Metal_Weight'])
              .toStringAsFixed(2);

  netBalanceRow.cells[2].value = purchaseDetails['Payment_Type'] == 'Cash' ||
          purchaseDetails['Payment_Type'] == null
      ? purchaseDetails['Merchant_Credit_Balance'] == '0.000000'
          ? double.parse(purchaseDetails['Customer_Credit_Balance'])
              .toStringAsFixed(2)
          : double.parse(purchaseDetails['Merchant_Credit_Balance'])
              .toStringAsFixed(2)
      : purchaseDetails['Total_Amount'] == null
          ? ''
          : double.parse(purchaseDetails['Total_Amount']).toStringAsFixed(2);
  netBalanceGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);
  PdfLayoutResult netResult = netBalanceGrid.draw(
    page: page,
    bounds: Rect.fromLTWH(
      page.getClientSize().width * 0.57,
      result.bounds.bottom + 50,
      page.getClientSize().width,
      page.getClientSize().height,
    ),
  ) as PdfLayoutResult;

  Directory? _downloadsDirectory = await getDownloadsDirectory();
  String downloadPath = _downloadsDirectory!.path;
  File('$downloadPath/PDFTable.pdf')
      .writeAsBytes(await document.save())
      .then((value) {
    final fileUriWindows =
        Uri.file('$downloadPath/PDFTable.pdf', windows: true);

    launchUrl(fileUriWindows, mode: LaunchMode.externalApplication)
        .then((value) {
      print(value);
    });
  });
  // pdfController.openDocument(PdfDocument.fromBase64String('assets/sample.pdf'));

// Dispose the document.
  document.dispose();
}
