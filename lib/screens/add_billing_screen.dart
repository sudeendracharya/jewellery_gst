import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_sales_journal.dart';
import 'balance_sheet_screen.dart';
import 'cash_book_page.dart';
import 'customer_details_page.dart';
import 'customerslist_screen.dart';
import 'daily_report_screen.dart';
import 'expenses_page.dart';
import 'profit_and_loss_screen.dart';
import 'purchase_report_screen.dart';
import 'purchases_screen.dart';
import 'sales_report_screen.dart';

enum paymentType {
  cash,
  card,
  credit,
}

class AddBillingScreen extends StatefulWidget {
  AddBillingScreen({Key? key, required this.editData}) : super(key: key);
  final Map<String, dynamic> editData;
  static const routeName = '/AddBillingScreen';

  @override
  State<AddBillingScreen> createState() => _AddBillingScreenState();
}

class _AddBillingScreenState extends State<AddBillingScreen> {
  Map<String, dynamic> billDetails = {};
  paymentType selectedPayType = paymentType.cash;

  bool secondLineAdded = false;

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> _customerKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController idProffController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  Map<String, dynamic> purchaseDetails = {};

  int itemCount = 1;

  TextEditingController dateController = TextEditingController();

  var selectedItemFirstRow;

  var gender;

  TextEditingController customerNameController = TextEditingController();

  TextEditingController customerNumberController = TextEditingController();

  TextEditingController cusAddressController = TextEditingController();

  TextEditingController cusIdController = TextEditingController();

  var customerId;

  TextEditingController cusCreditController = TextEditingController();

  TextEditingController totalAmountController = TextEditingController();

  TextEditingController oldAmountFirstRowController = TextEditingController();

  double grossAmount = 0;
  FocusNode exchangeTotalAmountFirstRowFocus = FocusNode();
  FocusNode exchangeTotalAmountSecondRowFocus = FocusNode();
  double firstRowOldAmount = 0;
  double secondRowOldAmount = 0;

  TextEditingController onlineController = TextEditingController();

  TextEditingController creditController = TextEditingController();

  TextEditingController cashController = TextEditingController();

  TextEditingController oldAmountsecondRowController = TextEditingController();

  TextEditingController oldWeightSecondRowController = TextEditingController();

  var selectedSecondRowItem;

  TextEditingController oldItemFirstRowWeight = TextEditingController();

  var selectedIdProof;

  TextEditingController customerCreditAmountController =
      TextEditingController();

  TextEditingController merchantCreditAmountController =
      TextEditingController();

  var selectedAccountType;

  TextEditingController invoiceIdController = TextEditingController();
  bool nameValidation = true;
  String nameValidationMessage = '';
  bool mobileNumberValidation = true;
  String mobileNumberValidationMessage = '';
  bool selectedIdValidation = true;
  String selectedIdValidationMessage = '';
  bool idControllerValidation = true;
  String idControllerValidationMessage = '';
  bool addressControllerValidation = true;
  String addressControllerValidationMessage = '';
  bool openingBalanceControllerValidation = true;
  String openingBalanceControllerValidationMessage = '';

  List itemIdsList = [];

  List invoiceIdList = [];

  var invoiceId;

  List oldItemIds = [];

