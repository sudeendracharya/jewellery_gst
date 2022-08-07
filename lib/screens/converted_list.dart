import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../colors.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';

class ConvertedList extends StatefulWidget {
  ConvertedList({Key? key}) : super(key: key);

  static const routeName = '/ConvertedList';

  @override
  State<ConvertedList> createState() => _ConvertedListState();
}

class _ConvertedListState extends State<ConvertedList> {
  List<dynamic> convertedOldItemList = [];

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getConvertedOldItem(token)
          .then((value) => null);
    });
    super.initState();
  }

  int defaultRowsPerPage = 3;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    convertedOldItemList = Provider.of<ApiCalls>(context).convertedOldItemList;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Converted List',
          style: ProjectStyles.headingStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
        child: Column(
          children: [
            Container(
              width: size.width * 0.8,
              child: PaginatedDataTable(
                source: MyItemList(
                    convertedOldItemList, (Map<String, dynamic> data) {}),
                arrowHeadColor: ProjectColors.themeColor,

                columns: const [
                  DataColumn(
                      label: Text('Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Metal Type',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Gross Weight',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Wastage',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Net Weight',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                    label: Text(
                      'Convert To',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Wastage',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Loss Amount',
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
}

class MyItemList extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  MyItemList(
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
            DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(data[index]['created_Date'])),
          )),
          DataCell(Text(data[index]['Metal_Type'].toString())),
          DataCell(Text(data[index]['Gross_Weight'].toString())),
          DataCell(Text(data[index]['Wastage'].toString())),
          DataCell(Text(data[index]['Net_Weight'].toString())),
          DataCell(Text(data[index]['Convert_To'].toString())),
          DataCell(Text(data[index]['Wastage'].toString())),
          DataCell(Text(data[index]['Loss_Amount'].toString())),
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

var data = {
  'Opening Balance': 'data',
  'Sales': {
    'Cash+Card': 'data',
    'Credit': 'data',
  },
  'Purchases': {
    'Cash': 'data',
    'Credit': 'data',
  },
  'Bills Paid': 'data',
  'Bills Received': 'data',
  'Closing_Balance': 'data',
};
