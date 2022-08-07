import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../main.dart';
import '../providers/api_calls.dart';
import '../providers/authenticate.dart';
import '../styles.dart';
import 'add_billing_screen.dart';
import 'purchase_details_page.dart';
import 'purchase_list_screen.dart';
import 'temprory_purchase_list.dart';

class PurchasesScreen extends StatefulWidget {
  PurchasesScreen({Key? key, required this.tempData, required this.editData})
      : super(key: key);

  static const routeName = '/PurchasesScreen';
  final Map<String, dynamic> tempData;
  final Map<String, dynamic> editData;

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  Map<String, dynamic> purchaseDetails = {};

  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> _formStateKey = GlobalKey();

  Map<String, dynamic> purchaseDetailsData = {};
  TextEditingController dateController = TextEditingController();

  var selectedCreditorType;

  TextEditingController nameController = TextEditingController();

  TextEditingController billNumberController = TextEditingController();
  FocusNode exchangeTotalAmountFocus = FocusNode();
  var selectedProductType;

  var selectedPaymentType;

  TextEditingController itemNameExchangeController = TextEditingController();

  TextEditingController grossWeightExchangeController = TextEditingController();

  TextEditingController wastageExchangeController = TextEditingController();

  TextEditingController netWtExchangeController = TextEditingController();

  TextEditingController amountExchangeController = TextEditingController();
  TextEditingController pieceController = TextEditingController();
  double grandTotal = 0;

  List itemList = [];
  int itemCount = 1;
  TextEditingController totalAmountController = TextEditingController();

  bool searchSelected = false;

  var customerId;

  ScrollController listController = ScrollController();

  TextEditingController merchantCreditBalanceController =
      TextEditingController();

  TextEditingController customerCreditBalanceController =
      TextEditingController();

  TextEditingController meltController = TextEditingController();

  TextEditingController totalPercentageController = TextEditingController();

  TextEditingController meltExchangeController = TextEditingController();

  TextEditingController exchangeTotalPercentageController =
      TextEditingController();

  FocusNode itemNameFocus = FocusNode();
  FocusNode grossWeightFocus = FocusNode();
  FocusNode meltFocus = FocusNode();
  FocusNode wastageFocus = FocusNode();
  FocusNode totalPercentageFocus = FocusNode();
  FocusNode netWtFocus = FocusNode();
  FocusNode rateFocus = FocusNode();
  FocusNode piecesFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode exchangeItemNameFocus = FocusNode();
  FocusNode exchangeGrossWeightFocus = FocusNode();
  FocusNode exchangeMeltWeightFocus = FocusNode();
  FocusNode exchangeWastageFocus = FocusNode();
  FocusNode exchangeTotalPercentageFocus = FocusNode();
  FocusNode exchangeNetweightFocus = FocusNode();

  TextEditingController totalWeightController = TextEditingController();

  TextEditingController customerSilverStockController = TextEditingController();

  TextEditingController customerGoldStockController = TextEditingController();

  var purchaseId;

  var purchaseItemId;

  List tempItemIdList = [];
  double totalAmount = 0;

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

  var latestPurchaseId;

  var exchangeItemId;

  TextEditingController merchantCashBalanceController = TextEditingController();

  var merchantNewBalance;

  var customerNewGoldStock;

  var customerNewSilverStock;

  List removedItems = [];

  TextEditingController productTypeController = TextEditingController();

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

  void _onAmountFocusChange() {
    double netAmount = double.parse(
        amountController.text == '' ? '0' : amountController.text.toString());
    if (amountFocus.hasFocus == false) {
      if (totalAmount == 0) {
        // double amount = double.parse(totalWeightController.text) - netWeight;

        if (selectedProductType == 'Gold_Bullion' &&
            customerCreditBalanceController.text == '0.00' &&
            merchantCreditBalanceController.text == '0.00' &&
            customerGoldStockController.text == '0.00' &&
            merchantCashBalanceController.text == '0.00') {
          totalAmountController.text = netAmount.toStringAsFixed(2);
        } else if (selectedProductType == 'Silver_Bullion' &&
            customerCreditBalanceController.text == '0.00' &&
            merchantCreditBalanceController.text == '0.00' &&
            customerSilverStockController.text == '0.00' &&
            merchantCashBalanceController.text == '0.00') {
          totalAmountController.text = netAmount.toStringAsFixed(2);
        } else {
          double amount = (double.parse(totalWeightController.text) *
                  double.parse(rateController.text == ''
                      ? '0'
                      : rateController.text.isAlphabetOnly
                          ? '0'
                          : rateController.text))
              .abs()
              .toPrecision(2);

          if (merchantCashBalanceController.text != '0.00') {
            print('inside merchant casj');
            print(amount);

            if (amount < double.parse(merchantCashBalanceController.text)) {
              totalAmountController.text = '0.00';
              amount =
                  double.parse(merchantCashBalanceController.text) - amount;
              merchantNewBalance = amount;
              return;
            } else {
              amount =
                  amount - double.parse(merchantCashBalanceController.text);
              merchantNewBalance = 0;
            }
          }

          if (customerCreditBalanceController.text != '0.00') {
            print('customer credit');
            if (amount > double.parse(customerCreditBalanceController.text)) {
              amount =
                  amount - double.parse(customerCreditBalanceController.text);
            } else {
              amount = 0.0;
            }
          }

          if (merchantCreditBalanceController.text != '0.00') {
            print('inside merchant credit');
            amount = amount + double.parse(totalAmountController.text);
          }

          totalAmountController.text = amount.abs().toStringAsFixed(2);

          // totalAmountController.text = (double.parse(
          //             totalAmountController.text == ''
          //                 ? '0'
          //                 : totalAmountController.text) +
          //         netAmount)
          //     .toString();
        }

        totalAmount = netAmount;
        print('Total Amount ${totalAmountController.text}');
      } else {
        if (totalAmount == netAmount) {
          print('Total amount when equal ${totalAmountController.text}');
        } else if (totalAmount < netAmount) {
          double data = netAmount - totalAmount;
          double amount = double.parse(totalAmountController.text) + data;

          totalAmountController.text = amount.toString();
          totalAmount = netAmount;
          print('Total amount after addition ${totalAmountController.text}');
        } else if (totalAmount > netAmount) {
          double data = totalAmount - netAmount;
          double amount = double.parse(totalAmountController.text) - data;

          totalAmountController.text = amount.toString();
          totalAmount = netAmount;
          print(
              'Total amount after substraction ${totalAmountController.text}');
        }
      }
    }
  }

