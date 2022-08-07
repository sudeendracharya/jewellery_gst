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

class CashBookPage extends StatefulWidget {
  CashBookPage({Key? key}) : super(key: key);

  static const routeName = '/CashBookPage';

  @override
  State<CashBookPage> createState() => _CashBookPageState();
}

class _CashBookPageState extends State<CashBookPage> {
  TextEditingController fromDateController = TextEditingController();

  var startDate;
  var fromDate;
  var endDate;
  var toDate;

  int defaultRowsPerPage = 3;

  Map<String, dynamic> cashReport = {};
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
      endDate = DateFormat("yyyy-MM-dd'").format(pickedDate);

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
        Provider.of<ApiCalls>(context, listen: false).getCashBook(
            {'Start_Date': startDate, 'End_Date': endDate},
            token).then((value) {
          EasyLoading.dismiss();
        });
      });
    }
  }

  ScrollController controller = ScrollController();

  TextStyle tableHeadingStyle() {
    return const TextStyle(fontSize: 18);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    cashReport = Provider.of<ApiCalls>(context).cashReport;
    var sheetWidth = size.width;
    var sheetHeight = size.height * 1;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Cash Book',
          style: ProjectStyles.headingStyle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.05),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ModularWidgets.selectFromDateAndToDate(startDatePicker,
                    endDatePicker, size, fromDate, toDate, save),
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
                  width: sheetWidth * 0.9,
                  height: 520,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Cash Report',
                              style: ProjectStyles.headingStyle()
                                  .copyWith(color: Colors.black),
                            ),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Debit',
                                  style: ProjectStyles.invoiceheadingStyle(),
                                ),
                                Text(
                                  'Credit',
                                  style: ProjectStyles.invoiceheadingStyle(),
                                )
                              ],
                            ),
                          ),
                          const Divider(color: Colors.black),
                          Container(
                            width: sheetWidth * 0.9,
                            height: 400,
                            alignment: Alignment.topCenter,
                            child: Row(
                              children: [
                                Container(
                                  width: sheetWidth * 0.45,
                                  height: 400,
                                  child: DataTable(
                                    // headingTextStyle: TextStyle(fontSize: 18),

                                    columns: [
                                      DataColumn(
                                        label: Container(
                                          width: 50,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Date',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Container(
                                          width: 150,
                                          child: Text(
                                            'Particulars',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Container(
                                          width: 80,
                                          child: Text(
                                            'Cash',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Container(
                                          width: 150,
                                          child: Text(
                                            'Bank',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: cashReport.isEmpty
                                        ? []
                                        : [
                                            DataRow(cells: [
                                              DataCell(Text(startDate ?? '')),
                                              const DataCell(
                                                Text('To Capital'),
                                              ),
                                              DataCell(Text(
                                                  cashReport['Cash_Open']
                                                      .toString())),
                                              DataCell(Text(
                                                  cashReport['Bank_Cash_Open']
                                                      .toString()))
                                            ]),
                                            for (var data in cashReport['Debit']
                                                ['To_Sale'])
                                              DataRow(cells: [
                                                DataCell(
                                                    Text(data['Created_Date'])),
                                                const DataCell(Text('To Sale')),
                                                DataCell(Text(
                                                    data['Cash'].toString())),
                                                DataCell(Text(
                                                    data['Online'].toString()))
                                              ]),
                                            for (var data in cashReport['Debit']
                                                ['To_Received'])
                                              DataRow(cells: [
                                                DataCell(
                                                    Text(data['Created_Date'])),
                                                DataCell(Text(data[
                                                    'Customer_Id__Customer_Name'])),
                                                DataCell(Text(
                                                    data['Cash'].toString())),
                                                DataCell(Text(
                                                    data['Online'].toString()))
                                              ]),
                                            DataRow(cells: [
                                              DataCell(Text('')),
                                              DataCell(
                                                Text('By Balance'),
                                              ),
                                              DataCell(Text(double.parse(
                                                          cashReport[
                                                                  'Cash_Close']
                                                              .toString())
                                                      .isNegative
                                                  ? double.parse(cashReport[
                                                              'Cash_Close']
                                                          .toString())
                                                      .abs()
                                                      .toString()
                                                  : '')),
                                              DataCell(Text(double.parse(cashReport[
                                                              'Bank_Cash_Close']
                                                          .toString())
                                                      .isNegative
                                                  ? double.parse(cashReport[
                                                              'Bank_Cash_Close']
                                                          .toString())
                                                      .abs()
                                                      .toString()
                                                  : '')),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('')),
                                              const DataCell(
                                                Text(''),
                                              ),
                                              DataCell(Text(double.parse(
                                                          cashReport[
                                                                  'Cash_Close']
                                                              .toString())
                                                      .isNegative
                                                  ? (cashReport['Debit'][
                                                              'Debit_Cash_Total'] +
                                                          double.parse(cashReport[
                                                                      'Cash_Close']
                                                                  .toString())
                                                              .abs())
                                                      .toString()
                                                  : cashReport['Debit']
                                                          ['Debit_Cash_Total']
                                                      .toString())),
                                              DataCell(Text(double.parse(cashReport[
                                                              'Bank_Cash_Close']
                                                          .toString())
                                                      .isNegative
                                                  ? (cashReport['Debit'][
                                                              'Debit_Online_Total'] +
                                                          cashReport[
                                                              'Bank_Cash_Close'])
                                                      .toString()
                                                  : cashReport['Debit']
                                                          ['Debit_Online_Total']
                                                      .toString())),
                                            ]),
                                          ],
                                  ),
                                ),
                                Container(
                                  width: sheetWidth * 0.44,
                                  height: 400,
                                  child: DataTable(
                                    // headingTextStyle: TextStyle(fontSize: 18),

                                    columns: [
                                      DataColumn(
                                        label: Container(
                                          // width: 150,
                                          child: Text(
                                            'Date',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Container(
                                          width: 150,
                                          child: Text(
                                            'Particulars',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Container(
                                          width: 80,
                                          child: Text(
                                            'Cash',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Container(
                                          width: 80,
                                          child: Text(
                                            'Bank',
                                            style: tableHeadingStyle(),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: cashReport.isEmpty
                                        ? []
                                        : [
                                            for (var data
                                                in cashReport['Credit']
                                                    ['By_Purchase'])
                                              DataRow(cells: [
                                                DataCell(
                                                    Text(data['Created_Date'])),
                                                const DataCell(
                                                  Text('To Purchase'),
                                                ),
                                                DataCell(Text(
                                                    data['cash'].toString())),
                                                const DataCell(Text('')),
                                              ]),
                                            for (var data
                                                in cashReport['Credit']
                                                    ['by_bank'])
                                              DataRow(cells: [
                                                DataCell(
                                                    Text(data['Created_Date'])),
                                                const DataCell(
                                                  Text('To Purchase'),
                                                ),
                                                const DataCell(Text('')),
                                                DataCell(Text(
                                                    data['bank'].toString())),
                                              ]),
                                            for (var data
                                                in cashReport['Credit']
                                                    ['Expenses'])
                                              DataRow(cells: [
                                                DataCell(
                                                    Text(data['Created_Date'])),
                                                DataCell(
                                                  Text(data['Expense_Name']),
                                                ),
                                                DataCell(Text(
                                                    data['Cash_Expenses']
                                                        .toString())),
                                                DataCell(Text(
                                                    data['Online_Expenses']
                                                        .toString())),
                                              ]),
                                            for (var data
                                                in cashReport['Credit']
                                                    ['To_Paid'])
                                              DataRow(cells: [
                                                DataCell(
                                                    Text(data['Created_Date'])),
                                                DataCell(
                                                  Text(data[
                                                      'Customer_Id__Customer_Name']),
                                                ),
                                                DataCell(Text(
                                                    data['Cash'].toString())),
                                                DataCell(Text(
                                                    data['Online'].toString())),
                                              ]),
                                            DataRow(cells: [
                                              DataCell(Text('')),
                                              DataCell(
                                                Text('By Balance'),
                                              ),
                                              DataCell(Text(double.parse(
                                                          cashReport[
                                                                  'Cash_Close']
                                                              .toString())
                                                      .isNegative
                                                  ? ''
                                                  : cashReport['Cash_Close']
                                                      .toString())),
                                              DataCell(Text(double.parse(cashReport[
                                                              'Bank_Cash_Close']
                                                          .toString())
                                                      .isNegative
                                                  ? ''
                                                  : cashReport[
                                                          'Bank_Cash_Close']
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('')),
                                              const DataCell(
                                                Text(''),
                                              ),
                                              DataCell(Text(double.parse(
                                                          cashReport[
                                                                  'Cash_Close']
                                                              .toString())
                                                      .isNegative
                                                  ? cashReport['Credit']
                                                          ['Credit_Cash_Total']
                                                      .toString()
                                                  : (cashReport['Credit'][
                                                              'Credit_Cash_Total'] +
                                                          cashReport[
                                                              'Cash_Close'])
                                                      .toString())),
                                              DataCell(
                                                Text(
                                                  double.parse(cashReport[
                                                                  'Bank_Cash_Close']
                                                              .toString())
                                                          .isNegative
                                                      ? cashReport['Credit'][
                                                              'Credit_Online_Total']
                                                          .toString()
                                                      : (cashReport['Credit'][
                                                                  'Credit_Online_Total'] +
                                                              cashReport[
                                                                  'Bank_Cash_Close'])
                                                          .toString(),
                                                ),
                                              ),
                                            ]),
                                          ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
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
  }
}
