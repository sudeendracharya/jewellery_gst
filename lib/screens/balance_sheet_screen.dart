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

class BalanceSheetScreen extends StatefulWidget {
  BalanceSheetScreen({Key? key}) : super(key: key);

  static const routeName = '/BalanaceSheet';

  @override
  State<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends State<BalanceSheetScreen> {
  TextEditingController fromDateController = TextEditingController();

  var startDate;
  var fromDate;
  var endDate;
  var toDate;

  Map<String, dynamic> balanceSheet = {};
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

  @override
  void initState() {
    super.initState();
    fromDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    toDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    endDate = DateFormat("yyyy-MM-dd'").format(DateTime.now());
    save();
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
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false).getBalanceSheet(
            {'Start_Date': startDate, 'End_Date': endDate},
            token).then((value) {
          EasyLoading.dismiss();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    balanceSheet = Provider.of<ApiCalls>(context).balanceSheet;
    var sheetWidth = size.width * 0.5;
    var sheetHeight = size.height * 0.7;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Balance Sheet',
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
                startDatePicker,
                endDatePicker,
                size,
                fromDate,
                toDate,
                save,
              ),
              // Row(
              //   children: [
              //     InkWell(
              //       onTap: startDatePicker,
              //       child: Container(
              //         width: size.width * 0.20,
              //         decoration: BoxDecoration(
              //             border: Border.all(),
              //             borderRadius: BorderRadius.circular(10)),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 'From Date:',
              //                 style: ProjectStyles.headingStyle()
              //                     .copyWith(color: Colors.black, fontSize: 18),
              //               ),
              //               Text(
              //                 fromDate ?? '',
              //                 style: ProjectStyles.headingStyle()
              //                     .copyWith(color: Colors.black, fontSize: 18),
              //               ),
              //               SizedBox(
              //                 width: size.width * 0.01,
              //               ),
              //               IconButton(
              //                   onPressed: startDatePicker,
              //                   icon: Icon(
              //                     Icons.calendar_month_outlined,
              //                     color: ProjectColors.themeColor,
              //                   )),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Row(
              //       children: [
              //         InkWell(
              //           onTap: endDatePicker,
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 border: Border.all(),
              //                 borderRadius: BorderRadius.circular(10)),
              //             width: size.width * 0.18,
              //             child: Padding(
              //               padding:
              //                   const EdgeInsets.symmetric(horizontal: 8.0),
              //               child: Row(
              //                 children: [
              //                   Text(
              //                     'To Date:',
              //                     style: ProjectStyles.headingStyle().copyWith(
              //                         color: Colors.black, fontSize: 18),
              //                   ),
              //                   Text(
              //                     toDate ?? '',
              //                     style: ProjectStyles.headingStyle().copyWith(
              //                         color: Colors.black, fontSize: 18),
              //                   ),
              //                   SizedBox(
              //                     width: size.width * 0.01,
              //                   ),
              //                   IconButton(
              //                       onPressed: endDatePicker,
              //                       icon: Icon(
              //                         Icons.calendar_month_outlined,
              //                         color: ProjectColors.themeColor,
              //                       ))
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     const SizedBox(
              //       width: 45,
              //     ),
              //     Row(
              //       children: [
              //         SizedBox(
              //           height: 40,
              //           child: ElevatedButton(
              //               onPressed: save,
              //               child: const Text(
              //                 'Submit',
              //                 style: TextStyle(fontSize: 18),
              //               )),
              //         )
              //       ],
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 35,
              ),
              balanceSheet.isEmpty
                  ? const SizedBox()
                  : Container(
                      width: sheetWidth,
                      height: sheetHeight,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.02,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Balance Sheet',
                              style: ProjectStyles.invoiceheadingStyle(),
                            ),
                            SizedBox(
                              height: sheetHeight * 0.05,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: sheetWidth * 0.28,
                                  child: Text(
                                    'From Date: $fromDate',
                                    style: ProjectStyles.invoiceContentStyle(),
                                  ),
                                ),
                                SizedBox(
                                  width: sheetWidth * 0.02,
                                ),
                                Container(
                                  width: sheetWidth * 0.3,
                                  child: Text(
                                    'To Date: $toDate',
                                    style: ProjectStyles.invoiceContentStyle(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: sheetHeight * 0.05,
                            ),
                            DataTable(
                              columnSpacing: 50,
                              // headingTextStyle: TextStyle(fontSize: 25),
                              columns: [
                                DataColumn(
                                  label: Container(
                                    width: 150,
                                    child: const Text(
                                      'Liabilities',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    'Amount',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                DataColumn(
                                  label: Container(
                                    width: 150,
                                    child: const Text(
                                      'Assets',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    'Amount',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                              rows: [
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Capital:'),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                  const DataCell(
                                    Text('Closing Stock'),
                                  ),
                                  DataCell(Text(balanceSheet['Asseets']
                                          ['Final_Closing_Stock']
                                      .toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Opening Balance'),
                                  ),
                                  DataCell(Text((balanceSheet['Liabilities']
                                              ['Cash_In_Hand'] +
                                          balanceSheet['Liabilities']
                                              ['Cash_In_Bank'] +
                                          balanceSheet['Liabilities']
                                              ['Capital_Gold_Buliion_Amount'] +
                                          balanceSheet['Liabilities']
                                              ['Capital_Gold_Ornament_Amount'] +
                                          balanceSheet['Liabilities'][
                                              'Capital_Silver_Buliion_Amount'] +
                                          balanceSheet['Liabilities'][
                                              'Capital_Silver_Ornament_Amount'] +
                                          balanceSheet['Liabilities']
                                              ['Capital_Old_Gold_Amount'] +
                                          balanceSheet['Liabilities']
                                              ['Capital_Old_Silver_Amount'])
                                      .toString())),
                                  const DataCell(
                                    Text('Sundry Debtors'),
                                  ),
                                  DataCell(Text(balanceSheet['Asseets']
                                          ['Receivable']
                                      .toString())),
                                ]),
                                DataRow(
                                  cells: [
                                    const DataCell(
                                      Text('Add:Profit'),
                                    ),
                                    DataCell(Text(balanceSheet['Liabilities']
                                            ['Profit']
                                        .toString())),
                                    const DataCell(
                                      Text('Cash In Hand'),
                                    ),
                                    DataCell(Text(balanceSheet['Asseets']
                                            ['Final_Closing_Cash']
                                        .toString())),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    const DataCell(
                                      Text('Less: Loss'),
                                    ),
                                    DataCell(Text(balanceSheet['Liabilities']
                                            ['Loss']
                                        .toString())),
                                    const DataCell(
                                      Text('Advances Paid'),
                                    ),
                                    DataCell(
                                      Text(balanceSheet['Asseets']
                                              ['advance_paid']
                                          .toString()),
                                    ),
                                  ],
                                ),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Sundry Creditors'),
                                  ),
                                  DataCell(Text(balanceSheet['Liabilities']
                                          ['Payable']
                                      .toString())),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                // DataRow(cells: [
                                //   DataCell(
                                //     Text('Accrued Expenses'),
                                //   ),
                                //   DataCell(Text(balanceSheet['Liabilities']
                                //           ['Accrued_Expenses']
                                //       .toString())),
                                //   DataCell(
                                //     SizedBox(),
                                //   ),
                                //   DataCell(
                                //     SizedBox(),
                                //   ),
                                // ]),
                                DataRow(
                                  cells: [
                                    const DataCell(Text(
                                      'Total',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                    DataCell(Text(balanceSheet['Liabilities']
                                            ['Liabilities']
                                        .toString())),
                                    const DataCell(
                                      Text(
                                        'Total',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    DataCell(Text(balanceSheet['Asseets']
                                            ['Assets']
                                        .toString())),
                                  ],
                                )
                              ],
                            )
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
  "liabilities": {
    "Bills_Payable": {"Payable": 0},
    "Out_Standing_Expenses": 401,
    "Profit": 0,
    "Loss": -123401
  },
  "Assets": {
    "Cash_In_Hand": {"Total_Purchase": 589000},
    "Bills_Receivable": {"Receivable": 5000},
    "Closing_Stock": 5316000
  }
};

var bb = {
  "Total_Sale_Amount": 655000.0,
  "Gold_Bullion_Purchased": 280000.0,
  "Gold_Ornament_Purchased": 120000.0,
  "Silver_Bullion_Purchased": 175000.0,
  "Silver_Ornament_Purchased": 80000.0,
  "Profit": 0,
  "Loss": -400.0,
  "FianlExpenses": {
    "Printing_And_Stationary": 0.0,
    "Travel": 200.0,
    "Food": 200.0,
    "Miscallenous_Expenses": 0.0,
    "Electricity": 0.0,
    "Wages": 0.0,
    "Rent": 0.0
  },
  "Total_Revenue": 655000.0,
  "Total_Expenses": 655400.0
};
var bui = {
  "Liabilities": {
    "Cash_In_Hand": 3000000.0,
    "Cash_In_Bank": 3000000.0,
    "Capital_Gold_Buliion_Amount": 3237504.0,
    "Capital_Gold_Ornament_Amount": 1120000.0,
    "Capital_Silver_Buliion_Amount": 0.0,
    "Capital_Silver_Ornament_Amount": 140000.0,
    "Payable": 5570000.0,
    "Profit": 0,
    "Loss": -388116.0,
    "Liabilities": 16455620.0
  },
  "Asseets": {
    "Receivable": 100000.0,
    "Final_Closing_Cash": -7985300.0,
    "Final_Closing_Stock": 4497504.0,
    "Assets": -3387796.0
  }
};