  bool billPreview = false;
  Container getErrorField(String labelText) {
    return Container(
        alignment: Alignment.centerLeft,
        width: 500,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 241, 237, 170)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          labelText,
          style: const TextStyle(color: Colors.black),
        ));
  }

  void _onExchangeFirstRowTotalAmountFocusChange() {
    print('object');
    double exchangeFirstRowAmount = double.parse(
        oldAmountFirstRowController.text == ''
            ? '0'
            : oldAmountFirstRowController.text.toString());
    if (exchangeTotalAmountFirstRowFocus.hasFocus == false) {
      if (firstRowOldAmount == 0) {
        double amount =
            double.parse(totalAmountController.text) - exchangeFirstRowAmount;
        totalAmountController.text = amount.toString();
        firstRowOldAmount = exchangeFirstRowAmount;
        print('Total amount ${totalAmountController.text}');
      } else {
        if (firstRowOldAmount == exchangeFirstRowAmount) {
          print('Total amount when equal ${totalAmountController.text}');
        } else if (firstRowOldAmount < exchangeFirstRowAmount) {
          double data = exchangeFirstRowAmount - firstRowOldAmount;
          double amount = double.parse(totalAmountController.text) - data;

          totalAmountController.text = amount.toString();
          firstRowOldAmount = exchangeFirstRowAmount;
          print('Total amount after sub ${totalAmountController.text}');
        } else if (firstRowOldAmount > exchangeFirstRowAmount) {
          double data = firstRowOldAmount - exchangeFirstRowAmount;
          double amount = double.parse(totalAmountController.text) + data;

          totalAmountController.text = amount.toString();
          firstRowOldAmount = exchangeFirstRowAmount;
          print('Total amount after addition ${totalAmountController.text}');
        }
      }
    }
  }

  void _onExchangeSecondRowTotalAmountFocusChange() {
    double exchangeSecondRowAmount = double.parse(
        oldAmountsecondRowController.text == ''
            ? '0'
            : oldAmountsecondRowController.text.toString());
    if (exchangeTotalAmountSecondRowFocus.hasFocus == false) {
      if (secondRowOldAmount == 0) {
        double amount =
            double.parse(totalAmountController.text) - exchangeSecondRowAmount;
        totalAmountController.text = amount.toString();
        secondRowOldAmount = exchangeSecondRowAmount;
        print('Total amount ${totalAmountController.text}');
      } else {
        if (secondRowOldAmount == exchangeSecondRowAmount) {
          print('Total amount when equal ${totalAmountController.text}');
        } else if (secondRowOldAmount < exchangeSecondRowAmount) {
          double data = exchangeSecondRowAmount - secondRowOldAmount;
          double amount = double.parse(totalAmountController.text) - data;

          totalAmountController.text = amount.toString();
          secondRowOldAmount = exchangeSecondRowAmount;
          print('Total amount after sub ${totalAmountController.text}');
        } else if (secondRowOldAmount > exchangeSecondRowAmount) {
          double data = secondRowOldAmount - exchangeSecondRowAmount;
          double amount = double.parse(totalAmountController.text) + data;

          totalAmountController.text = amount.toString();
          secondRowOldAmount = exchangeSecondRowAmount;
          print('Total amount after addition ${totalAmountController.text}');
        }
      }
    }
  }

  Container getField(
      TextEditingController controller, String labelText, bool enabled) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        // maxLines: 3,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  bool searchSelected = false;
  Map<String, dynamic> cashDetailsData = {};
  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .dailyStockAdjustment(token)
          .then((value) {});
      Provider.of<ApiCalls>(context, listen: false)
          .getCustomersList(token, 'Customer')
          .then((value) {
        if (value == 200) {
          cashDetailsData =
              Provider.of<ApiCalls>(context, listen: false).cashDetails;
        }
      });

      if (widget.editData.isNotEmpty) {
        editInvoice(widget.editData['invoice'], widget.editData['Item_Details'],
            widget.editData['Old_Items']);
        print(widget.editData);
      } else {
        Provider.of<ApiCalls>(context, listen: false)
            .getSalesInvoiceId(token)
            .then((value) {
          if (value != 0) {
            invoiceIdController.text = 'I$value';
          }
        });
      }

      // Provider.of<ApiCalls>(context, listen: false)
      //     .getPurchaseInvoiceId(token)
      //     .then((value) {});
    });
    searchFocus.addListener(onSearchFocusChange);

    totalAmountController.text = '0';
    exchangeTotalAmountFirstRowFocus
        .addListener(_onExchangeFirstRowTotalAmountFocusChange);
    exchangeTotalAmountSecondRowFocus
        .addListener(_onExchangeSecondRowTotalAmountFocusChange);
    onlineController.text = '0';
    creditController.text = '0';
    cashController.text = '0';
    selectedAccountType = 'Customer A/C';
    merchantCreditAmountController.text = '0';
    customerCreditAmountController.text = '0';
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    billDetails['Created_Date'] =
        DateFormat("yyyy-MM-dd").format(DateTime.now());
    super.initState();
  }

  Future<void> saveSalesInvoice() async {
    EasyLoading.show();
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      if (widget.editData.isEmpty) {
        Provider.of<ApiCalls>(context, listen: false)
            .sendInvoice(billDetails, token)
            .then((value) {
          EasyLoading.dismiss();
          if (value == 200 || value == 201) {
            formKey.currentState!.reset();
            itemList.clear();
            oldItemList.clear();
            itemCount = 1;
            totalAmountController.text = '0';
            firstRowOldAmount = 0;
            oldAmountFirstRowController.text = '0';

            secondRowOldAmount = 0;
            oldAmountsecondRowController.text = '0';
            customerCreditAmountController.text = '0';
            merchantCreditAmountController.text = '0';
            cashController.text = '0';
            onlineController.text = '0';
            creditController.text = '0';
            getNewBillNumber();

            setState(() {});
          }
        });
      } else {
        print('reverting');
        Provider.of<ApiCalls>(context, listen: false)
            .revertSalesInvoice(invoiceId, billDetails, token)
            .then((value) {
          EasyLoading.dismiss();
          if (value == 202 || value == 201) {
            Provider.of<ApiCalls>(context, listen: false)
                .updateSalesInvoice(invoiceId, billDetails, token)
                .then((value) {
              EasyLoading.dismiss();
              if (value == 202 || value == 201) {
                formKey.currentState!.reset();
                itemList.clear();
                itemCount = 1;
                totalAmountController.text = '0';
                firstRowOldAmount = 0;
                oldAmountFirstRowController.text = '0';

                secondRowOldAmount = 0;
                oldAmountsecondRowController.text = '0';
                customerCreditAmountController.text = '0';
                merchantCreditAmountController.text = '0';
                cashController.text = '0';
                onlineController.text = '0';
                creditController.text = '0';
                invoiceId = null;
                getNewBillNumber();
                setState(() {});
              }
            });
            // formKey.currentState!.reset();
            // itemList.clear();
            // itemCount = 1;
            // totalAmountController.text = '0';
            // firstRowOldAmount = 0;
            // oldAmountFirstRowController.text = '0';

            // secondRowOldAmount = 0;
            // oldAmountsecondRowController.text = '0';
            // customerCreditAmountController.text = '0';
            // merchantCreditAmountController.text = '0';
            // cashController.text = '0';
            // onlineController.text = '0';
            // creditController.text = '0';
            // invoiceId = null;
            // getNewBillNumber();
            // setState(() {});
          }
        });
      }
    });
  }

  void getNewBillNumber() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getSalesInvoiceId(token)
          .then((value) {
        if (value != 0) {
          invoiceIdController.text = 'I$value';
        }
      });
    });
  }

  @override
  void dispose() {
    searchFocus.removeListener(onSearchFocusChange);
    searchFocus.dispose();
    exchangeTotalAmountFirstRowFocus
        .removeListener(_onExchangeFirstRowTotalAmountFocusChange);
    exchangeTotalAmountFirstRowFocus.dispose();
    exchangeTotalAmountSecondRowFocus
        .removeListener(_onExchangeSecondRowTotalAmountFocusChange);
    exchangeTotalAmountSecondRowFocus.dispose();
    super.dispose();
  }

  void onSearchFocusChange() {
    if (searchFocus.hasFocus == false) {
      // setState(() {
      //   searchSelected = false;
      // });
    } else {
      // setState(() {
      //   searchSelected = true;
      // });
    }
  }

  Future<void> saveNewCustomer() async {
    Map<String, dynamic> newCustomer = {
      'Creditor_Type': 'Customer',
      'Customer_Name': nameController.text,
      'Mobile_Number': mobileNumberController.text,
      'Id_Proof': selectedIdProof,
      'Id_Number': idProffController.text,
      'Address': addressController.text,
      'Receivable': openingBalanceController.text,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(newCustomer);
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .addNewCustomer(newCustomer, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 200) {
          Get.back();
          successSnackbar('Successfully Added New Customer');
          nameController.text = '';
          mobileNumberController.text = '';
          selectedIdProof = null;
          addressController.text = '';
          openingBalanceController.text = '';
        } else {
          failureSnackbar('Something Went Wrong Unable to Add Customer');
        }
      });
    });
  }

  Future<void> saveCashCustomer() async {
    Map<String, dynamic> newCustomer = {
      'Creditor_Type': 'Customer',
      'Customer_Name': nameController.text,
      'Mobile_Number': mobileNumberController.text,
      'Id_Proof': selectedIdProof,
      'Id_Number': idProffController.text,
      'Address': addressController.text,
      'Receivable': openingBalanceController.text,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(newCustomer);
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .addNewCustomer(newCustomer, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 200) {
        } else {}
      });
    });
  }

  TextStyle drawerStyle() {
    return GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
  }

  List itemList = [];

  void recordData(Map<String, dynamic> data) {
    if (itemList.isEmpty) {
      itemList.add(data);
      if (data['Key'] == 'Amount') {
        double Amount = double.parse(totalAmountController.text) +
            double.parse(
                data['Value'].toString().isAlphabetOnly || data['Value'] == ''
                    ? '0'
                    : data['Value'].toString());

        totalAmountController.text = Amount.toString();
        if (selectedAccountType == 'Cash A/C') {
          cashController.text = totalAmountController.text;
        }

        print('total Amount ${totalAmountController.text}');
      }
    } else {
      bool repeated = false;
      for (var item in itemList) {
        if (item['Index'] == data['Index'] && item['Key'] == data['Key']) {
          if (data['Key'] == 'Amount') {
            double lessAmount = double.parse(totalAmountController.text) -
                double.parse(item['Value'].toString().isAlphabetOnly ||
                        item['Value'] == ''
                    ? '0'
                    : item['Value'].toString());
            double Amount = lessAmount +
                double.parse(data['Value'].toString().isAlphabetOnly ||
                        data['Value'] == ''
                    ? '0'
                    : data['Value'].toString());
            totalAmountController.text = Amount.toString();
            if (selectedAccountType == 'Cash A/C') {
              cashController.text = totalAmountController.text;
            }

            print('total Amount ${totalAmountController.text}');
          }
          itemList.remove(item);
          itemList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        itemList.add(data);
        if (data['Key'] == 'Amount') {
          double Amount = double.parse(totalAmountController.text) +
              double.parse(
                  data['Value'].toString().isAlphabetOnly || data['Value'] == ''
                      ? '0'
                      : data['Value'].toString());

          totalAmountController.text = Amount.toString();
          if (selectedAccountType == 'Cash A/C') {
            cashController.text = totalAmountController.text;
          }

          print('total Amount ${totalAmountController.text}');
        }
      }
    }

    print(itemList);
  }

  int oldItemCount = 1;

  List oldItemList = [];

  void recordOldItemData(Map<String, dynamic> data) {}

  void increaseOldItemRowCount(int data) {}

  void decreaseOldItemRowCount(int index) {}
  List removedSalesItems = [];
  List removedOldItems = [];

  void increaseRowCount(int index) {
    if (widget.editData.isNotEmpty) {
      itemIdsList.add(removedSalesItems[index]);
      removedSalesItems.removeAt(index);
      print(removedSalesItems);
    }
    setState(() {
      itemCount = itemCount + 1;
    });
    print(itemCount);
  }

  void decreaseRowCount(int index) {
    print(index);
    List temp = [];
    if (widget.editData.isNotEmpty) {
      removedSalesItems.add(itemIdsList[index]);
      itemIdsList.removeAt(index);
      print(removedSalesItems);
    }
    for (var data in itemList) {
      if (data['Key'] == 'Amount' && data['Index'] == index) {
        double amount = double.parse(totalAmountController.text) -
            double.parse(data['Value'].toString());
        totalAmountController.text = amount.toString();
      }
    }

    itemList.removeWhere((element) => element['Index'] == index);

    for (var data in itemList) {
      temp.add(
        {
          'Key': data['Key'],
          'Index': data['Index'] == 0 ? 0 : data['Index'] - 1,
          'Value': data['Value']
        },
      );
    }

    itemList = temp;

    print('After removing $itemList');
    setState(() {
      itemCount = itemCount - 1;
    });
  }

  ScrollController invoiceScrollController = ScrollController();

  Future<void> open() async {
    Process.run('"C:\\Program Files\\Mozilla Firefox\\firefox.exe"',
        ['assets/files/PDFTable.pdf']).then((ProcessResult results) {
      print(results.stdout);
    });
    // var bytes = await rootBundle.load('assets/files/PDFTable.pdf');
    // final blob = html.Blob([bytes], 'application/pdf');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
  }

  void datePicker() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themeColor, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
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
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // _startDate = pickedDate.millisecondsSinceEpoch;
      dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      billDetails['Created_Date'] = DateFormat("yyyy-MM-dd").format(pickedDate);

      // setState(() {});
    });
  }

  void getSingleInvoice(var id) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false).getSingleInvoice(id, token);
    });
  }

  void savePurchase() {
    _formKey.currentState!.save();
    purchaseDetails['Created_Date'] =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    print(purchaseDetails);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .sendPurchaseInvoice(purchaseDetails, token)
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

  Future<void> searchCustomer(String searchData) async {
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      await Provider.of<ApiCalls>(context, listen: false)
          .searchCustomer(searchData, token)
          .then((value) async {
        if (searchData == 'cash') {
          await Future.delayed(const Duration(seconds: 1));
          List customerList =
              Provider.of<ApiCalls>(context, listen: false).customerList;

          if (customerList.isEmpty) {
            nameController.text = 'cash';
            mobileNumberController.text = '00000000';
            selectedIdProof = 'Other';
            idProffController.text = '785874588';
            addressController.text = 'No address';
            openingBalanceController.text = '0';

            await saveCashCustomer().then((value) {
              searchCustomer('cash');
            });
          } else {
            for (var data in customerList) {
              customerId = data['Customer_Id'];
            }
          }
        }
      });
    });
  }

  void reFresh() {
    setState(() {
      searchSelected = false;
    });
  }

  void selectCustomerData(Map<String, dynamic> data) {
    customerId = data['Customer_Id'];
    customerNameController.text = data['Customer_Name'];
    customerNumberController.text = data['Mobile_Number'].toString();
    cusAddressController.text = data['Address'];
    cusIdController.text = data['Id_Proof'].toString();
    customerCreditAmountController.text = data['Receivable'].toString();
    merchantCreditAmountController.text = data['Payable'].toString();
    totalAmountController.text = ((double.parse(totalAmountController.text) +
                double.parse(customerCreditAmountController.text)) -
            double.parse(merchantCreditAmountController.text))
        .toStringAsFixed(2);
    setState(() {
      searchSelected = false;
    });
  }

  void validateDialog(List data) {
    Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.red),
        title: 'Validation Error',
        content: Container(
          width: 300,
          height: 100,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(data[index]),
              );
            },
          ),
        ),
        confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Ok')));
  }

  bool validate() {
    List errorList = [];

    if (selectedAccountType == 'Customer A/C') {
      if (customerNameController.text == '') {
        errorList.add('Customer Name Cannot be Empty');
      }
    }

    if (invoiceIdController.text == '') {
      errorList.add('Invoice Id cannot be empty');
    }

    if (itemList.isEmpty) {
      errorList.add('Add Items for sale');
    }

    if (totalAmountController.text != '0.0') {
      double amount = double.parse(totalAmountController.text);
      if (amount > 0) {
        if (cashController.text == '0' &&
            onlineController.text == '0' &&
            creditController.text == '0') {
          errorList.add('Received amount cannot be Empty');
        } else {
          double totalReceived = double.parse(cashController.text) +
              double.parse(onlineController.text) +
              double.parse(creditController.text);
          print(totalReceived);
          print(amount);
          if (totalReceived != amount) {
            errorList.add('Total Amount and Received Amount should be equal');
          }
        }
      }
    }

    if (totalAmountController.text == '') {
      errorList.add('Total amount cannot be empty');
    }

    if (errorList.isEmpty) {
      return true;
    } else {
      validateDialog(errorList);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var formWidth = size.width * 0.25;
    var bottomPadding = size.height * 0.02;
    var dialogFormWidth = size.width * 0.4;
    var formheight = size.height * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sales Invoice',
          style: ProjectStyles.headingStyle(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 30,
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellow)),
                  onPressed: () {
                    Get.back();
                    Get.toNamed(AddBillingScreen.routeName);
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 150,
              height: 30,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow)),
                onPressed: () async {
                  var pref = await SharedPreferences.getInstance();
                  if (pref.containsKey('Customer_Id')) {
                    pref.remove('Customer_Id');
                  }
                  var userData = json.encode({
                    'Customer_Id': cashDetailsData['Customer_Id'],
                  });

                  pref.setString('Customer_Id', userData);
                  Get.toNamed(CustomerDetailsPage.routeName,
                      arguments: 'Customer');
                },
                child: const Text(
                  'Cash Sale List',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 35,
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: GestureDetector(
        onTap: () {
          setState(() {
            searchSelected = false;
          });
          // FocusScopeNode currentFocus = FocusScope.of(context);
          // if (currentFocus.hasPrimaryFocus) {
          //   currentFocus.unfocus();
          //   setState(() {
          //     searchSelected = false;
          //   });
          // }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.01, vertical: size.height * 0.02),
            child: Row(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Item Details',
                        style: GoogleFonts.merriweather(fontSize: 22),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AddItems(
                        itemList: itemList,
                        decreaseRowCount: decreaseRowCount,
                        increaseRowCount: increaseRowCount,
                        index: 0,
                        itemCount: itemCount,
                        data: recordData,
                        key: UniqueKey(),
                      ),
                      itemCount >= 2
                          ? AddItems(
                              itemList: itemList,
                              decreaseRowCount: decreaseRowCount,
                              increaseRowCount: increaseRowCount,
                              index: 1,
                              itemCount: itemCount,
                              data: recordData,
                              key: UniqueKey(),
                            )
                          : const SizedBox(),
                      itemCount >= 3
                          ? AddItems(
                              itemList: itemList,
                              decreaseRowCount: decreaseRowCount,
                              increaseRowCount: increaseRowCount,
                              index: 2,
                              itemCount: itemCount,
                              data: recordData,
                              key: UniqueKey(),
                            )
                          : const SizedBox(),
                      itemCount >= 4
                          ? AddItems(
                              itemList: itemList,
                              decreaseRowCount: decreaseRowCount,
                              increaseRowCount: increaseRowCount,
                              index: 3,
                              itemCount: itemCount,
                              data: recordData,
                              key: UniqueKey(),
                            )
                          : const SizedBox(),
                      itemCount >= 5
                          ? AddItems(
                              itemList: itemList,
                              decreaseRowCount: decreaseRowCount,
                              increaseRowCount: increaseRowCount,
                              index: 4,
                              itemCount: itemCount,
                              data: recordData,
                              key: UniqueKey(),
                            )
                          : const SizedBox(),
                      itemCount >= 6
                          ? AddItems(
                              itemList: itemList,
                              decreaseRowCount: decreaseRowCount,
                              increaseRowCount: increaseRowCount,
                              index: 5,
                              itemCount: itemCount,
                              data: recordData,
                              key: UniqueKey(),
                            )
                          : const SizedBox(),
                      itemCount >= 7
                          ? AddItems(
                              itemList: itemList,
                              decreaseRowCount: decreaseRowCount,
                              increaseRowCount: increaseRowCount,
                              index: 6,
                              itemCount: itemCount,
                              data: recordData,
                              key: UniqueKey(),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        children: [
                          Container(
                            width: formWidth,
                            height: 600,
                            // decoration: BoxDecoration(border: Border.all()),
                            child: Stack(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    'Customer Details',
                                    style: GoogleFonts.merriweather(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Positioned(
                                  top: 550 * 0.39,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: formWidth,
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: const Text.rich(
                                          TextSpan(children: [
                                            TextSpan(text: 'Invoice Id'),
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                        ),
                                      ),
                                      Container(
                                        width: formWidth,
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.black26),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: TextFormField(
                                            enabled: true,
                                            controller: invoiceIdController,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    'Enter Invoice number',
                                                border: InputBorder.none),
                                            validator: (value) {
                                              // if (value!.isEmpty) {
                                              //   // showError('FirmCode');
                                              //   return 'Old return amount cannot be empty';
                                              // }
                                            },
                                            onSaved: (value) {
                                              billDetails['Invoice_Code'] =
                                                  value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 550 * 0.07,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: formWidth * 0.85,
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: const Text.rich(
                                          TextSpan(children: [
                                            TextSpan(text: 'Account Type'),
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                        ),
                                      ),
                                      Container(
                                        width: formWidth * 0.85,
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.black26),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: selectedAccountType,
                                              items: [
                                                'Cash A/C',
                                                'Customer A/C',
                                              ].map<DropdownMenuItem<String>>(
                                                  (e) {
                                                return DropdownMenuItem(
                                                  enabled:
                                                      widget.editData.isEmpty
                                                          ? true
                                                          : false,
                                                  child: Text(
                                                    e,
                                                    style: ProjectStyles
                                                            .invoiceheadingStyle()
                                                        .copyWith(
                                                            fontSize:
                                                                formWidth *
                                                                    0.04,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  value: e,
                                                  onTap: () {
                                                    if (e == 'Cash A/C') {
                                                      searchCustomer('cash');
                                                      cashController.text =
                                                          totalAmountController
                                                              .text;
                                                    }
                                                  },
                                                );
                                              }).toList(),
                                              hint: Text(
                                                'Select Item',
                                                style: ProjectStyles
                                                        .invoiceheadingStyle()
                                                    .copyWith(
                                                        fontSize:
                                                            formWidth * 0.04,
                                                        color: Colors.black),
                                              ),
                                              style: ProjectStyles
                                                      .invoiceheadingStyle()
                                                  .copyWith(
                                                      fontSize:
                                                          formWidth * 0.04,
                                                      color: Colors.black),
                                              iconDisabledColor: Colors.black,
                                              iconEnabledColor: Colors.black,
                                              dropdownColor: Colors.white,
                                              alignment: Alignment.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedAccountType =
                                                      value as String;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 550 * 0.23,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: formWidth,
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: const Text.rich(
                                          TextSpan(children: [
                                            TextSpan(text: 'Date'),
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: datePicker,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: formWidth * 0.85,
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black26),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                child: TextFormField(
                                                  enabled: false,
                                                  controller: dateController,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              'Choose Date',
                                                          border:
                                                              InputBorder.none),
                                                  validator: (value) {
                                                    // if (value!.isEmpty) {
                                                    //   // showError('FirmCode');
                                                    //   return 'Name cannot be empty';
                                                    // }
                                                  },
                                                  onSaved: (value) {
                                                    billDetails[
                                                            'Customer_Name'] =
                                                        value;
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: formWidth * 0.04,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: IconButton(
                                                  onPressed: datePicker,
                                                  icon: Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    color: ProjectColors
                                                        .themeColor,
                                                    size: 30,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Positioned(
                                //   top: 550 * 0.55,
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Container(
                                //         width: formWidth,
                                //         padding:
                                //             const EdgeInsets.only(bottom: 12),
                                //         child: const Text.rich(
                                //           TextSpan(children: [
                                //             TextSpan(text: 'Mobile Number'),
                                //             TextSpan(
                                //                 text: '*',
                                //                 style: TextStyle(
                                //                     color: Colors.red))
                                //           ]),
                                //         ),
                                //       ),
                                //       Container(
                                //         width: formWidth,
                                //         height: 40,
                                //         alignment: Alignment.center,
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(8),
                                //           color: Colors.white,
                                //           border:
                                //               Border.all(color: Colors.black26),
                                //         ),
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 12, vertical: 6),
                                //           child: TextFormField(
                                //             enabled: false,
                                //             controller:
                                //                 customerNumberController,
                                //             decoration: const InputDecoration(
                                //                 hintText: 'Enter Mobile Name',
                                //                 border: InputBorder.none),
                                //             validator: (value) {
                                //               if (value!.isEmpty) {
                                //                 // showError('FirmCode');
                                //                 return 'Mobile number cannot be empty';
                                //               }
                                //             },
                                //             onSaved: (value) {
                                //               billDetails['Mobile_Number'] =
                                //                   value;
                                //             },
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Positioned(
                                //   top: 550 * 0.71,
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Container(
                                //         width: formWidth,
                                //         padding:
                                //             const EdgeInsets.only(bottom: 12),
                                //         child: const Text.rich(
                                //           TextSpan(children: [
                                //             TextSpan(text: 'Address'),
                                //             TextSpan(
                                //                 text: '*',
                                //                 style: TextStyle(
                                //                     color: Colors.red))
                                //           ]),
                                //         ),
                                //       ),
                                //       Container(
                                //         width: formWidth,
                                //         height: 80,
                                //         alignment: Alignment.topCenter,
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(8),
                                //           color: Colors.white,
                                //           border:
                                //               Border.all(color: Colors.black26),
                                //         ),
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 12, vertical: 6),
                                //           child: TextFormField(
                                //             enabled: false,
                                //             controller: cusAddressController,
                                //             decoration: const InputDecoration(
                                //                 hintText: 'Enter Address',
                                //                 border: InputBorder.none),
                                //             validator: (value) {
                                //               if (value!.isEmpty) {
                                //                 // showError('FirmCode');
                                //                 return 'Address cannot be empty';
                                //               }
                                //             },
                                //             onSaved: (value) {
                                //               billDetails['Address'] = value;
                                //             },
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Positioned(
                                //   top: 550 * 0.95,
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Container(
                                //         width: formWidth,
                                //         padding:
                                //             const EdgeInsets.only(bottom: 12),
                                //         child: const Text.rich(
                                //           TextSpan(children: [
                                //             TextSpan(
                                //                 text: 'Aadhar Card Number'),
                                //             TextSpan(
                                //                 text: '*',
                                //                 style: TextStyle(
                                //                     color: Colors.red))
                                //           ]),
                                //         ),
                                //       ),
                                //       Container(
                                //         width: formWidth,
                                //         height: 40,
                                //         alignment: Alignment.center,
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(8),
                                //           color: Colors.white,
                                //           border:
                                //               Border.all(color: Colors.black26),
                                //         ),
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 12, vertical: 6),
                                //           child: TextFormField(
                                //             enabled: false,
                                //             controller: cusIdController,
                                //             decoration: const InputDecoration(
                                //                 hintText:
                                //                     'Enter aadhar card number',
                                //                 border: InputBorder.none),
                                //             validator: (value) {
                                //               // if (value!.isEmpty) {
                                //               //   // showError('FirmCode');
                                //               //   return 'Old return amount cannot be empty';
                                //               // }
                                //             },
                                //             onSaved: (value) {
                                //               billDetails['Aadhar_Card'] =
                                //                   value;
                                //             },
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Positioned(
                                //   top: 550 * 0.93,
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Container(
                                //         width: formWidth,
                                //         padding:
                                //             const EdgeInsets.only(bottom: 12),
                                //         child: const Text.rich(
                                //           TextSpan(children: [
                                //             TextSpan(text: 'Credit Balance'),
                                //             TextSpan(
                                //                 text: '*',
                                //                 style: TextStyle(
                                //                     color: Colors.red))
                                //           ]),
                                //         ),
                                //       ),
                                //       Container(
                                //         width: formWidth,
                                //         height: 40,
                                //         alignment: Alignment.center,
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(8),
                                //           color: Colors.white,
                                //           border:
                                //               Border.all(color: Colors.black26),
                                //         ),
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 12, vertical: 6),
                                //           child: TextFormField(
                                //             controller: cusCreditController,
                                //             decoration: const InputDecoration(
                                //                 hintText:
                                //                     'Enter Credit Balance',
                                //                 border: InputBorder.none),
                                //             validator: (value) {
                                //               // if (value!.isEmpty) {
                                //               //   // showError('FirmCode');
                                //               //   return 'Old return amount cannot be empty';
                                //               // }
                                //             },
                                //             onSaved: (value) {
                                //               billDetails['Credit_Balance'] =
                                //                   value;
                                //             },
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                selectedAccountType == 'Cash A/C'
                                    ? const SizedBox()
                                    : Positioned(
                                        top: 550 * 0.55,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: formWidth * 0.85,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: const Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(text: 'Name'),
                                                      TextSpan(
                                                        text: '*',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )
                                                    ]),
                                                  ),
                                                ),
                                                Container(
                                                  width: formWidth * 0.85,
                                                  height: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    child: TextFormField(
                                                      onTap: () {
                                                        setState(() {
                                                          Provider.of<ApiCalls>(
                                                                  context,
                                                                  listen: false)
                                                              .customerList
                                                              .clear();
                                                          searchSelected = true;
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Enter Customer Name',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      controller:
                                                          customerNameController,
                                                      onChanged: (value) {
                                                        if (value.length >= 2) {
                                                          setState(() {
                                                            searchCustomer(
                                                                value);
                                                          });
                                                        } else {
                                                          setState(() {});
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          // showError('FirmCode');
                                                          return 'Name cannot be empty';
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        billDetails[
                                                                'Customer_Name'] =
                                                            value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                searchSelected == true
                                                    ? Container(
                                                        width: formWidth * 0.85,
                                                        height: 300,
                                                        decoration:
                                                            BoxDecoration(
                                                          // border: Border.all(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.white,
                                                        ),
                                                        child:
                                                            Consumer<ApiCalls>(
                                                          builder: (context,
                                                              value, child) {
                                                            return ListView
                                                                .builder(
                                                              itemCount: value
                                                                  .customerList
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return CustomerSearchList(
                                                                    customer: value
                                                                            .customerList[
                                                                        index],
                                                                    select:
                                                                        selectCustomerData);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            Container(
                                              width: formWidth * 0.15,
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                  color:
                                                      ProjectColors.themeColor,
                                                  iconSize: 30,
                                                  onPressed: () =>
                                                      addCustomer(size),
                                                  icon: const Icon(Icons
                                                      .add_circle_outline)),
                                            )
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: formWidth * 0.2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Amount Details',
                                style: GoogleFonts.merriweather(
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              widget.editData.isEmpty
                                  ? oldItemFirstFilelds(
                                      bottomPadding, formWidth)
                                  : widget.editData['Old_Items'].isEmpty
                                      ? const SizedBox()
                                      : oldItemFirstFilelds(
                                          bottomPadding, formWidth),
                              secondLineAdded == true
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: 15,
                                    ),
                              widget.editData.isEmpty
                                  ? secondLineAdded == false
                                      ? const SizedBox()
                                      : oldItemSecondFields(
                                          bottomPadding, formWidth)
                                  : widget.editData['Old_Items'].isEmpty
                                      ? const SizedBox()
                                      : secondLineAdded == false
                                          ? const SizedBox()
                                          : oldItemSecondFields(
                                              bottomPadding, formWidth),
                              selectedAccountType == 'Cash A/C'
                                  ? const SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          bottom: bottomPadding),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: formWidth,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text.rich(
                                              TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        'Merchant Credit Balance'),
                                                TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red))
                                              ]),
                                            ),
                                          ),
                                          Container(
                                            width: formWidth,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                enabled: false,
                                                controller:
                                                    merchantCreditAmountController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Enter Total amount',
                                                        border:
                                                            InputBorder.none),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    // showError('FirmCode');
                                                    return 'Total Amount Cannot be empty';
                                                  }
                                                },
                                                onSaved: (value) {
                                                  billDetails['Total_Amount'] =
                                                      value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              selectedAccountType == 'Cash A/C'
                                  ? const SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          bottom: bottomPadding),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: formWidth,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text.rich(
                                              TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        'Customer Credit Balance'),
                                                TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red))
                                              ]),
                                            ),
                                          ),
                                          Container(
                                            width: formWidth,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                enabled: false,
                                                controller:
                                                    customerCreditAmountController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Enter Total amount',
                                                        border:
                                                            InputBorder.none),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    // showError('FirmCode');
                                                    return 'Total Amount Cannot be empty';
                                                  }
                                                },
                                                onSaved: (value) {
                                                  billDetails['Total_Amount'] =
                                                      value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.only(bottom: bottomPadding),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: formWidth,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: const Text.rich(
                                        TextSpan(children: [
                                          TextSpan(text: 'Total Amount'),
                                          TextSpan(
                                              text: '*',
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                      ),
                                    ),
                                    Container(
                                      width: formWidth,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black26),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        child: TextFormField(
                                          controller: totalAmountController,
                                          decoration: const InputDecoration(
                                              hintText: 'Enter Total amount',
                                              border: InputBorder.none),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              // showError('FirmCode');
                                              return 'Total Amount Cannot be empty';
                                            }
                                          },
                                          onSaved: (value) {
                                            billDetails['Total_Amount'] = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: bottomPadding),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: formWidth,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: const Text.rich(
                                        TextSpan(children: [
                                          TextSpan(text: 'Received Amount'),
                                          TextSpan(
                                              text: '*',
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: formWidth * 0.2,
                                          child: const Text(
                                            'Cash',
                                          ),
                                        ),
                                        Container(
                                          width: formWidth * 0.8,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black26),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: TextFormField(
                                              controller: cashController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Enter amount',
                                                  border: InputBorder.none),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  // showError('FirmCode');
                                                  return 'Received amount cannot be empty';
                                                }
                                              },
                                              onSaved: (value) {
                                                billDetails['Cash_Amount'] =
                                                    value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: formWidth * 0.2,
                                          child: const Text(
                                            'G Pay/PhonePe',
                                          ),
                                        ),
                                        Container(
                                          width: formWidth * 0.8,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black26),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: TextFormField(
                                              controller: onlineController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Enter amount',
                                                  border: InputBorder.none),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  // showError('FirmCode');
                                                  return 'Received amount cannot be empty';
                                                }
                                              },
                                              onSaved: (value) {
                                                billDetails['Online_Amount'] =
                                                    value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    selectedAccountType == 'Cash A/C'
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              Container(
                                                width: formWidth * 0.2,
                                                child: const Text(
                                                  'Credit',
                                                ),
                                              ),
                                              Container(
                                                width: formWidth * 0.8,
                                                height: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  child: TextFormField(
                                                    controller:
                                                        creditController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Enter amount',
                                                            border: InputBorder
                                                                .none),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        // showError('FirmCode');
                                                        return 'Received amount cannot be empty';
                                                      }
                                                    },
                                                    onSaved: (value) {
                                                      billDetails[
                                                              'Credit_Amount'] =
                                                          value;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(bottom: bottomPadding),
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Container(
                              //         width: formWidth,
                              //         padding:
                              //             const EdgeInsets.only(bottom: 12),
                              //         child: const Text.rich(
                              //           TextSpan(children: [
                              //             TextSpan(text: 'Balance Amount'),
                              //             TextSpan(
                              //                 text: '*',
                              //                 style:
                              //                     TextStyle(color: Colors.red))
                              //           ]),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: formWidth,
                              //         height: 40,
                              //         alignment: Alignment.center,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(8),
                              //           color: Colors.white,
                              //           border:
                              //               Border.all(color: Colors.black26),
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 12, vertical: 6),
                              //           child: TextFormField(
                              //             decoration: const InputDecoration(
                              //                 hintText: 'Enter Balance amount',
                              //                 border: InputBorder.none),
                              //             validator: (value) {
                              //               if (value!.isEmpty) {
                              //                 // showError('FirmCode');
                              //                 return 'Balance amount cannot be empty';
                              //               }
                              //             },
                              //             onSaved: (value) {
                              //               billDetails['Balance_Amount'] =
                              //                   value;
                              //             },
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.only(bottom: bottomPadding),
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Container(
                              //         width: formWidth,
                              //         padding:
                              //             const EdgeInsets.only(bottom: 12),
                              //         child: const Text.rich(
                              //           TextSpan(children: [
                              //             TextSpan(text: 'Payment Type'),
                              //             TextSpan(
                              //                 text: '*',
                              //                 style:
                              //                     TextStyle(color: Colors.red))
                              //           ]),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: formWidth,
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceAround,
                              //           children: [
                              //             Row(
                              //               children: [
                              //                 Radio(
                              //                     activeColor:
                              //                         ProjectColors.themeColor,
                              //                     value: paymentType.cash,
                              //                     groupValue: selectedPayType,
                              //                     onChanged: (value) {
                              //                       setState(() {
                              //                         selectedPayType =
                              //                             value as paymentType;
                              //                         billDetails[
                              //                                 'Payment_Type'] =
                              //                             'Cash';
                              //                       });
                              //                     }),
                              //                 const SizedBox(
                              //                   width: 6,
                              //                 ),
                              //                 const Text('Cash')
                              //               ],
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Radio(
                              //                     activeColor:
                              //                         ProjectColors.themeColor,
                              //                     value: paymentType.card,
                              //                     groupValue: selectedPayType,
                              //                     onChanged: (value) {
                              //                       setState(() {
                              //                         selectedPayType =
                              //                             value as paymentType;
                              //                         billDetails[
                              //                                 'Payment_Type'] =
                              //                             'Card';
                              //                       });
                              //                     }),
                              //                 const SizedBox(
                              //                   width: 6,
                              //                 ),
                              //                 const Text('Card')
                              //               ],
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Radio(
                              //                     activeColor:
                              //                         ProjectColors.themeColor,
                              //                     value: paymentType.credit,
                              //                     groupValue: selectedPayType,
                              //                     onChanged: (value) {
                              //                       setState(() {
                              //                         selectedPayType =
                              //                             value as paymentType;
                              //                         billDetails[
                              //                                 'Payment_Type'] =
                              //                             'Credit';
                              //                       });
                              //                     }),
                              //                 const SizedBox(
                              //                   width: 6,
                              //                 ),
                              //                 const Text('Credit')
                              //               ],
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.only(bottom: bottomPadding),
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Container(
                              //         width: formWidth,
                              //         padding: const EdgeInsets.only(bottom: 12),
                              //         child: const Text.rich(
                              //           TextSpan(children: [
                              //             TextSpan(text: 'Old return Amount'),
                              //             TextSpan(
                              //                 text: '*',
                              //                 style: TextStyle(color: Colors.red))
                              //           ]),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: formWidth,
                              //         height: 40,
                              //         alignment: Alignment.center,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(8),
                              //           color: Colors.white,
                              //           border: Border.all(color: Colors.black26),
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 12, vertical: 6),
                              //           child: TextFormField(
                              //             decoration: const InputDecoration(
                              //                 hintText: 'Enter old return amount',
                              //                 border: InputBorder.none),
                              //             validator: (value) {
                              //               if (value!.isEmpty) {
                              //                 // showError('FirmCode');
                              //                 return 'Old return amount cannot be empty';
                              //               }
                              //             },
                              //             onSaved: (value) {
                              //               billDetails['Old_Return'] = value;
                              //             },
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.only(bottom: bottomPadding),
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Container(
                              //         width: formWidth,
                              //         padding: const EdgeInsets.only(bottom: 12),
                              //         child: const Text.rich(
                              //           TextSpan(children: [
                              //             TextSpan(text: 'Discount'),
                              //             TextSpan(
                              //                 text: ' %',
                              //                 style: TextStyle(color: Colors.red))
                              //           ]),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: formWidth,
                              //         height: 40,
                              //         alignment: Alignment.center,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(8),
                              //           color: Colors.white,
                              //           border: Border.all(color: Colors.black26),
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 12, vertical: 6),
                              //           child: TextFormField(
                              //             decoration: const InputDecoration(
                              //                 hintText: 'Enter discount amount',
                              //                 border: InputBorder.none),
                              //             validator: (value) {
                              //               // if (value!.isEmpty) {
                              //               //   // showError('FirmCode');
                              //               //   return 'Old return amount cannot be empty';
                              //               // }
                              //             },
                              //             onSaved: (value) {
                              //               billDetails['Discount'] = value;
                              //             },
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 8,
                              // ),
                              Container(
                                width: formWidth,
                                height: 40,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (cashController.text == '') {
                                        cashController.text = '0';
                                      }
                                      if (onlineController.text == '') {
                                        onlineController.text = '0';
                                      }
                                      if (creditController.text == '') {
                                        creditController.text = '0';
                                      }

                                      bool validateData = validate();

                                      if (validateData != true) {
                                        return;
                                      }
                                      formKey.currentState!.save();

                                      List temp = [];
                                      int itemsRowCount = itemCount;

                                      var realItemCount = (itemList.length) / 4;
                                      print(realItemCount);
                                      List<String> substr =
                                          realItemCount.toString().split('.');
                                      if (substr.length == 1) {
                                        if (substr[0] == '0') {
                                          if (realItemCount <
                                              double.parse(
                                                  itemCount.toString())) {
                                            itemsRowCount =
                                                realItemCount.abs().toInt();
                                          }
                                        }
                                      }

                                      for (int i = 0; i < itemsRowCount; i++) {
                                        var item = '';
                                        var itemName = '';
                                        var weight = '';
                                        var amount = '';
                                        var rate = '';
                                        List group = [];
                                        for (int j = 0;
                                            j < itemList.length;
                                            j++) {
                                          if (itemList[j]['Index'] == i) {
                                            group.add(itemList[j]);
                                          }
                                        }

                                        for (var data in group) {
                                          if (data['Key'] == 'Item_Name') {
                                            itemName = data['Value'];
                                          } else if (data['Key'] == 'Weight') {
                                            weight = data['Value'];
                                          } else if (data['Key'] == 'Amount') {
                                            amount = data['Value'];
                                          } else if (data['Key'] == 'Item') {
                                            item = data['Value'];
                                          } else if (data['Key'] == 'Rate') {
                                            rate = data['Value'];
                                          }
                                        }
                                        temp.add({
                                          'Item_Id': itemIdsList.isEmpty
                                              ? ''
                                              : i >= itemIdsList.length
                                                  ? ''
                                                  : itemIdsList[i],
                                          'Item_Type': item,
                                          'Item_Name': itemName,
                                          'Weight': weight,
                                          'Rate': rate,
                                          'Amount': amount,
                                          'Invoice_Id': invoiceId,
                                        });
                                      }
                                      List errorList = [];
                                      for (var data in temp) {
                                        if (data['Item_Type'] == '') {
                                          errorList
                                              .add('Item Type cannot be empty');
                                        }
                                        if (data['Item_Name'] == '') {
                                          errorList
                                              .add('Item name cannot be empty');
                                        }
                                        if (data['Weight'].toString().isNum !=
                                            true) {
                                          errorList.add('Enter a valid weight');
                                        }
                                        if (data['Amount'].toString().isNum !=
                                            true) {
                                          errorList.add('Enter a valid Amount');
                                        }

                                        if (errorList.isNotEmpty) {
                                          validateDialog(errorList);
                                          return;
                                        }
                                      }
                                      billDetails['Customer_Id'] = customerId;

                                      billDetails['Item_Details'] = temp;

                                      if (secondLineAdded == true) {
                                        var firstRowData = {
                                          'Item_Id': oldItemIds.isEmpty
                                              ? ''
                                              : oldItemIds[0],
                                          'Invoice_Id': invoiceId,
                                          'Old_Item_Type': selectedItemFirstRow,
                                          'Weight': oldItemFirstRowWeight.text,
                                          'Amount':
                                              oldAmountFirstRowController.text,
                                        };
                                        var secondRowData = {
                                          'Item_Id': oldItemIds.isEmpty
                                              ? ''
                                              : oldItemIds[1],
                                          'Invoice_Id': invoiceId,
                                          'Old_Item_Type':
                                              selectedSecondRowItem,
                                          'Weight':
                                              oldWeightSecondRowController.text,
                                          'Amount':
                                              oldAmountsecondRowController.text,
                                        };
                                        List data = [];

                                        data.add(firstRowData);
                                        data.add(secondRowData);
                                        billDetails['Old_Item_Details'] = data;

                                        for (var details in data) {
                                          List errorList = [];
                                          if (details['Old_Item_Type'] ==
                                              null) {
                                            errorList.add(
                                                'Old item type cannot be empty');
                                          }
                                          if (details['Weight']
                                                  .toString()
                                                  .isNum !=
                                              true) {
                                            errorList.add(
                                                'Enter a valid Old item weight ');
                                          }
                                          if (details['Amount']
                                                  .toString()
                                                  .isNum !=
                                              true) {
                                            errorList.add(
                                                'Enter a valid Old item amount ');
                                          }

                                          if (errorList.isNotEmpty) {
                                            validateDialog(errorList);
                                            return;
                                          }
                                        }
                                      } else {
                                        List data = [];
                                        if (oldItemFirstRowWeight.text != '') {
                                          var firstRowData = {
                                            'Item_Id': oldItemIds.isEmpty
                                                ? ''
                                                : oldItemIds[0],
                                            'Invoice_Id': invoiceId,
                                            'Old_Item_Type':
                                                selectedItemFirstRow,
                                            'Weight':
                                                oldItemFirstRowWeight.text,
                                            'Amount':
                                                oldAmountFirstRowController
                                                    .text,
                                          };
                                          data.add(firstRowData);
                                        }
                                        for (var details in data) {
                                          List errorList = [];
                                          if (details['Old_Item_Type'] ==
                                              null) {
                                            errorList.add(
                                                'Old item type cannot be empty');
                                          }
                                          if (details['Weight']
                                                  .toString()
                                                  .isNum !=
                                              true) {
                                            errorList.add(
                                                'Enter a valid Old item weight ');
                                          }
                                          if (details['Amount']
                                                  .toString()
                                                  .isNum !=
                                              true) {
                                            errorList.add(
                                                'Enter a valid Old item amount ');
                                          }

                                          if (errorList.isNotEmpty) {
                                            validateDialog(errorList);
                                            return;
                                          }
                                        }
                                        billDetails['Old_Item_Details'] = data;
                                      }

                                      billDetails['Customer_Credit_Balance'] =
                                          customerCreditAmountController.text;
                                      billDetails['Merchant_Credit_Balance'] =
                                          merchantCreditAmountController.text;

                                      if (merchantCreditAmountController.text !=
                                          '0') {
                                        double total = 0;
                                        for (var data in temp) {
                                          total = total +
                                              double.parse(data['Amount']);
                                        }

                                        if (total >
                                            double.parse(
                                                merchantCreditAmountController
                                                    .text)) {
                                          billDetails['Advance_Deducted'] =
                                              merchantCreditAmountController
                                                  .text;
                                          billDetails['New_Payable'] = 0;
                                        } else {
                                          billDetails['Advance_Deducted'] =
                                              total;
                                          double newPayable = double.parse(
                                                  merchantCreditAmountController
                                                      .text) -
                                              total;
                                          if (billDetails['Old_Item_Details']
                                              .isEmpty) {
                                            billDetails['New_Payable'] =
                                                newPayable;
                                          } else {
                                            double oldItemsTotal = 0;
                                            for (var data in billDetails[
                                                'Old_Item_Details']) {
                                              oldItemsTotal = oldItemsTotal +
                                                  double.parse(data['Amount']);
                                            }
                                            billDetails['New_Payable'] =
                                                newPayable + oldItemsTotal;
                                          }
                                        }
                                      } else {
                                        billDetails['New_Payable'] = 0;
                                        billDetails['Advance_Deducted'] = 0;
                                      }

                                      billDetails['Invoice_Id'] = invoiceId;
                                      billDetails['Removed_Items'] =
                                          removedSalesItems;

                                      billDetails['Removed_Old_Items'] =
                                          removedOldItems;

                                      print(billDetails);
                                      grossAmount = 0;
                                      setState(() {
                                        billPreview = true;
                                      });
                                    },
                                    child: const Text('Preview')),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: Container(
                      width: size.width * 0.35,
                      height: size.height * 0.8,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child:
                          // double grossAmount = 0;
                          // if (billDetails.isNotEmpty && grossAmount == 0) {
                          //   for (var data in billDetails['Item_Details']) {
                          //     grossAmount = grossAmount +
                          //         double.parse(data['Amount'].toString());
                          //   }
                          // }

                          billPreview == false
                              ? const SizedBox(
                                  child: Center(
                                    child: Text(
                                        'Invoice details will be displayed over here'),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.01,
                                      vertical: 25),
                                  child: SingleChildScrollView(
                                    controller: invoiceScrollController,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Sales Invoice',
                                            style: ProjectStyles
                                                    .invoiceheadingStyle()
                                                .copyWith(fontSize: 28),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            billDetails['Customer_Name'] ==
                                                    'cash'
                                                ? Text(
                                                    'Invoide Id: ${billDetails['Invoice_Code']}',
                                                    style: ProjectStyles
                                                        .invoiceContentStyle(),
                                                  )
                                                : Text(
                                                    'Customer Name: ${billDetails['Customer_Name']}',
                                                    style: ProjectStyles
                                                        .invoiceContentStyle(),
                                                  ),
                                            Text(
                                              'Date of Purchase: ${DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(billDetails[
                                                    'Created_Date']),
                                              )}',
                                              style: ProjectStyles
                                                  .invoiceContentStyle(),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Invoice Id: ${billDetails['Invoice_Code']}',
                                          style: ProjectStyles
                                              .invoiceContentStyle(),
                                        ),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        // Text(
                                        //   'Cash Paid: ${double.parse(billDetails['invoice']['Cash_Amount']).toStringAsFixed(2)}',
                                        //   style:
                                        //       ProjectStyles.invoiceContentStyle(),
                                        // ),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        // Text(
                                        //   'Online Amount Paid: ${double.parse(billDetails['invoice']['Online_Amount']).toStringAsFixed(2)}',
                                        //   style:
                                        //       ProjectStyles.invoiceContentStyle(),
                                        // ),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        // Text(
                                        //   'Credit Amount: ${double.parse(billDetails['invoice']['Credit_Amount']).toStringAsFixed(2)}',
                                        //   style:
                                        //       ProjectStyles.invoiceContentStyle(),
                                        // ),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        // Text(
                                        //   'Old Item Amount: ${value.singleInvoiceData['invoice']['Old_Return_Amount']}',
                                        //   style:
                                        //       ProjectStyles.invoiceContentStyle(),
                                        // ),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        // // Text(
                                        // //     'Amount paid: ${value.singleInvoiceData['invoice']['Old_Gold_Weight']}'),
                                        // Text(
                                        //   'Amount paid: ${value.singleInvoiceData['invoice']['Received_Amount']}',
                                        //   style:
                                        //       ProjectStyles.invoiceContentStyle(),
                                        // ),

                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Item Details',
                                            style: ProjectStyles
                                                .invoiceheadingStyle(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: DataTable(
                                            columnSpacing: formWidth * 0.08,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                  label: Text(
                                                'Item',
                                                textAlign: TextAlign.left,
                                              )),
                                              DataColumn(
                                                  label: Text(
                                                'Item Name',
                                                textAlign: TextAlign.left,
                                              )),
                                              DataColumn(
                                                  label: Text('Weight (g)')),
                                              DataColumn(label: Text('Amount')),
                                            ],
                                            rows: billDetails['Item_Details']
                                                    .isEmpty
                                                ? []
                                                : [
                                                    for (var data
                                                        in billDetails[
                                                            'Item_Details'])
                                                      DataRow(
                                                        cells: <DataCell>[
                                                          DataCell(
                                                            Text(
                                                              data['Item_Type']
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              data['Item_Name']
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          // DataCell(Text(data['Firm_Name'])),
                                                          DataCell(Text(
                                                              double.parse(
                                                            data['Weight']
                                                                .toString(),
                                                          ).toStringAsFixed(
                                                                  2))),
                                                          DataCell(Text(double
                                                                  .parse(data[
                                                                          'Amount']
                                                                      .toString())
                                                              .toStringAsFixed(
                                                                  2))),
                                                        ],
                                                      )
                                                  ],
                                          ),
                                        ),
                                        billDetails['Old_Item_Details'].isEmpty
                                            ? const SizedBox()
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                    width: size.width * 0.25,
                                                    child: const Divider()),
                                              ),
                                        // billDetails['Old_Item_Details'].isEmpty
                                        //     ? const SizedBox()
                                        //     : Align(
                                        //         alignment: Alignment.center,
                                        //         child: Container(
                                        //           width: size.width * 0.25,
                                        //           child: Row(
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment.end,
                                        //             children: [
                                        //               const Text(
                                        //                   'Gross Amount: '),
                                        //               const SizedBox(
                                        //                 width: 50,
                                        //               ),
                                        //               Container(
                                        //                 width: 80,
                                        //                 alignment: Alignment
                                        //                     .centerLeft,
                                        //                 child: Text(grossAmount
                                        //                     .toString()),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ),
                                        billDetails['Old_Item_Details'].isEmpty
                                            ? const SizedBox()
                                            : const SizedBox(
                                                height: 8,
                                              ),
                                        billDetails['Old_Item_Details'].isEmpty
                                            ? const SizedBox()
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: size.width * 0.25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                          'Old Item Details '),
                                                      const SizedBox(
                                                        width: 50,
                                                      ),
                                                      Container(
                                                        width: 80,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: const SizedBox(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              billDetails['Old_Item_Details']
                                                  .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    billDetails[
                                                            'Old_Item_Details'][
                                                        index]['Old_Item_Type'],
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    double.parse(billDetails[
                                                                    'Old_Item_Details']
                                                                [
                                                                index]['Weight']
                                                            .toString())
                                                        .toStringAsFixed(2),
                                                  ),
                                                ),
                                                Container(
                                                  width: 140,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    double.parse(billDetails[
                                                                    'Old_Item_Details']
                                                                [
                                                                index]['Amount']
                                                            .toString())
                                                        .toStringAsFixed(2),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              width: size.width * 0.25,
                                              child: const Divider()),
                                        ),
                                        billDetails['Merchant_Credit_Balance'] ==
                                                    '0.000000' ||
                                                billDetails[
                                                        'Merchant_Credit_Balance'] ==
                                                    '0'
                                            ? const SizedBox()
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: size.width * 0.25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                          'Merchant Credit Balance: '),
                                                      const SizedBox(
                                                        width: 50,
                                                      ),
                                                      Container(
                                                        width: 80,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(double.parse(
                                                                billDetails[
                                                                        'Merchant_Credit_Balance']
                                                                    .toString())
                                                            .toStringAsFixed(
                                                                2)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        billDetails['Merchant_Credit_Balance'] ==
                                                    '0.000000' ||
                                                billDetails[
                                                        'Merchant_Credit_Balance'] ==
                                                    '0'
                                            ? const SizedBox()
                                            : billDetails[
                                                        'Merchant_Credit_Balance'] ==
                                                    null
                                                ? const SizedBox()
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                        width:
                                                            size.width * 0.25,
                                                        child: const Divider()),
                                                  ),
                                        billDetails['Customer_Credit_Balance'] ==
                                                    '0.000000' ||
                                                billDetails[
                                                        'Merchant_Credit_Balance'] ==
                                                    '0'
                                            ? const SizedBox()
                                            : billDetails[
                                                        'Customer_Credit_Balance'] ==
                                                    null
                                                ? const SizedBox()
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: size.width * 0.25,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Text(
                                                              'Customer Credit Balance: '),
                                                          const SizedBox(
                                                            width: 50,
                                                          ),
                                                          Container(
                                                            width: 80,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(double.parse(
                                                                    billDetails[
                                                                            'Customer_Credit_Balance']
                                                                        .toString())
                                                                .toStringAsFixed(
                                                                    2)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                        billDetails['Customer_Credit_Balance'] ==
                                                    '0.000000' ||
                                                billDetails[
                                                        'Merchant_Credit_Balance'] ==
                                                    '0'
                                            ? const SizedBox()
                                            : billDetails[
                                                        'Customer_Credit_Balance'] ==
                                                    null
                                                ? const SizedBox()
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                        width:
                                                            size.width * 0.25,
                                                        child: const Divider()),
                                                  ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: size.width * 0.25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Text('Net Amount: '),
                                                const SizedBox(
                                                  width: 50,
                                                ),
                                                Container(
                                                  width: 80,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(double.parse(
                                                          billDetails[
                                                                  'Total_Amount']
                                                              .toString())
                                                      .toStringAsFixed(2)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              width: size.width * 0.25,
                                              child: const Divider()),
                                        ),
                                        billDetails['Cash_Amount'] == '0.000000'
                                            ? const SizedBox()
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: size.width * 0.25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const Text('Cash Paid: '),
                                                      const SizedBox(
                                                        width: 50,
                                                      ),
                                                      Container(
                                                        width: 80,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(double.parse(
                                                                billDetails[
                                                                    'Cash_Amount'])
                                                            .toStringAsFixed(
                                                                2)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        billDetails['Cash_Amount'] == '0.000000'
                                            ? const SizedBox()
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                    width: size.width * 0.25,
                                                    child: const Divider()),
                                              ),
                                        billDetails['Online_Amount'] ==
                                                '0.000000'
                                            ? const SizedBox()
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: size.width * 0.25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                          'Online Paid: '),
                                                      const SizedBox(
                                                        width: 50,
                                                      ),
                                                      Container(
                                                        width: 80,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(double.parse(
                                                                billDetails[
                                                                    'Online_Amount'])
                                                            .toStringAsFixed(
                                                                2)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        billDetails['Online_Amount'] ==
                                                '0.000000'
                                            ? const SizedBox()
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                    width: size.width * 0.25,
                                                    child: const Divider()),
                                              ),
                                        billDetails['Credit_Amount'] ==
                                                '0.000000'
                                            ? const SizedBox()
                                            : billDetails['Credit_Amount'] ==
                                                    null
                                                ? const SizedBox()
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: size.width * 0.25,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Text(
                                                              'Credit: '),
                                                          const SizedBox(
                                                            width: 50,
                                                          ),
                                                          Container(
                                                            width: 80,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(double.parse(
                                                                    billDetails[
                                                                        'Credit_Amount'])
                                                                .toStringAsFixed(
                                                                    2)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                        SizedBox(
                                          height: size.height * 0.05,
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  editInvoice(
                                                    billDetails,
                                                    billDetails['Item_Details'],
                                                    billDetails[
                                                        'Old_Item_Details'],
                                                  );
                                                },
                                                icon: const Icon(Icons.edit),
                                                label: const Text('Edit')),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                saveSalesInvoice()
                                                    .then((value) {});
                                              },
                                              icon: const Icon(
                                                  Icons.import_export),
                                              label:
                                                  const Text('Save & Export'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding oldItemSecondFields(double bottomPadding, double formWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: formWidth * 0.35,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Select old Item'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Container(
                width: formWidth * 0.35,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(formWidth * 0.02),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: selectedSecondRowItem,
                    items: [
                      'Gold',
                      'Silver',
                    ].map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                        child: Text(
                          e,
                          style: ProjectStyles.invoiceheadingStyle().copyWith(
                              fontSize: formWidth * 0.035, color: Colors.black),
                        ),
                        value: e,
                        onTap: () {
                          billDetails['Old_Item_Name'] = e;
                          // firmId = e['Firm_Code'];
                          // user['User_Role_Name'] = e['Role_Name'];
                        },
                      );
                    }).toList(),
                    hint: Text(
                      'Select Item',
                      style: ProjectStyles.invoiceheadingStyle().copyWith(
                          fontSize: formWidth * 0.04, color: Colors.black),
                    ),
                    style: ProjectStyles.invoiceheadingStyle().copyWith(
                        fontSize: formWidth * 0.035, color: Colors.black),
                    iconDisabledColor: Colors.black,
                    iconEnabledColor: Colors.black,
                    dropdownColor: Colors.white,
                    alignment: Alignment.center,
                    onChanged: (value) {
                      setState(() {
                        selectedSecondRowItem = value as String;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: formWidth * 0.05,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: formWidth * 0.25,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Weight (g)'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Container(
                width: formWidth * 0.25,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 5),
                  child: TextFormField(
                    controller: oldWeightSecondRowController,
                    decoration: const InputDecoration(
                        hintText: 'Enter weight', border: InputBorder.none),
                    validator: (value) {
                      // if (value!.isEmpty) {
                      //   // showError('FirmCode');
                      //   return 'weight cannot be empty';
                      // }
                    },
                    onSaved: (value) {
                      // billDetails[
                      //     'Old_Weight'] = value;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: formWidth * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: formWidth * 0.3,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Amount'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: formWidth * 0.3,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 5),
                      child: TextFormField(
                        focusNode: exchangeTotalAmountSecondRowFocus,
                        controller: oldAmountsecondRowController,
                        decoration: const InputDecoration(
                            hintText: 'Enter amount', border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            // showError('FirmCode');
                            return 'Amount cannot be empty';
                          }
                        },
                        onSaved: (value) {
                          // billDetails[
                          //         'Old_Return_Amount'] =
                          //     value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          oldAmountsecondRowController.text = '';
                          _onExchangeSecondRowTotalAmountFocusChange();
                          secondLineAdded = false;
                          if (widget.editData.isNotEmpty) {
                            removedOldItems.add(oldItemIds[1]);
                            oldItemIds.removeAt(1);
                            print(removedOldItems);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: ProjectColors.themeColor,
                      ))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding oldItemFirstFilelds(double bottomPadding, double formWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: formWidth * 0.35,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Select old Item'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Container(
                width: formWidth * 0.35,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(formWidth * 0.02),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: selectedItemFirstRow,
                    items: [
                      'Gold',
                      'Silver',
                    ].map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                        child: Text(
                          e,
                          style: ProjectStyles.invoiceheadingStyle().copyWith(
                              fontSize: formWidth * 0.035, color: Colors.black),
                        ),
                        value: e,
                        onTap: () {
                          billDetails['Old_Item_Name'] = e;
                          // firmId = e['Firm_Code'];
                          // user['User_Role_Name'] = e['Role_Name'];
                        },
                      );
                    }).toList(),
                    hint: Text(
                      'Select Item',
                      style: ProjectStyles.invoiceheadingStyle().copyWith(
                          fontSize: formWidth * 0.04, color: Colors.black),
                    ),
                    style: ProjectStyles.invoiceheadingStyle().copyWith(
                        fontSize: formWidth * 0.035, color: Colors.black),
                    iconDisabledColor: Colors.black,
                    iconEnabledColor: Colors.black,
                    dropdownColor: Colors.white,
                    alignment: Alignment.center,
                    onChanged: (value) {
                      setState(() {
                        selectedItemFirstRow = value as String;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: formWidth * 0.05,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: formWidth * 0.25,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Weight (g)'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Container(
                width: formWidth * 0.25,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 5),
                  child: TextFormField(
                    controller: oldItemFirstRowWeight,
                    decoration: const InputDecoration(
                        hintText: 'Enter weight', border: InputBorder.none),
                    validator: (value) {
                      // if (value!.isEmpty) {
                      //   // showError('FirmCode');
                      //   return 'weight cannot be empty';
                      // }
                    },
                    onSaved: (value) {
                      billDetails['Old_Weight'] = value;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: formWidth * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: formWidth * 0.3,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Amount'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: formWidth * 0.3,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 5),
                      child: TextFormField(
                        maxLines: 2,
                        focusNode: exchangeTotalAmountFirstRowFocus,
                        controller: oldAmountFirstRowController,
                        decoration: const InputDecoration(
                            hintText: 'Enter amount', border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            // showError('FirmCode');
                            return 'Amount cannot be empty';
                          }
                        },
                        onSaved: (value) {
                          // billDetails[
                          //         'Old_Return_Amount'] =
                          //     value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  secondLineAdded == true
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            widget.editData.isEmpty
                                ? setState(() {
                                    secondLineAdded = true;
                                  })
                                : widget.editData['Old_Items'].length == 2
                                    ? setState(() {
                                        secondLineAdded = true;
                                        oldItemIds.add(removedOldItems[0]);
                                        removedOldItems.clear();
                                      })
                                    : const SizedBox();
                          },
                          icon: Icon(
                            Icons.add,
                            color: ProjectColors.themeColor,
                          ))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addCustomer(Size size) {
    var boxWidth = size.width * 0.38;
    double boxHeight = 580;
    nameValidation = true;
    mobileNumberValidation = true;
    selectedIdValidation = true;
    idControllerValidation = true;
    addressControllerValidation = true;
    openingBalanceControllerValidation = true;

    Get.dialog(Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _customerKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Customer',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: boxHeight * 0.06,
                      ),
                      getField(
                        nameController,
                        'Customer Name',
                        true,
                      ),

                      nameValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(nameValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        mobileNumberController,
                        'Mobile Number',
                        true,
                      ),
                      mobileNumberValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:
                                  getErrorField(mobileNumberValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),

                      Container(
                        width: 500,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedIdProof,
                            items: [
                              'Aadhar Card',
                              'Voter Id',
                              'Pan Card',
                              'Driving License',
                              'Other'
                            ].map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: 415,
                                    child: Text(
                                      e,
                                      // style: TextStyle(
                                      //   fontSize: 14,
                                      //   color: Colors.black,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ),
                                ),
                                value: e,
                                onTap: () {
                                  // purchaseDetailsData['Id_Proof'] = e;
                                  // firmId = e['Firm_Code'];
                                  // user['User_Role_Name'] = e['Role_Name'];
                                },
                              );
                            }).toList(),
                            hint: const Text(
                              'Select Id Proof',
                              // style: TextStyle(
                              //   fontSize: 14,
                              //   color: Colors.black,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),

                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            // alignment: Alignment.center,
                            onChanged: (value) {
                              setState(() {
                                selectedIdProof = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      selectedIdValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(selectedIdValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        idProffController,
                        'Id Number',
                        true,
                      ),
                      idControllerValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:
                                  getErrorField(idControllerValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        addressController,
                        'Address',
                        true,
                      ),
                      addressControllerValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  addressControllerValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.04,
                      ),
                      getField(
                        openingBalanceController,
                        'Credit Balance',
                        true,
                      ),
                      openingBalanceControllerValidation == true
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getErrorField(
                                  openingBalanceControllerValidationMessage),
                            ),
                      SizedBox(
                        height: boxHeight * 0.08,
                      ),
                      // DropdownButtonFormField(
                      //     isExpanded: true,
                      //     items: customerList
                      //         .map<DropdownMenuItem<String>>(
                      //             (e) => DropdownMenuItem(
                      //                   child: Text(e),
                      //                   value: e,
                      //                 ))
                      //         .toList(),
                      //     onChanged: (value) {}),

                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: boxWidth * 0.18,
                            height: boxHeight * 0.1,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.length > 15) {
                                    nameValidation = false;
                                    nameValidationMessage =
                                        'customer name cannot be greater then 15 characters';
                                  } else if (nameController.text == '') {
                                    nameValidation = false;
                                    nameValidationMessage =
                                        'Enter a valid name';
                                  } else {
                                    nameValidation = true;
                                  }
                                  if (mobileNumberController.text.length !=
                                      10) {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else if (mobileNumberController
                                          .text.isNum !=
                                      true) {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else if (mobileNumberController
                                          .text.length >
                                      10) {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else if (mobileNumberController.text ==
                                      '') {
                                    mobileNumberValidation = false;
                                    mobileNumberValidationMessage =
                                        'Enter a valid mobile number';
                                  } else {
                                    mobileNumberValidation = true;
                                  }

                                  if (selectedIdProof == null) {
                                    selectedIdValidation = false;
                                    selectedIdValidationMessage =
                                        'Select id proof';
                                  } else {
                                    selectedIdValidation = true;
                                  }

                                  if (idProffController.text == '') {
                                    idControllerValidation = false;
                                    idControllerValidationMessage =
                                        'Enter a valid id proof';
                                  } else {
                                    idControllerValidation = true;
                                  }
                                  if (addressController.text.length > 30) {
                                    addressControllerValidation = false;
                                    addressControllerValidationMessage =
                                        'Address cannot be greater then 30 characters';
                                  } else if (addressController.text == '') {
                                    addressControllerValidation = false;
                                    addressControllerValidationMessage =
                                        'Address cannot be empty';
                                  } else {
                                    addressControllerValidation = true;
                                  }
                                  if (openingBalanceController.text.isNum !=
                                      true) {
                                    openingBalanceControllerValidation = false;
                                    openingBalanceControllerValidationMessage =
                                        'credit balance cannot be empty either it should be zero or a valid integer';
                                  } else if (openingBalanceController.text ==
                                      '') {
                                    openingBalanceControllerValidation = false;
                                    openingBalanceControllerValidationMessage =
                                        'credit balance cannot be empty either it should be zero or a valid integer';
                                  } else {
                                    openingBalanceControllerValidation = true;
                                  }

                                  if (nameValidation == true &&
                                      mobileNumberValidation == true &&
                                      selectedIdValidation == true &&
                                      idControllerValidation == true &&
                                      addressControllerValidation == true &&
                                      openingBalanceControllerValidation ==
                                          true) {
                                    saveNewCustomer();
                                  } else {
                                    setState(() {});
                                    return;
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: ProjectStyles.invoiceheadingStyle()
                                      .copyWith(color: Colors.white),
                                )),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  void editInvoice(
      Map<String, dynamic> invoiceDetails, List itemDetails, List oldItems) {
    dateController.text = invoiceDetails['Created_Date'];
    cashController.text = invoiceDetails['Cash_Amount'];
    onlineController.text = invoiceDetails['Online_Amount'];
    creditController.text = invoiceDetails['Credit_Amount'] ?? '';
    customerId = invoiceDetails['Customer_Id'];
    invoiceDetails['Customer_Id__Customer_Name'] == 'cash'
        ? selectedAccountType = 'Cash A/C'
        : customerNameController.text = invoiceDetails['Customer_Name'] ??
            invoiceDetails['Customer_Id__Customer_Name'];
    merchantCreditAmountController.text =
        invoiceDetails['Merchant_Credit_Balance'];
    customerCreditAmountController.text =
        invoiceDetails['Customer_Credit_Balance'];
    totalAmountController.text = invoiceDetails['Total_Amount'];
    invoiceIdController.text = invoiceDetails['Invoice_Code'];
    invoiceId = invoiceDetails['Invoice_Id'];
    if (itemDetails.isNotEmpty) {
      itemCount = itemDetails.length;
      for (int i = 0; i < itemDetails.length; i++) {
        itemIdsList.add(itemDetails[i]['Item_Id']);

        Map<String, dynamic> itemType = {
          'Key': 'Item',
          'Index': i,
          'Value': itemDetails[i]['Item_Type']
        };
        Map<String, dynamic> itemName = {
          'Key': 'Item_Name',
          'Index': i,
          'Value': itemDetails[i]['Item_Name']
        };
        Map<String, dynamic> weight = {
          'Key': 'Weight',
          'Index': i,
          'Value': itemDetails[i]['Weight']
        };
        Map<String, dynamic> amount = {
          'Key': 'Amount',
          'Index': i,
          'Value': itemDetails[i]['Amount']
        };
        Map<String, dynamic> rate = {
          'Key': 'Rate',
          'Index': i,
          'Value': itemDetails[i]['Rate']
        };

        itemList.addAll([itemType, itemName, weight, amount, rate]);
      }
    }

    if (oldItems.isNotEmpty) {
      for (var data in oldItems) {
        oldItemIds.add(data['Item_Id']);
      }

      if (oldItems.length == 1) {
        selectedItemFirstRow = oldItems[0]['Old_Item_Type'];
        oldItemFirstRowWeight.text = oldItems[0]['Weight'];
        oldAmountFirstRowController.text = oldItems[0]['Amount'];
      } else {
        secondLineAdded = true;
        selectedItemFirstRow = oldItems[0]['Old_Item_Type'];
        oldItemFirstRowWeight.text = oldItems[0]['Weight'];
        oldAmountFirstRowController.text = oldItems[0]['Amount'];
        selectedSecondRowItem = oldItems[1]['Old_Item_Type'];
        oldWeightSecondRowController.text = oldItems[1]['Weight'];
        oldAmountsecondRowController.text = oldItems[1]['Amount'];
      }
    }

    setState(() {});
  }
}

class MainDrawer extends StatelessWidget {
  ScrollController controller = ScrollController();

  MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        backgroundColor: Colors.black.withOpacity(0.8),
        semanticLabel: 'Side bar',
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: ProjectColors.themeColor.withOpacity(0.8)),
                child: Container(
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome',
                        style:
                            ProjectStyles.drawerStyle().copyWith(fontSize: 20),
                      ),
                      // Text(
                      //   '5000',
                      //   style: ProjectStyles.drawerStyle().copyWith(fontSize: 18),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   'Gold In Hand(g)',
                      //   style: ProjectStyles.drawerStyle().copyWith(fontSize: 20),
                      // ),
                      // Text(
                      //   '5000',
                      //   style: ProjectStyles.drawerStyle().copyWith(fontSize: 18),
                      // ),
                    ],
                  ),
                ),
              ),
              // ListTile(
              //   onTap: () {
              //     Get.offNamed(ProfilePage.routeName);
              //   },
              //   hoverColor: ProjectColors.themeColor.withOpacity(0.5),
              //   title: Center(
              //     child: Text(
              //       'Old Inventory',
              //       style: ProjectStyles.drawerStyle(),
              //     ),
              //   ),
              // ),
              ListTile(
                onTap: () {
                  Get.offNamed(AddBillingScreen.routeName);
                },
                hoverColor: ProjectColors.themeColor.withOpacity(0.5),
                title: Center(
                  child: Text(
                    'Sales Invoice',
                    style: ProjectStyles.drawerStyle(),
                  ),
                ),
              ),
              // ListTile(
              //   onTap: () {
              //     Get.offNamed(SalesScreen.routeName);
              //   },
              //   hoverColor: ProjectColors.themeColor.withOpacity(0.5),
              //   title: Center(
              //     child: Text(
              //       'Individual Sales Invoice',
              //       style: ProjectStyles.drawerStyle(),
              //     ),
              //   ),
              // ),
              ListTile(
                onTap: () {
                  Get.offNamed(PurchasesScreen.routeName);
                },
                hoverColor: ProjectColors.themeColor.withOpacity(0.5),
                title: Center(
                  child: Text(
                    'Purchase Invoice',
                    style: ProjectStyles.drawerStyle(),
                  ),
                ),
              ),

              ListTile(
                onTap: () {
                  Get.offNamed(CustomersListScreen.routeName);
                },
                hoverColor: ProjectColors.themeColor.withOpacity(0.5),
                title: Center(
                  child: Text(
                    'Customers',
                    style: ProjectStyles.drawerStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // ListTile(
              //   onTap: () {
              //     Get.offNamed(SupplierListScreen.routeName);
              //   },
              //   hoverColor: ProjectColors.themeColor.withOpacity(0.5),
              //   title: Center(
              //     child: Text(
              //       'Suppliers',
              //       style: ProjectStyles.drawerStyle(),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              ListTile(
                onTap: () {
                  Get.offNamed(ExpensesPage.routeName);
                },
                hoverColor: ProjectColors.themeColor.withOpacity(0.5),
                title: Center(
                  child: Text(
                    'Expenses',
                    style: ProjectStyles.drawerStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ListTile(
                onTap: () {
                  Get.offNamed(AddSalesJournal.routeName);
                },
                hoverColor: ProjectColors.themeColor.withOpacity(0.5),
                title: Center(
                  child: Text(
                    'New Sales Page',
                    style: ProjectStyles.drawerStyle(),
                  ),
                ),
              ),
              // ListTile(
              //   onTap: () {
              //     Get.offNamed(PurchasesScreen.routeName);
              //   },
              //   hoverColor: ProjectColors.themeColor.withOpacity(0.5),
              //   title: Center(
              //     child: Text(
              //       'Purchases',
              //       style: ProjectStyles.drawerStyle(),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // ListTile(
              //   onTap: () {
              //     Get.toNamed(ReportScreen.routeName);
              //   },
              //   hoverColor: ProjectColors.themeColor.withOpacity(0.5),
              //   title: Center(
              //     child: Text(
              //       'Report',
              //       style: ProjectStyles.drawerStyle(),
              //     ),
              //   ),
              // ),
              // ListTile(
              //   onTap: () {
              //     Get.toNamed(BalanceSheetScreen.routeName);
              //   },
              //   hoverColor: ProjectColors.themeColor.withOpacity(0.5),
              //   title: Center(
              //     child: Text(
              //       'Balance Sheet',
              //       style: ProjectStyles.drawerStyle(),
              //     ),
              //   ),
              // ),
              OperationsDropDown(),
            ],
          ),
        ),
      ),
    );
  }
}

class AddItems extends StatefulWidget {
  AddItems(
      {Key? key,
      required this.data,
      required this.itemCount,
      required this.index,
      required this.increaseRowCount,
      required this.decreaseRowCount,
      required this.itemList})
      : super(key: key);

  final ValueChanged<Map<String, dynamic>> data;
  final int itemCount;
  final int index;
  final ValueChanged<int> increaseRowCount;
  final ValueChanged<int> decreaseRowCount;
  final List itemList;

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  Map<String, dynamic> billDetails = {};

  TextEditingController itemNameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  FocusNode itemFocus = FocusNode();
  FocusNode weightFocus = FocusNode();
  FocusNode amountFocus = FocusNode();

  var selectedItem;

  FocusNode rateFocus = FocusNode();

  TextEditingController rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.itemList.isNotEmpty) {
      for (var data in widget.itemList) {
        if (data['Index'] == widget.index) {
          if (data['Key'] == 'Item_Name') {
            itemNameController.text = data['Value'];
          } else if (data['Key'] == 'Weight') {
            weightController.text = data['Value'];
          } else if (data['Key'] == 'Amount') {
            amountController.text = data['Value'];
          } else if (data['Key'] == 'Item') {
            selectedItem = data['Value'];
          } else if (data['Key'] == 'Rate') {
            rateController.text = data['Value'];
          }
        }
      }
    }
    itemFocus.addListener(_onItemFocusChange);
    weightFocus.addListener(_onWeightFocusChange);
    amountFocus.addListener(_onAmountFocusChange);
    rateFocus.addListener(_onRateFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    itemFocus.removeListener(_onItemFocusChange);
    itemFocus.dispose();
    weightFocus.removeListener(_onWeightFocusChange);
    weightFocus.dispose();
    amountFocus.removeListener(_onAmountFocusChange);
    amountFocus.dispose();
    rateFocus.removeListener(_onRateFocusChange);
    rateFocus.dispose();
  }

  void _onRateFocusChange() {
    debugPrint("Rate: ${rateFocus.hasFocus.toString()}");

    if (rateFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Rate',
        'Index': widget.index,
        'Value': rateController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
      calculateTotalAmount();
      Map<String, dynamic> amountData = {
        'Key': 'Amount',
        'Index': widget.index,
        'Value': amountController.text,
      };
      // debugPrint(data.toString());
      widget.data(amountData);
    }
  }

  void _onItemFocusChange() {
    debugPrint("Focus: ${itemFocus.hasFocus.toString()}");

    if (itemFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Item_Name',
        'Index': widget.index,
        'Value': itemNameController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
    }
  }

  void _onWeightFocusChange() {
    if (weightFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Weight',
        'Index': widget.index,
        'Value': weightController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
      calculateTotalAmount();
      Map<String, dynamic> amountData = {
        'Key': 'Amount',
        'Index': widget.index,
        'Value': amountController.text,
      };
      // debugPrint(data.toString());
      widget.data(amountData);
    }
  }

  void _onAmountFocusChange() {
    debugPrint("Focus: ${amountFocus.hasFocus.toString()}");

    if (amountFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Amount',
        'Index': widget.index,
        'Value': amountController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
    }
  }

  void calculateTotalAmount() {
    double rate = rateController.text.isAlphabetOnly
        ? 0
        : rateController.text == ''
            ? 0
            : double.parse(rateController.text);
    double weight = weightController.text.isAlphabetOnly
        ? 0
        : weightController.text == ''
            ? 0
            : double.parse(weightController.text);
    amountController.text = (weight * rate).toStringAsFixed(2);
  }

  void validate(String message) {
    Get.defaultDialog(
        title: 'Validation Error',
        middleText: message,
        titleStyle: const TextStyle(color: Colors.red),
        confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Ok')));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var formWidth = size.width * 0.25;
    var bottomPadding = size.height * 0.02;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: formWidth * 0.35,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Select Item'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Container(
                width: formWidth * 0.35,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            // style: ProjectStyles.invoiceheadingStyle().copyWith(
                            //     fontSize: formWidth * 0.04, color: Colors.black),
                          ),
                          value: e,
                          onTap: () {
                            if (e == 'Gold_Bullion') {
                              itemNameController.text = 'Gold Bullion';
                              Map<String, dynamic> data = {
                                'Key': 'Item_Name',
                                'Index': widget.index,
                                'Value': itemNameController.text,
                              };
                              debugPrint(data.toString());
                              widget.data(data);
                            } else if (e == 'Silver_Bullion') {
                              itemNameController.text = 'Silver Bullion';
                              Map<String, dynamic> data = {
                                'Key': 'Item_Name',
                                'Index': widget.index,
                                'Value': itemNameController.text,
                              };
                              debugPrint(data.toString());
                              widget.data(data);
                            }

                            // billDetails['Old_Item_Name'] = e;
                            Map<String, dynamic> data = {
                              'Key': 'Item',
                              'Index': widget.index,
                              'Value': e,
                            };
                            debugPrint(data.toString());
                            widget.data(data);
                            // firmId = e['Firm_Code'];
                            // user['User_Role_Name'] = e['Role_Name'];
                          },
                        );
                      }).toList(),
                      hint: const Text(
                        'Select Item',
                        // style: ProjectStyles.invoiceheadingStyle().copyWith(
                        //     fontSize: formWidth * 0.04, color: Colors.black),
                      ),
                      // style: ProjectStyles.invoiceheadingStyle().copyWith(
                      //     fontSize: formWidth * 0.04, color: Colors.black),
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
            ],
          ),
        ),
        SizedBox(
          width: formWidth * 0.05,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: formWidth * 0.4,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Item Name'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ),
              Container(
                width: formWidth * 0.4,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 6),
                  child: TextFormField(
                    focusNode: itemFocus,
                    controller: itemNameController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Item Name', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        // showError('FirmCode');
                        return 'Item name cannot be empty';
                      }
                    },
                    onSaved: (value) {
                      billDetails['Item_Name'] = value;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: formWidth * 0.05,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: formWidth * 0.3,
                    padding: const EdgeInsets.only(bottom: 12),
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Weight (g)'),
                        TextSpan(text: '*', style: TextStyle(color: Colors.red))
                      ]),
                    ),
                  ),
                  Container(
                    width: formWidth * 0.3,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 6),
                      child: TextFormField(
                        focusNode: weightFocus,
                        controller: weightController,
                        decoration: const InputDecoration(
                            hintText: 'Enter weight', border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            // showError('FirmCode');
                            return 'weight cannot be empty';
                          }
                        },
                        onSaved: (value) {
                          billDetails['Weight'] = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: formWidth * 0.1,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: formWidth * 0.3,
                    padding: const EdgeInsets.only(bottom: 12),
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Rate'),
                        TextSpan(text: '*', style: TextStyle(color: Colors.red))
                      ]),
                    ),
                  ),
                  Container(
                    width: formWidth * 0.3,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 6),
                      child: TextFormField(
                        focusNode: rateFocus,
                        controller: rateController,
                        decoration: const InputDecoration(
                            hintText: 'Enter Rate', border: InputBorder.none),
                        onSaved: (value) {
                          billDetails['Rate'] = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: formWidth * 0.1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: formWidth * 0.4,
                    padding: const EdgeInsets.only(bottom: 12),
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Amount'),
                        TextSpan(text: '*', style: TextStyle(color: Colors.red))
                      ]),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: formWidth * 0.4,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 6),
                          child: TextFormField(
                            enabled: false,
                            focusNode: amountFocus,
                            controller: amountController,
                            decoration: const InputDecoration(
                                hintText: 'Enter amount',
                                border: InputBorder.none),
                            validator: (value) {
                              if (value!.isEmpty) {
                                // showError('FirmCode');
                                return 'Amount cannot be empty';
                              }
                            },
                            onSaved: (value) {
                              billDetails['Amount'] = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: formWidth * 0.1,
                      ),
                      widget.index + 1 == widget.itemCount
                          ? IconButton(
                              onPressed: () {
                                widget.increaseRowCount(widget.index);
                              },
                              icon: Icon(
                                Icons.add,
                                color: ProjectColors.themeColor,
                              ))
                          : IconButton(
                              onPressed: () {
                                widget.decreaseRowCount(widget.index);
                              },
                              icon: const Icon(Icons.remove))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: formWidth * 0.1,
        ),

        // Padding(
        //   padding: EdgeInsets.only(bottom: bottomPadding),
        //   child:
        // ),
      ],
    );
  }
}

