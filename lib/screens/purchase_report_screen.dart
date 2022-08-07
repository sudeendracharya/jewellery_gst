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

class PurchaseReportScreen extends StatefulWidget {
  PurchaseReportScreen({Key? key}) : super(key: key);
  static const routeName = '/PurchaseReportScreen';
  @override
  State<PurchaseReportScreen> createState() => _PurchaseReportScreenState();
}

class _PurchaseReportScreenState extends State<PurchaseReportScreen> {
  TextEditingController fromDateController = TextEditingController();

  var startDate;
  var fromDate;
  var endDate;
  var toDate;

  Map<String, dynamic> balanceSheet = {};

  List purchaseReport = [];
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
        Provider.of<ApiCalls>(context, listen: false).getPurchaseReport(
            {'Start_Date': startDate, 'End_Date': endDate},
            token).then((value) {
          EasyLoading.dismiss();
        });
      });
    }

    // Provider.of<Authenticate>(context, listen: false)
    //     .tryAutoLogin()
    //     .then((value) {
    //   var token = Provider.of<Authenticate>(context, listen: false).token;
    //   Provider.of<ApiCalls>(context, listen: false).getBalanceSheet(
    //       {'Start_Date': startDate, 'End_Date': endDate},
    //       token).then((value) {});
    // });
  }

  double cusGoldOrnamentTotal = 0;
  double cusSilverOrnamentTotal = 0;
  double cusGoldBullionTotal = 0;
  double cusSilverBullionTotal = 0;
  double supGoldOrnamentTotal = 0;
  double supSilverOrnamentTotal = 0;
  double supGoldBullionTotal = 0;
  double supSilverBullionTotal = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    purchaseReport = Provider.of<ApiCalls>(context).purchaseReportList;

    var sheetWidth = size.width * 0.38;
    var sheetHeight = size.height * 1;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Purchase Report',
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
                height: 500,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Purchase Report',
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
                                  DataColumn(
                                    label: Text('Credit'),
                                  ),
                                ],
                                rows: [
                                  for (var data in purchaseReport)
                                    DataRow(
                                      cells: [
                                        DataCell(Text(data['Created_Date'])),
                                        DataCell(
                                          Text(
                                            'Purchase',
                                            style: ProjectStyles
                                                .invoiceContentStyle(),
                                          ),
                                        ),
                                        DataCell(Text(data['Purchase_Credit']
                                            .toString())),
                                      ],
                                    ),
                                ]),
                          ),
                        ],
                      ),
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
  "Customer": {
    "Cash": {
      "Gold_Ornament": 0,
      "Silver_Ornament": 0,
      "Gold_Bullion": 0,
      "Silver_Bullion": 0
    },
    "Credit": {
      "Gold_Ornament": 50000.0,
      "Silver_Ornament": 0,
      "Gold_Bullion": 0,
      "Silver_Bullion": 0
    },
    "Exchange": {
      "Gold_Ornament": 0,
      "Silver_Ornament": 10000.0,
      "Gold_Bullion": 0,
      "Silver_Bullion": 0
    }
  },
  "Supplier": {
    "Cash": {
      "Gold_Ornament": 0,
      "Silver_Ornament": 0,
      "Gold_Bullion": 25000.0,
      "Silver_Bullion": 50000.0
    },
    "Credit": {
      "Gold_Ornament": 0,
      "Silver_Ornament": 0,
      "Gold_Bullion": 0,
      "Silver_Bullion": 0
    },
    "Exchange": {
      "Gold_Ornament": 0,
      "Silver_Ornament": 0,
      "Gold_Bullion": 0,
      "Silver_Bullion": 0
    }
  }
};

var cat = {
  'customer': {
    'Gold_Ornament': {
      'Cash': 'data',
      'Credit': 'data',
      'Exchange': 'data',
    },
    'Silver_Ornament': {
      'Cash': 'data',
      'Credit': 'data',
      'Exchange': 'data',
    }
  }
};

var sales = {
  'Cash': {
    'Gold': {
      'Grams': 'data',
      'Amount': 'data',
    },
    'Silver': {
      'Grams': 'data',
      'Amount': 'data',
    }
  },
  'Card': {
    'Gold': {
      'Grams': 'data',
      'Amount': 'data',
    },
    'Silver': {
      'Grams': 'data',
      'Amount': 'data',
    }
  },
  'Credit': {
    'Gold': {
      'Grams': 'data',
      'Amount': 'data',
    },
    'Silver': {
      'Grams': 'data',
      'Amount': 'data',
    }
  }
};

var dailyReport = {
  'Opening Balance': '',
  'Sales': {
    'Cash': {
      'Grams': 'data',
      'Amount': 'data',
    },
    'Card': {
      'Grams': 'data',
      'Amount': 'data',
    },
    'Credit': {
      'Grams': 'data',
      'Amount': 'data',
    }
  },
  'Old_Items': {
    'Old_Gold': {
      'Grams': 'data',
      'Amount': 'data',
    },
    'Old_Silver': {
      'Grams': 'data',
      'Amount': 'data',
    }
  },
  'Credit_Repaid': [
    {
      'Customer_Name': 'data',
      'Paid_Amount': 'data',
    }
  ],
  'Purchases': {
    "Customer": {
      "Cash": {
        "Gold_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Gold_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        }
      },
      "Credit": {
        "Gold_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Gold_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        }
      },
      "Exchange": {
        "Gold_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Gold_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        }
      }
    },
    "Supplier": {
      "Cash": {
        "Gold_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Gold_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        }
      },
      "Credit": {
        "Gold_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Gold_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        }
      },
      "Exchange": {
        "Gold_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Ornament": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Gold_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        },
        "Silver_Bullion": {
          'Grams': 'data',
          'Amount': 'data',
        }
      }
    }
  },
};
