import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row, Column, Border;
import 'package:url_launcher/url_launcher.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/modular.dart';
import 'add_billing_screen.dart';

class DailyReportScreen extends StatefulWidget {
  DailyReportScreen({Key? key}) : super(key: key);
  static const routeName = '/DailyReportScreen';

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  TextEditingController fromDateController = TextEditingController();

  var startDate;
  var fromDate;
  var endDate;
  var toDate;

  int defaultRowsPerPage = 3;

  Map<String, dynamic> dailyReport = {};

  var selectedDate;

  var selectedConversionTo;
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
        Provider.of<ApiCalls>(context, listen: false).getDailyReport(
            {'Start_Date': startDate, 'End_Date': endDate},
            token).then((value) {
          EasyLoading.dismiss();
        });
      });
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    fromDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    toDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    print({'Start_Date': startDate, 'End_Date': endDate});
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      EasyLoading.show();
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false).getDailyReport(
          {'Start_Date': startDate, 'End_Date': endDate}, token).then((value) {
        EasyLoading.dismiss();
      });
    });

    super.initState();
  }

  Future<void> exportExcel(String name) async {
    if (startDate == endDate) {
      List temp = [];
      if (dailyReport.isNotEmpty) {
        temp.add([
          'Gold Bullion',
          dailyReport['Gold_Bullion'][0]['Opening_Weight'],
          dailyReport['Gold_Bullion'][0]['Purchases'],
          dailyReport['Gold_Bullion'][0]['Sales'],
          dailyReport['Gold_Bullion'][0]['Converted_Weight'],
          dailyReport['Gold_Bullion'][0]['Closing_Weight'],
        ]);
        temp.add([
          'Silver Bullion',
          dailyReport['Silver_Bullion'][0]['Opening_Weight'],
          dailyReport['Silver_Bullion'][0]['Purchases'],
          dailyReport['Silver_Bullion'][0]['Sales'],
          dailyReport['Silver_Bullion'][0]['Converted_Weight'],
          dailyReport['Silver_Bullion'][0]['Closing_Weight'],
        ]);
        temp.add([
          'Gold Ornament',
          dailyReport['Gold_Ornament'][0]['Opening_Weight'],
          dailyReport['Gold_Ornament'][0]['Purchases'],
          dailyReport['Gold_Ornament'][0]['Sales'],
          dailyReport['Gold_Ornament'][0]['Converted_Weight'],
          dailyReport['Gold_Ornament'][0]['Closing_Weight'],
        ]);
        temp.add([
          'Silver Ornament',
          dailyReport['Silver_Oranament'][0]['Opening_Weight'],
          dailyReport['Silver_Oranament'][0]['Purchases'],
          dailyReport['Silver_Oranament'][0]['Sales'],
          dailyReport['Silver_Oranament'][0]['Converted_Weight'],
          dailyReport['Silver_Oranament'][0]['Closing_Weight'],
        ]);
        temp.add([
          'Old Gold',
          dailyReport['Old_Gold '][0]['Old_Gold_Opening_Stock'],
          dailyReport['Old_Gold '][0]['Old_Gold_Weight'],
          dailyReport['Old_Gold '][0]['Exchange_Weight'],
          dailyReport['Old_Gold '][0]['Converted_Weight'],
          dailyReport['Old_Gold '][0]['Old_Gold_Closing_Stock'],
        ]);
        temp.add([
          'Old Sillver',
          dailyReport['Old_Silver'][0]['Old_Silver_Opening_Stock'],
          dailyReport['Old_Silver'][0]['Old_Silver_Weight'],
          dailyReport['Old_Silver'][0]['Exchange_Weight'],
          dailyReport['Old_Silver'][0]['Converted_Weight'],
          dailyReport['Old_Silver'][0]['Old_Silver_Closing_Stock'],
        ]);
      }
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.name = 'Daily Stock';
      Range range = sheet.getRangeByName('A1');
      range.setText('Product Name');
      range = sheet.getRangeByName('B1');
      range.setText('Opening Stock');
      range = sheet.getRangeByName('C1');
      range.setText('Purchase');
      range = sheet.getRangeByName('D1');
      range.setText('Sales');
      range = sheet.getRangeByName('E1');
      range.setText('Converted');
      range = sheet.getRangeByName('F1');
      range.setText('Closing Stock');

      for (int i = 0; i < temp.length; i++) {
        sheet.importList(temp[i], i + 2, 1, false);
      }
      final List<int> bytes = workbook.saveAsStream();
      File('C:/Users/sudee/Documents/$startDate-$endDate.xlsx')
          .writeAsBytes(bytes)
          .then((value) {
        final fileUriWindows = Uri.file(
            'C:/Users/sudee/Documents/$startDate-$endDate.xlsx',
            windows: true);

        launchUrl(fileUriWindows, mode: LaunchMode.externalApplication)
            .then((value) {
          print(value);
        });
      });

      workbook.dispose();
    } else {
      if (dailyReport.isNotEmpty) {
        final Workbook workbook = Workbook(6);
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'Gold Bullion';
        Range range = sheet.getRangeByName('A1');
        range.setText('Date');
        range = sheet.getRangeByName('B1');
        range.setText('Opening Stock');
        range = sheet.getRangeByName('C1');
        range.setText('Purchase');
        range = sheet.getRangeByName('D1');
        range.setText('Sales');
        range = sheet.getRangeByName('E1');
        range.setText('Converted');
        range = sheet.getRangeByName('F1');
        range.setText('Closing Stock');

        List goldBullionTemp = [];
        recordForExport('Gold_Bullion', goldBullionTemp);
        for (int i = 0; i < goldBullionTemp.length; i++) {
          sheet.importList(goldBullionTemp[i], i + 2, 1, false);
        }

        final Worksheet sheet1 = workbook.worksheets[1];
        sheet1.name = 'Silver Bullion';
        Range range1 = sheet1.getRangeByName('A1');
        range1.setText('Date');
        range1 = sheet1.getRangeByName('B1');
        range1.setText('Opening Stock');
        range1 = sheet1.getRangeByName('C1');
        range1.setText('Purchase');
        range1 = sheet1.getRangeByName('D1');
        range1.setText('Sales');
        range1 = sheet1.getRangeByName('E1');
        range1.setText('Converted');
        range1 = sheet1.getRangeByName('F1');
        range1.setText('Closing Stock');

        List silverBullionTemp = [];
        recordForExport('Silver_Bullion', silverBullionTemp);
        for (int i = 0; i < silverBullionTemp.length; i++) {
          sheet1.importList(silverBullionTemp[i], i + 2, 1, false);
        }

        final Worksheet sheet2 = workbook.worksheets[2];
        sheet2.name = 'Gold Ornament';
        Range range2 = sheet2.getRangeByName('A1');
        range2.setText('Date');
        range2 = sheet2.getRangeByName('B1');
        range2.setText('Opening Stock');
        range2 = sheet2.getRangeByName('C1');
        range2.setText('Purchase');
        range2 = sheet2.getRangeByName('D1');
        range2.setText('Sales');
        range2 = sheet2.getRangeByName('E1');
        range2.setText('Converted');
        range2 = sheet2.getRangeByName('F1');
        range2.setText('Closing Stock');

        List goldOrnamentTemp = [];
        recordForExport('Gold_Ornament', goldOrnamentTemp);
        for (int i = 0; i < goldOrnamentTemp.length; i++) {
          sheet2.importList(goldOrnamentTemp[i], i + 2, 1, false);
        }

        final Worksheet sheet3 = workbook.worksheets[3];
        sheet3.name = 'Silver Ornament';
        Range range3 = sheet3.getRangeByName('A1');
        range3.setText('Date');
        range3 = sheet3.getRangeByName('B1');
        range3.setText('Opening Stock');
        range3 = sheet3.getRangeByName('C1');
        range3.setText('Purchase');
        range3 = sheet3.getRangeByName('D1');
        range3.setText('Sales');
        range3 = sheet3.getRangeByName('E1');
        range3.setText('Converted');
        range3 = sheet3.getRangeByName('F1');
        range3.setText('Closing Stock');

        List silverOrnamentTemp = [];
        recordForExport('Silver_Oranament', silverOrnamentTemp);
        for (int i = 0; i < silverOrnamentTemp.length; i++) {
          sheet3.importList(silverOrnamentTemp[i], i + 2, 1, false);
        }

        final Worksheet sheet4 = workbook.worksheets[4];
        sheet4.name = 'Old Gold';
        Range range4 = sheet3.getRangeByName('A1');
        range4.setText('Date');
        range4 = sheet4.getRangeByName('B1');
        range4.setText('Opening Stock');
        range4 = sheet4.getRangeByName('C1');
        range4.setText('Purchase');
        range4 = sheet4.getRangeByName('D1');
        range4.setText('Sales');
        range4 = sheet4.getRangeByName('E1');
        range4.setText('Converted');
        range4 = sheet4.getRangeByName('F1');
        range4.setText('Closing Stock');

        List oldGoldTemp = [];
        recordForOldExport('Old_Gold ', oldGoldTemp);
        for (int i = 0; i < oldGoldTemp.length; i++) {
          sheet4.importList(oldGoldTemp[i], i + 2, 1, false);
        }

        final Worksheet sheet5 = workbook.worksheets[5];
        sheet5.name = 'Old Silver';
        Range range5 = sheet5.getRangeByName('A1');
        range5.setText('Date');
        range5 = sheet5.getRangeByName('B1');
        range5.setText('Opening Stock');
        range5 = sheet5.getRangeByName('C1');
        range5.setText('Purchase');
        range5 = sheet5.getRangeByName('D1');
        range5.setText('Sales');
        range5 = sheet5.getRangeByName('E1');
        range5.setText('Converted');
        range5 = sheet5.getRangeByName('F1');
        range5.setText('Closing Stock');

        List oldSillverTemp = [];
        recordForOldExport('Old_Silver', oldSillverTemp);
        for (int i = 0; i < oldSillverTemp.length; i++) {
          sheet5.importList(oldSillverTemp[i], i + 2, 1, false);
        }

        final List<int> bytes = workbook.saveAsStream();

        try {
          File('C:/Users/sudee/Documents/$startDate-$endDate.xlsx')
              .writeAsBytes(bytes)
              .then((value) {
            final fileUriWindows = Uri.file(
                'C:/Users/sudee/Documents/$startDate-$endDate.xlsx',
                windows: true);

            launchUrl(fileUriWindows, mode: LaunchMode.externalApplication)
                .then((value) {
              print('After launching  $value');
            });
          });
        } catch (e) {
          failureSnackbar(e.toString());
        }

        workbook.dispose();
      }
    }
  }

  void recordForExport(String metal, List tempList) {
    for (var data in dailyReport[metal]) {
      tempList.add([
        DateFormat('dd-MM-yyyy').format(
          DateTime.parse(
            data['Created_Date'],
          ),
        ),
        data['Opening_Weight'],
        data['Purchases'],
        data['Sales'],
        data['Converted_Weight'],
        data['Closing_Weight'],
      ]);
    }
  }

  void recordForOldExport(String metal, List tempList) {
    for (var data in dailyReport[metal]) {
      tempList.add([
        DateFormat('dd-MM-yyyy').format(
          DateTime.parse(
            data['Created_Date'],
          ),
        ),
        metal == 'Old_Silver'
            ? data['Old_Silver_Opening_Stock']
            : data['Old_Gold_Opening_Stock'],
        metal == 'Old_Silver'
            ? data['Old_Silver_Weight']
            : data['Old_Gold_Weight'],
        data['Exchange_Weight'],
        data['Converted_Weight'],
        metal == 'Old_Silver'
            ? data['Old_Silver_Closing_Stock']
            : data['Old_Gold_Closing_Stock'],
      ]);
    }
  }

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectories();
    // For your reference print the AppDoc directory
    print(directory!.first.path);
    return directory.first.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${startDate}to$endDate.xlsx');
  }

  var token;
  Future<void> getToken() async {
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      token = Provider.of<Authenticate>(context, listen: false).token;
    });
  }

  void savePurchase() {
    _formKey.currentState!.save();
    convertDetails['Created_Date'] =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    print(convertDetails);
    getToken().then((value) {
      Provider.of<ApiCalls>(context, listen: false)
          .convertOldItem(convertDetails, token)
          .then((value) {
        if (value == 201 || value == 200) {
          Get.back();
          Get.showSnackbar(const GetSnackBar(
            title: 'Success',
            message: 'Successfully saved the data',
            duration: Duration(seconds: 4),
          ));
        } else {
          Get.showSnackbar(const GetSnackBar(
            title: 'Failed',
            message: 'Something went wrong unable to add data',
            duration: Duration(seconds: 4),
          ));
        }
      });
    });
  }

  Map<String, dynamic> convertDetails = {};
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var dialogFormWidth = size.width * 0.4;
    var formheight = size.height * 0.05;
    dailyReport = Provider.of<ApiCalls>(context).dailyReport;
    var sheetWidth = size.width;
    var sheetHeight = size.height * 1;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Report',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ProjectColors.buttonColor)),
                onPressed: () {
                  exportExcel('');
                },
                child: const Text(
                  'Export',
                  style: TextStyle(color: Colors.black),
                )),
          ),
        ],
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
              dailyReport.isEmpty
                  ? const SizedBox()
                  : fromDate == toDate
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            width: sheetWidth * 0.9,
                            height: 521,
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Stock Report',
                                    style: ProjectStyles.headingStyle()
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                                const Divider(color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'From Date: ${fromDate}',
                                        style:
                                            ProjectStyles.invoiceheadingStyle(),
                                      ),
                                      Text(
                                        'To Date: ${toDate}',
                                        style:
                                            ProjectStyles.invoiceheadingStyle(),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.black),
                                Container(
                                  width: sheetWidth * 0.9,
                                  height: 400,
                                  alignment: Alignment.topCenter,
                                  child: DataTable(
                                      columnSpacing: 100,
                                      headingTextStyle:
                                          ProjectStyles.invoiceheadingStyle(),
                                      columns: [
                                        DataColumn(
                                          label: Container(
                                            width: 150,
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Product Name'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                              width: 150,
                                              child: Text('Opening Stock')),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            width: 80,
                                            child: const Text('Purchase'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            width: 80,
                                            child: const Text('Sales'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            width: 150,
                                            child: const Text('Converted'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            width: 150,
                                            child: const Text('Closing Stock'),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        DataRow(cells: [
                                          const DataCell(
                                            Text('Gold Bullion'),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Gold_Bullion'][0]
                                                      ['Opening_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Gold_Bullion'][0]
                                                      ['Purchases']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Gold_Bullion'][0]
                                                      ['Sales']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Gold_Bullion'][0]
                                                      ['Converted_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Gold_Bullion'][0]
                                                      ['Closing_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text('Silver Bullion'),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Silver_Bullion'][0]
                                                      ['Opening_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Silver_Bullion'][0]
                                                      ['Purchases']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Silver_Bullion'][0]
                                                      ['Sales']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Silver_Bullion'][0]
                                                      ['Converted_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Silver_Bullion'][0]
                                                      ['Closing_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text('Gold Ornament'),
                                          ),
                                          DataCell(
                                            dailyReport['Gold_Ornament'].isEmpty
                                                ? const Text('')
                                                : Text(
                                                    dailyReport['Gold_Ornament']
                                                                [0]
                                                            ['Opening_Weight']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Gold_Ornament'].isEmpty
                                                ? const Text('')
                                                : Text(
                                                    dailyReport['Gold_Ornament']
                                                            [0]['Purchases']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Gold_Ornament'].isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Gold_Ornament']
                                                            [0]['Sales']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Gold_Ornament'].isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Gold_Ornament']
                                                                [0]
                                                            ['Converted_Weight']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Gold_Ornament'].isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Gold_Ornament']
                                                                [0]
                                                            ['Closing_Weight']
                                                        .toString(),
                                                  ),
                                          ),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text('Silver Ornament'),
                                          ),
                                          DataCell(
                                            dailyReport['Silver_Oranament']
                                                    .isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Silver_Oranament']
                                                                [0]
                                                            ['Opening_Weight']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Silver_Oranament']
                                                    .isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Silver_Oranament']
                                                            [0]['Purchases']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Silver_Oranament']
                                                    .isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Silver_Oranament']
                                                            [0]['Sales']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Silver_Oranament']
                                                    .isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Silver_Oranament']
                                                                [0]
                                                            ['Converted_Weight']
                                                        .toString(),
                                                  ),
                                          ),
                                          DataCell(
                                            dailyReport['Silver_Oranament']
                                                    .isEmpty
                                                ? Text('')
                                                : Text(
                                                    dailyReport['Silver_Oranament']
                                                                [0]
                                                            ['Closing_Weight']
                                                        .toString(),
                                                  ),
                                          ),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text('Old Gold'),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Gold '][0]
                                                      ['Old_Gold_Opening_Stock']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Gold '][0]
                                                      ['Old_Gold_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Gold '][0]
                                                      ['Exchange_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Gold '][0]
                                                      ['Converted_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Gold '][0]
                                                      ['Old_Gold_Closing_Stock']
                                                  .toString(),
                                            ),
                                          ),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(
                                            Text('Old Silver'),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Silver'][0][
                                                      'Old_Silver_Opening_Stock']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Silver'][0]
                                                      ['Old_Silver_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Silver'][0]
                                                      ['Exchange_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Silver'][0]
                                                      ['Converted_Weight']
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              dailyReport['Old_Silver'][0][
                                                      'Old_Silver_Closing_Stock']
                                                  .toString(),
                                            ),
                                          ),
                                        ]),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              width: size.width * 0.7,
                              child: PaginatedDataTable(
                                header: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Gold Bullion'),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       exportExcel('Gold_Bullion');
                                    //     },
                                    //     child: const Text('Export'))
                                  ],
                                ),
                                source: GoldBullionData(
                                    dailyReport['Gold_Bullion'], (value) {}),
                                arrowHeadColor: ProjectColors.themeColor,
                                columns: const [
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Opening Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Purchases',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Sales',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Converted',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Closing Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),

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
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: size.width * 0.7,
                              child: PaginatedDataTable(
                                header: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Silver Bullion'),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       exportExcel('Silver_Bullion');
                                    //     },
                                    //     child: const Text('Export'))
                                  ],
                                ),
                                source: GoldBullionData(
                                    dailyReport['Silver_Bullion'], (value) {}),
                                arrowHeadColor: ProjectColors.themeColor,

                                columns: const [
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Opening Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Purchases',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Sales',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Converted',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Closing Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),

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
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: size.width * 0.7,
                              child: PaginatedDataTable(
                                header: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Gold Ornament'),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       exportExcel('Gold_Ornament');
                                    //     },
                                    //     child: const Text('Export'))
                                  ],
                                ),
                                source: GoldBullionData(
                                    dailyReport['Gold_Ornament'], (value) {}),
                                arrowHeadColor: ProjectColors.themeColor,

                                columns: const [
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Opening Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Purchases',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Sales',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Converted',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Closing Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),

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
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: size.width * 0.7,
                              child: PaginatedDataTable(
                                header: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Silver Ornament'),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       exportExcel('Silver_Ornament');
                                    //     },
                                    //     child: const Text('Export'))
                                  ],
                                ),
                                source: GoldBullionData(
                                    dailyReport['Silver_Oranament'],
                                    (value) {}),
                                arrowHeadColor: ProjectColors.themeColor,

                                columns: const [
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Opening Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Purchases',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Sales',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Converted',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Closing Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),

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
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: size.width * 0.7,
                              child: PaginatedDataTable(
                                header: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Old Gold'),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       exportExcel('Old_Gold');
                                    //     },
                                    //     child: const Text('Export'))
                                  ],
                                ),
                                source: OldGoldMetalData(
                                    dailyReport['Old_Gold '], (value) {}),
                                arrowHeadColor: ProjectColors.themeColor,

                                columns: const [
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Opening Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Purchases',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Sales',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Converted',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Closing Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),

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
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: size.width * 0.7,
                              child: PaginatedDataTable(
                                header: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Old Silver'),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       exportExcel('Old_Silver');
                                    //     },
                                    //     child: const Text('Export'))
                                  ],
                                ),
                                source: OldSilverMetalData(
                                    dailyReport['Old_Silver'], (value) {}),
                                arrowHeadColor: ProjectColors.themeColor,

                                columns: const [
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Opening Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Purchases',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Sales',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Converted',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Closing Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),

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
                        )
            ],
          ),
        ),
      ),
    );
  }
}