// class AddOldItems extends StatefulWidget {
//   AddOldItems(
//       {Key? key,
//       required this.data,
//       required this.itemCount,
//       required this.index,
//       required this.increaseRowCount,
//       required this.decreaseRowCount,
//       required this.itemList})
//       : super(key: key);

//   final ValueChanged<Map<String, dynamic>> data;
//   final int itemCount;
//   final int index;
//   final ValueChanged<int> increaseRowCount;
//   final ValueChanged<int> decreaseRowCount;
//   final List itemList;

//   @override
//   State<AddOldItems> createState() => _AddOldItemsState();
// }

// class _AddOldItemsState extends State<AddOldItems> {
//   Map<String, dynamic> billDetails = {};

//   TextEditingController itemNameController = TextEditingController();
//   TextEditingController weightController = TextEditingController();
//   TextEditingController amountController = TextEditingController();

//   FocusNode itemFocus = FocusNode();
//   FocusNode weightFocus = FocusNode();
//   FocusNode amountFocus = FocusNode();

//   var selectedItem;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.itemList.isNotEmpty) {
//       for (var data in widget.itemList) {
//         if (data['Index'] == widget.index) {
//           if (data['Key'] == 'Item_Name') {
//             itemNameController.text = data['Value'];
//           } else if (data['Key'] == 'Weight') {
//             weightController.text = data['Value'];
//           } else if (data['Key'] == 'Amount') {
//             amountController.text = data['Value'];
//           } else if (data['Key'] == 'Item') {
//             selectedItem = data['Value'];
//             print('Selected item: $selectedItem');
//           }
//         }
//       }
//     }
//     itemFocus.addListener(_onItemFocusChange);
//     weightFocus.addListener(_onWeightFocusChange);
//     amountFocus.addListener(_onAmountFocusChange);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     itemFocus.removeListener(_onItemFocusChange);
//     itemFocus.dispose();
//     weightFocus.removeListener(_onWeightFocusChange);
//     weightFocus.dispose();
//     amountFocus.removeListener(_onAmountFocusChange);
//     amountFocus.dispose();
//   }

