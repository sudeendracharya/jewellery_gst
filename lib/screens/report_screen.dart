import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
// import 'dart:html' as html;
// import 'dart:js' as js;
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Column, Row, Alignment;

import '../colors.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_billing_screen.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({Key? key}) : super(key: key);

  static const routeName = '/ReportScreen';

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int defaultRowsPerPage = 5;
  var selectedDate;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  DateTime firstDayCurrentMonth = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime lastDayCurrentMonth = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month + 1,
    23,
    59,
    00,
  ).subtract(const Duration(days: 1));

  DateTime firstDayCurrentYear = DateTime.utc(DateTime.now().year, 1, 1);

  DateTime lastDayCurrentYear = DateTime.utc(DateTime.now().year, 12, 31);

  var selectedReport;

  String selectedCategory = 'Sales';

  Map<String, dynamic> salesRecord = {};

  Map<String, dynamic> purchaseRecord = {};

  String formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date);
  }

  var token;
  Future<void> getToken() async {
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      token = Provider.of<Authenticate>(context, listen: false).token;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // salesRecord = Provider.of<ApiCalls>(context).salesReportList;
    // purchaseRecord = Provider.of<ApiCalls>(context).purchaseReportList;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Report',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: Container(
              width: 170,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: selectedReport,
                  items: [
                    'Sales',
                    'Purchases',
                  ].map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(
                      child: Text(
                        e,
                        style: ProjectStyles.invoiceheadingStyle()
                            .copyWith(color: Colors.white),
                      ),
                      value: e,
                      onTap: () {
                        if (e == 'Sales') {
                          selectedCategory = 'Sales';

                          // print({
                          //   'Start_Date': formatDate(startDate),
                          //   'End_Date': formatDate(endDate),
                          // });

                          // Provider.of<ApiCalls>(context, listen: false)
                          //     .getSalesReport({
                          //   'Start_Date': formatDate(startDate),
                          //   'End_Date': formatDate(endDate),
                          // });
                        } else if (e == 'Purchases') {
                          selectedCategory = 'Purchases';
                          // print({
                          //   'Start_Date': firstDayCurrentMonth,
                          //   'End_Date': lastDayCurrentMonth
                          // });

                          // Provider.of<ApiCalls>(context, listen: false)
                          //     .getSalesReport({
                          //   'Start_Date': formatDate(firstDayCurrentMonth),
                          //   'End_Date': formatDate(lastDayCurrentMonth)
                          // });
                        }

                        // firmId = e['Firm_Code'];
                        // user['User_Role_Name'] = e['Role_Name'];
                      },
                    );
                  }).toList(),
                  hint: Text(
                    'Select Category',
                    style: ProjectStyles.invoiceheadingStyle()
                        .copyWith(color: Colors.white),
                  ),
                  style: ProjectStyles.invoiceheadingStyle()
                      .copyWith(color: Colors.white),
                  iconDisabledColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  dropdownColor: ProjectColors.themeColor,
                  alignment: Alignment.center,
                  onChanged: (value) {
                    setState(() {
                      selectedReport = value as String;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: Container(
              width: 145,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: selectedDate,
                  items: ['Daily', 'Monthly', 'Yearly']
                      .map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(
                      child: Text(
                        e,
                        style: ProjectStyles.invoiceheadingStyle()
                            .copyWith(color: Colors.white),
                      ),
                      value: e,
                      onTap: () {
                        if (e == 'Daily' && selectedCategory == 'Sales') {
                          print({
                            'Start_Date': formatDate(startDate),
                            'End_Date': formatDate(endDate),
                          });
                          getToken().then((value) {
                            Provider.of<ApiCalls>(context, listen: false)
                                .getSalesReport({
                              'Start_Date': formatDate(startDate),
                              'End_Date': formatDate(endDate),
                            }, token);
                          });
                        } else if (e == 'Monthly' &&
                            selectedCategory == 'Sales') {
                          print({
                            'Start_Date': firstDayCurrentMonth,
                            'End_Date': lastDayCurrentMonth
                          });
                          getToken().then((value) {
                            Provider.of<ApiCalls>(context, listen: false)
                                .getSalesReport({
                              'Start_Date': formatDate(firstDayCurrentMonth),
                              'End_Date': formatDate(lastDayCurrentMonth)
                            }, token);
                          });
                        } else if (e == 'Yearly' &&
                            selectedCategory == 'Sales') {
                          print({
                            'Start_Date': firstDayCurrentYear,
                            'End_Date': lastDayCurrentYear,
                          });
                          getToken().then((value) {
                            Provider.of<ApiCalls>(context, listen: false)
                                .getSalesReport({
                              'Start_Date': formatDate(firstDayCurrentYear),
                              'End_Date': formatDate(lastDayCurrentYear)
                            }, token);
                          });
                        }
                        if (e == 'Daily' && selectedCategory == 'Purchases') {
                          print({
                            'Start_Date': formatDate(startDate),
                            'End_Date': formatDate(endDate),
                          });

                          getToken().then((value) {
                            Provider.of<ApiCalls>(context, listen: false)
                                .getPurchaseReport({
                              'Start_Date': formatDate(startDate),
                              'End_Date': formatDate(endDate),
                            }, token);
                          });
                        } else if (e == 'Monthly' &&
                            selectedCategory == 'Purchases') {
                          print({
                            'Start_Date': firstDayCurrentMonth,
                            'End_Date': lastDayCurrentMonth
                          });

                          getToken().then((value) {
                            Provider.of<ApiCalls>(context, listen: false)
                                .getPurchaseReport({
                              'Start_Date': formatDate(firstDayCurrentMonth),
                              'End_Date': formatDate(lastDayCurrentMonth)
                            }, token);
                          });
                        } else if (e == 'Yearly' &&
                            selectedCategory == 'Purchases') {
                          print({
                            'Start_Date': firstDayCurrentYear,
                            'End_Date': lastDayCurrentYear,
                          });
                          getToken().then((value) {
                            Provider.of<ApiCalls>(context, listen: false)
                                .getPurchaseReport({
                              'Start_Date': formatDate(firstDayCurrentYear),
                              'End_Date': formatDate(lastDayCurrentYear)
                            }, token);
                          });
                        }

                        // firmId = e['Firm_Code'];
                        // user['User_Role_Name'] = e['Role_Name'];
                      },
                    );
                  }).toList(),
                  hint: Text(
                    'Select Mode',
                    style: ProjectStyles.invoiceheadingStyle()
                        .copyWith(color: Colors.white),
                  ),
                  style: ProjectStyles.invoiceheadingStyle()
                      .copyWith(color: Colors.white),
                  iconDisabledColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  dropdownColor: ProjectColors.themeColor,
                  alignment: Alignment.center,
                  onChanged: (value) {
                    setState(() {
                      selectedDate = value as String;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          selectedCategory == 'Sales'
              ? Container(
                  width: size.width * 0.9,
                  child: PaginatedDataTable(
                    source: MySearchData(salesRecord),
                    arrowHeadColor: ProjectColors.themeColor,

                    columns: const [
                      DataColumn(
                          label: Text('Date',
                              style: TextStyle(fontWeight: FontWeight.bold))),
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
                          label: Text('Aadhar Card',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Old Item',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Old Item Weight',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Old Item Amount',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Paid Amount',
                              style: TextStyle(fontWeight: FontWeight.bold))),
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
                )
              : Container(
                  width: size.width * 0.6,
                  child: PaginatedDataTable(
                    source: MyPurchaseData(purchaseRecord),
                    arrowHeadColor: ProjectColors.themeColor,

                    columns: const [
                      DataColumn(
                          label: Text('Date',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Item Name',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Weight (g)',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Amount',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Description',
                              style: TextStyle(fontWeight: FontWeight.bold))),
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
          const SizedBox(
            height: 25,
          ),
          selectedCategory == 'Sales'
              ? Consumer<ApiCalls>(
                  builder: (context, value, child) {
                    return Container(
                      child: Column(
                        children: [
                          const Text('Total Sales:'),
                          Text(value.totalSaleAmount.toString()),
                        ],
                      ),
                    );
                  },
                )
              : Consumer<ApiCalls>(
                  builder: (context, value, child) {
                    return Container(
                      child: Column(
                        children: [
                          const Text('Total Purchases:'),
                          Text(value.totalPurchaseAmount.toString()),
                        ],
                      ),
                    );
                  },
                )
          // Card(
          //   child: Container(
          //     width: size.width * 0.9,
          //     height: 80,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text('Cash In Hand'),
          //             Text('5000'),
          //           ],
          //         ),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text('Gold In Hand'),
          //             Text('5000'),
          //           ],
          //         ),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text('Sales'),
          //             Text('5000'),
          //           ],
          //         ),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text('Purchases'),
          //             Text('5000'),
          //           ],
          //         ),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text('Total'),
          //             Text('5000'),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ]),
      ),
    );
  }
}

List selectedActivityCodes = [];

class MySearchData extends DataTableSource {
  final Map<String, dynamic> data;

  // final ValueChanged<int> reFresh;

  MySearchData(
    this.data,
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
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy').format(
                DateTime.parse(
                  data[index]['Date'],
                ),
              ),
            ),
          ),
          DataCell(Text(data[index]['Customer_Id'].toString())),
          DataCell(Text(data[index]['Mobile_Number'].toString())),
          DataCell(Text(data[index]['Address'].toString())),
          DataCell(Text(data[index]['Aadhar_Card'].toString())),
          DataCell(Text(data[index]['Old_Item_Name'].toString())),
          DataCell(Text(data[index]['Old_Weight'].toString())),
          DataCell(Text(data[index]['Old_Return_Amount'].toString())),
          DataCell(Text(data[index]['Received_Amount'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  void downloadExcelSheet(List activityDataList, var id) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Range range = sheet.getRangeByName('A1');
    range.setText('Age in Days');
    range = sheet.getRangeByName('B1');
    range.setText('Activity');
    range = sheet.getRangeByName('C1');
    range.setText('Notification Days');

    List exportActivityList = [];

    for (var data in activityDataList) {
      exportActivityList.add([
        data['Age'],
        data['Activity_Name'],
        data['Notification_Prior_To_Activity'],
      ]);
    }

    for (int i = 0; i < exportActivityList.length; i++) {
      sheet.importList(exportActivityList[i], i + 2, 1, false);
    }
    final List<int> bytes = workbook.saveAsStream();

    // File file=File();

    // file.writeAsBytes(bytes);

    // _localFile.then((value) {
    //   final file = value;
    //   file.writeAsBytes(bytes);
    // });
    // save(bytes, 'Activity$id.xlsx');

    // final blob = html.Blob([bytes], 'application/vnd.ms-excel');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
    workbook.dispose();
  }

  // void save(Object bytes, String fileName) {
  //   js.context.callMethod("saveAs", <Object>[
  //     html.Blob(<Object>[bytes]),
  //     fileName
  //   ]);
  // }
}

class MyPurchaseData extends DataTableSource {
  final Map<String, dynamic> data;

  // final ValueChanged<int> reFresh;

  MyPurchaseData(
    this.data,
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
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy').format(
                DateTime.parse(
                  data[index]['Date'],
                ),
              ),
            ),
          ),
          DataCell(Text(data[index]['Item_Name'])),
          DataCell(Text(data[index]['Weight'].toString())),
          DataCell(Text(data[index]['Amount'].toString())),
          DataCell(Text(data[index]['Description'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  void downloadExcelSheet(List activityDataList, var id) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Range range = sheet.getRangeByName('A1');
    range.setText('Age in Days');
    range = sheet.getRangeByName('B1');
    range.setText('Activity');
    range = sheet.getRangeByName('C1');
    range.setText('Notification Days');

    List exportActivityList = [];

    for (var data in activityDataList) {
      exportActivityList.add([
        data['Age'],
        data['Activity_Name'],
        data['Notification_Prior_To_Activity'],
      ]);
    }

    for (int i = 0; i < exportActivityList.length; i++) {
      sheet.importList(exportActivityList[i], i + 2, 1, false);
    }
    final List<int> bytes = workbook.saveAsStream();

    // File file=File();

    // file.writeAsBytes(bytes);

    // _localFile.then((value) {
    //   final file = value;
    //   file.writeAsBytes(bytes);
    // });
    // save(bytes, 'Activity$id.xlsx');

    // final blob = html.Blob([bytes], 'application/vnd.ms-excel');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
    workbook.dispose();
  }

  // void save(Object bytes, String fileName) {
  //   js.context.callMethod("saveAs", <Object>[
  //     html.Blob(<Object>[bytes]),
  //     fileName
  //   ]);
  // }
}
