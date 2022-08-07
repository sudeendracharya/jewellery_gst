import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import 'purchase_details_page.dart';
import 'purchases_screen.dart';

class TemproryPurchaseList extends StatefulWidget {
  TemproryPurchaseList({Key? key}) : super(key: key);
  static const routeName = '/TemproryPurchaseList';
  @override
  State<TemproryPurchaseList> createState() => _TemproryPurchaseListState();
}

class _TemproryPurchaseListState extends State<TemproryPurchaseList> {
  List tempPurchaseList = [];

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getTemproryPurchaseInvoice(token)
          .then((value) => null);
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  void update(int id) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .getTemproryIndividualPurchaseInvoice(token, id)
          .then((value) {
        EasyLoading.dismiss();
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          Get.to(() => PurchasesScreen(
                tempData: value['Response_Body'],
                editData: const {},
              ));
          // Get.dialog(Dialog(
          //   child: StatefulBuilder(
          //     builder: (BuildContext context, setState) {
          //       var size = MediaQuery.of(context).size;
          //       return Container(
          //         width: size.width * 0.8,
          //         height: size.height * 0.8,
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10)),
          //       );
          //     },
          //   ),
          // ));
        } else {
          failureSnackbar('Something went wrong unable to fetch data ');
        }
      });
    });
  }

  void delete(int id) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .deletePurchaseTemproryInvoice(id, token)
          .then((value) {
        if (value == 204 || value == 202) {
          successSnackbar('Successfully deleted the data');
          fetch();
        } else {
          failureSnackbar('Something went wrong unable to delete the data');
        }
      });
    });
  }

  void fetch() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getTemproryPurchaseInvoice(token)
          .then((value) => null);
    });
  }

  void printPurchase(int id) {
    print(id);

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      EasyLoading.show();
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getTemproryIndividualPurchaseInvoice(token, id)
          .then((value) async {
        if (value['Status_Code'] == 200) {
          print(value['Response_Body']);
          var responseData = value['Response_Body'] as Map<String, dynamic>;
          // responseData.a
          Provider.of<ApiCalls>(context, listen: false)
              .fetchIndividualCustomerDetails(
                  value['Response_Body']['Purchase_Details']['Customer_Id'],
                  token)
              .then((value) {
            EasyLoading.dismiss();
            var customerDetails = Provider.of<ApiCalls>(context, listen: false)
                .individualCustomerDetails;

            final customerData = {
              'Customer_Name': customerDetails['Customer_Details']
                  ['Customer_Name'],
              'Customer_Credit_Balance': customerDetails['Customer_Details']
                  ['Receivable'],
              'Merchant_Credit_Balance': customerDetails['Customer_Details']
                  ['Payable'],
              'Customer_Gold_Stock': customerDetails['Customer_Details']
                  ['Customer_Gold_Stock'],
              'Customer_Silver_Stock': customerDetails['Customer_Details']
                  ['Customer_Silver_Stock'],
            };

            responseData['Purchase_Details'].addEntries(customerData.entries);
            print(responseData);
            print(customerDetails);
            convertPdf(responseData['Purchase_Details'],
                responseData['Item_Details'], []);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    tempPurchaseList = Provider.of<ApiCalls>(context).temproryPurchaseList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Cut Purchase List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            Container(
              width: size.width * 0.6,
              child: PaginatedDataTable(
                source: MySearchData(
                    tempPurchaseList, update, delete, printPurchase),
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
                  // DataColumn(
                  //     label: Text('Name',
                  //         style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Product Type',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Print',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Action',
                          style: TextStyle(fontWeight: FontWeight.bold))),

                  // DataColumn(
                  //   label: Text(
                  //     'Payment Type',
                  //     style: TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // DataColumn(
                  //   label: Text(
                  //     'Purchase Amount',
                  //     style: TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  // ),
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
}

class MySearchData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<int> reFresh;
  final ValueChanged<int> delete;
  final ValueChanged<int> printPurchase;
  MySearchData(
    this.data,
    this.reFresh,
    this.delete,
    this.printPurchase,
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
                // final prefs = await SharedPreferences.getInstance();
                // if (prefs.containsKey('Purchase_Id')) {
                //   prefs.remove('Purchase_Id');
                // }
                // final userData = json.encode(
                //   {
                //     'Purchase_Id': data[index]['Purchase_Id'],
                //   },
                // );
                // prefs.setString('Purchase_Id', userData);
                reFresh(data[index]['Temp_Purchase_Id']);
                // Get.toNamed(PurchaseDetailsPage.routeName);
              },
              child: Text(data[index]['Bill_Number']))),
          DataCell(Text(
            DateFormat('dd-MM-yyyy').format(
              DateTime.parse(
                data[index]['Created_Date'].toString(),
              ),
            ),
          )),
          // DataCell(Text(data[index]['Creditor_Type'].toString())),
          // DataCell(Text(data[index]['Creditor_Name'].toString())),
          DataCell(Text(data[index]['Product_Type'].toString())),
          DataCell(
            IconButton(
                onPressed: () {
                  printPurchase(data[index]['Temp_Purchase_Id']);
                },
                icon: const Icon(Icons.print)),
          ),
          DataCell(
            IconButton(
                onPressed: () {
                  delete(data[index]['Temp_Purchase_Id']);
                },
                icon: const Icon(Icons.delete)),
          ),

          // DataCell(Text(data[index]['Total_Amount'].toString())),
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