//   void _onItemFocusChange() {
//     debugPrint("Focus: ${itemFocus.hasFocus.toString()}");

//     if (itemFocus.hasFocus == false) {
//       Map<String, dynamic> data = {
//         'Key': 'Item_Name',
//         'Index': widget.index,
//         'Value': itemNameController.text,
//       };
//       debugPrint(data.toString());
//       widget.data(data);
//     }
//   }

//   void _onWeightFocusChange() {
//     if (weightFocus.hasFocus == false) {
//       Map<String, dynamic> data = {
//         'Key': 'Weight',
//         'Index': widget.index,
//         'Value': weightController.text,
//       };
//       debugPrint(data.toString());
//       widget.data(data);
//     }
//   }

//   void _onAmountFocusChange() {
//     debugPrint("Focus: ${amountFocus.hasFocus.toString()}");

//     if (amountFocus.hasFocus == false) {
//       Map<String, dynamic> data = {
//         'Key': 'Amount',
//         'Index': widget.index,
//         'Value': amountController.text,
//       };
//       debugPrint(data.toString());
//       widget.data(data);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     var formWidth = size.width * 0.25;
//     var bottomPadding = size.height * 0.02;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Padding(
//           padding: EdgeInsets.only(bottom: bottomPadding),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: formWidth * 0.35,
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: const Text.rich(
//                   TextSpan(children: [
//                     TextSpan(text: 'Select Item'),
//                     TextSpan(text: '*', style: TextStyle(color: Colors.red))
//                   ]),
//                 ),
//               ),
//               Container(
//                 width: formWidth * 0.35,
//                 height: 40,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                   border: Border.all(color: Colors.black26),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton(
//                     value: selectedItem,
//                     items: [
//                       'Gold',
//                       'Silver',
//                     ].map<DropdownMenuItem<String>>((e) {
//                       return DropdownMenuItem(
//                         child: Text(
//                           e,
//                           style: ProjectStyles.invoiceheadingStyle().copyWith(
//                               fontSize: formWidth * 0.04, color: Colors.black),
//                         ),
//                         value: e,
//                         onTap: () {
//                           // billDetails['Old_Item_Name'] = e;
//                           Map<String, dynamic> data = {
//                             'Key': 'Item',
//                             'Index': widget.index,
//                             'Value': e,
//                           };
//                           debugPrint(data.toString());
//                           widget.data(data);
//                           // firmId = e['Firm_Code'];
//                           // user['User_Role_Name'] = e['Role_Name'];
//                         },
//                       );
//                     }).toList(),
//                     hint: Text(
//                       'Select Item',
//                       style: ProjectStyles.invoiceheadingStyle().copyWith(
//                           fontSize: formWidth * 0.04, color: Colors.black),
//                     ),
//                     style: ProjectStyles.invoiceheadingStyle().copyWith(
//                         fontSize: formWidth * 0.04, color: Colors.black),
//                     iconDisabledColor: Colors.black,
//                     iconEnabledColor: Colors.black,
//                     dropdownColor: Colors.white,
//                     alignment: Alignment.center,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedItem = value as String;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           width: formWidth * 0.1,
//         ),
//         Padding(
//           padding: EdgeInsets.only(bottom: bottomPadding),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: formWidth * 0.5,
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: const Text.rich(
//                   TextSpan(children: [
//                     TextSpan(text: 'Item Name'),
//                     TextSpan(text: '*', style: TextStyle(color: Colors.red))
//                   ]),
//                 ),
//               ),
//               Container(
//                 width: formWidth * 0.5,
//                 height: 40,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                   border: Border.all(color: Colors.black26),
//                 ),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   child: TextFormField(
//                     focusNode: itemFocus,
//                     controller: itemNameController,
//                     decoration: const InputDecoration(
//                         hintText: 'Enter Item Name', border: InputBorder.none),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         // showError('FirmCode');
//                         return 'Item name cannot be empty';
//                       }
//                     },
//                     onSaved: (value) {
//                       billDetails['Item_Name'] = value;
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           width: formWidth * 0.1,
//         ),
//         Padding(
//           padding: EdgeInsets.only(bottom: bottomPadding),
//           child: Row(
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: formWidth * 0.4,
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: const Text.rich(
//                       TextSpan(children: [
//                         TextSpan(text: 'Weight (g)'),
//                         TextSpan(text: '*', style: TextStyle(color: Colors.red))
//                       ]),
//                     ),
//                   ),
//                   Container(
//                     width: formWidth * 0.4,
//                     height: 40,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.white,
//                       border: Border.all(color: Colors.black26),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       child: TextFormField(
//                         focusNode: weightFocus,
//                         controller: weightController,
//                         decoration: const InputDecoration(
//                             hintText: 'Enter weight', border: InputBorder.none),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             // showError('FirmCode');
//                             return 'weight cannot be empty';
//                           }
//                         },
//                         onSaved: (value) {
//                           billDetails['Weight'] = value;
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: formWidth * 0.1,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: formWidth * 0.5,
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: const Text.rich(
//                       TextSpan(children: [
//                         TextSpan(text: 'Amount'),
//                         TextSpan(text: '*', style: TextStyle(color: Colors.red))
//                       ]),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         width: formWidth * 0.5,
//                         height: 40,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.white,
//                           border: Border.all(color: Colors.black26),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           child: TextFormField(
//                             focusNode: amountFocus,
//                             controller: amountController,
//                             decoration: const InputDecoration(
//                                 hintText: 'Enter amount',
//                                 border: InputBorder.none),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 // showError('FirmCode');
//                                 return 'Amount cannot be empty';
//                               }
//                             },
//                             onSaved: (value) {
//                               billDetails['Amount'] = value;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: formWidth * 0.1,
//                       ),
//                       widget.index + 1 == widget.itemCount
//                           ? IconButton(
//                               onPressed: () {
//                                 widget.increaseRowCount(100);
//                               },
//                               icon: const Icon(Icons.add))
//                           : IconButton(
//                               onPressed: () {
//                                 widget.decreaseRowCount(widget.index);
//                               },
//                               icon: const Icon(Icons.remove))
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           width: formWidth * 0.1,
//         ),

//         // Padding(
//         //   padding: EdgeInsets.only(bottom: bottomPadding),
//         //   child:
//         // ),
//       ],
//     );
//   }
// }

class OperationsDropDown extends StatefulWidget {
  OperationsDropDown({Key? key}) : super(key: key);

  @override
  _OperationsDropDownState createState() => _OperationsDropDownState();
}

class _OperationsDropDownState extends State<OperationsDropDown> {
  bool isOpened = false;
  EdgeInsetsGeometry getpadding() {
    return const EdgeInsets.only(left: 55.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.headline6;
    final expansionDataTheme =
        ProjectStyles.invoiceContentStyle().copyWith(color: Colors.white);
    return ExpansionTile(
      onExpansionChanged: (value) {
        setState(() {
          isOpened = value;
        });
      },
      trailing: const SizedBox(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(
          //     width: 18,
          //     height: 20,
          //     child: Icon(
          //       Icons.calendar_today_rounded,
          //       color: Color.fromRGBO(159, 205, 255, 1),
          //     )),
          const SizedBox(
            width: 50,
          ),
          Text(
            'Report',
            style: ProjectStyles.drawerStyle(),
          ),
          const SizedBox(
            width: 10,
          ),
          isOpened == false
              ? const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(159, 205, 255, 1),
                  size: 20,
                )
              : const Icon(
                  Icons.arrow_drop_up,
                  color: Color.fromARGB(255, 234, 237, 241),
                  size: 20,
                ),
        ],
      ),
      children: [
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Stock Report',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.toNamed(DailyReportScreen.routeName);
            },
          ),
        ),
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Cash Book',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.toNamed(CashBookPage.routeName);
            },
          ),
        ),
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Sales Report',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.toNamed(SalesReportScreen.routeName);
            },
          ),
        ),
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Purchase Report',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.toNamed(PurchaseReportScreen.routeName);
            },
          ),
        ),
        // ListTile(
        //   title: const Text('Activity Header'),
        //   onTap: () {
        //     Modular.toNamed.navigate(ActivityHeader.routeName);
        //   },
        // ),

        // ListTile(
        //   title: const Text('Vaccination Header'),
        //   onTap: () {
        //     Modular.toNamed.navigate(VaccinationHeader.routeName);
        //   },
        // ),
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Profit And Loss',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.toNamed(ProfitAndLossPage.routeName);
            },
          ),
        ),
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Balance Sheet',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.toNamed(BalanceSheetScreen.routeName);
            },
          ),
        ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'Activity Log',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.toNamed(ActivityLogsScreen.routeName);
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'Vaccination Log',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.toNamed(VaccinationLogsScreen.routeName);
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'Medication Log',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.toNamed(MedicationLogsScreen.routeName);
        //     },
        //   ),
        // ),
        // ListTile(
        //   title: const Text('Medication Header'),
        //   onTap: () {
        //     Modular.toNamed.navigate(MedicationHeader.routeName);
        //   },
        // ),
      ],
    );
  }
}

