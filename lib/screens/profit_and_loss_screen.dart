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

class ProfitAndLossPage extends StatefulWidget {
  ProfitAndLossPage({Key? key}) : super(key: key);

  static const routeName = '/ProfitAndLossPage';

  @override
  State<ProfitAndLossPage> createState() => _ProfitAndLossPageState();
}

class _ProfitAndLossPageState extends State<ProfitAndLossPage> {
  TextEditingController fromDateController = TextEditingController();

  var startDate;
  var fromDate;
  var endDate;
  var toDate;

  Map<String, dynamic> profitAndLossSheet = {};
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
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false).getProfitAndLossSheet(
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
    profitAndLossSheet = Provider.of<ApiCalls>(context).profitAndLossSheet;
    var sheetWidth = size.width * 0.4;
    var sheetHeight = size.height * 0.8;
    double finalTotal = 0;
    if (profitAndLossSheet.isNotEmpty) {
      finalTotal =
          double.parse(profitAndLossSheet['Total_Revenue'].toString()) -
              double.parse(profitAndLossSheet['Total_Expenses'].toString()) -
              double.parse(
                  profitAndLossSheet['Gold_Bullion_Purchased'].toString()) -
              double.parse(
                  profitAndLossSheet['Gold_Ornament_Purchased'].toString()) -
              double.parse(
                  profitAndLossSheet['Silver_Bullion_Purchased'].toString()) -
              double.parse(
                  profitAndLossSheet['Silver_Ornament_Purchased'].toString());
    }
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Profit And Loss Sheet',
          style: ProjectStyles.headingStyle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.02),
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
                height: 20,
              ),
              profitAndLossSheet.isEmpty
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Profit And Loss Statement',
                                    style: ProjectStyles.invoiceheadingStyle(),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'From Date: ',
                                        style:
                                            ProjectStyles.invoiceheadingStyle()
                                                .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        fromDate ?? '',
                                        style:
                                            ProjectStyles.invoiceheadingStyle()
                                                .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'To Date: ',
                                        style:
                                            ProjectStyles.invoiceheadingStyle()
                                                .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        toDate ?? '',
                                        style:
                                            ProjectStyles.invoiceheadingStyle()
                                                .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              DataTable(columns: [
                                DataColumn(
                                  label: Container(
                                    width: 200,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Particulars',
                                      style:
                                          ProjectStyles.invoiceheadingStyle(),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Amount',
                                    style: ProjectStyles.invoiceheadingStyle(),
                                  ),
                                ),

                                // DataColumn(
                                //   label: Container(
                                //     width: 150,
                                //     alignment: Alignment.centerLeft,
                                //     child: Text(
                                //       'Particulars',
                                //       style: ProjectStyles.invoiceheadingStyle(),
                                //     ),
                                //   ),
                                // ),
                                DataColumn(
                                  label: Text(
                                    'Amount',
                                    style: ProjectStyles.invoiceheadingStyle(),
                                  ),
                                ),
                              ], rows: [
                                DataRow(cells: [
                                  DataCell(
                                    Text(
                                      'Revenues',
                                      style:
                                          ProjectStyles.invoiceheadingStyle(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Sales'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['Total_Sale_Amount']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                // DataRow(cells: [
                                //   const DataCell(
                                //     Text('Gold Ornament'),
                                //   ),
                                //   DataCell(
                                //     Text(
                                //       profitAndLossSheet['Gold_Ornament_Amount']
                                //           .toString(),
                                //     ),
                                //   ),
                                //   const DataCell(
                                //     const SizedBox(),
                                //   ),
                                // ]),
                                // DataRow(cells: [
                                //   const DataCell(
                                //     Text('Silver Bullion'),
                                //   ),
                                //   DataCell(
                                //     Text(
                                //       profitAndLossSheet[
                                //               'Silver_Bullion_Amount']
                                //           .toString(),
                                //     ),
                                //   ),
                                //   const DataCell(
                                //     SizedBox(),
                                //   ),
                                // ]),
                                // DataRow(cells: [
                                //   const DataCell(
                                //     Text('Silver Ornament'),
                                //   ),
                                //   DataCell(
                                //     Text(
                                //       profitAndLossSheet[
                                //               'Silver_Ornament_Amount']
                                //           .toString(),
                                //     ),
                                //   ),
                                //   const DataCell(
                                //     SizedBox(),
                                //   ),
                                // ]),
                                // DataRow(cells: [
                                //   const DataCell(
                                //     const Text('Bills Received'),
                                //   ),
                                //   DataCell(
                                //     Text(
                                //       profitAndLossSheet['Receivable']
                                //           .toString(),
                                //     ),
                                //   ),
                                //   const DataCell(
                                //     SizedBox(),
                                //   ),
                                // ]),
                                DataRow(cells: [
                                  DataCell(
                                    Text(
                                      'Total Revenues',
                                      style:
                                          ProjectStyles.invoiceheadingStyle(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['Total_Revenue']
                                          .toString(),
                                      style:
                                          ProjectStyles.invoiceheadingStyle(),
                                    ),
                                  ),
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                    Text(
                                      'Expenses',
                                      style:
                                          ProjectStyles.invoiceheadingStyle(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('COGS(Gold Bullion)'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet[
                                              'Gold_Bullion_Purchased']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    const SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    const Text('COGS(Silver Bullion)'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet[
                                              'Silver_Bullion_Purchased']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('COGS(Gold Ornament)'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet[
                                              'Gold_Ornament_Purchased']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    const Text('COGS(Silver Ornament)'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet[
                                              'Silver_Ornament_Purchased']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    const SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    const Text('Printing And Stationary'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['FianlExpenses']
                                              ['Printing_And_Stationary']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    const SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Travel'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['FianlExpenses']
                                              ['Travel']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Food'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['FianlExpenses']
                                              ['Food']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    const SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Miscallenous Expenses'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['FianlExpenses']
                                              ['Miscallenous_Expenses']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Electricity'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['FianlExpenses']
                                              ['Electricity']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    const Text('Wages'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['FianlExpenses']
                                              ['Wages']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    const SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  const DataCell(
                                    Text('Rent'),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['FianlExpenses']
                                              ['Rent']
                                          .toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                    Text(
                                      'Total Expenses',
                                      style:
                                          ProjectStyles.invoiceheadingStyle(),
                                    ),
                                  ),
                                  const DataCell(
                                    const SizedBox(),
                                  ),
                                  DataCell(
                                    Text(
                                      profitAndLossSheet['Total_Expenses']
                                          .toString(),
                                      style:
                                          ProjectStyles.invoiceheadingStyle(),
                                    ),
                                  ),
                                ]),
                                DataRow(cells: [
                                  DataCell(profitAndLossSheet['Profit'] == 0
                                      ? Text(
                                          'Net Loss',
                                          style: ProjectStyles
                                              .invoiceheadingStyle(),
                                        )
                                      : Text(
                                          'Net Income',
                                          style: ProjectStyles
                                              .invoiceheadingStyle(),
                                        )),
                                  const DataCell(
                                    SizedBox(),
                                  ),
                                  // DataCell(Text(
                                  //   '${double.parse(profitAndLossSheet['Total_Revenue'].toString()) - double.parse(profitAndLossSheet['Total_Expenses'].toString())}',
                                  //   style: ProjectStyles.invoiceheadingStyle(),
                                  // )),
                                  DataCell(Text(
                                    profitAndLossSheet['Profit'] == 0
                                        ? profitAndLossSheet['Loss'].toString()
                                        : profitAndLossSheet['Profit']
                                            .toString(),
                                    style: ProjectStyles.invoiceheadingStyle(),
                                  ))
                                ]),
                              ])
                            ],
                          ),
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
  "Payable": 0.0,
  "Receivable": 5000.0,
  "Gold_Bullion_Purchased": 1000.0,
  "Gold_Bullion_Amount": 25000.0,
  "Gold_Ornament_Purchased": 0,
  "Gold_Ornament_Amount": 0,
  "Silver_Bullion_Purchased": 0,
  "Silver_Bullion_Amount": 0,
  "Silver_Ornament_Purchased": 0,
  "Silver_Ornament_Amount": 0,
  "FianlExpenses": {
    "Printing_And_Stationary": 201.0,
    "Travel": 200.0,
    "Food": 0.0,
    "Miscallenous_Expenses": 0.0,
    "Electricity": 0.0,
    "Wages": 0.0,
    "Rent": 0.0
  }
};

var data1 = {
  'Total_Revenue': 'Gold_Bullion_Amount' +
      'Gold_Ornament_Amount' +
      'Silver_Bullion_Amount' +
      'Silver_Ornament_Amount' +
      'Receivable',
  'Total_Expenses': 'Gold_Bullion_Purchased' +
      'Gold_Ornament_Purchased' +
      'Silver_Bullion_Purchased' +
      'Silver_Ornament_Purchased' +
      'Printing_And_Stationary' +
      'Travel' +
      'Food' +
      'Miscallenous_Expenses' +
      'Electricity' +
      'Wages' +
      'Rent'
};

var thy = {
  "Total_Sale_Amount": 300000.0,
  "Gold_Bullion_Purchased": 300000.0,
  "Gold_Ornament_Purchased": 0.0,
  "Silver_Bullion_Purchased": 0.0,
  "Silver_Ornament_Purchased": 0.0,
  "FianlExpenses": {
    "Printing_And_Stationary": 0.0,
    "Travel": 0.0,
    "Food": 0.0,
    "Miscallenous_Expenses": 0.0,
    "Electricity": 0.0,
    "Wages": 0.0,
    "Rent": 0.0
  },
  "Total_Revenue": 300000.0,
  "Total_Expenses": 300000.0
};