class OldSilverMetalData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  OldSilverMetalData(
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
            DateFormat('dd-MM-yyyy').format(
              DateTime.parse(
                data[index]['Created_Date'],
              ),
            ),
          )),
          DataCell(Text(
              '${data[index]['Old_Silver_Opening_Stock'].toString()} (g)')),
          DataCell(Text('${data[index]['Old_Silver_Weight'].toString()} (g)')),
          DataCell(Text('${data[index]['Exchange_Weight'].toString()} (g)')),
          DataCell(Text('${data[index]['Converted_Weight'].toString()} (g)')),
          DataCell(Text(
              '${data[index]['Old_Silver_Closing_Stock'].toString()} (g)')),
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

class OldGoldMetalData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  OldGoldMetalData(
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
            DateFormat('dd-MM-yyyy').format(
              DateTime.parse(
                data[index]['Created_Date'],
              ),
            ),
          )),
          DataCell(
              Text('${data[index]['Old_Gold_Opening_Stock'].toString()} (g)')),
          DataCell(Text('${data[index]['Old_Gold_Weight'].toString()} (g)')),
          DataCell(Text('${data[index]['Exchange_Weight'].toString()} (g)')),
          DataCell(Text('${data[index]['Converted_Weight'].toString()} (g)')),
          DataCell(
              Text('${data[index]['Old_Gold_Closing_Stock'].toString()} (g)')),
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