  Future<void> getDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print(appDocDir);
  }

  @override
  void initState() {
    totalAmountController.text = '0';
    amountController.text = '0';
    totalWeightController.text = '0';
    customerGoldStockController.text = '0.00';
    customerSilverStockController.text = '0.00';
    getDirectory();
    exchangeTotalAmountFocus.addListener(_onExchangeTotalAmountFocusChange);
    amountFocus.addListener(_onAmountFocusChange);
    exchangeNetweightFocus.addListener(_onExchangeNetWeightFocusChange);
    netWtFocus.addListener(_onNetWeightFocusChange);
    if (widget.tempData.isNotEmpty) {
      purchaseId = widget.tempData['Purchase_Details']['Temp_Purchase_Id'];
      billNumberController.text =
          widget.tempData['Purchase_Details']['Bill_Number'];
      selectedProductType = widget.tempData['Purchase_Details']['Product_Type'];
      dateController.text = DateFormat('dd-MM-yyyy').format(
          DateTime.parse(widget.tempData['Purchase_Details']['Created_Date']));
      purchaseDetailsData['Created_Date'] = DateFormat("yyyy-MM-dd").format(
          DateTime.parse(widget.tempData['Purchase_Details']['Created_Date']));
      searchCustomerWithId(widget.tempData['Purchase_Details']['Customer_Id'])
          .then((value) {
        totalWeightController.text =
            widget.tempData['Purchase_Details']['Net_Metal_Weight'];
        switch (widget.tempData['Purchase_Details']['Product_Type']) {
          case 'Gold_Bullion':
            selectedProductType = 'Gold_Bullion';
            purchaseDetailsData['Product_Type'] = 'Gold_Bullion';
            itemNameController.text = 'Gold_Bullion';
            itemNameExchangeController.text = 'Old_Gold';
            purchaseItemId =
                widget.tempData['Item_Details'][0]['Purchase_Item_Id'];
            itemNameController.text =
                widget.tempData['Item_Details'][0]['Item_Name'];
            grossWeightController.text =
                widget.tempData['Item_Details'][0]['Gross_Weight'].toString();
            meltController.text =
                widget.tempData['Item_Details'][0]['Melt'].toString();
            wastageController.text =
                widget.tempData['Item_Details'][0]['Wastage'].toString();
            totalPercentageController.text = widget.tempData['Item_Details'][0]
                ['Total_Percentage']
              ..toString();
            netWtController.text =
                widget.tempData['Item_Details'][0]['Net_Weight'].toString();
            pieceController.text =
                widget.tempData['Item_Details'][0]['Pcs'].toString();

            break;
          case 'Silver_Bullion':
            selectedProductType = 'Silver_Bullion';
            purchaseDetailsData['Product_Type'] = 'Silver_Bullion';
            itemNameController.text = 'Silver_Bullion';
            itemNameExchangeController.text = 'Old_Silver';
            purchaseItemId =
                widget.tempData['Item_Details'][0]['Purchase_Item_Id'];
            itemNameController.text =
                widget.tempData['Item_Details'][0]['Item_Name'];
            grossWeightController.text =
                widget.tempData['Item_Details'][0]['Gross_Weight'].toString();
            meltController.text =
                widget.tempData['Item_Details'][0]['Melt'].toString();
            wastageController.text =
                widget.tempData['Item_Details'][0]['Wastage'].toString();
            totalPercentageController.text = widget.tempData['Item_Details'][0]
                ['Total_Percentage']
              ..toString();
            netWtController.text =
                widget.tempData['Item_Details'][0]['Net_Weight'].toString();
            pieceController.text =
                widget.tempData['Item_Details'][0]['Pcs'].toString();
            break;
          case 'Gold_Ornament':
            selectedProductType = 'Gold_Ornament';
            purchaseDetailsData['Product_Type'] = 'Gold_Ornament';
            itemNameExchangeController.text = 'Gold_Bullion';
            itemCount = widget.tempData['Item_Details'].length;
            for (int i = 0; i < widget.tempData['Item_Details'].length; i++) {
              tempItemIdList
                  .add(widget.tempData['Item_Details'][i]['Purchase_Item_Id']);
              itemList.add({
                'Index': i,
                'Key': 'Item_Name',
                'Value': widget.tempData['Item_Details'][i]['Item_Name']
              });
              itemList.add({
                'Index': i,
                'Key': 'Gross_Weight',
                'Value': widget.tempData['Item_Details'][i]['Gross_Weight']
              });
              itemList.add({
                'Index': i,
                'Key': 'Wastage',
                'Value': widget.tempData['Item_Details'][i]['Wastage']
              });
              itemList.add({
                'Index': i,
                'Key': 'Net_Weight',
                'Value': widget.tempData['Item_Details'][i]['Net_Weight']
              });
              itemList.add({
                'Index': i,
                'Key': 'Melt',
                'Value': widget.tempData['Item_Details'][i]['Melt']
              });
              itemList.add({
                'Index': i,
                'Key': 'Percentage',
                'Value': widget.tempData['Item_Details'][i]['Total_Percentage']
              });
              itemList.add({
                'Index': i,
                'Key': 'Pieces',
                'Value': widget.tempData['Item_Details'][i]['Pcs']
              });
            }
            break;
          case 'Silver_Ornament':
            selectedProductType = 'Silver_Ornament';
            purchaseDetailsData['Product_Type'] = 'Silver_Ornament';
            itemNameExchangeController.text = 'Old_Silver';
            for (int i = 0; i < widget.tempData['Item_Details'].length; i++) {
              itemList.add({
                'Index': i,
                'Key': 'Item_Name',
                'Value': widget.tempData['Item_Details'][i]['Item_Name']
              });
              itemList.add({
                'Index': i,
                'Key': 'Gross_Weight',
                'Value': widget.tempData['Item_Details'][i]['Gross_Weight']
              });
              itemList.add({
                'Index': i,
                'Key': 'Wastage',
                'Value': widget.tempData['Item_Details'][i]['Wastage']
              });
              itemList.add({
                'Index': i,
                'Key': 'Net_Weight',
                'Value': widget.tempData['Item_Details'][i]['Net_Weight']
              });
              itemList.add({
                'Index': i,
                'Key': 'Melt',
                'Value': widget.tempData['Item_Details'][i]['Melt']
              });
              itemList.add({
                'Index': i,
                'Key': 'Percentage',
                'Value': widget.tempData['Item_Details'][i]['Total_Percentage']
              });
              itemList.add({
                'Index': i,
                'Key': 'Pieces',
                'Value': widget.tempData['Item_Details'][i]['Pcs']
              });
            }
            break;
          default:
        }
      });

      setState(() {});
    } else if (widget.editData.isNotEmpty) {
      // dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      // purchaseDetailsData['Created_Date'] =
      //     DateFormat("yyyy-MM-dd").format(DateTime.now());
      // Provider.of<Authenticate>(context, listen: false)
      //     .tryAutoLogin()
      //     .then((value) {
      //   var token = Provider.of<Authenticate>(context, listen: false).token;
      //   Provider.of<ApiCalls>(context, listen: false)
      //       .getPurchaseInvoiceId(token)
      //       .then((value) {
      //     if (value != 0) {
      //       latestPurchaseId = value;
      //       billNumberController.text = 'P$value';
      //     }
      //   });
      // });
      purchaseDetailsData['Payment_Type'] =
          widget.editData['Purchase_Details']['Payment_Type'];
      purchaseId = widget.editData['Purchase_Details']['Purchase_Id'];
      customerId = widget.editData['Purchase_Details']['Customer_Id'];
      billNumberController.text =
          widget.editData['Purchase_Details']['Bill_Number'];
      selectedProductType = widget.editData['Purchase_Details']['Product_Type'];
      selectedPaymentType = widget.editData['Purchase_Details']
                  ['Payment_Type'] ==
              'No_Payment_Type'
          ? null
          : widget.editData['Purchase_Details']['Payment_Type'];
      dateController.text = DateFormat('dd-MM-yyyy').format(
          DateTime.parse(widget.editData['Purchase_Details']['Created_Date']));
      purchaseDetailsData['Created_Date'] = DateFormat("yyyy-MM-dd").format(
          DateTime.parse(widget.editData['Purchase_Details']['Created_Date']));
      totalWeightController.text =
          widget.editData['Purchase_Details']['Net_Metal_Weight'];
      totalAmountController.text =
          widget.editData['Purchase_Details']['Total_Amount'];
      nameController.text =
          widget.editData['Purchase_Details']['Creditor_Name'];
      customerCreditBalanceController.text = double.parse(
              widget.editData['Purchase_Details']['Customer_Credit_Balance'])
          .toStringAsFixed(2);
      merchantCashBalanceController.text = double.parse(
              widget.editData['Purchase_Details']['Merchant_Old_Cash_Balance'])
          .toStringAsFixed(2);
      merchantCreditBalanceController.text = double.parse(
              widget.editData['Purchase_Details']['Merchant_Credit_Balance'])
          .toStringAsFixed(2);
      customerGoldStockController.text = double.parse(
              widget.editData['Purchase_Details']['Customer_Old_Gold_Stock'])
          .toStringAsFixed(2);
      customerSilverStockController.text = double.parse(
              widget.editData['Purchase_Details']['Customer_Old_Silver_Stock'])
          .toStringAsFixed(2);
      switch (widget.editData['Purchase_Details']['Product_Type']) {
        case 'Gold_Bullion':
          selectedProductType = 'Gold_Bullion';
          purchaseDetailsData['Product_Type'] = 'Gold_Bullion';
          itemNameController.text = 'Gold_Bullion';
          itemNameExchangeController.text = 'Old_Gold';
          purchaseItemId =
              widget.editData['Item_Details'][0]['Purchase_Item_Id'];
          itemNameController.text =
              widget.editData['Item_Details'][0]['Item_Name'];
          grossWeightController.text =
              widget.editData['Item_Details'][0]['Gross_Weight'].toString();
          meltController.text =
              widget.editData['Item_Details'][0]['Melt'].toString();
          wastageController.text =
              widget.editData['Item_Details'][0]['Wastage'].toString();
          totalPercentageController.text = widget.editData['Item_Details'][0]
              ['Total_Percentage']
            ..toString();
          netWtController.text =
              widget.editData['Item_Details'][0]['Net_Weight'].toString();
          pieceController.text =
              widget.editData['Item_Details'][0]['Pcs'].toString();
          rateController.text = widget.editData['Item_Details'][0]['Rate'];
          amountController.text = widget.editData['Item_Details'][0]['Amount'];

          break;
        case 'Silver_Bullion':
          selectedProductType = 'Silver_Bullion';
          purchaseDetailsData['Product_Type'] = 'Silver_Bullion';
          itemNameController.text = 'Silver_Bullion';
          itemNameExchangeController.text = 'Old_Silver';
          purchaseItemId =
              widget.editData['Item_Details'][0]['Purchase_Item_Id'];
          itemNameController.text =
              widget.editData['Item_Details'][0]['Item_Name'];
          grossWeightController.text =
              widget.editData['Item_Details'][0]['Gross_Weight'].toString();
          meltController.text =
              widget.editData['Item_Details'][0]['Melt'].toString();
          wastageController.text =
              widget.editData['Item_Details'][0]['Wastage'].toString();
          totalPercentageController.text = widget.editData['Item_Details'][0]
              ['Total_Percentage']
            ..toString();
          netWtController.text =
              widget.editData['Item_Details'][0]['Net_Weight'].toString();
          pieceController.text =
              widget.editData['Item_Details'][0]['Pcs'].toString();
          rateController.text = widget.editData['Item_Details'][0]['Rate'];
          amountController.text = widget.editData['Item_Details'][0]['Amount'];

          break;
        case 'Gold_Ornament':
          selectedProductType = 'Gold_Ornament';
          purchaseDetailsData['Product_Type'] = 'Gold_Ornament';
          itemNameExchangeController.text = 'Gold_Bullion';
          itemCount = widget.editData['Item_Details'].length;
          for (int i = 0; i < widget.editData['Item_Details'].length; i++) {
            tempItemIdList
                .add(widget.editData['Item_Details'][i]['Purchase_Item_Id']);
            itemList.add({
              'Index': i,
              'Key': 'Item_Name',
              'Value': widget.editData['Item_Details'][i]['Item_Name']
            });
            itemList.add({
              'Index': i,
              'Key': 'Gross_Weight',
              'Value': widget.editData['Item_Details'][i]['Gross_Weight']
            });
            itemList.add({
              'Index': i,
              'Key': 'Wastage',
              'Value': widget.editData['Item_Details'][i]['Wastage']
            });
            itemList.add({
              'Index': i,
              'Key': 'Net_Weight',
              'Value': widget.editData['Item_Details'][i]['Net_Weight']
            });
            itemList.add({
              'Index': i,
              'Key': 'Melt',
              'Value': widget.editData['Item_Details'][i]['Melt']
            });
            itemList.add({
              'Index': i,
              'Key': 'Percentage',
              'Value': widget.editData['Item_Details'][i]['Total_Percentage']
            });
            itemList.add({
              'Index': i,
              'Key': 'Pieces',
              'Value': widget.editData['Item_Details'][i]['Pcs']
            });
            itemList.add({
              'Index': i,
              'Key': 'Total_Amount',
              'Value': widget.editData['Item_Details'][i]['Amount']
            });
            itemList.add({
              'Index': i,
              'Key': 'Rate',
              'Value': widget.editData['Item_Details'][i]['Rate']
            });
          }
          break;
        case 'Silver_Ornament':
          selectedProductType = 'Silver_Ornament';
          purchaseDetailsData['Product_Type'] = 'Silver_Ornament';
          itemNameExchangeController.text = 'Old_Silver';
          itemCount = widget.editData['Item_Details'].length;

          for (int i = 0; i < widget.editData['Item_Details'].length; i++) {
            tempItemIdList
                .add(widget.editData['Item_Details'][i]['Purchase_Item_Id']);

            itemList.add({
              'Index': i,
              'Key': 'Item_Name',
              'Value': widget.editData['Item_Details'][i]['Item_Name']
            });
            itemList.add({
              'Index': i,
              'Key': 'Gross_Weight',
              'Value': widget.editData['Item_Details'][i]['Gross_Weight']
            });
            itemList.add({
              'Index': i,
              'Key': 'Wastage',
              'Value': widget.editData['Item_Details'][i]['Wastage']
            });
            itemList.add({
              'Index': i,
              'Key': 'Net_Weight',
              'Value': widget.editData['Item_Details'][i]['Net_Weight']
            });
            itemList.add({
              'Index': i,
              'Key': 'Melt',
              'Value': widget.editData['Item_Details'][i]['Melt']
            });
            itemList.add({
              'Index': i,
              'Key': 'Percentage',
              'Value': widget.editData['Item_Details'][i]['Total_Percentage']
            });
            itemList.add({
              'Index': i,
              'Key': 'Pieces',
              'Value': widget.editData['Item_Details'][i]['Pcs']
            });
            itemList.add({
              'Index': i,
              'Key': 'Total_Amount',
              'Value': widget.editData['Item_Details'][i]['Amount']
            });
            itemList.add({
              'Index': i,
              'Key': 'Rate',
              'Value': widget.editData['Item_Details'][i]['Rate']
            });
          }
          break;
        default:
      }

      if (widget.editData['Exchange_Details'].isNotEmpty) {
        exchangeItemId =
            widget.editData['Exchange_Details'][0]['Purchase_Item_Id'] ?? '';
        itemNameExchangeController.text =
            widget.editData['Exchange_Details'][0]['Exchange_Item'] ?? '';
        grossWeightExchangeController.text =
            widget.editData['Exchange_Details'][0]['Gross_Weight'] ?? '';
        wastageExchangeController.text =
            widget.editData['Exchange_Details'][0]['Wastage'] ?? '';
        netWtExchangeController.text =
            widget.editData['Exchange_Details'][0]['Net_Weight'] ?? '';
        amountExchangeController.text =
            widget.editData['Exchange_Details'][0]['Amount'] ?? '';
      }
      setState(() {});
    } else {
      dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      purchaseDetailsData['Created_Date'] =
          DateFormat("yyyy-MM-dd").format(DateTime.now());
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .getPurchaseInvoiceId(token)
            .then((value) {
          if (value != 0) {
            latestPurchaseId = value;
            billNumberController.text = 'P$value';
          }
        });
      });
    }

    super.initState();
  }

  void getNewBillNumber() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .getPurchaseInvoiceId(token)
          .then((value) {
        if (value != 0) {
          latestPurchaseId = value;
          billNumberController.text = 'P$value';
        }
      });
    });
  }

  @override
  void dispose() {
    exchangeTotalAmountFocus.removeListener(_onExchangeTotalAmountFocusChange);
    exchangeTotalAmountFocus.dispose();
    amountFocus.removeListener(_onAmountFocusChange);
    amountFocus.dispose();
    itemNameFocus.dispose();
    grossWeightFocus.dispose();
    meltFocus.dispose();
    wastageFocus.dispose();
    totalPercentageFocus.dispose();
    rateFocus.dispose();
    piecesFocus.dispose();
    exchangeItemNameFocus.dispose();
    exchangeGrossWeightFocus.dispose();
    exchangeMeltWeightFocus.dispose();
    exchangeWastageFocus.dispose();
    exchangeTotalPercentageFocus.dispose();
    exchangeNetweightFocus.removeListener(_onExchangeNetWeightFocusChange);
    exchangeNetweightFocus.dispose();
    netWtFocus.removeListener(_onNetWeightFocusChange);
    netWtFocus.dispose();

    super.dispose();
  }

  double oldWeight = 0;
  void _onExchangeNetWeightFocusChange() {
    double exchangeNetWeight = double.parse(netWtExchangeController.text == ''
        ? '0'
        : netWtExchangeController.text.toString());
    if (exchangeNetweightFocus.hasFocus == false) {
      if (oldWeight == 0) {
        double amount =
            double.parse(totalWeightController.text).abs() - exchangeNetWeight;
        totalWeightController.text = amount.abs().toString();
        oldWeight = exchangeNetWeight;
        print('Total weight ${totalWeightController.text}');
      } else {
        if (oldWeight == exchangeNetWeight) {
          print('Total weight when equal ${totalWeightController.text}');
        } else if (oldWeight < exchangeNetWeight) {
          double data = exchangeNetWeight - oldWeight;
          double amount = double.parse(totalWeightController.text).abs() - data;

          totalWeightController.text = amount.abs().toString();
          oldWeight = exchangeNetWeight;
          print('Total weight after sub ${totalWeightController.text}');
        } else if (oldWeight > exchangeNetWeight) {
          double data = oldWeight - exchangeNetWeight;
          double amount = double.parse(totalWeightController.text).abs() + data;

          totalWeightController.text = amount.abs().toString();
          oldWeight = exchangeNetWeight;
          print('Total weight after addition ${totalWeightController.text}');
        }
      }
    }
  }

  double totalNetWeight = 0;
  void _onNetWeightFocusChange() {
    double netWeight = double.parse(
        netWtController.text == '' ? '0' : netWtController.text.toString());
    if (netWtFocus.hasFocus == false) {
      if (totalNetWeight == 0) {
        // double amount = double.parse(totalWeightController.text) - netWeight;
        totalWeightController.text = netWeight.toString();
        totalNetWeight = netWeight;
        print('Total weight ${totalWeightController.text}');
      } else {
        if (totalNetWeight == netWeight) {
          print('Total weight when equal ${totalWeightController.text}');
        } else if (totalNetWeight < netWeight) {
          double data = netWeight - totalNetWeight;
          double amount = double.parse(totalWeightController.text) + data;

          totalWeightController.text = amount.toString();
          totalNetWeight = netWeight;
          print('Total weight after addition ${totalWeightController.text}');
        } else if (totalNetWeight > netWeight) {
          double data = totalNetWeight - netWeight;
          double amount = double.parse(totalWeightController.text) - data;

          totalWeightController.text = amount.toString();
          totalNetWeight = netWeight;
          print('Total weight after sub ${totalWeightController.text}');
        }
      }
    }
  }

  double oldAmount = 0;

  void _onExchangeTotalAmountFocusChange() {
    double exchangeAmount = double.parse(amountExchangeController.text == ''
        ? '0'
        : amountExchangeController.text.toString());
    if (exchangeTotalAmountFocus.hasFocus == false) {
      if (oldAmount == 0) {
        double amount =
            double.parse(totalAmountController.text) - exchangeAmount;
        totalAmountController.text = amount.toString();
        oldAmount = exchangeAmount;
        print('Total amount ${totalAmountController.text}');
      } else {
        if (oldAmount == exchangeAmount) {
          print('Total amount when equal ${totalAmountController.text}');
        } else if (oldAmount < exchangeAmount) {
          double data = exchangeAmount - oldAmount;
          double amount = double.parse(totalAmountController.text) - data;

          totalAmountController.text = amount.toString();
          oldAmount = exchangeAmount;
          print('Total amount after sub ${totalAmountController.text}');
        } else if (oldAmount > exchangeAmount) {
          double data = oldAmount - exchangeAmount;
          double amount = double.parse(totalAmountController.text) + data;

          totalAmountController.text = amount.toString();
          oldAmount = exchangeAmount;
          print('Total amount after addition ${totalAmountController.text}');
        }
      }
    }
  }

  var token;
  Future<void> getToken() async {
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      token = Provider.of<Authenticate>(context, listen: false).token;
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
        // if (value == 204 || value == 202) {
        //   successSnackbar('Successfully deleted the data');
        // } else {
        //   failureSnackbar('Something went wrong unable to delete the data');
        // }
      });
    });
  }

  void save() {
    bool validateData = validate();

    if (validateData != true) {
      return;
    }
    _formStateKey.currentState!.save();
    purchaseDetailsData['Total_Amount'] = totalAmountController.text;
    List temp = [];
    if (selectedProductType == 'Gold_Bullion' ||
        selectedProductType == 'Silver_Bullion') {
      purchaseDetailsData['Item_Details'] = [
        {
          'Purchase_Item_Id': purchaseItemId,
          'Item_Name': itemNameController.text,
          'Gross_Weight': grossWeightController.text,
          'Melt': meltController.text,
          'Wastage': wastageController.text,
          'Total_Percentage': totalPercentageController.text,
          'Net_Weight': netWtController.text,
          'Rate': rateController.text == ''
              ? null
              : double.parse(rateController.text).toStringAsFixed(2),
          'Pcs': pieceController.text,
          'Amount': amountController.text,
        }
      ];
    } else {
      var itemName;
      var grossWt;
      var wastage;
      var netWt;
      var itemQty;
      var rate;
      var totalAmount;
      var Melt;
      var percentage;
      var pcs;

      for (int i = 0; i < itemCount; i++) {
        List group = [];
        for (int j = 0; j < itemList.length; j++) {
          if (itemList[j]['Index'] == i) {
            group.add(itemList[j]);
          }
        }

        for (var data in group) {
          if (data['Key'] == 'Item_Name') {
            itemName = data['Value'];
          } else if (data['Key'] == 'Gross_Weight') {
            grossWt = data['Value'];
          } else if (data['Key'] == 'Wastage') {
            wastage = data['Value'];
          } else if (data['Key'] == 'Net_Weight') {
            netWt = data['Value'];
          } else if (data['Key'] == 'Rate') {
            rate = data['Value'];
          } else if (data['Key'] == 'Total_Amount') {
            totalAmount = data['Value'];
          } else if (data['Key'] == 'Melt') {
            Melt = data['Value'];
          } else if (data['Key'] == 'Percentage') {
            percentage = data['Value'];
          } else if (data['Key'] == 'Pieces') {
            pcs = data['Value'];
          }
        }
        temp.add({
          'Purchase_Item_Id': tempItemIdList.isEmpty ? '' : tempItemIdList[i],
          'Item_Name': itemName,
          'Gross_Weight': grossWt,
          'Melt': Melt,
          'Wastage': wastage,
          'Total_Percentage': percentage,
          'Net_Weight': netWt,
          'Rate': rate == null || rate == '' || rate.toString().isAlphabetOnly
              ? null
              : double.parse(rate.toString()).toStringAsFixed(2),
          'Pcs': pcs,
          'Amount': totalAmount,
        });
      }
      purchaseDetailsData['Item_Details'] = temp;
      print(temp);
    }

    List errorList = [];

    for (var data in temp) {
      if (data['Item_Name'] == '') {
        errorList.add('Item Name cannot be empty');
      }
      if (data['Gross_Weight'].toString().isNum != true) {
        errorList.add('Enter a valid gross weight');
      }
      if (data['Melt'].toString().isNum != true) {
        errorList.add('Enter a valid Melt');
      }
      if (data['Wastage'].toString().isNum != true) {
        errorList.add('Enter a valid Wastage');
      }
      if (data['Total_Percentage'].toString().isNum != true) {
        errorList.add('Enter a valid Percentage');
      }
      if (data['Net_Weight'].toString().isNum != true) {
        errorList.add('Enter a valid Net weight');
      }
      if (data['Rate'] != null) {
        if (data['Rate'].toString().isNum != true) {
          errorList.add('Enter a valid Rate');
        }
      }
      if (data['Amount'] != null) {
        if (selectedPaymentType != null) {
          if (data['Amount'].toString().isNum != true) {
            errorList.add('Enter a valid Amount');
          }
        }
      }
    }

    if (errorList.isNotEmpty) {
      validateDialog(errorList);
      return;
    }

    if (selectedPaymentType == 'Exchange' ||
        selectedPaymentType == 'Cash_Plus_Exchange' ||
        selectedPaymentType == 'Credit_Plus_Exchange') {
      purchaseDetailsData['Exchange_Details'] = [
        {
          'Purchase_Item_Id': exchangeItemId,
          'Exchange_Item': itemNameExchangeController.text,
          'Gross_Weight': grossWeightExchangeController.text,
          'Percentage': wastageExchangeController.text,
          'Net_Weight': netWtExchangeController.text,
          'Amount': amountExchangeController.text,
          'Purchase_Id': purchaseId,
        }
      ];
    } else {
      purchaseDetailsData['Exchange_Details'] = [];
    }
    purchaseDetailsData['Customer_Credit_Balance'] =
        customerCreditBalanceController.text;
    purchaseDetailsData['Merchant_Credit_Balance'] =
        merchantCreditBalanceController.text;

    purchaseDetailsData['Customer_Id'] = customerId;

    if (customerCreditBalanceController.text != '0.00') {
      double total = 0;

      if (selectedProductType == 'Gold_Bullion' ||
          selectedProductType == 'Silver_Bullion') {
        double amount = amountController.text == ''
            ? 0
            : amountController.text.isAlphabetOnly
                ? 0
                : double.parse(amountController.text).toPrecision(2);
        if (amount >= double.parse(customerCreditBalanceController.text)) {
          purchaseDetailsData['New_Receivable'] = 0;
        } else {
          double newReceivable =
              double.parse(customerCreditBalanceController.text) - amount;
          purchaseDetailsData['New_Receivable'] = newReceivable;
        }
      } else {
        for (var data in temp) {
          total = total +
              double.parse(data['Amount'] == '' || data['Amount'] == null
                  ? '0'
                  : data['Amount']);
        }
        if (total >= double.parse(customerCreditBalanceController.text)) {
          purchaseDetailsData['New_Receivable'] = 0;
        } else {
          double newReceivable =
              double.parse(customerCreditBalanceController.text) - total;
          purchaseDetailsData['New_Receivable'] = newReceivable;
        }
      }
    } else {
      purchaseDetailsData['New_Receivable'] = 0;
    }

    if (selectedPaymentType == 'Exchange' &&
            selectedProductType == 'Gold_Ornament' ||
        selectedPaymentType == 'Exchange' &&
            selectedProductType == 'Gold_Bullion') {
      purchaseDetailsData['Customer_Gold_Stock'] =
          double.parse(totalWeightController.text).abs().toStringAsFixed(2);
      purchaseDetailsData['Customer_Old_Gold_Stock'] =
          customerGoldStockController.text;
      purchaseDetailsData['Customer_Old_Silver_Stock'] =
          customerSilverStockController.text;
      print(
          'customer Gold Stock ${purchaseDetailsData['Customer_Gold_Stock']}');
    } else if (selectedPaymentType == 'Exchange' &&
            selectedProductType == 'Silver_Ornament' ||
        selectedPaymentType == 'Exchange' &&
            selectedProductType == 'Silver_Bullion') {
      purchaseDetailsData['Customer_Silver_Stock'] =
          double.parse(totalWeightController.text).abs().toStringAsFixed(2);
      purchaseDetailsData['Customer_Old_Gold_Stock'] =
          customerGoldStockController.text;
      purchaseDetailsData['Customer_Old_Silver_Stock'] =
          customerSilverStockController.text;
      print(purchaseDetailsData['Customer_Silver_Stock']);
    } else {
      purchaseDetailsData['Customer_Gold_Stock'] =
          customerGoldStockController.text;
      purchaseDetailsData['Customer_Silver_Stock'] =
          customerSilverStockController.text;

      purchaseDetailsData['Customer_Old_Gold_Stock'] =
          customerGoldStockController.text;
      purchaseDetailsData['Customer_Old_Silver_Stock'] =
          customerSilverStockController.text;
    }

    purchaseDetailsData['Net_Metal_Weight'] =
        double.parse(totalWeightController.text).toStringAsFixed(2);
    purchaseDetailsData['Purchase_Id'] = purchaseId;
    purchaseDetailsData['Merchant_Cash_Stock'] =
        merchantCashBalanceController.text;
    purchaseDetailsData['Merchant_New_Cash_Balance'] = merchantNewBalance;
    purchaseDetailsData['Customer_New_Gold_Stock'] = customerNewGoldStock;
    purchaseDetailsData['Customer_New_Silver_Stock'] = customerNewSilverStock;
    purchaseDetailsData['Merchant_Old_Cash_Balance'] =
        merchantCashBalanceController.text;
    if (totalAmountController.text == '0.00') {
      purchaseDetailsData['Payment_Type'] = 'No_Payment_Type';
    }

    purchaseDetailsData['Removed_Items'] = removedItems;
    print(purchaseDetailsData);
    EasyLoading.show();
    if (selectedPaymentType == null &&
            purchaseDetailsData['Item_Details'][0]['Amount'] == '' ||
        selectedPaymentType == null &&
            purchaseDetailsData['Item_Details'][0]['Amount'] == '0') {
      if (widget.tempData.isEmpty) {
        print('Entering temp send');
        getToken().then((value) {
          Provider.of<ApiCalls>(context, listen: false)
              .sendPurchaseTemproryInvoice(purchaseDetailsData, token)
              .then((value) {
            EasyLoading.dismiss();
            if (value == 200 || value == 201) {
              successSnackbar('Successfully saved to rate cut table');
              itemList.clear();
              selectedProductType = null;
              selectedPaymentType = null;
              totalAmountController.text = '0';
              totalWeightController.text = '0';
              oldAmount = 0;
              amountExchangeController.text = '0';
              amountController.text = '0';
              netWtController.text = '0';
              rateController.text = '0';
              nameController.text = '';
              pureNetWt = 0;
              setState(() {});
              getNewBillNumber();
            } else {
              failureSnackbar('Something went wrong unable to add data');
            }
          });
        });
      } else {
        print('Updating $purchaseId');
        getToken().then((value) {
          Provider.of<ApiCalls>(context, listen: false)
              .updatePurchaseTemproryInvoice(
                  purchaseId, purchaseDetailsData, token)
              .then((value) {
            EasyLoading.dismiss();

            if (value == 200 || value == 202) {
              successSnackbar('Successfully updated to rate cut table');
              itemList.clear();
              selectedProductType = null;
              selectedPaymentType = null;
              totalAmountController.text = '0';
              totalWeightController.text = '0';
              oldAmount = 0;
              amountExchangeController.text = '0';
              amountController.text = '0';
              netWtController.text = '0';
              rateController.text = '0';
              pureNetWt = 0;
              nameController.text = '';

              setState(() {});
              getNewBillNumber();
            } else {
              failureSnackbar('Something went wrong unable to update the data');
            }
          });
        });
      }
    } else if (widget.editData.isNotEmpty) {
      print(purchaseDetailsData);
      print('updating purchase details');
      purchaseDetailsData['Purchase_Id'] = purchaseId;
      getToken().then((value) {
        Provider.of<ApiCalls>(context, listen: false)
            .updatePurchaseInvoice(purchaseId, purchaseDetailsData, token)
            .then((value) {
          EasyLoading.dismiss();

          if (value['Status_Code'] == 201 || value['Status_Code'] == 202) {
            // purchaseDetailsData['Purchase_Id'] = latestPurchaseId;
            Provider.of<ApiCalls>(context, listen: false)
                .updateSinglePurchaseInvoiceAccountDetails(
                    purchaseId, purchaseDetailsData, token)
                .then((value) {
              if (value == 201 || value == 200) {
                // successSnackbar('successfully saved the data');
                Get.defaultDialog(
                    title: 'Successfully saved the data',
                    middleText: 'Do you want to have a print out of this bill',
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('No')),
                      const SizedBox(
                        width: 25,
                      ),
                      TextButton(
                          onPressed: () {
                            var token = Provider.of<Authenticate>(context,
                                    listen: false)
                                .token;
                            EasyLoading.show();
                            Provider.of<ApiCalls>(context, listen: false)
                                .getSinglePurchaseInvoice(purchaseId, token)
                                .then((value) async {
                              EasyLoading.dismiss();
                              if (value == 200) {
                                Map<String, dynamic> purchaseDetails =
                                    Provider.of<ApiCalls>(context,
                                            listen: false)
                                        .individualPurchaseInvoice;
                                print(purchaseDetails);
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                convertPdf(
                                    purchaseDetails['Purchase_Details'],
                                    purchaseDetails['Item_Details'],
                                    purchaseDetails['Exchange_Details']);
                                Get.back();
                              }
                            });
                          },
                          child: const Text('Yes'))
                    ]);
                itemList.clear();
                selectedProductType = null;
                selectedPaymentType = null;
                totalAmountController.text = '0';
                oldAmount = 0;
                pureNetWt = 0;
                amountExchangeController.text = '0';
                totalWeightController.text = '0';
                amountController.text = '0';
                netWtController.text = '0';
                rateController.text = '0';
                nameController.text = '';
                // purchaseId != null ? delete(purchaseId) : const SizedBox();
                setState(() {});
                getNewBillNumber();
                // getProfile();
              } else {
                failureSnackbar('Something went wrong unable to add data');
              }
            });
            // successSnackbar('successfully saved the data');
            // Get.defaultDialog(
            //     title: 'Successfully updated the data',
            //     middleText: 'Do you want to have a print out of this bill',
            //     actions: [
            //       TextButton(
            //           onPressed: () {
            //             Get.back();
            //           },
            //           child: const Text('No')),
            //       const SizedBox(
            //         width: 25,
            //       ),
            //       TextButton(
            //           onPressed: () {
            //             var token =
            //                 Provider.of<Authenticate>(context, listen: false)
            //                     .token;
            //             EasyLoading.show();
            //             Provider.of<ApiCalls>(context, listen: false)
            //                 .getSinglePurchaseInvoice(value['Id'], token)
            //                 .then((value) async {
            //               EasyLoading.dismiss();
            //               if (value == 200) {
            //                 Map<String, dynamic> purchaseDetails =
            //                     Provider.of<ApiCalls>(context, listen: false)
            //                         .individualPurchaseInvoice;
            //                 print(purchaseDetails);
            //                 await Future.delayed(const Duration(seconds: 1));
            //                 convertPdf(
            //                     purchaseDetails['Purchase_Details'],
            //                     purchaseDetails['Item_Details'],
            //                     purchaseDetails['Exchange_Details']);
            //                 Get.back();
            //               }
            //             });
            //           },
            //           child: const Text('Yes'))
            //     ]);
            // itemList.clear();
            // selectedProductType = null;
            // selectedPaymentType = null;
            // totalAmountController.text = '0';
            // oldAmount = 0;
            // pureNetWt = 0;
            // amountExchangeController.text = '0';
            // totalWeightController.text = '0';
            // amountController.text = '0';
            // netWtController.text = '0';
            // rateController.text = '0';
            // nameController.text = '';
            // // purchaseId != null ? delete(purchaseId) : const SizedBox();
            // setState(() {});
            // getNewBillNumber();
            // // getProfile();
          } else {
            failureSnackbar('Something went wrong unable to add data');
          }
        });
      });
    } else {
      print('Entering permanent send');
      getToken().then((value) {
        Provider.of<ApiCalls>(context, listen: false)
            .sendPurchaseInvoice(purchaseDetailsData, token)
            .then((value) {
          EasyLoading.dismiss();

          if (value['Status_Code'] == 201 || value['Status_Code'] == 200) {
            // successSnackbar('successfully saved the data');
            Get.defaultDialog(
                title: 'Successfully saved the data',
                middleText: 'Do you want to have a print out of this bill',
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('No')),
                  const SizedBox(
                    width: 25,
                  ),
                  TextButton(
                      onPressed: () {
                        var token =
                            Provider.of<Authenticate>(context, listen: false)
                                .token;
                        EasyLoading.show();
                        Provider.of<ApiCalls>(context, listen: false)
                            .getSinglePurchaseInvoice(value['Id'], token)
                            .then((value) async {
                          EasyLoading.dismiss();
                          if (value == 200) {
                            Map<String, dynamic> purchaseDetails =
                                Provider.of<ApiCalls>(context, listen: false)
                                    .individualPurchaseInvoice;
                            print(purchaseDetails);
                            await Future.delayed(const Duration(seconds: 1));
                            convertPdf(
                                purchaseDetails['Purchase_Details'],
                                purchaseDetails['Item_Details'],
                                purchaseDetails['Exchange_Details']);
                            Get.back();
                          }
                        });
                      },
                      child: const Text('Yes'))
                ]);
            itemList.clear();
            selectedProductType = null;
            selectedPaymentType = null;
            totalAmountController.text = '0';
            oldAmount = 0;
            pureNetWt = 0;
            amountExchangeController.text = '0';
            totalWeightController.text = '0';
            amountController.text = '0';
            netWtController.text = '0';
            rateController.text = '0';
            nameController.text = '';
            purchaseId != null ? delete(purchaseId) : const SizedBox();
            setState(() {});
            getNewBillNumber();
            // getProfile();
          } else {
            failureSnackbar('Something went wrong unable to add data');
          }
        });
      });
    }
  }

  double pureNetWt = 0;

  void recordData(Map<String, dynamic> data) {
    if (itemList.isEmpty) {
      itemList.add(data);
      if (data['Key'] == 'Total_Amount') {
        void calculateAsUsual() {
          double Amount = double.parse(totalAmountController.text) +
              double.parse(
                  data['Value'] == '' || data['Value'].toString().isAlphabetOnly
                      ? '0'
                      : data['Value'].toString());

          totalAmountController.text = Amount.toString();
          return;
        }

        if (selectedProductType == 'Gold_Ornament' ||
            selectedProductType == 'Old_Gold_Ornament') {
          if (customerGoldStockController.text != '0.00') {
            double sumTotal = 0;
            for (var data in itemList) {
              if (data['Key'] == 'Total_Amount') {
                sumTotal = sumTotal +
                    double.parse(data['Value'] == ''
                        ? '0'
                        : data['Value'].toString().isAlphabetOnly
                            ? '0'
                            : data['Value']);
              }
            }
            double averageRate =
                sumTotal / double.parse(totalWeightController.text);
            print('Average Rate is $averageRate');
            double amount =
                double.parse(totalWeightController.text) * averageRate;

            totalAmountController.text = amount.abs().toStringAsFixed(2);
          } else {
            calculateAsUsual();
          }
        } else if (selectedProductType == 'Silver_Ornament' ||
            selectedProductType == 'Old_Silver_Ornament') {
          if (customerSilverStockController.text != '0.00') {
            double sumTotal = 0;
            for (var data in itemList) {
              if (data['Key'] == 'Total_Amount') {
                sumTotal = sumTotal + data['Value'];
              }
            }
            double averageRate =
                sumTotal / double.parse(totalWeightController.text);
            print('Average Rate is $averageRate');
            double amount =
                double.parse(totalWeightController.text) * averageRate;

            totalAmountController.text = amount.abs().toStringAsFixed(2);
          } else {
            calculateAsUsual();
          }
        }

        if (merchantCashBalanceController.text != '0.00' &&
            totalAmountController.text != '0.00') {
          if (double.parse(merchantCashBalanceController.text) <
              double.parse(totalAmountController.text)) {
            merchantNewBalance = 0;
            totalAmountController.text =
                (double.parse(totalAmountController.text) -
                        double.parse(merchantCashBalanceController.text))
                    .abs()
                    .toStringAsFixed(2);
          } else {
            double amount = (double.parse(merchantCashBalanceController.text) -
                    double.parse(totalAmountController.text))
                .abs()
                .toPrecision(2);
            merchantNewBalance = amount;
            totalAmountController.text = '0.00';
          }
        }

        print('total Amount ${totalAmountController.text}');
      } else if (data['Key'] == 'Net_Weight') {
        if (selectedProductType == 'Gold_Bullion' ||
            selectedProductType == 'Gold_Ornament' ||
            selectedProductType == 'Old_Gold_Ornament') {
          if (customerGoldStockController.text != '0.00') {
            double cusGoldStock =
                double.parse(customerGoldStockController.text).toPrecision(2);
            double enteredValue = double.parse(
                data['Value'] == '' || data['Value'].toString().isAlphabetOnly
                    ? '0'
                    : data['Value'].toString());

            if (cusGoldStock < enteredValue) {
              customerNewGoldStock = 0;
              pureNetWt = pureNetWt + enteredValue;
              totalWeightController.text =
                  (cusGoldStock - pureNetWt).toStringAsFixed(2);
            } else {
              pureNetWt = pureNetWt + enteredValue;
              customerNewGoldStock = (pureNetWt - cusGoldStock).toPrecision(2);
              totalWeightController.text = '0.00';
            }
          } else {
            double calculatedWeight = double.parse(totalWeightController.text) +
                double.parse(data['Value'] == '' ||
                        data['Value'].toString().isAlphabetOnly
                    ? '0'
                    : data['Value'].toString());

            totalWeightController.text = calculatedWeight.toStringAsFixed(2);
          }
        } else if (selectedProductType == 'Silver_Bullion' ||
            selectedProductType == 'Silver_Ornament' ||
            selectedProductType == 'Old_Silver_Ornament') {
          if (customerSilverStockController.text != '0.00') {
            double cusSilverStock =
                double.parse(customerSilverStockController.text).toPrecision(2);
            double enteredValue = double.parse(
                data['Value'] == '' || data['Value'].toString().isAlphabetOnly
                    ? '0'
                    : data['Value'].toString());

            if (cusSilverStock < enteredValue) {
              customerNewSilverStock = 0;
              pureNetWt = pureNetWt + enteredValue;
              totalWeightController.text =
                  (cusSilverStock - pureNetWt).toStringAsFixed(2);
            } else {
              pureNetWt = pureNetWt + enteredValue;
              customerNewSilverStock =
                  (pureNetWt - cusSilverStock).toPrecision(2);
              totalWeightController.text = '0.00';
            }
          } else {
            double calculatedWeight = double.parse(totalWeightController.text) +
                double.parse(data['Value'] == '' ||
                        data['Value'].toString().isAlphabetOnly
                    ? '0'
                    : data['Value'].toString());

            totalWeightController.text = calculatedWeight.toStringAsFixed(2);
          }
        } else {
          double calculatedWeight = double.parse(totalWeightController.text) +
              double.parse(
                  data['Value'] == '' || data['Value'].toString().isAlphabetOnly
                      ? '0'
                      : data['Value'].toString());

          totalWeightController.text = calculatedWeight.toStringAsFixed(2);
        }
        print('total weight ${totalWeightController.text}');
      }
    } else {
      bool repeated = false;
      for (var item in itemList) {
        if (item['Index'] == data['Index'] && item['Key'] == data['Key']) {
          if (data['Key'] == 'Total_Amount') {
            void calculateAsUsual() {
              // print('entering calcu;late as usual');
              // double lessAmount = double.parse(totalAmountController.text) -
              //     double.parse(item['Value'] == '' ||
              //             item['Value'].toString().isAlphabetOnly
              //         ? '0'
              //         : item['Value'].toString());

              // print(lessAmount);
              // double amount = lessAmount +
              //     double.parse(data['Value'] == '' ||
              //             data['Value'].toString().isAlphabetOnly
              //         ? '0'
              //         : data['Value'].toString());
              // print(amount);
              double sumTotal = 0;
              for (var data in itemList) {
                if (data['Key'] == 'Total_Amount') {
                  sumTotal = sumTotal +
                      double.parse(data['Value'] == ''
                          ? '0'
                          : data['Value'].toString().isAlphabetOnly
                              ? '0'
                              : data['Value']);
                }
              }
              double averageRate =
                  sumTotal / double.parse(totalWeightController.text);
              print('Average Rate is $averageRate');
              double amount =
                  double.parse(totalWeightController.text) * averageRate;
              if (merchantCashBalanceController.text != '0.00' &&
                  totalAmountController.text != '0.00') {
                print('entering merchant cash balance section');
                if (double.parse(merchantCashBalanceController.text) < amount) {
                  merchantNewBalance = 0;
                  totalAmountController.text = (amount -
                          double.parse(merchantCashBalanceController.text))
                      .abs()
                      .toStringAsFixed(2);
                } else {
                  double merchantNewAmount =
                      (double.parse(merchantCashBalanceController.text) -
                              amount)
                          .abs()
                          .toPrecision(2);
                  merchantNewBalance = merchantNewAmount;
                  totalAmountController.text = '0.00';
                }
              } else {
                print('calculate as usual total amount ');
                totalAmountController.text = amount.toStringAsFixed(2);
              }
              return;
            }

            if (selectedProductType == 'Gold_Ornament' ||
                selectedProductType == 'Old_Gold_Ornament') {
              if (customerGoldStockController.text != '0.00') {
                double sumTotal = 0;
                for (var data in itemList) {
                  if (data['Key'] == 'Total_Amount') {
                    sumTotal = sumTotal +
                        double.parse(data['Value'] == ''
                            ? '0'
                            : data['Value'].toString().isAlphabetOnly
                                ? '0'
                                : data['Value']);
                  }
                }
                double averageRate =
                    sumTotal / double.parse(totalWeightController.text);
                print('Average Rate is $averageRate');
                double amount =
                    double.parse(totalWeightController.text) * averageRate;

                totalAmountController.text = amount.abs().toStringAsFixed(2);
              } else {
                calculateAsUsual();
              }
            } else if (selectedProductType == 'Silver_Ornament' ||
                selectedProductType == 'Old_Silver_Ornament') {
              if (customerSilverStockController.text != '0.00') {
                double sumTotal = 0;
                for (var data in itemList) {
                  if (data['Key'] == 'Total_Amount') {
                    sumTotal = sumTotal + data['Value'];
                  }
                }
                double averageRate =
                    sumTotal / double.parse(totalWeightController.text);
                print('Average Rate is $averageRate');
                double amount =
                    double.parse(totalWeightController.text) * averageRate;

                totalAmountController.text = amount.abs().toStringAsFixed(2);
              } else {
                calculateAsUsual();
              }
            }

            // if (merchantCashBalanceController.text != '0.00' &&
            //     totalAmountController.text != '0.00') {}
            print('total Amount ${totalAmountController.text}');
          } else if (data['Key'] == 'Net_Weight') {
            if (selectedProductType == 'Gold_Bullion' ||
                selectedProductType == 'Gold_Ornament' ||
                selectedProductType == 'Old_Gold_Ornament') {
              if (customerGoldStockController.text != '0.00') {
                totalWeightController.text =
                    (double.parse(customerGoldStockController.text) -
                            double.parse(totalWeightController.text))
                        .toStringAsFixed(2);

                print(
                    'total weioght when repeated ${totalWeightController.text}');
                double lessWeight = pureNetWt -
                    double.parse(item['Value'] == '' ||
                            item['Value'].toString().isAlphabetOnly
                        ? '0'
                        : item['Value'].toString());

                print(lessWeight);
                pureNetWt = lessWeight +
                    double.parse(data['Value'] == '' ||
                            data['Value'].toString().isAlphabetOnly
                        ? '0'
                        : data['Value'].toString());

                print(pureNetWt);
                // totalWeightController.text = pureNetWt.toString();
                if (double.parse(customerGoldStockController.text) <
                    pureNetWt) {
                  customerNewGoldStock = 0;
                  totalWeightController.text =
                      (double.parse(customerGoldStockController.text) -
                              pureNetWt)
                          .toStringAsFixed(2);
                } else {
                  customerNewGoldStock =
                      (double.parse(customerGoldStockController.text) -
                              pureNetWt)
                          .toPrecision(2);

                  totalWeightController.text = '0.00';
                }

                print(totalWeightController.text);
              } else {
                double lessWeight = double.parse(totalWeightController.text) -
                    double.parse(item['Value'] == '' ||
                            item['Value'].toString().isAlphabetOnly
                        ? '0'
                        : item['Value'].toString());
                double actualWeight = lessWeight +
                    double.parse(data['Value'] == '' ||
                            data['Value'].toString().isAlphabetOnly
                        ? '0'
                        : data['Value'].toString());
                totalWeightController.text = actualWeight.toStringAsFixed(2);
              }
            } else if (selectedProductType == 'Silver_Bullion' ||
                selectedProductType == 'Silver_Ornament' ||
                selectedProductType == 'Old_Silver_Ornament') {
              if (customerSilverStockController.text != '0.00') {
                totalWeightController.text =
                    (double.parse(customerSilverStockController.text) -
                            double.parse(totalWeightController.text))
                        .toStringAsFixed(2);
                double lessWeight = pureNetWt -
                    double.parse(item['Value'] == '' ||
                            item['Value'].toString().isAlphabetOnly
                        ? '0'
                        : item['Value'].toString());
                pureNetWt = lessWeight +
                    double.parse(data['Value'] == '' ||
                            data['Value'].toString().isAlphabetOnly
                        ? '0'
                        : data['Value'].toString());
                // totalWeightController.text = pureNetWt.toString();
                if (double.parse(customerSilverStockController.text) <
                    pureNetWt) {
                  customerNewSilverStock = 0;
                  totalWeightController.text =
                      (double.parse(customerSilverStockController.text) -
                              pureNetWt)
                          .toStringAsFixed(2);
                } else {
                  customerNewSilverStock =
                      (double.parse(customerSilverStockController.text) -
                              pureNetWt)
                          .toPrecision(2);

                  totalWeightController.text = '0.00';
                }
              } else {
                double lessWeight = double.parse(totalWeightController.text) -
                    double.parse(item['Value'] == '' ||
                            item['Value'].toString().isAlphabetOnly
                        ? '0'
                        : item['Value'].toString());
                double actualWeight = lessWeight +
                    double.parse(data['Value'] == '' ||
                            data['Value'].toString().isAlphabetOnly
                        ? '0'
                        : data['Value'].toString());
                totalWeightController.text = actualWeight.toStringAsFixed(2);
              }
            } else {
              double lessWeight = double.parse(totalWeightController.text) -
                  double.parse(item['Value'] == '' ||
                          item['Value'].toString().isAlphabetOnly
                      ? '0'
                      : item['Value'].toString());
              double actualWeight = lessWeight +
                  double.parse(data['Value'] == '' ||
                          data['Value'].toString().isAlphabetOnly
                      ? '0'
                      : data['Value'].toString());
              totalWeightController.text = actualWeight.toStringAsFixed(2);
            }
            print(
                'total weight when repeated is true ${totalWeightController.text}');
          }
          itemList.remove(item);
          itemList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        itemList.add(data);
        if (data['Key'] == 'Total_Amount') {
          void calculateAsUsual() {
            // double Amount = double.parse(totalAmountController.text) +
            //     double.parse(data['Value'] == '' ||
            //             data['Value'].toString().isAlphabetOnly
            //         ? '0'
            //         : data['Value'].toString());

            // totalAmountController.text = Amount.toString();
            double sumTotal = 0;
            for (var data in itemList) {
              if (data['Key'] == 'Total_Amount') {
                sumTotal = sumTotal +
                    double.parse(data['Value'] == ''
                        ? '0'
                        : data['Value'].toString().isAlphabetOnly
                            ? '0'
                            : data['Value']);
              }
            }
            print('Average sum rate $sumTotal');

            double averageRate =
                sumTotal / double.parse(totalWeightController.text);
            print('Average Rate is $averageRate');
            double amount =
                double.parse(totalWeightController.text) * averageRate;
            if (merchantCashBalanceController.text != '0.00') {
              if (double.parse(merchantCashBalanceController.text) < amount) {
                merchantNewBalance = 0;
                totalAmountController.text =
                    (amount - double.parse(merchantCashBalanceController.text))
                        .abs()
                        .toStringAsFixed(2);
              } else {
                double merchantNewAmount =
                    (double.parse(merchantCashBalanceController.text) - amount)
                        .abs()
                        .toPrecision(2);
                merchantNewBalance = merchantNewAmount;
                totalAmountController.text = '0.00';
              }
            }
            return;
          }

          if (selectedProductType == 'Gold_Ornament' ||
              selectedProductType == 'Old_Gold_Ornament') {
            if (customerGoldStockController.text != '0.00') {
              double sumTotal = 0;
              for (var data in itemList) {
                if (data['Key'] == 'Total_Amount') {
                  sumTotal = sumTotal +
                      double.parse(data['Value'] == ''
                          ? '0'
                          : data['Value'].toString().isAlphabetOnly
                              ? '0'
                              : data['Value']);
                }
              }
              double averageRate =
                  sumTotal / double.parse(totalWeightController.text);
              print('Average Rate is $averageRate');
              double amount =
                  double.parse(totalWeightController.text) * averageRate;

              totalAmountController.text = amount.abs().toStringAsFixed(2);
            } else {
              calculateAsUsual();
            }
          } else if (selectedProductType == 'Silver_Ornament' ||
              selectedProductType == 'Old_Silver_Ornament') {
            if (customerSilverStockController.text != '0.00') {
              double sumTotal = 0;
              for (var data in itemList) {
                if (data['Key'] == 'Total_Amount') {
                  sumTotal = sumTotal + data['Value'];
                }
              }
              double averageRate =
                  sumTotal / double.parse(totalWeightController.text);
              print('Average Rate is $averageRate');
              double amount =
                  double.parse(totalWeightController.text) * averageRate;

              totalAmountController.text = amount.abs().toStringAsFixed(2);
            } else {
              calculateAsUsual();
            }
          }

          print('total Amount ${totalAmountController.text}');
        } else if (data['Key'] == 'Net_Weight') {
          if (selectedProductType == 'Gold_Bullion' ||
              selectedProductType == 'Gold_Ornament' ||
              selectedProductType == 'Old_Gold_Ornament') {
            if (customerGoldStockController.text != '0.00') {
              double cusGoldStock =
                  double.parse(customerGoldStockController.text).toPrecision(2);
              double enteredValue = double.parse(
                  data['Value'] == '' || data['Value'].toString().isAlphabetOnly
                      ? '0'
                      : data['Value'].toString());

              if (cusGoldStock < enteredValue) {
                print('enterd value is greater');
                customerNewGoldStock = 0;
                pureNetWt = pureNetWt + enteredValue;
                totalWeightController.text =
                    (cusGoldStock - pureNetWt).toStringAsFixed(2);
              } else {
                print('Entred value is smaller');
                pureNetWt = pureNetWt + enteredValue;
                customerNewGoldStock =
                    (pureNetWt - cusGoldStock).toPrecision(2);
                totalWeightController.text = '0.00';
              }
            } else {
              double calculatedWeight =
                  double.parse(totalWeightController.text) +
                      double.parse(data['Value'] == '' ||
                              data['Value'].toString().isAlphabetOnly
                          ? '0'
                          : data['Value'].toString());

              totalWeightController.text = calculatedWeight.toString();
            }
          } else if (selectedProductType == 'Silver_Bullion' ||
              selectedProductType == 'Silver_Ornament' ||
              selectedProductType == 'Old_Silver_Ornament') {
            if (customerSilverStockController.text != '0.00') {
              double cusSilverStock =
                  double.parse(customerSilverStockController.text)
                      .toPrecision(2);
              double enteredValue = double.parse(
                  data['Value'] == '' || data['Value'].toString().isAlphabetOnly
                      ? '0'
                      : data['Value'].toString());

              if (cusSilverStock < enteredValue) {
                customerNewSilverStock = 0;
                pureNetWt = pureNetWt + enteredValue;
                totalWeightController.text =
                    (cusSilverStock - pureNetWt).toStringAsFixed(2);
              } else {
                pureNetWt = pureNetWt + enteredValue;
                customerNewSilverStock =
                    (pureNetWt - cusSilverStock).toPrecision(2);
                totalWeightController.text = '0.00';
              }
            } else {
              double calculatedWeight =
                  double.parse(totalWeightController.text) +
                      double.parse(data['Value'] == '' ||
                              data['Value'].toString().isAlphabetOnly
                          ? '0'
                          : data['Value'].toString());

              totalWeightController.text = calculatedWeight.toString();
            }
          } else {
            double calculatedWeight = double.parse(totalWeightController.text) +
                double.parse(data['Value'] == '' ||
                        data['Value'].toString().isAlphabetOnly
                    ? '0'
                    : data['Value'].toString());

            totalWeightController.text = calculatedWeight.toString();
          }

          print(
              'total weight when repeated is false ${totalWeightController.text}');
        }
      }
    }

    print(itemList);
  }

  void increaseRowCount(int index) {
    if (widget.editData.isNotEmpty) {
      if (removedItems.isNotEmpty) {
        removedItems.remove(tempItemIdList[index]);
      }
    }
    if (widget.editData.isNotEmpty) {
      if (itemCount < widget.editData['Item_Details'].length) {
        setState(() {
          itemCount = itemCount + 1;
        });
      } else {
        print('Greater');
      }
    } else {
      setState(() {
        itemCount = itemCount + 1;
      });
    }

    print(itemCount);
  }

  void decreaseRowCount(int index) {
    print('decrease row count');
    print(index);
    List temp = [];
    if (widget.editData.isNotEmpty) {
      removedItems.add(tempItemIdList[index]);
    }
    for (var data in itemList) {
      if (data['Key'] == 'Net_Weight' && data['Index'] == index) {
        if (double.parse(data['Value']) <=
            double.parse(totalWeightController.text)) {
          totalWeightController.text =
              (double.parse(totalWeightController.text) -
                      double.parse(data['Value']))
                  .toStringAsFixed(2);
          // itemList.removeWhere((element) => element['Index'] == index);
          double sumTotal = 0;
          for (var data in itemList) {
            if (data['Key'] == 'Total_Amount' && data['Index'] != index) {
              sumTotal = sumTotal +
                  double.parse(data['Value'] == ''
                      ? '0'
                      : data['Value'].toString().isAlphabetOnly
                          ? '0'
                          : data['Value']);
            }
          }
          print('Total Weight Controller ${totalWeightController.text}');
          print('sum rate $sumTotal');
          print('itemcount $itemCount');
          double count = itemCount - 1;
          double averageRate = 0;
          if (sumTotal != 0 && count != 0) {
            averageRate = sumTotal / double.parse(totalWeightController.text);
          }

          print('Average Rate is $averageRate');
          double amount =
              double.parse(totalWeightController.text) * averageRate;
          if (merchantCashBalanceController.text != '0.00' &&
              totalAmountController.text != '0.00') {
            if (double.parse(merchantCashBalanceController.text) < amount) {
              merchantNewBalance = 0;
              totalAmountController.text =
                  (amount - double.parse(merchantCashBalanceController.text))
                      .abs()
                      .toStringAsFixed(2);
            } else {
              double merchantNewAmount =
                  (double.parse(merchantCashBalanceController.text) - amount)
                      .abs()
                      .toPrecision(2);
              merchantNewBalance = merchantNewAmount;
              totalAmountController.text = '0.00';
            }
          } else {
            totalAmountController.text = amount.toStringAsFixed(2);
          }
        }
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

  Text formName(String name) {
    return Text(
      name,
      style: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  void searchCustomer(String searchData) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .searchCustomer(searchData, token)
          .then((value) => null);
    });
  }

  Future<void> searchCustomerWithId(String id) async {
    await Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      await Provider.of<ApiCalls>(context, listen: false)
          .fetchIndividualCustomerDetails(id, token)
          .then((value) {
        if (value == 200 || value == 201) {
          Map<String, dynamic> customerDetails =
              Provider.of<ApiCalls>(context, listen: false)
                  .individualCustomerDetails;
          nameController.text =
              customerDetails['Customer_Details']['Customer_Name'];
          selectCustomerData(customerDetails['Customer_Details']);
        }
      });
    });
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
      purchaseDetailsData['Created_Date'] =
          DateFormat("yyyy-MM-dd").format(pickedDate);

      // setState(() {});
    });
  }

  ScrollController firstRowController = ScrollController();

  SizedBox gap() {
    return const SizedBox(
      width: 40,
    );
  }

  double tableHeaderWidth = 100;

  SizedBox tableHeaderContainer(String name) {
    return SizedBox(
      width: 160,
      child: Text(
        name,
        style: ProjectStyles.drawerStyle()
            .copyWith(color: Colors.black, fontSize: 16),
      ),
    );
  }

  void calculateTotalAmountIfCredit() {
    totalAmountController.text = ((double.parse(totalAmountController.text == ''
                    ? '0'
                    : totalAmountController.text) +
                double.parse(merchantCreditBalanceController.text == ''
                    ? '0'
                    : merchantCreditBalanceController.text)) -
            double.parse(customerCreditBalanceController.text == ''
                ? '0'
                : customerCreditBalanceController.text))
        .toStringAsFixed(2);
  }

  void calculateTotalWeight() {
    if (selectedProductType == 'Gold_Ornament' ||
        selectedProductType == 'Gold_Bullion') {
      if (customerGoldStockController.text == '0.00') {
        totalWeightController.text = '0';
        totalAmountController.text = '0';
        oldWeight = 0;
        totalNetWeight = 0;
        oldAmount = 0;
        if (itemList.isNotEmpty) {
          for (var data in itemList) {
            if (data['Key'] == 'Net_Weight') {
              totalWeightController
                  .text = (double.parse(totalWeightController.text) +
                      double.parse(
                          data['Value'] == '' ? '0' : data['Value'].toString()))
                  .toStringAsFixed(2);
            } else if (data['Key'] == 'Total_Amount') {
              totalAmountController
                  .text = (double.parse(totalAmountController.text) +
                      double.parse(
                          data['Value'] == '' ? '0' : data['Value'].toString()))
                  .toStringAsFixed(2);
            }
          }
        } else {
          totalWeightController.text = netWtController.text;
          totalAmountController.text = amountController.text;
        }
      }
    } else if (selectedProductType == 'Silver_Ornament' ||
        selectedProductType == 'Silver_Bullion') {
      if (customerSilverStockController.text == '0.00') {
        totalWeightController.text = '0';
        totalAmountController.text = '0';
        oldWeight = 0;
        totalNetWeight = 0;
        oldAmount = 0;
        if (itemList.isNotEmpty) {
          for (var data in itemList) {
            if (data['Key'] == 'Net_Weight') {
              totalWeightController
                  .text = (double.parse(totalWeightController.text) +
                      double.parse(
                          data['Value'] == '' ? '0' : data['Value'].toString()))
                  .toStringAsFixed(2);
            } else if (data['Key'] == 'Total_Amount') {
              totalAmountController
                  .text = (double.parse(totalAmountController.text) +
                      double.parse(
                          data['Value'] == '' ? '0' : data['Value'].toString()))
                  .toStringAsFixed(2);
            }
          }
        } else {
          totalWeightController.text = netWtController.text;
          totalAmountController.text = amountController.text;
        }
      }
    } else {
      totalWeightController.text = '0';
      totalAmountController.text = '0';
      oldWeight = 0;
      totalNetWeight = 0;
      oldAmount = 0;
      if (itemList.isNotEmpty) {
        for (var data in itemList) {
          if (data['Key'] == 'Net_Weight') {
            totalWeightController
                .text = (double.parse(totalWeightController.text) +
                    double.parse(
                        data['Value'] == '' ? '0' : data['Value'].toString()))
                .toStringAsFixed(2);
          } else if (data['Key'] == 'Total_Amount') {
            totalAmountController
                .text = (double.parse(totalAmountController.text) +
                    double.parse(
                        data['Value'] == '' ? '0' : data['Value'].toString()))
                .toStringAsFixed(2);
          }
        }
      } else {
        totalWeightController.text = netWtController.text;
        totalAmountController.text = amountController.text;
      }
    }
  }

  void selectCustomerData(Map<String, dynamic> data) {
    itemList.clear();
    totalNetWeight = 0;
    oldWeight = 0;
    oldAmount = 0;
    totalAmount = 0;
    if (selectedProductType == 'Gold_Bullion' ||
        selectedProductType == 'Gold_Ornament') {
      netWtController.text = '0';
      rateController.text = '0';
      amountController.text = '0';
    }
    totalAmountController.text = '0';
    amountExchangeController.text = '0';
    totalWeightController.text = selectedProductType == 'Gold_Bullion'
        ? data['Customer_Gold_Stock']
        : selectedProductType == 'Silver_Bullion'
            ? data['Customer_Silver_Stock']
            : '0';
    customerId = data['Customer_Id'];
    nameController.text = data['Customer_Name'];
    customerCreditBalanceController.text = double.parse(
            data['Receivable'] == null ? '0' : data['Receivable'].toString())
        .toStringAsFixed(2);
    merchantCreditBalanceController.text =
        double.parse(data['Payable'] == null ? '0' : data['Payable'].toString())
            .toStringAsFixed(2);
    customerGoldStockController.text =
        double.parse(data['Customer_Gold_Stock'] ?? '0').toStringAsFixed(2);
    customerSilverStockController.text =
        double.parse(data['Customer_Silver_Stock'] ?? '0').toStringAsFixed(2);
    merchantCashBalanceController.text =
        double.parse(data['Customer_excess_cash'] ?? '0').toStringAsFixed(2);
    if (selectedPaymentType == 'Credit') {
      totalAmountController.text = ((double.parse(totalAmountController.text) +
                  double.parse(merchantCreditBalanceController.text)) -
              double.parse(customerCreditBalanceController.text))
          .toStringAsFixed(2);
    }

    setState(() {
      searchSelected = false;
    });
  }

  TextEditingController itemNameController = TextEditingController();
  TextEditingController grossWeightController = TextEditingController();
  TextEditingController wastageController = TextEditingController();
  TextEditingController netWtController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  calculateTotalPercentageAndNetWeight() {
    totalPercentageController.text = (double.parse(
                meltController.text == '' || meltController.text.isAlphabetOnly
                    ? '0'
                    : meltController.text) +
            double.parse(wastageController.text == '' ||
                    wastageController.text.isAlphabetOnly
                ? '0'
                : wastageController.text))
        .toStringAsFixed(2);

    netWtController.text = ((double.parse(grossWeightController.text == '' ||
                        grossWeightController.text.isAlphabetOnly
                    ? '0'
                    : grossWeightController.text) *
                double.parse(totalPercentageController.text)) /
            100)
        .toStringAsFixed(2);
    if (selectedProductType == 'Gold_Bullion' ||
        selectedProductType == 'Gold_Ornament') {
      if (customerGoldStockController.text != '0.00') {
        if (double.parse(customerGoldStockController.text) >
            double.parse(netWtController.text)) {
          customerNewGoldStock =
              (double.parse(customerGoldStockController.text) -
                      double.parse(netWtController.text))
                  .toPrecision(2);
          totalWeightController.text =
              (double.parse(customerGoldStockController.text) -
                      double.parse(netWtController.text))
                  .toStringAsFixed(2);
          print('new customer less gold stock $customerNewGoldStock');
        } else {
          customerNewGoldStock = 0;
          totalWeightController.text =
              (double.parse(customerGoldStockController.text) -
                      double.parse(netWtController.text))
                  .toStringAsFixed(2);

          print('new customer greater gold stock $customerNewGoldStock');
        }
      } else {
        totalWeightController.text = netWtController.text;
      }
    } else if (selectedProductType == 'Silver_Bullion' ||
        selectedProductType == 'Silver_Ornament') {
      if (customerSilverStockController.text != '0.00') {
        if (double.parse(customerSilverStockController.text) >
            double.parse(netWtController.text)) {
          customerNewSilverStock =
              (double.parse(customerSilverStockController.text) -
                      double.parse(netWtController.text))
                  .toPrecision(2);
          totalWeightController.text =
              (double.parse(customerSilverStockController.text) -
                      double.parse(netWtController.text))
                  .toStringAsFixed(2);
          print('new customer less gold stock $customerNewSilverStock');
        } else {
          customerNewSilverStock = 0;
          totalWeightController.text =
              (double.parse(customerSilverStockController.text) -
                      double.parse(netWtController.text))
                  .toStringAsFixed(2);

          print('new customer greater gold stock $customerNewSilverStock');
        }

        totalWeightController.text =
            (double.parse(customerSilverStockController.text) -
                    double.parse(netWtController.text))
                .toStringAsFixed(2);
      } else {
        totalWeightController.text = netWtController.text;
      }
    } else {
      totalWeightController.text = netWtController.text;
    }
  }

  Container tableDataContainer(
    TextEditingController controller,
    String name,
    FocusNode focusNode,
  ) {
    return Container(
        width: 140,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
            enabled: name == 'Exchange_Item_Name' ||
                    name == 'Total Percentage' ||
                    name == 'Net_Weight'
                ? false
                : true,
            focusNode: focusNode,
            onFieldSubmitted: (value) {},
            onChanged: (value) {
              // if (name == 'Rate') {
              //   double data = double.parse(rateController.text) *
              //       double.parse(netWtController.text);
              //   amountController.text = data.toString();
              // }
              if (name == 'Total_Amount') {
                // totalAmountController.text =
                //     (double.parse(totalAmountController.text) +
                //             double.parse(value))
                //         .toStringAsFixed(2);
                if (amountController.text != '' && netWtController.text != '') {
                  double data = double.parse(amountController.text.isNum != true
                          ? '0'
                          : amountController.text) /
                      double.parse(netWtController.text);

                  rateController.text = data.toStringAsFixed(2);
                }
              }

              if (name == 'Wastage' ||
                  name == 'Melt' ||
                  name == 'Gross_Weight') {
                calculateTotalPercentageAndNetWeight();
              }
              // else if (name == 'Total_Exchange_Amount') {
              //   double amount = double.parse(totalAmountController.text) -
              //       double.parse(value.toString());
              //   totalAmountController.text = amount.toString();
              //   print('Total amount ${totalAmountController.text}');
              // }
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
            ),
            controller: controller,
          ),
        ));
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
    if (billNumberController.text == '') {
      errorList.add('Bill number cannot be empty');
    }
    if (selectedProductType == null) {
      errorList.add('Product Type Cannot be empty');
    }

    if (nameController.text == '') {
      errorList.add('Name cannot be empty');
    }

    if (selectedProductType == 'Gold_Bullion' ||
        selectedProductType == 'Silver_Bullion') {
      if (itemNameController.text == '') {
        errorList.add('Item Name cannot be empty');
      }

      if (grossWeightController.text.isNum != true) {
        errorList.add('Enter a valid gross weight');
      }

      if (meltController.text.isNum != true) {
        errorList.add('Enter a valid Melt');
      }

      if (wastageController.text.isNum != true) {
        errorList.add('Enter a valid wastage');
      }

      if (totalPercentageController.text.isNum != true) {
        errorList.add('Enter a valid percentage');
      }

      if (netWtController.text.isNum != true) {
        errorList.add('Enter a valid Net weight');
      }

      if (rateController.text != '') {
        if (rateController.text.isNum != true) {
          errorList.add('Enter a valid rate');
        }
      }
      if (amountController.text != '') {
        if (selectedPaymentType != null) {
          print('true');
          if (amountController.text.isNum != true) {
            errorList.add('Enter a valid amount');
          }
        }
      }
    }

    if (selectedPaymentType == 'Exchange' ||
        selectedPaymentType == 'Cash_Plus_Exchange' ||
        selectedPaymentType == 'Credit_Plus_Exchange') {
      if (grossWeightExchangeController.text.isNum != true) {
        errorList.add('Enter a valid exchange gross weight');
      }
      if (wastageExchangeController.text.isNum != true) {
        errorList.add('Enter a valid exchange wastage');
      }

      if (netWtExchangeController.text.isNum != true) {
        errorList.add('Enter a valid exchange net weight');
      }

      if (amountExchangeController.text.isNum != true) {
        errorList.add('Enter a valid exchange amount');
      }
    }

    if (errorList.isEmpty) {
      return true;
    } else {
      validateDialog(errorList);
      return false;
    }
  }

  List productTypes = [
    'Gold_Ornament',
    'Silver_Ornament',
    'Gold_Bullion',
    'Silver_Bullion',
    'Old_Gold_Ornament',
    'Old_Silver_Ornament'
  ];

  void afterSelectingProductType(var e) {
    if (itemList.isNotEmpty) {
      itemList.clear();
    }
    netWtController.text = '';
    rateController.text = '';
    amountController.text = '';
    totalNetWeight = 0;
    totalAmount = 0;
    purchaseDetailsData['Product_Type'] = e;
    totalAmountController.text = '0';
    totalWeightController.text = '0';
    setState(() {});

    if (purchaseDetailsData['Product_Type'] == 'Gold_Ornament') {
      itemNameExchangeController.text = 'Gold_Bullion';
    } else if (purchaseDetailsData['Product_Type'] == 'Silver_Ornament') {
      itemNameExchangeController.text = 'Silver_Bullion';
    } else if (purchaseDetailsData['Product_Type'] == 'Silver_Bullion') {
      itemNameExchangeController.text = 'Old_Silver';
      itemNameController.text = 'Silver_Bullion';
    } else if (purchaseDetailsData['Product_Type'] == 'Gold_Bullion') {
      itemNameController.text = 'Gold_Bullion';
      itemNameExchangeController.text = 'Old_Gold';
    } else {
      itemNameExchangeController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var formWidth = size.width * 0.2;
    var formheight = size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Purchase Invoice',
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
                Get.toNamed(TemproryPurchaseList.routeName);
              },
              child: Text(
                'Rate-Cut Purchase List',
                style: ProjectStyles.drawerStyle()
                    .copyWith(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ProjectColors.buttonColor)),
              onPressed: () {
                Get.toNamed(PurchaseListScreen.routeName);
              },
              child: Text(
                'Purchase List',
                style: ProjectStyles.drawerStyle()
                    .copyWith(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: GestureDetector(
        onTap: () {
          setState(() {
            searchSelected = false;
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Form(
              key: _formStateKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Purchase Information',
                          style: ProjectStyles.headingStyle()
                              .copyWith(color: Colors.black, fontSize: 25),
                        ),
                        // const SizedBox(
                        //   width: 40,
                        // ),
                        ElevatedButton.icon(
                            onPressed: () {
                              // getNewBillNumber();
                              // selectedProductType = null;
                              // selectedPaymentType = null;
                              // itemList.clear();
                              // totalAmountController.text = '0';
                              // totalWeightController.text = '0';
                              Get.back();
                              Get.toNamed(PurchasesScreen.routeName);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: firstRowController,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            formName('Purchase Bill No.'),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: formWidth * 0.6,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  enabled: false,
                                  controller: billNumberController,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter Bill Number',
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      // showError('FirmCode');
                                      return 'Bill Number Cannot be empty';
                                    }
                                  },
                                  onSaved: (value) {
                                    purchaseDetailsData['Bill_Number'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        gap(),
                        Row(
                          children: [
                            formName('Purchase Date'),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: datePicker,
                              child: Row(
                                children: [
                                  Container(
                                    width: formWidth * 0.7,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        enabled: false,
                                        controller: dateController,
                                        decoration: const InputDecoration(
                                            hintText: 'Choose Date',
                                            border: InputBorder.none),
                                        validator: (value) {
                                          // if (value!.isEmpty) {
                                          //   // showError('FirmCode');
                                          //   return 'Name cannot be empty';
                                          // }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: formWidth * 0.01,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: IconButton(
                                        onPressed: datePicker,
                                        icon: Icon(
                                          Icons.calendar_month_outlined,
                                          color: ProjectColors.themeColor,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Row(
                          children: [
                            formName('Product Type'),
                            const SizedBox(
                              width: 25,
                            ),
                            Container(
                              width: formWidth * 0.6,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(formWidth * 0.02),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: selectedProductType,
                                    items: productTypes
                                        .map<DropdownMenuItem<String>>((e) {
                                      return DropdownMenuItem(
                                        enabled: widget.editData.isNotEmpty
                                            ? false
                                            : true,
                                        value: e,
                                        onTap: () {
                                          if (itemList.isNotEmpty) {
                                            itemList.clear();
                                          }
                                          netWtController.text = '';
                                          rateController.text = '';
                                          amountController.text = '';
                                          totalNetWeight = 0;
                                          totalAmount = 0;
                                          purchaseDetailsData['Product_Type'] =
                                              e;
                                          totalAmountController.text = '0';
                                          totalWeightController.text = '0';
                                          setState(() {});

                                          if (purchaseDetailsData[
                                                  'Product_Type'] ==
                                              'Gold_Ornament') {
                                            itemNameExchangeController.text =
                                                'Gold_Bullion';
                                          } else if (purchaseDetailsData[
                                                  'Product_Type'] ==
                                              'Silver_Ornament') {
                                            itemNameExchangeController.text =
                                                'Silver_Bullion';
                                          } else if (purchaseDetailsData[
                                                  'Product_Type'] ==
                                              'Silver_Bullion') {
                                            itemNameExchangeController.text =
                                                'Old_Silver';
                                            itemNameController.text =
                                                'Silver_Bullion';
                                          } else if (purchaseDetailsData[
                                                  'Product_Type'] ==
                                              'Gold_Bullion') {
                                            itemNameController.text =
                                                'Gold_Bullion';
                                            itemNameExchangeController.text =
                                                'Old_Gold';
                                          } else {
                                            itemNameExchangeController.text =
                                                '';
                                          }
                                        },
                                        child: Text(e,
                                            style: TextStyle(
                                                fontSize: formWidth * 0.055,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400)),
                                      );
                                    }).toList(),

                                    hint: const Text(
                                      'Select product type',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    // TextField(
                                    //   decoration: const InputDecoration(
                                    //       contentPadding:
                                    //           EdgeInsets.only(bottom: 8),
                                    //       hintText: 'Select Product Type',
                                    //       border: InputBorder.none),
                                    //   controller: productTypeController,
                                    //   onChanged: (value) {
                                    //     print(value);
                                    //     if (productTypeController.text == '1') {
                                    //       selectedProductType = 'Gold_Bullion';
                                    //       afterSelectingProductType(
                                    //           'Gold_Bullion');
                                    //       setState(() {});
                                    //     }
                                    //   },
                                    // ),

                                    style: TextStyle(
                                        fontSize: formWidth * 0.06,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    iconDisabledColor: Colors.black,
                                    iconEnabledColor: Colors.black,
                                    // dropdownColor: Colors.white,
                                    // alignment: Alignment.center,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedProductType = value as String;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        // Row(
                        //   children: [
                        //     formName('Creditor Type'),
                        //     const SizedBox(
                        //       width: 20,
                        //     ),
                        //     Container(
                        //       width: formWidth * 0.6,
                        //       height: 40,
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //         borderRadius:
                        //             BorderRadius.circular(formWidth * 0.02),
                        //         color: Colors.white,
                        //         border: Border.all(color: Colors.black26),
                        //       ),
                        //       child: DropdownButtonHideUnderline(
                        //         child: DropdownButton(
                        //           value: selectedCreditorType,
                        //           items: [
                        //             'Supplier',
                        //             'Customer',
                        //           ].map<DropdownMenuItem<String>>((e) {
                        //             return DropdownMenuItem(
                        //               child: Text(e,
                        //                   style: TextStyle(
                        //                       fontSize: formWidth * 0.06,
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.w400)),
                        //               value: e,
                        //               onTap: () {
                        //                 purchaseDetailsData[
                        //                     'Creditor_Type'] = e;
                        //                 // firmId = e['Firm_Code'];
                        //                 // user['User_Role_Name'] = e['Role_Name'];
                        //               },
                        //             );
                        //           }).toList(),
                        //           hint: Text('Select Creditor',
                        //               style: TextStyle(
                        //                   fontSize: formWidth * 0.06,
                        //                   color: Colors.black,
                        //                   fontWeight: FontWeight.w400)),
                        //           style: TextStyle(
                        //               fontSize: formWidth * 0.06,
                        //               color: Colors.black,
                        //               fontWeight: FontWeight.w400),
                        //           iconDisabledColor: Colors.black,
                        //           iconEnabledColor: Colors.black,
                        //           dropdownColor: Colors.white,
                        //           // alignment: Alignment.center,
                        //           onChanged: (value) {
                        //             setState(() {
                        //               selectedCreditorType =
                        //                   value as String;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          width: 20,
                        ),
                        // Row(
                        //   children: [
                        //     formName('Payment Type'),
                        //     const SizedBox(
                        //       width: 25,
                        //     ),
                        //     Container(
                        //       width: formWidth * 0.65,
                        //       height: 40,
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //         borderRadius:
                        //             BorderRadius.circular(formWidth * 0.02),
                        //         color: Colors.white,
                        //         border: Border.all(color: Colors.black26),
                        //       ),
                        //       child: Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 8.0),
                        //         child: DropdownButtonHideUnderline(
                        //           child: DropdownButton(
                        //             isExpanded: true,
                        //             value: selectedPaymentType,
                        //             items: [
                        //               'Cash',
                        //               'Credit',
                        //               'Exchange',
                        //               'Bank',
                        //               // 'Cash_Exchange',
                        //               'Credit_Exchange'
                        //             ].map<DropdownMenuItem<String>>((e) {
                        //               return DropdownMenuItem(
                        //                 child: Text(e,
                        //                     style: TextStyle(
                        //                         fontSize: formWidth * 0.055,
                        //                         color: Colors.black,
                        //                         fontWeight: FontWeight.w400)),
                        //                 value: e,
                        //                 onTap: () {
                        //                   purchaseDetailsData['Payment_Type'] =
                        //                       e;
                        //                   if (purchaseDetailsData[
                        //                           'Payment_Type'] ==
                        //                       'Exchange') {
                        //                     // totalAmountController.text = '0';
                        //                     if (selectedProductType ==
                        //                                 'Gold_Ornament' &&
                        //                             purchaseDetailsData[
                        //                                     'Payment_Type'] ==
                        //                                 'Exchange' ||
                        //                         selectedProductType ==
                        //                                 'Gold_Bullion' &&
                        //                             purchaseDetailsData[
                        //                                     'Payment_Type'] ==
                        //                                 'Exchange') {
                        //                       // totalWeightController
                        //                       //     .text = (double.parse(
                        //                       //             totalWeightController
                        //                       //                 .text) -
                        //                       //         double.parse(
                        //                       //             customerGoldStockController
                        //                       //                 .text))
                        //                       //     .toStringAsFixed(2);
                        //                     } else if (selectedProductType ==
                        //                             'Silver_Ornament' ||
                        //                         selectedProductType ==
                        //                             'Silver_Bullion') {
                        //                       // totalWeightController
                        //                       //     .text = (double.parse(
                        //                       //             totalWeightController
                        //                       //                 .text) -
                        //                       //         double.parse(
                        //                       //             customerSilverStockController
                        //                       //                 .text))
                        //                       //     .toStringAsFixed(2);
                        //                     }
                        //                     // itemNameExchangeController.text = 'Gold';
                        //                     setState(() {});
                        //                   }
                        //                   if (purchaseDetailsData[
                        //                               'Payment_Type'] ==
                        //                           'Credit' ||
                        //                       purchaseDetailsData[
                        //                               'Payment_Type'] ==
                        //                           'Cash' ||
                        //                       purchaseDetailsData[
                        //                               'Payment_Type'] ==
                        //                           'Bank' ||
                        //                       purchaseDetailsData[
                        //                               'Payment_Type'] ==
                        //                           'Credit_Exchange') {
                        //                     calculateTotalWeight();
                        //                   }

                        //                   if (purchaseDetailsData[
                        //                           'Payment_Type'] ==
                        //                       'Credit') {
                        //                     calculateTotalAmountIfCredit();
                        //                   }
                        //                 },
                        //               );
                        //             }).toList(),
                        //             hint: Text('Select Payment',
                        //                 style: TextStyle(
                        //                     fontSize: formWidth * 0.06,
                        //                     color: Colors.black,
                        //                     fontWeight: FontWeight.w400)),
                        //             style: TextStyle(
                        //                 fontSize: formWidth * 0.06,
                        //                 color: Colors.black,
                        //                 fontWeight: FontWeight.w400),
                        //             iconDisabledColor: Colors.black,
                        //             iconEnabledColor: Colors.black,
                        //             dropdownColor: Colors.white,
                        //             // alignment: Alignment.center,
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 selectedPaymentType = value as String;
                        //               });
                        //             },
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        width: 400,
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text('Customer/Supplier Details'),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Customer C/B : '),
                                    Container(
                                      width: 200,
                                      height: 20,
                                      child: TextField(
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          controller:
                                              customerCreditBalanceController),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Merchant C/B : '),
                                    Container(
                                      width: 200,
                                      height: 20,
                                      child: TextField(
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          controller:
                                              merchantCreditBalanceController),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Merchant Cash/B : '),
                                    Container(
                                      width: 200,
                                      height: 20,
                                      child: TextField(
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          controller:
                                              merchantCashBalanceController),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Old/Bal Gold Stock: '),
                                    Container(
                                      width: 200,
                                      height: 18,
                                      child: TextField(
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          controller:
                                              customerGoldStockController),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Old/Bal Silver Stock : '),
                                    Container(
                                      width: 200,
                                      height: 18,
                                      child: TextField(
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          controller:
                                              customerSilverStockController),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 90),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formName('Name'),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Container(
                                width: formWidth * 0.6,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    onTap: () {
                                      setState(() {
                                        Provider.of<ApiCalls>(context,
                                                listen: false)
                                            .customerList
                                            .clear();
                                        searchSelected = true;
                                      });
                                    },
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                        hintText: 'Enter Name',
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        // showError('FirmCode');
                                        return 'Name Cannot be empty';
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value.length >= 2) {
                                        setState(() {
                                          searchCustomer(value);
                                        });
                                      } else {
                                        setState(() {});
                                      }
                                    },
                                    onSaved: (value) {
                                      purchaseDetailsData['Creditor_Name'] =
                                          value;
                                    },
                                  ),
                                ),
                              ),
                              searchSelected == true
                                  ? Container(
                                      width: 185,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Consumer<ApiCalls>(
                                        builder: (context, value, child) {
                                          return ListView.builder(
                                            controller: listController,
                                            itemCount:
                                                value.customerList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CustomerSearchList(
                                                  customer:
                                                      value.customerList[index],
                                                  select: selectCustomerData);
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          IconButton(
                              onPressed: () => addCustomer(size),
                              icon: Icon(
                                Icons.add,
                                color: ProjectColors.themeColor,
                              ))
                        ],
                      ),

                      // gap(),
                      // Row(
                      //   children: [
                      //     formName('Customer C/B'),
                      //     const SizedBox(
                      //       width: 20,
                      //     ),
                      //     Container(
                      //       width: formWidth * 0.6,
                      //       height: 40,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: Colors.white,
                      //         border: Border.all(color: Colors.black26),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 12, vertical: 6),
                      //         child: TextFormField(
                      //           controller: customerCreditBalanceController,
                      //           decoration: const InputDecoration(
                      //               hintText: 'Enter Bill Number',
                      //               border: InputBorder.none),
                      //           validator: (value) {
                      //             if (value!.isEmpty) {
                      //               // showError('FirmCode');
                      //               return 'Bill Number Cannot be empty';
                      //             }
                      //           },
                      //           onSaved: (value) {
                      //             purchaseDetailsData['Bill_Number'] =
                      //                 value;
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // gap(),
                      // Row(
                      //   children: [
                      //     formName('Merchant C/B'),
                      //     const SizedBox(
                      //       width: 20,
                      //     ),
                      //     Container(
                      //       width: formWidth * 0.6,
                      //       height: 40,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: Colors.white,
                      //         border: Border.all(color: Colors.black26),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 12, vertical: 6),
                      //         child: TextFormField(
                      //           controller: merchantCreditBalanceController,
                      //           decoration: const InputDecoration(
                      //               hintText: 'Enter Bill Number',
                      //               border: InputBorder.none),
                      //           validator: (value) {
                      //             if (value!.isEmpty) {
                      //               // showError('FirmCode');
                      //               return 'Bill Number Cannot be empty';
                      //             }
                      //           },
                      //           onSaved: (value) {
                      //             purchaseDetailsData['Bill_Number'] =
                      //                 value;
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Item Information',
                      style: ProjectStyles.headingStyle()
                          .copyWith(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              tableHeaderContainer('Item Name'),

                              tableHeaderContainer('Gross Wt.'),
                              tableHeaderContainer('Melt'),
                              tableHeaderContainer('Wastage'),
                              tableHeaderContainer('%'),
                              tableHeaderContainer('Net Wt.'),
                              // tableHeaderContainer('Item Qty'),
                              tableHeaderContainer('Rate'),
                              // tableHeaderContainer('Pcs'),
                              tableHeaderContainer('Total Amount'),
                              selectedProductType == 'Gold_Ornament' &&
                                          nameController.text != '' ||
                                      selectedProductType ==
                                              'Silver_Ornament' &&
                                          nameController.text != '' ||
                                      selectedProductType ==
                                              'Old_Gold_Ornament' &&
                                          nameController.text != '' ||
                                      selectedProductType ==
                                              'Old_Silver_Ornament' &&
                                          nameController.text != ''
                                  ? IconButton(
                                      onPressed: () {
                                        increaseRowCount(0);
                                      },
                                      icon: const Icon(Icons.add))
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          selectedProductType == 'Gold_Bullion' &&
                                      nameController.text != '' ||
                                  selectedProductType == 'Silver_Bullion' &&
                                      nameController.text != ''
                              ? Row(
                                  children: [
                                    tableDataContainer(itemNameController,
                                        'Item_Name', itemNameFocus),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    tableDataContainer(grossWeightController,
                                        'Gross_Weight', grossWeightFocus),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    tableDataContainer(
                                        meltController, 'Melt', meltFocus),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    tableDataContainer(wastageController,
                                        'Wastage', wastageFocus),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    tableDataContainer(
                                        totalPercentageController,
                                        'Total Percentage',
                                        totalPercentageFocus),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    tableDataContainer(netWtController,
                                        'Net_Weight', netWtFocus),
                                    // const SizedBox(
                                    //   width: 40,
                                    // ),
                                    // tableDataContainer(
                                    //     itemQtyController, 'Item_Qty'),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    tableDataContainer(
                                        rateController, 'Rate', rateFocus),
                                    // const SizedBox(
                                    //   width: 20,
                                    // ),
                                    // tableDataContainer(
                                    //     pieceController, 'Pieces', piecesFocus),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    tableDataContainer(amountController,
                                        'Total_Amount', amountFocus),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          selectedProductType == 'Gold_Ornament' &&
                                      nameController.text != '' ||
                                  selectedProductType == 'Silver_Ornament' &&
                                      nameController.text != '' ||
                                  selectedProductType == 'Old_Gold_Ornament' &&
                                      nameController.text != '' ||
                                  selectedProductType ==
                                          'Old_Silver_Ornament' &&
                                      nameController.text != ''
                              ? Column(
                                  children: [
                                    AddPurchaseItems(
                                      itemList: itemList,
                                      decreaseRowCount: decreaseRowCount,
                                      increaseRowCount: increaseRowCount,
                                      index: 0,
                                      itemCount: itemCount,
                                      data: recordData,
                                      key: UniqueKey(),
                                    ),
                                    itemCount >= 2
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: AddPurchaseItems(
                                              itemList: itemList,
                                              decreaseRowCount:
                                                  decreaseRowCount,
                                              increaseRowCount:
                                                  increaseRowCount,
                                              index: 1,
                                              itemCount: itemCount,
                                              data: recordData,
                                              key: UniqueKey(),
                                            ),
                                          )
                                        : const SizedBox(),
                                    itemCount >= 3
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: AddPurchaseItems(
                                              itemList: itemList,
                                              decreaseRowCount:
                                                  decreaseRowCount,
                                              increaseRowCount:
                                                  increaseRowCount,
                                              index: 2,
                                              itemCount: itemCount,
                                              data: recordData,
                                              key: UniqueKey(),
                                            ),
                                          )
                                        : const SizedBox(),
                                    itemCount >= 4
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: AddPurchaseItems(
                                              itemList: itemList,
                                              decreaseRowCount:
                                                  decreaseRowCount,
                                              increaseRowCount:
                                                  increaseRowCount,
                                              index: 3,
                                              itemCount: itemCount,
                                              data: recordData,
                                              key: UniqueKey(),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 34,
                  ),
                  selectedPaymentType == 'Exchange' ||
                          selectedPaymentType == 'Cash_Plus_Exchange' ||
                          selectedPaymentType == 'Credit_Plus_Exchange'
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Payment Information',
                            style: ProjectStyles.headingStyle()
                                .copyWith(color: Colors.black, fontSize: 20),
                          ),
                        )
                      : const SizedBox(),
                  selectedPaymentType == 'Exchange' ||
                          selectedPaymentType == 'Cash_Plus_Exchange' ||
                          selectedPaymentType == 'Credit_Plus_Exchange'
                      ? const SizedBox(
                          height: 24,
                        )
                      : const SizedBox(),
                  selectedPaymentType == 'Exchange' ||
                          selectedPaymentType == 'Cash_Plus_Exchange' ||
                          selectedPaymentType == 'Credit_Plus_Exchange'
                      ? Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      tableHeaderContainer('Item'),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      tableHeaderContainer('Gross Wt.'),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      tableHeaderContainer('Wastage (Pct)'),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      tableHeaderContainer('Net Wt.'),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      tableHeaderContainer('Amount'),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      tableDataContainer(
                                          itemNameExchangeController,
                                          'Exchange_Item_Name',
                                          exchangeItemNameFocus),
                                      const SizedBox(
                                        width: 35,
                                      ),
                                      tableDataContainer(
                                          grossWeightExchangeController,
                                          'Exchange_Gross_Weight',
                                          exchangeGrossWeightFocus),
                                      // const SizedBox(
                                      //   width: 30,
                                      // ),
                                      // tableDataContainer(
                                      //     meltExchangeController,
                                      //     'Exchange_Melt_Weight',
                                      //     exchangeMeltWeightFocus),
                                      const SizedBox(
                                        width: 35,
                                      ),
                                      tableDataContainer(
                                          wastageExchangeController,
                                          'Exchange_Wastage',
                                          exchangeWastageFocus),
                                      // const SizedBox(
                                      //   width: 30,
                                      // ),
                                      // tableDataContainer(
                                      //     exchangeTotalPercentageController,
                                      //     'Exchange_Total_Percentage',
                                      //     exchangeTotalPercentageFocus),
                                      const SizedBox(
                                        width: 35,
                                      ),
                                      tableDataContainer(
                                          netWtExchangeController,
                                          'Exchange_Net_Weight',
                                          exchangeNetweightFocus),
                                      const SizedBox(
                                        width: 35,
                                      ),
                                      // tableDataContainer(itemQtyController),
                                      // const SizedBox(
                                      //   width: 40,
                                      // ),
                                      // tableDataContainer(rateController),
                                      // const SizedBox(
                                      //   width: 40,
                                      // ),
                                      Container(
                                          width: 150,
                                          height: 32,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: TextFormField(
                                              focusNode:
                                                  exchangeTotalAmountFocus,
                                              onChanged: (value) {
                                                // else if (name == 'Total_Exchange_Amount') {
                                                //   double amount = double.parse(totalAmountController.text) -
                                                //       double.parse(value.toString());
                                                //   totalAmountController.text = amount.toString();
                                                //   print('Total amount ${totalAmountController.text}');
                                                // }
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isCollapsed: true,
                                              ),
                                              controller:
                                                  amountExchangeController,
                                            ),
                                          )),
                                      // tableDataContainer(amountExchangeController,
                                      //     'Total_Exchange_Amount'),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Net Weight :',
                        style: ProjectStyles.drawerStyle()
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                          width: 200,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: totalWeightController,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Net Amount :',
                        style: ProjectStyles.drawerStyle()
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                          width: 200,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            enabled: true,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: totalAmountController,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      totalAmountController.text == '0.00'
                          ? const SizedBox()
                          : Row(
                              children: [
                                formName('Payment Type'),
                                const SizedBox(
                                  width: 25,
                                ),
                                Container(
                                  width: formWidth * 0.65,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(formWidth * 0.02),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedPaymentType,
                                        items: [
                                          'Cash',
                                          'Credit',
                                          // 'Exchange',
                                          'Bank',
                                          // 'Cash_Exchange',
                                          'Credit_Exchange'
                                        ].map<DropdownMenuItem<String>>((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            onTap: () {
                                              purchaseDetailsData[
                                                  'Payment_Type'] = e;
                                              if (purchaseDetailsData[
                                                      'Payment_Type'] ==
                                                  'Exchange') {
                                                // totalAmountController.text = '0';
                                                if (selectedProductType ==
                                                            'Gold_Ornament' &&
                                                        purchaseDetailsData[
                                                                'Payment_Type'] ==
                                                            'Exchange' ||
                                                    selectedProductType ==
                                                            'Gold_Bullion' &&
                                                        purchaseDetailsData[
                                                                'Payment_Type'] ==
                                                            'Exchange') {
                                                  // totalWeightController
                                                  //     .text = (double.parse(
                                                  //             totalWeightController
                                                  //                 .text) -
                                                  //         double.parse(
                                                  //             customerGoldStockController
                                                  //                 .text))
                                                  //     .toStringAsFixed(2);
                                                } else if (selectedProductType ==
                                                        'Silver_Ornament' ||
                                                    selectedProductType ==
                                                        'Silver_Bullion') {
                                                  // totalWeightController
                                                  //     .text = (double.parse(
                                                  //             totalWeightController
                                                  //                 .text) -
                                                  //         double.parse(
                                                  //             customerSilverStockController
                                                  //                 .text))
                                                  //     .toStringAsFixed(2);
                                                }
                                                // itemNameExchangeController.text = 'Gold';
                                                setState(() {});
                                              }
                                              if (purchaseDetailsData[
                                                          'Payment_Type'] ==
                                                      'Credit' ||
                                                  purchaseDetailsData[
                                                          'Payment_Type'] ==
                                                      'Cash' ||
                                                  purchaseDetailsData[
                                                          'Payment_Type'] ==
                                                      'Bank' ||
                                                  purchaseDetailsData[
                                                          'Payment_Type'] ==
                                                      'Credit_Exchange') {
                                                // calculateTotalWeight();
                                              }

                                              if (purchaseDetailsData[
                                                      'Payment_Type'] ==
                                                  'Credit') {
                                                // calculateTotalAmountIfCredit();
                                              }
                                            },
                                            child: Text(e,
                                                style: TextStyle(
                                                    fontSize: formWidth * 0.055,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          );
                                        }).toList(),
                                        hint: Text('Select Payment',
                                            style: TextStyle(
                                                fontSize: formWidth * 0.06,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400)),
                                        style: TextStyle(
                                            fontSize: formWidth * 0.06,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        iconDisabledColor: Colors.black,
                                        iconEnabledColor: Colors.black,
                                        dropdownColor: Colors.white,
                                        // alignment: Alignment.center,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPaymentType =
                                                value as String;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Cancel',
                                style: ProjectStyles.headingStyle(),
                              ))),
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: save,
                              child: Text(
                                'Save',
                                style: ProjectStyles.headingStyle(),
                              )))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  GlobalKey<FormState> _customerKey = GlobalKey();
  TextEditingController cusNameController = TextEditingController();
  TextEditingController idProffController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  var selectedCreditorTypeForAdding;
  var selectedIdProof;
  void saveNewCustomer() {
    Map<String, dynamic> newCustomer = {
      'Customer_Name': cusNameController.text,
      'Mobile_Number': mobileNumberController.text,
      'Creditor_Type': 'Customer',
      'Id_Proof': selectedIdProof,
      'Id_Number': idProffController.text,
      'Address': addressController.text,
      'Payable': openingBalanceController.text,
      'Created_Date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    print(newCustomer);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      EasyLoading.show();
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .addNewCustomer(newCustomer, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 200) {
          Get.back();
          successSnackbar('Successfully Added New Data');
        } else {
          failureSnackbar('Something Went Wrong Unable to Add Data');
        }
      });
    });
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
                        cusNameController,
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
                                value: e,
                                onTap: () {
                                  // purchaseDetailsData['Id_Proof'] = e;
                                  // firmId = e['Firm_Code'];
                                  // user['User_Role_Name'] = e['Role_Name'];
                                },
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
                                  if (cusNameController.text.length > 15) {
                                    nameValidation = false;
                                    nameValidationMessage =
                                        'customer name cannot be greater then 15 characters';
                                  } else if (cusNameController.text == '') {
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
}

class AddPurchaseItems extends StatefulWidget {
  AddPurchaseItems(
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
  State<AddPurchaseItems> createState() => _AddPurchaseItemsState();
}

class _AddPurchaseItemsState extends State<AddPurchaseItems> {
  Map<String, dynamic> billDetails = {};

  TextEditingController itemNameController = TextEditingController();
  TextEditingController grossWeightController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  TextEditingController wastageController = TextEditingController();
  TextEditingController netWtController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  FocusNode itemNameFocus = FocusNode();
  FocusNode grossWeightFocus = FocusNode();
  FocusNode totalAmountFocus = FocusNode();

  FocusNode wastageFocus = FocusNode();
  FocusNode netWtFocus = FocusNode();
  FocusNode itemQtyFocus = FocusNode();
  FocusNode rateFocus = FocusNode();
  var selectedItem;
  FocusNode meltFocus = FocusNode();
  TextEditingController meltController = TextEditingController();
  FocusNode percentageFocus = FocusNode();
  TextEditingController percentageController = TextEditingController();
  FocusNode piecesFocus = FocusNode();
  TextEditingController piecesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.itemList.isNotEmpty) {
      for (var data in widget.itemList) {
        if (data['Index'] == widget.index) {
          if (data['Key'] == 'Item_Name') {
            itemNameController.text = data['Value'];
          } else if (data['Key'] == 'Gross_Weight') {
            grossWeightController.text = data['Value'];
          } else if (data['Key'] == 'Total_Amount') {
            totalAmountController.text = data['Value'] ?? '';
          } else if (data['Key'] == 'Wastage') {
            wastageController.text = data['Value'];
          } else if (data['Key'] == 'Net_Weight') {
            netWtController.text = data['Value'];
          } else if (data['Key'] == 'Rate') {
            rateController.text = data['Value'];
          } else if (data['Key'] == 'Melt') {
            meltController.text = data['Value'];
          } else if (data['Key'] == 'Percentage') {
            percentageController.text = data['Value'];
          } else if (data['Key'] == 'Pieces') {
            piecesController.text = data['Value'].toString();
          }
        }
      }
    }
    itemNameFocus.addListener(_onItemFocusChange);
    grossWeightFocus.addListener(_onWeightFocusChange);
    totalAmountFocus.addListener(_onAmountFocusChange);

    wastageFocus.addListener(_onWastageFocusChange);
    netWtFocus.addListener(_onNetWtFocusChange);
    itemQtyFocus.addListener(_onItemQtyFocusChange);
    rateFocus.addListener(_onRateFocusChange);
    meltFocus.addListener(_onMeltFocusChange);
    percentageFocus.addListener(_onPercentageFocusChange);
    piecesFocus.addListener(_onPiecesFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    itemNameFocus.removeListener(_onItemFocusChange);
    itemNameFocus.dispose();
    grossWeightFocus.removeListener(_onWeightFocusChange);
    grossWeightFocus.dispose();
    totalAmountFocus.removeListener(_onAmountFocusChange);
    totalAmountFocus.dispose();
    wastageFocus.removeListener(_onWastageFocusChange);
    wastageFocus.dispose();
    netWtFocus.removeListener(_onNetWtFocusChange);
    netWtFocus.dispose();
    itemQtyFocus.removeListener(_onItemQtyFocusChange);
    itemQtyFocus.dispose();
    rateFocus.removeListener(_onRateFocusChange);
    rateFocus.dispose();
    meltFocus.removeListener(_onMeltFocusChange);
    meltFocus.dispose();
    percentageFocus.removeListener(_onPercentageFocusChange);
    percentageFocus.dispose();
    piecesFocus.removeListener(_onPiecesFocusChange);
    piecesFocus.dispose();
  }

  void _onMeltFocusChange() {
    debugPrint("Focus: ${meltFocus.hasFocus.toString()}");

    if (meltFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Melt',
        'Index': widget.index,
        'Value': meltController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
      calculateTotalPercentageAndNetWeight();
      Map<String, dynamic> netWtdata = {
        'Key': 'Net_Weight',
        'Index': widget.index,
        'Value': netWtController.text,
      };
      widget.data(netWtdata);
      Map<String, dynamic> percentageData = {
        'Key': 'Percentage',
        'Index': widget.index,
        'Value': percentageController.text,
      };
      widget.data(percentageData);
      Map<String, dynamic> totalAmount = {
        'Key': 'Total_Amount',
        'Index': widget.index,
        'Value': totalAmountController.text,
      };
      widget.data(totalAmount);
    }
  }

  void _onPercentageFocusChange() {
    debugPrint("Focus: ${percentageFocus.hasFocus.toString()}");

    if (percentageFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Percentage',
        'Index': widget.index,
        'Value': percentageController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
    }
  }

  void _onPiecesFocusChange() {
    debugPrint("Focus: ${piecesFocus.hasFocus.toString()}");

    if (piecesFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Pieces',
        'Index': widget.index,
        'Value': piecesController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
    }
  }

  void _onItemFocusChange() {
    debugPrint("Focus: ${itemNameFocus.hasFocus.toString()}");

    if (itemNameFocus.hasFocus == false) {
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
    if (grossWeightFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Gross_Weight',
        'Index': widget.index,
        'Value': grossWeightController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
      calculateTotalPercentageAndNetWeight();
      Map<String, dynamic> netWtdata = {
        'Key': 'Net_Weight',
        'Index': widget.index,
        'Value': netWtController.text,
      };
      widget.data(netWtdata);
      Map<String, dynamic> percentageData = {
        'Key': 'Percentage',
        'Index': widget.index,
        'Value': percentageController.text,
      };
      widget.data(percentageData);
      Map<String, dynamic> totalAmount = {
        'Key': 'Total_Amount',
        'Index': widget.index,
        'Value': totalAmountController.text,
      };
      widget.data(totalAmount);
    }
  }

  void _onAmountFocusChange() {
    debugPrint("Focus: ${totalAmountFocus.hasFocus.toString()}");

    if (totalAmountFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Total_Amount',
        'Index': widget.index,
        'Value': totalAmountController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
    }
  }

  void _onWastageFocusChange() {
    debugPrint("Focus: ${wastageFocus.hasFocus.toString()}");

    if (wastageFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Wastage',
        'Index': widget.index,
        'Value': wastageController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
      calculateTotalPercentageAndNetWeight();
      Map<String, dynamic> netWtdata = {
        'Key': 'Net_Weight',
        'Index': widget.index,
        'Value': netWtController.text,
      };
      widget.data(netWtdata);
      Map<String, dynamic> percentageData = {
        'Key': 'Percentage',
        'Index': widget.index,
        'Value': percentageController.text,
      };
      widget.data(percentageData);
      Map<String, dynamic> totalAmount = {
        'Key': 'Total_Amount',
        'Index': widget.index,
        'Value': totalAmountController.text,
      };
      widget.data(totalAmount);
    }
  }

  void _onNetWtFocusChange() {
    debugPrint("Focus: ${netWtFocus.hasFocus.toString()}");

    if (netWtFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Net_Weight',
        'Index': widget.index,
        'Value': netWtController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
    }
  }

  void _onItemQtyFocusChange() {
    debugPrint("Focus: ${itemQtyFocus.hasFocus.toString()}");

    if (itemQtyFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Item_Quantity',
        'Index': widget.index,
        'Value': itemQtyController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
    }
  }

  void _onRateFocusChange() {
    debugPrint("Focus: ${rateFocus.hasFocus.toString()}");

    if (rateFocus.hasFocus == false) {
      Map<String, dynamic> data = {
        'Key': 'Rate',
        'Index': widget.index,
        'Value': rateController.text,
      };
      debugPrint(data.toString());
      widget.data(data);
      calculateTotalAmount();
      Map<String, dynamic> totalAmount = {
        'Key': 'Total_Amount',
        'Index': widget.index,
        'Value': totalAmountController.text,
      };
      widget.data(totalAmount);
    }
  }

  calculateTotalAmount() {
    totalAmountController.text = rateController.text != ''
        ? rateController.text.isAlphabetOnly
            ? ''
            : (double.parse(rateController.text) *
                    double.parse(netWtController.text))
                .toStringAsFixed(2)
        : '';
  }

  calculateTotalPercentageAndNetWeight() {
    percentageController.text = (double.parse(
                meltController.text == '' || meltController.text.isAlphabetOnly
                    ? '0'
                    : meltController.text) +
            double.parse(wastageController.text == '' ||
                    wastageController.text.isAlphabetOnly
                ? '0'
                : wastageController.text))
        .toStringAsFixed(2);

    netWtController.text = ((double.parse(grossWeightController.text == '' ||
                        grossWeightController.text.isAlphabetOnly
                    ? '0'
                    : grossWeightController.text) *
                double.parse(percentageController.text)) /
            100)
        .toStringAsFixed(2);

    totalAmountController.text = rateController.text != ''
        ? rateController.text.isAlphabetOnly
            ? ''
            : (double.parse(rateController.text) *
                    double.parse(netWtController.text))
                .toStringAsFixed(2)
        : '';
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
        // Padding(
        //   padding: EdgeInsets.only(bottom: bottomPadding),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Container(
        //         width: formWidth * 0.35,
        //         padding: const EdgeInsets.only(bottom: 12),
        //         child: const Text.rich(
        //           TextSpan(children: [
        //             TextSpan(text: 'Select Item'),
        //             TextSpan(text: '*', style: TextStyle(color: Colors.red))
        //           ]),
        //         ),
        //       ),
        //       Container(
        //         width: formWidth * 0.35,
        //         height: 40,
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(8),
        //           color: Colors.white,
        //           border: Border.all(color: Colors.black26),
        //         ),
        //         child: DropdownButtonHideUnderline(
        //           child: DropdownButton(
        //             value: selectedItem,
        //             items: [
        //               'Gold',
        //               'Silver',
        //             ].map<DropdownMenuItem<String>>((e) {
        //               return DropdownMenuItem(
        //                 child: Text(
        //                   e,
        //                   style: ProjectStyles.invoiceheadingStyle().copyWith(
        //                       fontSize: formWidth * 0.04, color: Colors.black),
        //                 ),
        //                 value: e,
        //                 onTap: () {
        //                   // billDetails['Old_Item_Name'] = e;
        //                   Map<String, dynamic> data = {
        //                     'Key': 'Item',
        //                     'Index': widget.index,
        //                     'Value': e,
        //                   };
        //                   debugPrint(data.toString());
        //                   widget.data(data);
        //                   // firmId = e['Firm_Code'];
        //                   // user['User_Role_Name'] = e['Role_Name'];
        //                 },
        //               );
        //             }).toList(),
        //             hint: Text(
        //               'Select Item',
        //               style: ProjectStyles.invoiceheadingStyle().copyWith(
        //                   fontSize: formWidth * 0.04, color: Colors.black),
        //             ),
        //             style: ProjectStyles.invoiceheadingStyle().copyWith(
        //                 fontSize: formWidth * 0.04, color: Colors.black),
        //             iconDisabledColor: Colors.black,
        //             iconEnabledColor: Colors.black,
        //             dropdownColor: Colors.white,
        //             alignment: Alignment.center,
        //             onChanged: (value) {
        //               setState(() {
        //                 selectedItem = value as String;
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   width: formWidth * 0.1,
        // ),
        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              focusNode: itemNameFocus,
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
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              focusNode: grossWeightFocus,
              controller: grossWeightController,
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
        const SizedBox(
          width: 20,
        ),

        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              focusNode: meltFocus,
              controller: meltController,
              decoration: const InputDecoration(
                  hintText: 'Enter Melt', border: InputBorder.none),
              validator: (value) {
                if (value!.isEmpty) {
                  // showError('FirmCode');
                  return 'Melt cannot be empty';
                }
              },
              onSaved: (value) {
                billDetails['Melt'] = value;
              },
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),

        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              focusNode: wastageFocus,
              controller: wastageController,
              decoration: const InputDecoration(
                  hintText: 'Enter Wastage', border: InputBorder.none),
              validator: (value) {
                if (value!.isEmpty) {
                  // showError('FirmCode');
                  return 'Wastage cannot be empty';
                }
              },
              onSaved: (value) {
                billDetails['Wastage'] = value;
              },
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              enabled: false,
              focusNode: percentageFocus,
              controller: percentageController,
              decoration: const InputDecoration(
                  hintText: 'Enter Percentage', border: InputBorder.none),
              validator: (value) {
                if (value!.isEmpty) {
                  // showError('FirmCode');
                  return 'Percentage cannot be empty';
                }
              },
              onSaved: (value) {
                billDetails['Percentage'] = value;
              },
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              enabled: false,
              focusNode: netWtFocus,
              controller: netWtController,
              decoration: const InputDecoration(
                  hintText: 'Enter Net Weight', border: InputBorder.none),
              validator: (value) {
                // if (value!.isEmpty) {
                //   // showError('FirmCode');
                //   return 'Item name cannot be empty';
                // }
              },
              onSaved: (value) {
                billDetails['Net_Weight'] = value;
              },
            ),
          ),
        ),
        // const SizedBox(
        //   width: 40,
        // ),
        // Container(
        //   width: 160,
        //   height: 40,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(8),
        //     color: Colors.white,
        //     border: Border.all(color: Colors.black26),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //     child: TextFormField(
        //       focusNode: itemQtyFocus,
        //       controller: itemQtyController,
        //       decoration: const InputDecoration(
        //           hintText: 'Enter Item Qty', border: InputBorder.none),
        //       validator: (value) {
        //         // if (value!.isEmpty) {
        //         //   // showError('FirmCode');
        //         //   return 'Item name cannot be empty';
        //         // }
        //       },
        //       onSaved: (value) {
        //         billDetails['Item_Qty'] = value;
        //       },
        //     ),
        //   ),
        // ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 140,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              focusNode: rateFocus,
              controller: rateController,
              decoration: const InputDecoration(
                  hintText: 'Enter Rate', border: InputBorder.none),
              validator: (value) {
                if (value!.isEmpty) {
                  // showError('FirmCode');
                  return 'Rate cannot be empty';
                }
              },
              onSaved: (value) {
                billDetails['Rate'] = value;
              },
            ),
          ),
        ),
        // const SizedBox(
        //   width: 20,
        // ),
        // Container(
        //   width: 140,
        //   height: 40,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(8),
        //     color: Colors.white,
        //     border: Border.all(color: Colors.black26),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //     child: TextFormField(
        //       focusNode: piecesFocus,
        //       controller: piecesController,
        //       decoration: const InputDecoration(
        //           hintText: 'Enter pcs', border: InputBorder.none),
        //       validator: (value) {
        //         if (value!.isEmpty) {
        //           // showError('FirmCode');
        //           return 'piece cannot be empty';
        //         }
        //       },
        //       onSaved: (value) {
        //         billDetails['Pieces'] = value;
        //       },
        //     ),
        //   ),
        // ),
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            Container(
              width: 140,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: TextFormField(
                  focusNode: totalAmountFocus,
                  controller: totalAmountController,
                  decoration: const InputDecoration(
                      hintText: 'Enter amount', border: InputBorder.none),
                  validator: (value) {
                    if (value!.isEmpty) {
                      // showError('FirmCode');
                      return 'Amount cannot be empty';
                    }
                  },
                  onSaved: (value) {
                    billDetails['Total_Amount'] = value;
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            // widget.index + 1 == widget.itemCount
            //     ? IconButton(
            //         onPressed: () {
            //           widget.increaseRowCount(widget.index);
            //         },
            //         icon: const Icon(Icons.add))
            //     :
            IconButton(
                onPressed: () {
                  widget.decreaseRowCount(widget.index);
                },
                icon: const Icon(Icons.remove))
          ],
        ),

        // Padding(
        //   padding: EdgeInsets.only(bottom: bottomPadding),
        //   child:
        // ),
      ],
    );
  }
}

// Get.dialog(Dialog(
//   child: StatefulBuilder(
//     builder: (BuildContext context, setState) {
//       return Container(
//         width: size.width * 0.5,
//         height: size.height * 0.6,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10)),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: size.width * 0.02,
//             vertical: size.height * 0.02,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Add Purchases',
//                   style: ProjectStyles.headingStyle()
//                       .copyWith(color: Colors.black),
//                 ),
//                 SizedBox(
//                   height: size.height * 0.03,
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: formWidth,
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: const Text.rich(
//                         TextSpan(children: [
//                           TextSpan(text: 'Item Name'),
//                           TextSpan(
//                               text: '*',
//                               style: TextStyle(color: Colors.red))
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       width: formWidth,
//                       height: formheight,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black26),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         child: TextFormField(
//                           decoration: const InputDecoration(
//                               hintText: 'Enter Item Name',
//                               border: InputBorder.none),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               // showError('FirmCode');
//                               return 'Item Name cannot be empty';
//                             }
//                           },
//                           onSaved: (value) {
//                             purchaseDetails['Item_Name'] = value;
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: size.height * 0.02,
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: formWidth,
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: const Text.rich(
//                         TextSpan(children: [
//                           TextSpan(text: 'Amount'),
//                           TextSpan(
//                               text: '*',
//                               style: TextStyle(color: Colors.red))
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       width: formWidth,
//                       height: formheight,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black26),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         child: TextFormField(
//                           decoration: const InputDecoration(
//                               hintText: 'Enter Amount',
//                               border: InputBorder.none),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               // showError('FirmCode');
//                               return 'Amount cannot be empty';
//                             }
//                           },
//                           onSaved: (value) {
//                             purchaseDetails['Amount'] = value;
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: size.height * 0.02,
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: formWidth,
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: const Text.rich(
//                         TextSpan(children: [
//                           TextSpan(text: 'Description'),
//                           // TextSpan(
//                           //     text: '*',
//                           //     style: TextStyle(color: Colors.red))
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       width: formWidth,
//                       height: formheight + 20,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black26),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         child: TextFormField(
//                           decoration: const InputDecoration(
//                               hintText: 'Enter Description',
//                               border: InputBorder.none),
//                           validator: (value) {},
//                           onSaved: (value) {
//                             purchaseDetails['Description'] =
//                                 value;
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: size.height * 0.04,
//                 ),
//                 Container(
//                   width: formWidth,
//                   height: formheight,
//                   child: ElevatedButton(
//                     onPressed: save,
//                     child: const Text('Save'),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   ),
// ));
