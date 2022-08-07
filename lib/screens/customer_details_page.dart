import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'customer_individual_invoice_details_page.dart';

class CustomerDetailsPage extends StatefulWidget {
  CustomerDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/CustomerDetailsPage';

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  var _customerId;

  Map<String, dynamic> individualCustomerDetails = {};
  var appBarName;
  @override
  void initState() {
    appBarName = Get.arguments;
    super.initState();
    getCustomerId().then((value) {
      Provider.of<Authenticate>(context, listen: false).tryAutoLogin().then(
        (value) {
          var token = Provider.of<Authenticate>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .fetchIndividualCustomerDetails(_customerId, token)
              .then((value) => null);
        },
      );
    });
  }

  Future<void> getCustomerId() async {
    var pref = await SharedPreferences.getInstance();

    if (pref.containsKey('Customer_Id')) {
      var extratedData =
          json.decode(pref.getString('Customer_Id')!) as Map<String, dynamic>;

      print(extratedData);
      _customerId = extratedData['Customer_Id'];
    }
  }

  void fetch() {
    getCustomerId().then((value) {
      Provider.of<Authenticate>(context, listen: false).tryAutoLogin().then(
        (value) {
          var token = Provider.of<Authenticate>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .fetchIndividualCustomerDetails(_customerId, token)
              .then((value) => null);
        },
      );
    });
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    individualCustomerDetails =
        Provider.of<ApiCalls>(context).individualCustomerDetails;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${appBarName ?? ''} Details',
          style: ProjectStyles.headingStyle(),
        ),
      ),
      body: individualCustomerDetails.isEmpty
          ? const SizedBox()
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Name',
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ??
                                ''),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Mobile Number',
                            individualCustomerDetails['Customer_Details']
                                    ['Mobile_Number'] ??
                                ''),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Id Proof',
                            individualCustomerDetails['Customer_Details']
                                    ['Id_Proof'] ??
                                ''),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Address',
                            individualCustomerDetails['Customer_Details']
                                    ['Address'] ??
                                ''),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Debt Payable',
                            individualCustomerDetails['Customer_Details']
                                    ['Payable'] ??
                                ''),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Debt Receivable',
                            individualCustomerDetails['Customer_Details']
                                    ['Receivable'] ??
                                ''),
                    const SizedBox(
                      height: 60,
                    ),
                    individualCustomerDetails['Invoice'] != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: Text(
                              'Sales Invoice Details',
                              style: ProjectStyles.headingStyle()
                                  .copyWith(color: Colors.black),
                            ),
                          )
                        : const SizedBox(),
                    individualCustomerDetails['Invoice'] == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.5,
                                  child: PaginatedDataTable(
                                    source: MyExchangeItemList(
                                        individualCustomerDetails['Invoice'] ??
                                            [], (Map<String, dynamic> data) {
                                      fetch();
                                    }),
                                    arrowHeadColor: ProjectColors.themeColor,

                                    columns: const [
                                      DataColumn(
                                          label: Text('Invoice Code',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Date',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),

                                      DataColumn(
                                          label: Text('Cash Amount',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Online Amount',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Credit Amount',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      // DataColumn(
                                      //     label: Text('Old Item Name',
                                      //         style: TextStyle(
                                      //             fontWeight:
                                      //                 FontWeight.bold))),
                                      // DataColumn(
                                      //   label: Text(
                                      //     'Old Item Weight (g)',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // ),
                                      // DataColumn(
                                      //   label: Text(
                                      //     'Old Item Amount',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // ),
                                      DataColumn(
                                        label: Text(
                                          'Total Amount',
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
                    const SizedBox(
                      height: 30,
                    ),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'Credit Details',
                              style: ProjectStyles.headingStyle()
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                    individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'cash' ||
                            individualCustomerDetails['Customer_Details']
                                    ['Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.5,
                                  child: PaginatedDataTable(
                                    source: MyItemList(
                                        individualCustomerDetails['Credit'] ??
                                            [],
                                        (Map<String, dynamic> data) {}),
                                    arrowHeadColor: ProjectColors.themeColor,

                                    columns: const [
                                      DataColumn(
                                          label: Text('Date',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Deduct From',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),

                                      DataColumn(
                                          label: Text('Credit Balance',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Cash Paid',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Online Paid',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),

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
          DataCell(Text(
            DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(data[index]['Created_on'])),
          )),
          DataCell(Text(data[index]['Deduct_From'].toString())),
          DataCell(Text(data[index]['Credit_Amount'].toString())),

          DataCell(Text(data[index]['Cash_Amount'].toString())),
          DataCell(Text(data[index]['Online_Amount'].toString())),
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
          DataCell(TextButton(
              onPressed: () async {
                var result = await Get.toNamed(
                    CustomerIndividualInvoiceDetailsPage.routeName,
                    arguments: data[index]['Invoice_Id']);

                if (result == 'delete') {}
              },
              child: Text(data[index]['Invoice_Code'].toString()))),
          DataCell(Text(
            DateFormat('dd-MM-yyyy').format(
              DateTime.parse(
                data[index]['Created_Date'],
              ),
            ),
          )),
          DataCell(Text(data[index]['Cash_Amount'].toString())),
          DataCell(Text(data[index]['Online_Amount'].toString())),
          DataCell(Text(data[index]['Credit_Amount'].toString())),
          DataCell(Text(data[index]['Total_Amount'].toString())),

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

var daata = {
  "Customer_Details": {
    "Customer_Id": 1,
    "Customer_Name": "Ravi",
    "Mobile_Number": "7845874855",
    "Id_Proof": "7458744585",
    "Address": "some address",
    "Credit_Balance": "40000.0"
  },
  "Credit": [
    {
      "Credit_Id": 1,
      "Credit_Balance": "80000.0",
      "Paid_Amount": "40000.0",
      "created_on": "2022-04-29T05:12:03.480061Z",
      "Customer_Id": 1
    }
  ],
  "Invoice": [
    {
      "Invoice_Id": 1,
      "Received_Amount": "5000.00",
      "Total_Amount": "5000.00",
      "Balance_Amount": "0.00",
      "Old_Return_Amount": "0.00",
      "Old_Weight": "0.00",
      "Old_Item_Name": "gfgdg",
      "Date": "2022-04-01T00:00:00Z",
      "Payment_Type": "Cash",
      "Customer_Id": 1
    },
    {
      "Invoice_Id": 2,
      "Received_Amount": "5000.00",
      "Total_Amount": "5000.00",
      "Balance_Amount": "0.00",
      "Old_Return_Amount": "0.00",
      "Old_Weight": "0.00",
      "Old_Item_Name": "gfgdg",
      "Date": "2022-04-01T00:00:00Z",
      "Payment_Type": "Cash",
      "Customer_Id": 1
    },
    {
      "Invoice_Id": 3,
      "Received_Amount": "0.00",
      "Total_Amount": "35000.00",
      "Balance_Amount": "0.00",
      "Old_Return_Amount": "0.00",
      "Old_Weight": "0.00",
      "Old_Item_Name": "Gold",
      "Date": "2022-04-28T00:00:00Z",
      "Payment_Type": "Credit",
      "Customer_Id": 1
    },
    {
      "Invoice_Id": 4,
      "Received_Amount": "85000.00",
      "Total_Amount": "85000.00",
      "Balance_Amount": "0.00",
      "Old_Return_Amount": "5000.00",
      "Old_Weight": "5.00",
      "Old_Item_Name": "Gold",
      "Date": "2022-04-29T00:00:00Z",
      "Payment_Type": "Cash",
      "Customer_Id": 1
    },
    {
      "Invoice_Id": 5,
      "Received_Amount": "10000.00",
      "Total_Amount": "10000.00",
      "Balance_Amount": "0.00",
      "Old_Return_Amount": "5000.00",
      "Old_Weight": "5.00",
      "Old_Item_Name": "Gold",
      "Date": "2022-04-28T00:00:00Z",
      "Payment_Type": "Cash",
      "Customer_Id": 1
    },
    {
      "Invoice_Id": 6,
      "Received_Amount": "0.00",
      "Total_Amount": "35000.00",
      "Balance_Amount": "0.00",
      "Old_Return_Amount": "5000.00",
      "Old_Weight": "5.00",
      "Old_Item_Name": "Silver",
      "Date": "2022-04-28T00:00:00Z",
      "Payment_Type": "Credit",
      "Customer_Id": 1
    },
    {
      "Invoice_Id": 7,
      "Received_Amount": "0.00",
      "Total_Amount": "25000.00",
      "Balance_Amount": "0.00",
      "Old_Return_Amount": "0.00",
      "Old_Weight": "0.00",
      "Old_Item_Name": "Gold",
      "Date": "2022-04-28T00:00:00Z",
      "Payment_Type": "Card",
      "Customer_Id": 1
    }
  ]
};
