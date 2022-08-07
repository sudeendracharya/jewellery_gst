import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_billing_screen.dart';

class CustomerIndividualInvoiceDetailsPage extends StatefulWidget {
  CustomerIndividualInvoiceDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/CustomerIndividualInvoiceDetailsPage';

  @override
  State<CustomerIndividualInvoiceDetailsPage> createState() =>
      _CustomerIndividualInvoiceDetailsPageState();
}

class _CustomerIndividualInvoiceDetailsPageState
    extends State<CustomerIndividualInvoiceDetailsPage> {
  var token;

  Map<String, dynamic> singlePersonInvoiceData = {};

  TextEditingController itemNameController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  var purchaseItemId;

  var selectedItem;

  var itemid;

  var invoiceId;

  var selectedOldItem;

  TextEditingController oldWeightController = TextEditingController();

  TextEditingController oldAmountController = TextEditingController();

  var oldItemId;

  var oldInvoiceId;

  var amountSaved;

  var oldSavedAmount;

  @override
  void initState() {
    var data = Get.arguments;
    getSingleInvoice(data);
    super.initState();
  }

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

  SizedBox gap() {
    return const SizedBox(
      height: 20,
    );
  }

  void saveEditedItems() {
    Map<String, dynamic> editedItem = {
      'Item_Id': itemid,
      'Item_Type': selectedItem.toString(),
      'Item_Name': itemNameController.text,
      'Weight': weightController.text,
      'Amount': amountController.text,
      'Invoice_Id': invoiceId
    };
    if (amountSaved != amountController.text) {
      double savedAmount = double.parse(amountSaved);
      double editedAmount = double.parse(amountController.text);
      if (savedAmount > editedAmount) {
        double balanceAmount = savedAmount - editedAmount;
        double totalAmount = double.parse(
                singlePersonInvoiceData['invoice']['Total_Amount'].toString()) -
            balanceAmount;
        updateBothDetails(totalAmount, editedItem);
        print(totalAmount);
      } else {
        double balanceAmount = editedAmount - savedAmount;
        double totalAmount =
            double.parse(singlePersonInvoiceData['invoice']['Total_Amount']) +
                balanceAmount;

        print(totalAmount);
        updateBothDetails(totalAmount, editedItem);
      }
    } else {
      print(editedItem);

      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .updateSingleSalesInvoice(itemid, editedItem, token)
            .then((value) {
          if (value == 201 || value == 204) {
            Get.back();
            getSingleInvoice(invoiceId);
            successSnackbar('Successfully Updated the data');
          } else {
            failureSnackbar('Something Went wrong unable to update the data');
          }
        });
      });
    }
  }

  void updateBothDetails(var totalAmount, Map<String, dynamic> editedItem) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateSingleSalesInvoice(itemid, editedItem, token)
          .then((value) {
        if (value == 201 || value == 202) {
          Provider.of<ApiCalls>(context, listen: false)
              .updateSingleSalesInvoiceDetails(
                  invoiceId, {'Total_Amount': totalAmount}, token)
              .then((value) {
            EasyLoading.dismiss();
            if (value == 201 || value == 202) {
              Get.back();
              getSingleInvoice(invoiceId);
              successSnackbar('Successfully Updated the data');
            } else {
              failureSnackbar('Something Went wrong unable to update the data');
            }
          });
        }
      });
    });
  }

  void saveOldEditedItems() {
    Map<String, dynamic> editedItem = {
      'Item_Id': oldItemId,
      'Old_Item_Type': selectedOldItem.toString(),
      'Weight': oldWeightController.text,
      'Amount': oldAmountController.text,
      'Invoice_Id': oldInvoiceId
    };

    print(editedItem);

    if (oldSavedAmount != oldAmountController.text) {
      double savedAmount = double.parse(oldSavedAmount);
      double editedAmount = double.parse(oldAmountController.text);
      if (savedAmount > editedAmount) {
        double balanceAmount = savedAmount - editedAmount;
        double totalAmount = double.parse(
                singlePersonInvoiceData['invoice']['Total_Amount'].toString()) +
            balanceAmount;
        updateBothOldDetails(totalAmount, editedItem);
        print(totalAmount);
      } else {
        double balanceAmount = editedAmount - savedAmount;
        double totalAmount =
            double.parse(singlePersonInvoiceData['invoice']['Total_Amount']) -
                balanceAmount;

        print(totalAmount);
        updateBothOldDetails(totalAmount, editedItem);
      }
    } else {
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        EasyLoading.show();
        Provider.of<ApiCalls>(context, listen: false)
            .updateOldSingleSalesInvoice(oldItemId, editedItem, token)
            .then((value) {
          EasyLoading.dismiss();
          if (value == 201 || value == 204) {
            Get.back();
            getSingleInvoice(invoiceId);
            successSnackbar('Successfully Updated the data');
          } else {
            failureSnackbar('Something Went wrong unable to update the data');
          }
        });
      });
    }
  }

  void updateBothOldDetails(var totalAmount, Map<String, dynamic> editedItem) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateOldSingleSalesInvoice(oldItemId, editedItem, token)
          .then((value) {
        if (value == 201 || value == 202) {
          Provider.of<ApiCalls>(context, listen: false)
              .updateSingleSalesInvoiceDetails(
                  oldInvoiceId, {'Total_Amount': totalAmount}, token)
              .then((value) {
            EasyLoading.dismiss();
            if (value == 201 || value == 202) {
              Get.back();
              getSingleInvoice(oldInvoiceId);
              successSnackbar('Successfully Updated the data');
            } else {
              failureSnackbar('Something Went wrong unable to update the data');
            }
          });
        }
      });
    });
  }

  void editItemList(Map<String, dynamic> data) {
    print(data);
    itemid = data['Item_Id'];
    invoiceId = data['Invoice_Id'];
    selectedItem = data['Item_Type'];
    itemNameController.text = data['Item_Name'];
    weightController.text = data['Weight'];
    amountController.text = data['Amount'].toString();
    amountSaved = data['Amount'].toString();

    // weightController.text = data['Gross_Weight'].toString();

    // amountController.text = data['Amount'].toString();

    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          var formWidth = size.width * 0.3;
          double formHeight = 40;
          return Container(
            width: size.width * 0.4,
            height: size.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.03,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Edit Item',
                          style: ProjectStyles.invoiceheadingStyle()
                              .copyWith(fontSize: 22),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      width: formWidth,
                      height: formHeight,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Item Type',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      width: formWidth,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: selectedItem,
                            items: [
                              'Gold_Ornament',
                              'Silver_Ornament',
                              'Gold_Bullion',
                              'Silver_Bullion',
                            ].map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Text(
                                  e,
                                  style: ProjectStyles.invoiceheadingStyle()
                                      .copyWith(
                                          fontSize: formWidth * 0.04,
                                          color: Colors.black.withOpacity(0.8)),
                                ),
                                value: e,
                                onTap: () {
                                  // billDetails['Old_Item_Name'] = e;

                                  // firmId = e['Firm_Code'];
                                  // user['User_Role_Name'] = e['Role_Name'];
                                },
                              );
                            }).toList(),
                            hint: Text(
                              'Select Item',
                              style: ProjectStyles.invoiceheadingStyle()
                                  .copyWith(
                                      fontSize: formWidth * 0.04,
                                      color: Colors.black),
                            ),
                            style: ProjectStyles.invoiceheadingStyle().copyWith(
                                fontSize: formWidth * 0.04,
                                color: Colors.black54),
                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            alignment: Alignment.center,
                            onChanged: (value) {
                              setState(() {
                                selectedItem = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Item Name',
                        'Enter Item Name', itemNameController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Weight', 'Weight',
                        weightController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Amount',
                        'Enter Amount', amountController),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      width: formWidth,
                      height: formHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: saveEditedItems,
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  int defaultRowsPerPage = 3;
  Padding getRow(String heading, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              heading,
              style: ProjectStyles.invoiceheadingStyle().copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          Container(
            width: 180,
            child: Text(
              data,
              style: ProjectStyles.invoiceContentStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Column getField(var size, var formWidth, var formHeight, var heading,
      var helpText, TextEditingController controller) {
    return Column(
      children: [
        Container(
          width: formWidth,
          height: formHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              heading,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: formWidth,
          height: formHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: helpText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void editOldItems(Map<String, dynamic> data) {
    print(data);
    oldItemId = data['Item_Id'];
    selectedOldItem = data['Old_Item_Type'].toString();
    oldWeightController.text = data['Weight'].toString();
    oldAmountController.text = data['Amount'].toString();
    oldSavedAmount = data['Amount'].toString();
    oldInvoiceId = data['Invoice_Id'].toString();
    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          var formWidth = size.width * 0.3;
          double formHeight = 40;
          return Container(
            width: size.width * 0.4,
            height: size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.03,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Edit Item',
                          style: ProjectStyles.invoiceheadingStyle()
                              .copyWith(fontSize: 22),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      width: formWidth,
                      height: formHeight,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Item Type',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      width: formWidth,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: selectedOldItem,
                            items: [
                              'Gold',
                              'Silver',
                            ].map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Text(
                                  e,
                                  style: ProjectStyles.invoiceheadingStyle()
                                      .copyWith(
                                          fontSize: formWidth * 0.04,
                                          color: Colors.black.withOpacity(0.8)),
                                ),
                                value: e,
                                onTap: () {
                                  // billDetails['Old_Item_Name'] = e;

                                  // firmId = e['Firm_Code'];
                                  // user['User_Role_Name'] = e['Role_Name'];
                                },
                              );
                            }).toList(),
                            hint: Text(
                              'Select Item',
                              style: ProjectStyles.invoiceheadingStyle()
                                  .copyWith(
                                      fontSize: formWidth * 0.04,
                                      color: Colors.black),
                            ),
                            style: ProjectStyles.invoiceheadingStyle().copyWith(
                                fontSize: formWidth * 0.04,
                                color: Colors.black54),
                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            alignment: Alignment.center,
                            onChanged: (value) {
                              setState(() {
                                selectedOldItem = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Weight', 'Weight',
                        oldWeightController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Amount',
                        'Enter Amount', oldAmountController),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      width: formWidth,
                      height: formHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: saveOldEditedItems,
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  void saveSalesInvoice() {
    Map<String, dynamic> data = {
      'Cash_Amount': cashAmountController.text,
      'Credit_Amount': creditAmountController.text,
      'Online_Amount': onlineAmountController.text,
    };

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateSingleSalesInvoiceDetails(invoiceId, data, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 202) {
          Get.back();
          getSingleInvoice(invoiceId);
          successSnackbar('Successfully Updated the data');
        } else {
          failureSnackbar('Something Went wrong unable to update the data');
        }
      });
    });
  }

  TextEditingController cashAmountController = TextEditingController();
  TextEditingController onlineAmountController = TextEditingController();
  TextEditingController creditAmountController = TextEditingController();

  void editInvoice(Map<String, dynamic> data) {
    print(data);
    invoiceId = singlePersonInvoiceData['Item_Details'][0]['Invoice_Id'];
    onlineAmountController.text = data['Online_Amount'];
    cashAmountController.text = data['Cash_Amount'];
    creditAmountController.text = data['Credit_Amount'];
    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var size = MediaQuery.of(context).size;
          var formWidth = size.width * 0.3;
          double formHeight = 40;
          return Container(
            width: size.width * 0.4,
            height: size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.03,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Edit Item',
                          style: ProjectStyles.invoiceheadingStyle()
                              .copyWith(fontSize: 22),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    getField(size, formWidth, formHeight, 'Cash Amount',
                        'Enter cash Amount', cashAmountController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Online Amount',
                        'Enter Online Amount', onlineAmountController),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    getField(size, formWidth, formHeight, 'Credit Amount',
                        'Enter Credit Amount Amount', creditAmountController),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      width: formWidth,
                      height: formHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: formWidth * 0.4,
                            height: formHeight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themeColor),
                              ),
                              onPressed: saveSalesInvoice,
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    singlePersonInvoiceData = Provider.of<ApiCalls>(
      context,
    ).singleSalesInvoiceData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Invoice',
          style: ProjectStyles.headingStyle(),
        ),
      ),
      body: singlePersonInvoiceData.isEmpty
          ? SizedBox()
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              double grossAmount = 0;
                              for (var data
                                  in singlePersonInvoiceData['Item_Details']) {
                                grossAmount =
                                    grossAmount + double.parse(data['Amount']);
                              }
                              exportPdf(
                                  singlePersonInvoiceData['Item_Details'],
                                  singlePersonInvoiceData['invoice'],
                                  singlePersonInvoiceData['Old_Items'],
                                  grossAmount,
                                  singlePersonInvoiceData['invoice']
                                      ['Total_Amount']);
                            },
                            icon: const Icon(Icons.print),
                            label: const Text('Print'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(() => AddBillingScreen(
                                    editData: singlePersonInvoiceData,
                                  ));
                              // editInvoice({
                              //   'Cash_Amount':
                              //       singlePersonInvoiceData['invoice']
                              //           ['Cash_Amount'],
                              //   'Credit_Amount':
                              //       singlePersonInvoiceData['invoice']
                              //           ['Credit_Amount'],
                              //   'Online_Amount':
                              //       singlePersonInvoiceData['invoice']
                              //           ['Online_Amount'],
                              // });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Update'),
                          ),
                        ),
                        DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(
                                    singlePersonInvoiceData['invoice']
                                        ['Created_Date'],
                                  ),
                                ) ==
                                DateFormat('dd-MM-yyyy').format(DateTime.now())
                            ? Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                        title: 'Alert',
                                        middleText:
                                            'Are you sure want to delete this bill?',
                                        confirm: TextButton(
                                          onPressed: () {
                                            getToken().then((value) {
                                              Provider.of<ApiCalls>(context,
                                                      listen: false)
                                                  .deleteSalesInvoice(
                                                      singlePersonInvoiceData[
                                                              'invoice']
                                                          ['Invoice_Id'],
                                                      token)
                                                  .then((value) {
                                                if (value == 204) {
                                                  Get.back();
                                                  Get.back(result: 'deleted');
                                                  successSnackbar(
                                                      'successfully deleted the invoice');
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
                                    },
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Delete')),
                              )
                            : const SizedBox()
                      ],
                    ),
                    getRow(
                      'Date of Sale',
                      DateFormat('dd-MM-yyyy').format(
                        DateTime.parse(
                          singlePersonInvoiceData['invoice']['Created_Date'],
                        ),
                      ),
                    ),
                    gap(),
                    getRow(
                        'Invoice Code',
                        singlePersonInvoiceData['invoice']['Invoice_Code'] ??
                            ''),
                    gap(),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Name',
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ??
                                ''),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Mobile Number',
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Mobile_Number'] ??
                                ''),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Id Proof',
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Id_Proof'] ??
                                ''),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Id Proof Number',
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Id_Number'] ??
                                ''),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : getRow(
                            'Address',
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Address'] ??
                                ''),
                    singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'cash' ||
                            singlePersonInvoiceData['invoice']
                                    ['Customer_Id__Customer_Name'] ==
                                'Cash'
                        ? const SizedBox()
                        : gap(),
                    getRow(
                        'Net Amount',
                        singlePersonInvoiceData['invoice']['Total_Amount'] ??
                            ''),
                    gap(),
                    getRow(
                        'Cash paid',
                        singlePersonInvoiceData['invoice']['Cash_Amount'] ??
                            ''),
                    gap(),
                    getRow(
                        'Online paid',
                        singlePersonInvoiceData['invoice']['Online_Amount'] ??
                            ''),
                    gap(),
                    getRow(
                        'Credit',
                        singlePersonInvoiceData['invoice']['Credit_Amount'] ??
                            ''),
                    const SizedBox(
                      height: 60,
                    ),
                    singlePersonInvoiceData['Item_Details'] != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: Text(
                              'Sales Item Details',
                              style: ProjectStyles.headingStyle()
                                  .copyWith(color: Colors.black),
                            ),
                          )
                        : const SizedBox(),
                    singlePersonInvoiceData['Item_Details'] == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.5,
                                  child: PaginatedDataTable(
                                    source: InvoiceItemList(
                                        singlePersonInvoiceData[
                                                'Item_Details'] ??
                                            [],
                                        editItemList),
                                    arrowHeadColor: ProjectColors.themeColor,

                                    columns: const [
                                      DataColumn(
                                          label: Text('Item Type',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Item Name',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),

                                      DataColumn(
                                          label: Text('Weight',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text(' Amount',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      // DataColumn(
                                      //     label: Text('Action',
                                      //         style: TextStyle(
                                      //             fontWeight:
                                      //                 FontWeight.bold))),

                                      // DataColumn(
                                      //     label: Text('Old Item Name',
                                      //         style: TextStyle(
                                      //             fontWeight:
                                      //                 FontWeight.bold))),
                                      // DataColumn(
                                      //   label: Text(
                                      //     'Old Item Weight (g)',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // ),
                                      // DataColumn(
                                      //   label: Text(
                                      //     'Old Item Amount',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // ),
                                      // DataColumn(
                                      //   label: Text(
                                      //     'Total Amount',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold),
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
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Old Items Details',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.5,
                            child: PaginatedDataTable(
                              source: InvoiceOldItemList(
                                singlePersonInvoiceData['Old_Items'] ?? [],
                                editOldItems,
                              ),
                              arrowHeadColor: ProjectColors.themeColor,

                              columns: const [
                                DataColumn(
                                    label: Text('Old Item type',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Weight',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                // DataColumn(
                                //     label: Text('Action',
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.bold))),

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
                  ],
                ),
              ),
            ),
    );
  }
}

class InvoiceOldItemList extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  InvoiceOldItemList(
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
          DataCell(Text(data[index]['Old_Item_Type'].toString())),
          DataCell(Text(data[index]['Weight'].toString())),
          DataCell(Text(data[index]['Amount'].toString())),
          // DataCell(
          //   IconButton(
          //     onPressed: () {
          //       reFresh(data[index]);
          //     },
          //     icon: const Icon(Icons.edit),
          //   ),
          // ),
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

class InvoiceItemList extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<Map<String, dynamic>> reFresh;

  InvoiceItemList(
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
          DataCell(Text(data[index]['Item_Type'].toString())),

          DataCell(Text(data[index]['Item_Name'].toString())),
          DataCell(Text(data[index]['Weight'].toString())),
          DataCell(Text(data[index]['Amount'].toString())),
          // DataCell(IconButton(
          //     onPressed: () {
          //       reFresh(data[index]);
          //     },
          //     icon: const Icon(Icons.edit))),

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
