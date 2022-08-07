import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../colors.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';

class SalesScreen extends StatefulWidget {
  SalesScreen({Key? key}) : super(key: key);
  static const routeName = '/SalesScreen';

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List invoiceList = [];
  ScrollController controller = ScrollController();
  ScrollController invoiceController = ScrollController();

  String query = '';

  List list = [];

  @override
  void initState() {
    getToken().then((value) {
      Provider.of<ApiCalls>(context, listen: false).getInvoice(token);
    });

    super.initState();
  }

  var token;
  Future<void> getToken() async {
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      token = Provider.of<Authenticate>(context, listen: false).token;
    });
  }

  void getSingleInvoice(var id) {
    EasyLoading.show();

    getToken().then((value) {
      Provider.of<ApiCalls>(context, listen: false)
          .getSingleInvoice(id, token)
          .then((value) {
        EasyLoading.dismiss();
      });
    });
  }

  Future<void> exportPdf(
      List itemList, Map<String, dynamic> invoiceData) async {
    print('invoice data $invoiceData');

    String mobileNumber = invoiceData['Mobile_Number'].toString();

    mobileNumber.replaceAll(' ', '');
    print(mobileNumber);

// Create a new PDF document.
    final PdfDocument document = PdfDocument();
// Add a new page to the document.
    final PdfPage page = document.pages.add();

    Color color = Color.fromARGB(255, 7, 7, 7);

    page.graphics.drawString(
        'Invoice', PdfStandardFont(PdfFontFamily.helvetica, 16),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(page.getClientSize().width * 0.45, 0, 250, 20));
    page.graphics.drawString('Customer Name: ${invoiceData['Customer_Name']}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.05, 250, 20));
    page.graphics.drawString(
        'Date of Purchase: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(invoiceData['Date'])).toString()}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.07, 250, 20));
    page.graphics.drawString('Address: ${invoiceData['Address']}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.09, 250, 20));
    page.graphics.drawString('Mobile Numbers: $mobileNumber',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.11, 250, 20));
    page.graphics.drawString(
        'Amount paid: ${invoiceData['Received_Amount'].toString()}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.13, 250, 20));
    page.graphics.drawString(
        'Item Details', PdfStandardFont(PdfFontFamily.helvetica, 16),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(page.getClientSize().width * 0.45,
            page.getClientSize().height * 0.18, 150, 20));
// Create a PDF grid class to add tables.
    final PdfGrid grid = PdfGrid();
// Specify the grid column count.
    grid.columns.add(count: 3);
// Add a grid header row.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Item Name';
    headerRow.cells[1].value = 'Weight (g)';
    headerRow.cells[2].value = 'Amount';
// Set header font.
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    for (var data in itemList) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = data['Item_Name'];
      row.cells[1].value = data['Weight'].toString();
      row.cells[2].value = data['Amount'].toString();
    }
// Add rows to the grid.

// // Add next row.
//     row = grid.rows.add();
//     row.cells[0].value = 'ANATR';
//     row.cells[1].value = 'Ana Trujillo';
//     row.cells[2].value = 'Mexico';
// // Add next row.
//     row = grid.rows.add();
//     row.cells[0].value = 'ANTON';
//     row.cells[1].value = 'Antonio Mereno';
//     row.cells[2].value = 'Mexico';
// Set grid format.
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.23,
            page.getClientSize().width, page.getClientSize().height));
// Save the document.
    File('Table.pdf').writeAsBytes(await document.save());
// Dispose the document.
    document.dispose();
  }

  void searchBook(String query) {
    final searchOutput = invoiceList.where((details) {
      final name = details['Customer_Id__Customer_Name'];
      final amount = details['Received_Amount'].toString();

      final searchName = query.toString();

      return name.contains(searchName) || amount.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  int defaultRowsPerPage = 5;
  void update(Map<String, dynamic> data) {}
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // invoiceList = Provider.of<ApiCalls>(context).invoicelist;
    if (query == '') {
      list = invoiceList;
    }
    return Scaffold(
      // drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Sales',
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
                  source: MySearchData(invoiceList, update),
                  arrowHeadColor: ProjectColors.themeColor,

                  columns: const [
                    DataColumn(
                        label: Text('Bill Number',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Date',
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
          // Row(
          //   children: [
          //     // Padding(
          //     //   padding: EdgeInsets.only(left: size.width * 0.05),
          //     //   child: Container(
          //     //     width: size.width * 0.43,
          //     //     height: size.height * 0.8,
          //     //     decoration: BoxDecoration(
          //     //         border: Border.all(),
          //     //         borderRadius: BorderRadius.circular(10)),
          //     //     child: Consumer<ApiCalls>(builder: (context, value, child) {
          //     //       return value.singlePurchaseInvoiceData.isEmpty
          //     //           ? const SizedBox()
          //     //           : Padding(
          //     //               padding: EdgeInsets.symmetric(
          //     //                   horizontal: size.width * 0.04, vertical: 25),
          //     //               child: SingleChildScrollView(
          //     //                 controller: invoiceController,
          //     //                 child: Column(
          //     //                   crossAxisAlignment: CrossAxisAlignment.start,
          //     //                   children: [
          //     //                     Align(
          //     //                       alignment: Alignment.center,
          //     //                       child: Text(
          //     //                         'Invoice',
          //     //                         style: ProjectStyles.invoiceheadingStyle()
          //     //                             .copyWith(fontSize: 28),
          //     //                       ),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 14,
          //     //                     ),
          //     //                     Text(
          //     //                       'Customer Name: ${value.singlePurchaseInvoiceData['invoice']['Customer_Id__Customer_Name']}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 8,
          //     //                     ),
          //     //                     Text(
          //     //                       'Date of Purchase: ${DateFormat('dd-MM-yyyy').format(
          //     //                         DateTime.parse(
          //     //                             value.singlePurchaseInvoiceData[
          //     //                                 'invoice']['Date']),
          //     //                       )}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 8,
          //     //                     ),
          //     //                     Text(
          //     //                       'Address: ${value.singlePurchaseInvoiceData['invoice']['Customer_Id__Address']}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 8,
          //     //                     ),
          //     //                     Text(
          //     //                       'Mobile Number: ${value.singlePurchaseInvoiceData['invoice']['Customer_Id__Mobile_Number']}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 8,
          //     //                     ),
          //     //                     Text(
          //     //                       'Old Item: ${value.singlePurchaseInvoiceData['invoice']['Old_Item_Name']}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 8,
          //     //                     ),
          //     //                     Text(
          //     //                       'Old Item Weight: ${value.singlePurchaseInvoiceData['invoice']['Old_Weight']}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 8,
          //     //                     ),
          //     //                     Text(
          //     //                       'Old Item Amount: ${value.singlePurchaseInvoiceData['invoice']['Old_Return_Amount']}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 8,
          //     //                     ),
          //     //                     // Text(
          //     //                     //     'Amount paid: ${value.singleInvoiceData['invoice']['Old_Gold_Weight']}'),
          //     //                     Text(
          //     //                       'Amount paid: ${value.singlePurchaseInvoiceData['invoice']['Received_Amount']}',
          //     //                       style: ProjectStyles.invoiceContentStyle(),
          //     //                     ),

          //     //                     const SizedBox(
          //     //                       height: 15,
          //     //                     ),
          //     //                     Align(
          //     //                       alignment: Alignment.center,
          //     //                       child: Text(
          //     //                         'Item Details',
          //     //                         style: ProjectStyles.invoiceheadingStyle(),
          //     //                       ),
          //     //                     ),
          //     //                     const SizedBox(
          //     //                       height: 15,
          //     //                     ),
          //     //                     Align(
          //     //                       alignment: Alignment.center,
          //     //                       child: DataTable(
          //     //                         columns: const <DataColumn>[
          //     //                           DataColumn(
          //     //                               label: Text(
          //     //                             'Item',
          //     //                             textAlign: TextAlign.left,
          //     //                           )),
          //     //                           DataColumn(
          //     //                               label: Text(
          //     //                             'Item Name',
          //     //                             textAlign: TextAlign.left,
          //     //                           )),
          //     //                           DataColumn(label: Text('Weight (g)')),
          //     //                           DataColumn(label: Text('Amount')),
          //     //                         ],
          //     //                         rows: value
          //     //                                 .singlePurchaseInvoiceData[
          //     //                                     'Item_Details']
          //     //                                 .isEmpty
          //     //                             ? []
          //     //                             : [
          //     //                                 for (var data in value
          //     //                                         .singlePurchaseInvoiceData[
          //     //                                     'Item_Details'])
          //     //                                   DataRow(
          //     //                                     cells: <DataCell>[
          //     //                                       DataCell(
          //     //                                         Text(
          //     //                                           data['Item'].toString(),
          //     //                                         ),
          //     //                                       ),
          //     //                                       DataCell(
          //     //                                         Text(
          //     //                                           data['Item_Name']
          //     //                                               .toString(),
          //     //                                         ),
          //     //                                       ),
          //     //                                       // DataCell(Text(data['Firm_Name'])),
          //     //                                       DataCell(Text(
          //     //                                         data['Weight'].toString(),
          //     //                                       )),
          //     //                                       DataCell(Text(
          //     //                                         data['Amount'].toString(),
          //     //                                       )),
          //     //                                     ],
          //     //                                   )
          //     //                               ],
          //     //                       ),
          //     //                     ),

          //     //                     SizedBox(
          //     //                       height: size.height * 0.1,
          //     //                     ),

          //     //                     Align(
          //     //                       alignment: Alignment.center,
          //     //                       child: ElevatedButton(
          //     //                         onPressed: () {
          //     //                           exportPdf(
          //     //                             value.singlePurchaseInvoiceData[
          //     //                                 'Item_Details'],
          //     //                             value.singlePurchaseInvoiceData[
          //     //                                 'invoice'],
          //     //                           );
          //     //                           // // Create a new PDF document.
          //     //                           // final PdfDocument document =
          //     //                           //     PdfDocument();
          //     //                           //     final PdfPage page = document.pages.add();
          //     //                           // // Add a PDF page and draw text.
          //     //                           // document.pages.add().graphics.drawString(
          //     //                           //     'Invoice',
          //     //                           //     PdfStandardFont(
          //     //                           //         PdfFontFamily.helvetica, 12),
          //     //                           //     brush:
          //     //                           //         PdfSolidBrush(PdfColor(0, 0, 0)),
          //     //                           //     bounds: const Rect.fromLTWH(
          //     //                           //         0, 0, 150, 20));

          //     //                           // // Save the document.
          //     //                           // File('HelloWorld.pdf')
          //     //                           //     .writeAsBytes(document.save());
          //     //                           // // Dispose the document.
          //     //                           // document.dispose();
          //     //                         },
          //     //                         child: const Text('Export'),
          //     //                       ),
          //     //                     )
          //     //                   ],
          //     //                 ),
          //     //               ),
          //     //             );
          //     // }),
          //     // ),
          //     // )
          //   ],
          // ),
          ),
    );
  }
}

class MySearchData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  MySearchData(
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
          DataCell(Text(data[index]['Creditor_Name'].toString())),
          DataCell(Text(data[index]['Product_Type'].toString())),
          DataCell(Text(data[index]['Payment_Type'].toString())),
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