class CustomerSearchList extends StatefulWidget {
  CustomerSearchList({Key? key, required this.customer, required this.select})
      : super(key: key);

  final Map<String, dynamic> customer;
  final ValueChanged<Map<String, dynamic>> select;

  @override
  State<CustomerSearchList> createState() => _CustomerSearchListState();
}

class _CustomerSearchListState extends State<CustomerSearchList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('Customer Selected');
        widget.select(widget.customer);
      },
      title: Text(widget.customer['Customer_Name'] ?? ''),
      subtitle: Text(widget.customer['Mobile_Number'] == null
          ? ''
          : widget.customer['Mobile_Number'].toString()),
    );
  }
}

Future<void> exportPdf(List itemList, Map<String, dynamic> invoiceData,
    List oldItems, var grossAmount, var netAmount) async {
  // print('invoice data $invoiceData');
  // print('Item data $itemList');
  // print('Item data $oldItems');
  // Create a new PDF document.
  final PdfDocument document = PdfDocument();
  // Add a new page to the document.
  final PdfPage page = document.pages.add();
  page.graphics.drawString(
      'Prathiba Jewellers', PdfStandardFont(PdfFontFamily.helvetica, 16),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.37, 0, 250, 20));
  page.graphics.drawString(
      'Sales Invoice', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.42,
          page.getClientSize().height * 0.03, 250, 20));
  page.graphics.drawString('Invoice Id: ${invoiceData['Invoice_Code']}',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.05, 250, 20));
  invoiceData['Customer_Id__Customer_Name'] == 'cash'
      ? const SizedBox()
      : page.graphics.drawString(
          'Customer Name: ${invoiceData['Customer_Id__Customer_Name']}',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds:
              Rect.fromLTWH(0, page.getClientSize().height * 0.075, 250, 20));
  page.graphics.drawString(
      'Date of Purchase: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(invoiceData['Created_Date']))}',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.67,
          page.getClientSize().height * 0.05, 250, 20));
  // page.graphics.drawString('Address: ${invoiceData['Customer_Id__Address']}',
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  //     bounds: Rect.fromLTWH(0, page.getClientSize().height * 0.10, 250, 20));
  invoiceData['Customer_Id__Customer_Name'] == 'cash'
      ? const SizedBox()
      : page.graphics.drawString(
          'Mobile Number: ${invoiceData['Customer_Id__Mobile_Number']}',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.67,
              page.getClientSize().height * 0.075, 250, 20));

  page.graphics.drawString(
      'Item Details', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(page.getClientSize().width * 0.42,
          page.getClientSize().height * 0.12, 150, 20));
