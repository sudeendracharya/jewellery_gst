import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../colors.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import '../widgets/modular.dart';
import 'add_billing_screen.dart';

class SalesReportScreen extends StatefulWidget {
  SalesReportScreen({Key? key}) : super(key: key);

  static const routeName = '/SalesReportScreen';

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  TextEditingController fromDateController = TextEditingController();

  var startDate;
  var fromDate;
  var endDate;
  var toDate;

  Map<String, dynamic> balanceSheet = {};

  List salesReport = [];
  void startDatePicker() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themeColor, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
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
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // _startDate = pickedDate.millisecondsSinceEpoch;
      fromDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      startDate = DateFormat("yyyy-MM-dd").format(pickedDate);

      setState(() {});
    });
  }

  void endDatePicker() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themeColor, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
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
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // _startDate = pickedDate.millisecondsSinceEpoch;
      toDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      endDate = DateFormat("yyyy-MM-dd").format(pickedDate);

      setState(() {});
    });
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
  void initState() {
    fromDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    toDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    endDate = DateFormat("yyyy-MM-dd'").format(DateTime.now());
    save();
    super.initState();
  }

  void save() {
    print({'Start_Date': startDate, 'End_Date': endDate});
    int fromDate = DateTime.parse(startDate).millisecondsSinceEpoch;
    int toDate = DateTime.parse(endDate).millisecondsSinceEpoch;
    if (toDate < fromDate) {
      Get.defaultDialog(
          title: 'Alert',
          middleText: 'To date should not be less then from date',
          confirm: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Ok')));
    } else {
      EasyLoading.show();
      getToken().then((value) {
        Provider.of<ApiCalls>(context, listen: false).getSalesReport({
          'Start_Date': startDate,
          'End_Date': endDate,
        }, token).then((value) {
          EasyLoading.dismiss();
        });
      });
    }

    // Provider.of<Authenticate>(context, listen: false)
    //     .tryAutoLogin()
    //     .then((value) {
    //   var token = Provider.of<Authenticate>(context, listen: false).token;
    //   Provider.of<ApiCalls>(context, listen: false).getBalanceSheet(
    //       {'Start_Date': startDate, 'End_Date': endDate}, token).then((value) {
    //     EasyLoading.dismiss();
    //   });
    // });
  }

  double totalGoldGrams = 0;
  double totalGoldAmount = 0;
  double totalSilverGrams = 0;
  double totalSilverAmount = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    salesReport = Provider.of<ApiCalls>(context).salesReportList;
    // if (salesReport.isNotEmpty) {
    //   totalGoldGrams =
    //       double.parse(salesReport['Cash']['Gold']['Grams'].toString()) +
    //           double.parse(salesReport['Card']['Gold']['Grams'].toString()) +
    //           double.parse(salesReport['Credit']['Gold']['Grams'].toString());
    //   totalGoldAmount =
    //       double.parse(salesReport['Cash']['Gold']['Amount'].toString()) +
    //           double.parse(salesReport['Card']['Gold']['Amount'].toString()) +
    //           double.parse(salesReport['Credit']['Gold']['Amount'].toString());
    //   totalSilverGrams =
    //       double.parse(salesReport['Cash']['Silver']['Grams'].toString()) +
    //           double.parse(salesReport['Card']['Silver']['Grams'].toString()) +
    //           double.parse(salesReport['Credit']['Silver']['Grams'].toString());
    //   totalSilverAmount = double.parse(
    //           salesReport['Cash']['Silver']['Amount'].toString()) +
    //       double.parse(salesReport['Card']['Silver']['Amount'].toString()) +
    //       double.parse(salesReport['Credit']['Silver']['Amount'].toString());
    // }
    var sheetWidth = size.width * 0.38;
    var sheetHeight = size.height * 1;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Sales Report',
          style: ProjectStyles.headingStyle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ModularWidgets.selectFromDateAndToDate(
                  startDatePicker, endDatePicker, size, fromDate, toDate, save),
              // Row(
              //   children: [
              //     Container(
              //       width: size.width * 0.18,
              //       child: Row(
              //         children: [
              //           Text(
              //             'From Date:',
              //             style: ProjectStyles.headingStyle()
              //                 .copyWith(color: Colors.black),
              //           ),
              //           Text(
              //             fromDate ?? '',
              //             style: ProjectStyles.headingStyle()
              //                 .copyWith(color: Colors.black),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: size.width * 0.02,
              //     ),
              //     IconButton(
              //         onPressed: startDatePicker,
              //         icon: Icon(
              //           Icons.calendar_month_outlined,
              //           color: ProjectColors.themeColor,
              //         ))
              //   ],
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   children: [
              //     Container(
              //       width: size.width * 0.18,
              //       child: Row(
              //         children: [
              //           Text(
              //             'To Date:',
              //             style: ProjectStyles.headingStyle()
              //                 .copyWith(color: Colors.black),
              //           ),
              //           Text(
              //             toDate ?? '',
              //             style: ProjectStyles.headingStyle()
              //                 .copyWith(color: Colors.black),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: size.width * 0.02,
              //     ),
              //     IconButton(
              //         onPressed: endDatePicker,
              //         icon: Icon(
              //           Icons.calendar_month_outlined,
              //           color: ProjectColors.themeColor,
              //         ))
              //   ],
              // ),
              // const SizedBox(
              //   height: 25,
              // ),
              // Row(
              //   children: [
              //     ElevatedButton(onPressed: save, child: const Text('Submit'))
              //   ],
              // ),
              const SizedBox(
                height: 35,
              ),
              Container(
                width: 850,
                height: 750,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Sales Report',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black),
                      ),
                      const Divider(color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'From Date: ${fromDate}',
                              style: ProjectStyles.invoiceheadingStyle(),
                            ),
                            Text(
                              'To Date: ${toDate}',
                              style: ProjectStyles.invoiceheadingStyle(),
                            )
                          ],
                        ),
                      ),
                      const Divider(color: Colors.black),
                      Container(
                        width: 850,
                        height: 600,
                        child: DataTable(
                            headingTextStyle:
                                ProjectStyles.invoiceheadingStyle(),
                            columns: const [
                              DataColumn(
                                label: Text('Date'),
                              ),
                              DataColumn(
                                label: Text('Particulars'),
                              ),
                              // DataColumn(
                              //   label: Text('Grams'),
                              // ),
                              DataColumn(
                                label: Text('Amount'),
                              ),
                            ],
                            rows: salesReport.isEmpty
                                ? []
                                : [
                                    for (var data in salesReport)
                                      DataRow(
                                        cells: [
                                          DataCell(Text(
                                              data['Created_Date'].toString())),
                                          DataCell(
                                            Text(
                                              'Sale',
                                              style: ProjectStyles
                                                  .invoiceContentStyle(),
                                            ),
                                          ),
                                          DataCell(
                                              Text(data['Credit'].toString())),
                                        ],
                                      ),

                                    // DataRow(
                                    //   cells: [
                                    //     DataCell(
                                    //       Text(
                                    //         'Gross Total',
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),
                                    //     DataCell(
                                    //       Text(
                                    //         totalGoldGrams.toString(),
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),
                                    //     DataCell(
                                    //       Text(
                                    //         totalGoldAmount.toString(),
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),

                                    // DataRow(
                                    //   cells: [
                                    //     DataCell(
                                    //       Text(
                                    //         'Gross Total',
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),
                                    //     DataCell(
                                    //       Text(
                                    //         totalSilverGrams.toString(),
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),
                                    //     DataCell(
                                    //       Text(
                                    //         totalSilverAmount.toString(),
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // DataRow(
                                    //   cells: [
                                    //     DataCell(
                                    //       Text(
                                    //         'Net Total',
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),

                                    //     const DataCell(
                                    //       SizedBox(),
                                    //     ),
                                    //     DataCell(
                                    //       Text(
                                    //         '${totalSilverAmount + totalGoldAmount}',
                                    //         style: ProjectStyles
                                    //             .invoiceContentStyle(),
                                    //       ),
                                    //     ),
                                    //     // DataCell(Text(
                                    //     //   '${cusGoldOrnamentTotal + cusSilverOrnamentTotal + cusGoldBullionTotal + cusSilverBullionTotal + supGoldOrnamentTotal + supSilverOrnamentTotal + supGoldBullionTotal + supSilverBullionTotal}',
                                    //     //   style: ProjectStyles
                                    //     //       .invoiceContentStyle(),
                                    //     // )),
                                    //   ],
                                    // ),
                                  ]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

var data = {
  "Cash": {
    "Gold": {"Grams": 10.0, "Amount": 25000.0},
    "Silver": {"Grams": 25.0, "Amount": 45000.0}
  },
  "Card": {
    "Gold": {"Grams": 10.0, "Amount": 25000.0},
    "Silver": {"Grams": null, "Amount": null}
  },
  "Credit": {
    "Gold": {"Grams": 20.0, "Amount": 40000.0},
    "Silver": {"Grams": 30.0, "Amount": 35000.0}
  }
};

var data1 = {
  "Cash": {
    "Gold": {"Grams": 0.0, "Amount": 0.0},
    "Silver": {"Grams": 0.0, "Amount": 0.0}
  },
  "Card": {
    "Gold": {"Grams": 0.0, "Amount": 0.0},
    "Silver": {"Grams": 0.0, "Amount": 0.0}
  },
  "Credit": {
    "Gold": {"Grams": 0.0, "Amount": 0.0},
    "Silver": {"Grams": 0.0, "Amount": 0.0}
  }
};