class GoldBullionData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  GoldBullionData(
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
            DateFormat('dd-MM-yyyy').format(
              DateTime.parse(
                data[index]['Created_Date'],
              ),
            ),
          )),
          DataCell(Text('${data[index]['Opening_Weight'].toString()} (g)')),
          DataCell(Text('${data[index]['Purchases'].toString()} (g)')),
          DataCell(Text('${data[index]['Sales'].toString()} (g)')),
          DataCell(Text('${data[index]['Converted_Weight'].toString()} (g)')),
          DataCell(Text('${data[index]['Closing_Weight'].toString()} (g)')),
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

var tty = {
  "Cash_Open": 500000.0,
  "Cash_Close": 825000.0,
  "Bank_Cash_Open": 200000.0,
  "Bank_Cash_Close": 170000.0,
  "Gold_Bullion": [
    {
      "Gold_Bullion_Stock_Id": 1,
      "Opening_Weight": "1000.00",
      "Rate": "4500.00",
      "Amount": "4500000.00",
      "Sales": "1000.00",
      "Purchases": "700.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "700.00",
      "Created_on": "2022-05-20T13:23:36.688132",
      "Created_Date": "2022-05-20"
    }
  ],
  "Gold_Ornament": [
    {
      "Gold_Ornament_Stock_Id": 1,
      "Opening_Weight": "100.00",
      "Rate": "4500.00",
      "Amount": "4500000.00",
      "Sales": "150.00",
      "Purchases": "100.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "50.00",
      "Created_on": "2022-05-20T13:24:09.821716",
      "Created_Date": "2022-05-20"
    }
  ],
  "Silver_Bullion": [
    {
      "Silver_Bullion_Stock_Id": 1,
      "Opening_Weight": "1000.00",
      "Rate": "2000.00",
      "Amount": "2000000.00",
      "Sales": "150.00",
      "Purchases": "200.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "1050.00",
      "Created_on": "2022-05-20T13:40:21.523165",
      "Created_Date": "2022-05-20"
    }
  ],
  "Silver_Oranament": [
    {
      "Silver_Ornament_Stock_Id": 1,
      "Opening_Weight": "200.00",
      "Rate": "4500.00",
      "Amount": "900000.00",
      "Sales": "250.00",
      "Purchases": "0.00",
      "Converted_Weight": "0.00",
      "Closing_Weight": "-50.00",
      "Created_on": "2022-05-20T13:41:06.320609",
      "Created_Date": "2022-05-20"
    }
  ],
  "Old_Gold ": [
    {
      "Old_Gold_Id": 1,
      "Old_Gold_Opening_Stock": "250.00",
      "Old_Gold_Weight": "456.00",
      "Old_Gold_Closing_Stock": "356.00",
      "Exchange_Weight": "350.00",
      "Converted_Weight": "0.00",
      "Created_on": "2022-05-20T13:24:33.821351",
      "Created_Date": "2022-05-20"
    }
  ],
  "Old_Silver": [
    {
      "Old_Silver_Id": 1,
      "Old_Silver_Opening_Stock": "250.00",
      "Old_Silver_Weight": "326.00",
      "Old_Silver_Closing_Stock": "576.00",
      "Exchange_Weight": "0.00",
      "Converted_Weight": "0.00",
      "Created_on": "2022-05-20T13:26:20.598705",
      "Created_Date": "2022-05-20"
    }
  ]
};