// Create a PDF grid class to add tables.
  final PdfGrid grid = PdfGrid();
// Specify the grid column count.
  grid.columns.add(count: 4);
// Add a grid header row.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].value = 'Item Type';
  headerRow.cells[1].value = 'Item Name';
  headerRow.cells[2].value = 'Weight (g)';
  headerRow.cells[3].value = 'Amount';
// Set header font.
  headerRow.style.font =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

  for (var data in itemList) {
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = data['Item_Type'];
    row.cells[1].value = data['Item_Name'];
    row.cells[2].value =
        double.parse(data['Weight'].toString()).toStringAsFixed(2);
    row.cells[3].value =
        double.parse(data['Amount'].toString()).toStringAsFixed(2);
  }
  // PdfGridRow row = grid.rows.add();

  // row.cells[1].value = 'Gross Weight';
  // row.cells[2].value = 'data';
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
  PdfLayoutResult result = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0,
          page.getClientSize().height * 0.16,
          page.getClientSize().width,
          page.getClientSize().height)) as PdfLayoutResult;

  // oldItems.isEmpty
  //     ? const SizedBox()
  //     : page.graphics.drawString(
  //         'Gross Amount:', PdfStandardFont(PdfFontFamily.helvetica, 12),
  //         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  //         bounds: Rect.fromLTWH(page.getClientSize().width * 0.48,
  //             result.bounds.bottom + 8, 250, 20));
  oldItems.isEmpty
      ? const SizedBox()
      : page.graphics.drawString(
          grossAmount.toString(), PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.78,
              result.bounds.bottom + 8, 250, 20));

  final PdfGrid oldItemsgrid = PdfGrid();

  if (oldItems.isNotEmpty) {
    page.graphics.drawString(
        'Old Item Details', PdfStandardFont(PdfFontFamily.helvetica, 13),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(page.getClientSize().width * 0.39,
            result.bounds.bottom + 30, 250, 20));
// Specify the grid column count.
    oldItemsgrid.columns.add(count: 3);
// Add a grid header row.
    final PdfGridRow oldItemheaderRow = oldItemsgrid.headers.add(1)[0];
    oldItemheaderRow.cells[0].value = 'Item Name';
    oldItemheaderRow.cells[1].value = 'Weight (g)';
    oldItemheaderRow.cells[2].value = 'Amount';
// Set header font.
    oldItemheaderRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
  }

  for (var data in oldItems) {
    PdfGridRow row = oldItemsgrid.rows.add();
    row.cells[0].value = data['Old_Item_Type'];
    row.cells[1].value =
        double.parse(data['Weight'].toString()).toStringAsFixed(2);
    row.cells[2].value =
        double.parse(data['Amount'].toString()).toStringAsFixed(2);
  }

  oldItemsgrid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
  PdfLayoutResult Oldresult = oldItemsgrid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0,
          result.bounds.bottom + 50,
          page.getClientSize().width,
          page.getClientSize().height)) as PdfLayoutResult;

  invoiceData['Customer_Id__Customer_Name'] == 'cash'
      ? const SizedBox()
      : page.graphics.drawString('Merchant Credit Balance:',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.48,
              Oldresult.bounds.bottom + 8, 250, 20));
  invoiceData['Customer_Id__Customer_Name'] == 'cash'
      ? const SizedBox()
      : page.graphics.drawString(
          double.parse(invoiceData['Merchant_Credit_Balance'])
              .toStringAsFixed(2),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.78,
              Oldresult.bounds.bottom + 8, 250, 20));
  invoiceData['Customer_Id__Customer_Name'] == 'cash'
      ? const SizedBox()
      : page.graphics.drawString('Customer Credit Balance:',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.48,
              Oldresult.bounds.bottom + 23, 250, 20));
  invoiceData['Customer_Id__Customer_Name'] == 'cash'
      ? const SizedBox()
      : page.graphics.drawString(
          double.parse(invoiceData['Customer_Credit_Balance'])
              .toStringAsFixed(2),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.78,
              Oldresult.bounds.bottom + 23, 250, 20));
  page.graphics.drawString(
      'Net Amount:', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(
          page.getClientSize().width * 0.48,
          invoiceData['Customer_Id__Customer_Name'] == 'cash'
              ? Oldresult.bounds.bottom
              : Oldresult.bounds.bottom + 38,
          250,
          20));
  page.graphics.drawString(
      double.parse(netAmount.toString()).toStringAsFixed(2),
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(
          page.getClientSize().width * 0.78,
          invoiceData['Customer_Id__Customer_Name'] == 'cash'
              ? Oldresult.bounds.bottom
              : Oldresult.bounds.bottom + 38,
          250,
          20));
  invoiceData['Cash_Amount'] == '0.000000'
      ? const SizedBox()
      : page.graphics.drawString(
          'Cash Paid:', PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(
              page.getClientSize().width * 0.48,
              invoiceData['Customer_Id__Customer_Name'] == 'cash'
                  ? Oldresult.bounds.bottom + 15
                  : Oldresult.bounds.bottom + 53,
              250,
              20));
  invoiceData['Cash_Amount'] == '0.000000'
      ? const SizedBox()
      : page.graphics.drawString(
          double.parse(invoiceData['Cash_Amount'].toString())
              .toStringAsFixed(2),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(
              page.getClientSize().width * 0.78,
              invoiceData['Customer_Id__Customer_Name'] == 'cash'
                  ? Oldresult.bounds.bottom + 15
                  : Oldresult.bounds.bottom + 53,
              250,
              20));
  invoiceData['Online_Amount'] == '0.000000'
      ? const SizedBox()
      : page.graphics.drawString(
          'Online Paid:', PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(
              page.getClientSize().width * 0.48,
              invoiceData['Customer_Id__Customer_Name'] == 'cash'
                  ? Oldresult.bounds.bottom + 29
                  : Oldresult.bounds.bottom + 66,
              250,
              20));
  invoiceData['Online_Amount'] == '0.000000'
      ? const SizedBox()
      : page.graphics.drawString(
          double.parse(invoiceData['Online_Amount'].toString())
              .toStringAsFixed(2),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(
              page.getClientSize().width * 0.78,
              invoiceData['Customer_Id__Customer_Name'] == 'cash'
                  ? Oldresult.bounds.bottom + 29
                  : Oldresult.bounds.bottom + 66,
              250,
              20));
  invoiceData['Credit_Amount'] == '0.000000'
      ? const SizedBox()
      : page.graphics.drawString(
          'Credit:', PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.48,
              Oldresult.bounds.bottom + 79, 250, 20));
  invoiceData['Credit_Amount'] == '0.000000'
      ? const SizedBox()
      : page.graphics.drawString(
          double.parse(invoiceData['Credit_Amount'].toString())
              .toStringAsFixed(2),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(page.getClientSize().width * 0.78,
              Oldresult.bounds.bottom + 79, 250, 20));
  // page.graphics.drawString(
  //     'Cash paid: ${double.parse(invoiceData['Cash_Amount'].toString()).toStringAsFixed(2)}',
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  //     bounds: Rect.fromLTWH(0, Oldresult.bounds.bottom + 20, 250, 20));
  // page.graphics.drawString(
  //     'Online paid: ${double.parse(invoiceData['Online_Amount'].toString()).toStringAsFixed(2)}',
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  //     bounds: Rect.fromLTWH(0, Oldresult.bounds.bottom + 35, 250, 20));
  // page.graphics.drawString(
  //     'Credit: ${double.parse(invoiceData['Credit_Amount'].toString()).toStringAsFixed(2)}',
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  //     bounds: Rect.fromLTWH(0, Oldresult.bounds.bottom + 50, 250, 20));
// Save the document.
  // var file = Uri.dataFromBytes(
  //   document.save(),
  //   mimeType: "application/pdf",
  // );
  // launchUrl(file, mode: LaunchMode.platformDefault).then((value) {
  //   print(value);
  // });
  Directory? _downloadsDirectory = await getDownloadsDirectory();
  String downloadPath = _downloadsDirectory!.path;
  File('$downloadPath/PDFTable.pdf')
      .writeAsBytes(await document.save())
      .then((value) {
    final fileUriWindows =
        Uri.file('$downloadPath/PDFTable.pdf', windows: true);
    launchUrl(fileUriWindows, mode: LaunchMode.externalApplication)
        .then((value) {
      print(value);
    });
  });
  // pdfController.openDocument(PdfDocument.fromBase64String('assets/sample.pdf'));

// Dispose the document.
  document.dispose();
}

var dat = [
  {
    'Advance_Id': 'if present ok or else null or empty',
    'Date': '',
    'Mode': 'Advance/Purchase/null',
    'Amount': '',
  }
];
