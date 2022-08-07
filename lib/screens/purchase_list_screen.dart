import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'purchase_details_page.dart';
import 'purchases_screen.dart';

class PurchaseListScreen extends StatefulWidget {
  PurchaseListScreen({Key? key}) : super(key: key);

  static const routeName = '/PurchaseListScreen';

  @override
  State<PurchaseListScreen> createState() => _PurchaseListScreenState();
}

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  List purchaseList = [];

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getPurchaseInvoice(token)
          .then((value) => null);
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;

  void fetch() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getPurchaseInvoice(token)
          .then((value) => null);
    });
  }

  void deletePurchase(int id) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      title: 'Alert',
      middleText: 'Are you sure want to delete this bill?',
      confirm: TextButton(
        onPressed: () {
          Provider.of<Authenticate>(context, listen: false)
              .tryAutoLogin()
              .then((value) {
            var token = Provider.of<Authenticate>(context, listen: false).token;
            Provider.of<ApiCalls>(context, listen: false)
                .deletePurchaseInvoice(id, token)
                .then((value) {
              if (value == 204) {
                Get.back();
                fetch();
                successSnackbar('successfully deleted the invoice');
              } else {
                Get.back();
                failureSnackbar(
                    'Something went wrong unable to delete the invoice');
              }
            });
          });
        },
        child: const Text('Delete'),
      ),
      cancel: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel')),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    purchaseList = Provider.of<ApiCalls>(context).purchaseList;
    return Scaffold(
      // drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Purchase List',
          style: ProjectStyles.headingStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            Container(
              width: size.width * 0.8,
              child: PaginatedDataTable(
                source:
                    MySearchData(purchaseList, editPurchase, deletePurchase),
                arrowHeadColor: ProjectColors.themeColor,

                columns: const [
                  DataColumn(
                      label: Text('Bill Number',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Purchase Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  // DataColumn(
                  //     label: Text('Creditor Type',
                  //         style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Product Type',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                    label: Text(
                      'Payment Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Purchase Amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  void editPurchase(int id) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      EasyLoading.show();
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getSinglePurchaseInvoice(id, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 200) {
          Map<String, dynamic> editData =
              Provider.of<ApiCalls>(context, listen: false)
                  .individualPurchaseInvoice;

          Get.to(() => PurchasesScreen(tempData: {}, editData: editData));
        }
      });
    });
  }
}

class MySearchData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<int> reFresh;
  final ValueChanged<int> delete;

  MySearchData(
    this.data,
    this.reFresh,
    this.delete,
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
              final prefs = await SharedPreferences.getInstance();
              if (prefs.containsKey('Purchase_Id')) {
                prefs.remove('Purchase_Id');
              }
              final userData = json.encode(
                {
                  'Purchase_Id': data[index]['Purchase_Id'],
                },
              );
              prefs.setString('Purchase_Id', userData);

              Get.toNamed(PurchaseDetailsPage.routeName);
            },
            child: Text(
              data[index]['Bill_Number'],
            ),
          )),
          DataCell(Text(
            DateFormat('dd-MM-yyyy').format(
              DateTime.parse(
                data[index]['Created_Date'].toString(),
              ),
            ),
          )),
          // DataCell(Text(data[index]['Creditor_Type'].toString())),
          DataCell(Text(data[index]['Creditor_Name'].toString())),
          DataCell(Text(data[index]['Product_Type'].toString())),
          DataCell(Text(data[index]['Payment_Type'].toString())),
          DataCell(Text(data[index]['Total_Amount'].toString())),

          DataCell(ElevatedButton.icon(
              onPressed: () {
                reFresh(data[index]['Purchase_Id']);
              },
              icon: const Icon(Icons.edit, size: 15),
              label: const Text('Edit'))),

          DateFormat('dd-MM-yyyy').format(
                    DateTime.parse(
                      data[index]['Created_Date'].toString(),
                    ),
                  ) ==
                  DateFormat('dd-MM-yyyy').format(
                    DateTime.now(),
                  )
              ? DataCell(ElevatedButton.icon(
                  onPressed: () {
                    delete(data[index]['Purchase_Id']);
                  },
                  icon: const Icon(Icons.delete, size: 15),
                  label: const Text('delete')))
              : const DataCell(
                  SizedBox(),
                )
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
