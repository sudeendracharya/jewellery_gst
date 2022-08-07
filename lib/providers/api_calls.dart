import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/add_billing_screen.dart';
import 'classes.dart';

class ApiCalls with ChangeNotifier {
  // var baseUrl = 'http://127.0.0.1:8000/';
  var baseUrl = 'https://jewelleryinvoiceapp.herokuapp.com/';

  List _invoideList = [];

  var token;

  List _allCustomerList = [];

  List _purchaseList = [];

  Map<String, dynamic> _individualPurchaseInvoice = {};

  Map<String, dynamic> _individualCustomerDetails = {};

  List _convertedOldItemList = [];

  Map<String, dynamic> _dailyReport = {};

  Map<String, dynamic> _profitAndLossSheet = {};

  List _expenseList = [];

  Map<String, dynamic> _cashReport = {};

  List _temproryPurchaseList = [];

  Map<String, dynamic> _cashDetails = {};

  Map<String, dynamic> cusPaymentSheet = {};

  List<CustomerAdvance> advanceDetailsData = [];

  List<CustomerInvoiceTotal> invoiceItemDetails = [];

  Map<String, dynamic> get cusPaymentSheetData {
    return cusPaymentSheet;
  }

  Map<String, dynamic> get cashReport {
    return _cashReport;
  }

  Map<String, dynamic> get cashDetails {
    return _cashDetails;
  }

  Map<String, dynamic> get profitAndLossSheet {
    return _profitAndLossSheet;
  }

  Map<String, dynamic> get dailyReport {
    return _dailyReport;
  }

  List get convertedOldItemList {
    return _convertedOldItemList;
  }

  List<CustomerInvoiceTotal> get customerInvoiceItemDetails {
    return invoiceItemDetails;
  }

  List<CustomerAdvance> get customerAdvanceDetailsData {
    return advanceDetailsData;
  }

  List get temproryPurchaseList {
    return _temproryPurchaseList;
  }

  List get expenseList {
    return _expenseList;
  }

  Map<String, dynamic> get individualCustomerDetails {
    return _individualCustomerDetails;
  }

  Map<String, dynamic> get individualPurchaseInvoice {
    return _individualPurchaseInvoice;
  }

  set tokenId(var tokenData) {
    token = tokenData;
    print(token);
  }

  Map<String, dynamic> _singleSalesInvoiceData = {};

  List _purchaseReportList = [];

  List _salesReportList = [];

  double _totalSaleAmount = 0;

  double _totalPurchaseAmount = 0;

  Map<String, dynamic> _profileData = {};

  Map<String, dynamic> _balanceSheet = {};

  Map<String, dynamic> logException = {};

  List _customersList = [];

  List get customerList {
    return _customersList;
  }

  List get purchaseList {
    return _purchaseList;
  }

  List get allCustomerList {
    return _allCustomerList;
  }

  Map<String, dynamic> get profileData {
    return _profileData;
  }

  Map<String, dynamic> get balanceSheet {
    return _balanceSheet;
  }

  Map<String, dynamic> get singleSalesInvoiceData {
    return _singleSalesInvoiceData;
  }

  List get invoicelist {
    return _invoideList;
  }

  double get totalSaleAmount {
    return _totalSaleAmount;
  }

  double get totalPurchaseAmount {
    return _totalPurchaseAmount;
  }

  List get salesReportList {
    return _salesReportList;
  }

  List get purchaseReportList {
    return _purchaseReportList;
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userData')) {
      prefs.remove('userData');
    }

    Get.offAllNamed('/');
  }

  Future<void> dailyStockAdjustment(var token) async {
    final url = Uri.parse('${baseUrl}business/adjust-daily-stock/');

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print('search result ${response.body}');
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSalesInvoiceId(var token) async {
    final url = Uri.parse('${baseUrl}invoice/latest-sales-id/');

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print('search result ${response.body}');
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        return responseData['latest_sales_id'];
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getPurchaseInvoiceId(var token) async {
    final url = Uri.parse('${baseUrl}purchase/latest-purchase-id/');

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print('search result ${response.body}');
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        return responseData['latest_purchase_id'];
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<void> searchCustomer(var string, var token) async {
    final url = Uri.parse(
        '${baseUrl}customer/customer-search/?search=${string.toString()}');

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print('search result ${response.body}');
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        _customersList.clear();
        var responseData = json.decode(response.body);

        _customersList = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }
    } catch (e) {
      EasyLoading.dismiss();

      rethrow;
    }
  }

  //  Future<void> purchaseReport(var string, var token) async {
  //   final url = Uri.parse(
  //       '${baseUrl}customer/customer-search/?search=${string.toString()}');

  //   try {
  //     var response = await http.get(
  //       url,
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8",
  //         "Authorization": 'Token $token',
  //       },
  //       // body: json.encode(batchCode),
  //     );
  //     print(response.statusCode);
  //     print('search result ${response.body}');

  //     if (response.statusCode == 200) {
  //       var responseData = json.decode(response.body);

  //       _customersList = responseData;
  //       notifyListeners();
  //     } else if (response.statusCode == 404) {
  //       var responseData = json.decode(response.body) as Map<String, dynamic>;
  //       logException = responseData;

  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<int> sendInvoice(var data, var token) async {
    final url = Uri.parse('${baseUrl}invoice/invoice-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        getSingleInvoice(responseData['Invoice_Id'], token).then((value) {
          Map<String, dynamic> exportData = singleSalesInvoiceData;
          double grossAmount = 0;
          exportPdf(
              exportData['Item_Details'],
              exportData['invoice'],
              exportData['Old_Items'],
              grossAmount,
              exportData['invoice']['Total_Amount']);
        });
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> revertSalesInvoice(var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}invoice/revert-invoice-details/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        getSingleInvoice(responseData['Invoice_Id'], token);
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateSalesInvoice(var id, var data, var token) async {
    final url =
        Uri.parse('${baseUrl}invoice/update-revert-invoice-details/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 202 || response.statusCode == 200) {
        var responseData = json.decode(response.body);
        getSingleInvoice(responseData['Invoice_Id'], token).then((value) {
          Map<String, dynamic> exportData = singleSalesInvoiceData;
          double grossAmount = 0;
          exportPdf(
              exportData['Item_Details'],
              exportData['invoice'],
              exportData['Old_Items'],
              grossAmount,
              exportData['invoice']['Total_Amount']);
        });
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> addNewCustomer(var data, var token) async {
    final url = Uri.parse('${baseUrl}customer/customer-list/customer/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        // getSingleInvoice(responseData['Invoice_Id']);
      }
      if (response.statusCode == 406) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['Message'] ??
              'Something Went Wrong please try again',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateCustomer(var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}customer/customer-details/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        // getSingleInvoice(responseData['Invoice_Id']);
      }
      if (response.statusCode == 406) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['Message'] ??
              'Something Went Wrong please try again',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getInvoice(var token) async {
    final url = Uri.parse('${baseUrl}invoice/invoice-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        _invoideList = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getSingleInvoice(var id, var token) async {
    final url = Uri.parse('${baseUrl}invoice/invoice-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _singleSalesInvoiceData = responseData;

        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> deleteSalesInvoice(var id, var token) async {
    final url = Uri.parse('${baseUrl}invoice/invoice-details/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> deletePurchaseInvoice(var id, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-details/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getCustomersList(var token, String type) async {
    final url = Uri.parse('${baseUrl}customer/customer-list/$type/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      print('customer List  ${response.statusCode}');
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];

        if (responseData['CashAccount'].isNotEmpty) {
          _cashDetails = responseData['CashAccount'];
        }

        for (var data in responseData['Customer_Account']) {
          temp.add({
            "Customer_Id": data['Customer_Id'],
            "Customer_Name": data['Customer_Name'],
            "Mobile_Number": data['Mobile_Number'],
            "Creditor_Type": data['Creditor_Type'],
            "Id_Proof": data['Id_Proof'],
            "Id_Number": data['Id_Number'],
            "Address": data['Address'],
            "Payable": data['Payable'],
            "Receivable": data['Receivable'],
            "Customer_Gold_Stock": data['Customer_Gold_Stock'],
            "Customer_Silver_Stock": data['Customer_Silver_Stock'],
            'Customer_excess_cash': data['Customer_excess_cash'],
            "Created_on": data['Created_on'],
            "Created_Date": data['Created_Date'],
            'Is_Selected': false
          });
        }
        _allCustomerList = temp;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getExpenseList(var token) async {
    final url = Uri.parse('${baseUrl}purchase/expense-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Expense_Id": data['Expense_Id'],
            "Spender": data['Spender'],
            "Expense_Name": data['Expense_Name'],
            "Cash_Expense": data['Cash_Expense'],
            "Online_Expense": data['Online_Expense'],
            "Payment_Type": data['Payment_Type'],
            "Created_on": data['Created_on'],
            "Created_Date": data['Created_Date'],
            'Is_Selected': false,
          });
        }
        _expenseList = temp;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> addExpense(var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/expense-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);

      // if (response.statusCode == 200) {
      //   var responseData = json.decode(response.body);
      //   _expenseList = responseData;
      //   notifyListeners();
      // }
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateExpense(var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/expense-details/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);

      // if (response.statusCode == 200) {
      //   var responseData = json.decode(response.body);
      //   _expenseList = responseData;
      //   notifyListeners();
      // }
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> deleteExpense(var id, var token) async {
    final url = Uri.parse('${baseUrl}purchase/expense-details/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      print(response.statusCode);
      print(response.body);

      // if (response.statusCode == 200) {
      //   var responseData = json.decode(response.body);
      //   _expenseList = responseData;
      //   notifyListeners();
      // }
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> addCustomerCreditInvoice(var data, var token) async {
    final url = Uri.parse('${baseUrl}customer/credit-invoice-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        fetchIndividualCustomerDetails(responseData['Customer_Id'], token);
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> fetchIndividualCustomerDetails(var id, var token) async {
    final url = Uri.parse('${baseUrl}customer/customer-report-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      print(response.statusCode);
      print('individual customer details ${response.body}');
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _individualCustomerDetails = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);
        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> fetchIndividualCustomerCreditInvoice(var id, var token) async {
    final url = Uri.parse('${baseUrl}customer/credit-invoice-detail/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data),
      );
      print(response.statusCode);
      print('individual customer credit invoice ${response.body}');

      // if (response.statusCode == 200) {
      //   var responseData = json.decode(response.body);
      //   _allCustomerList = responseData;
      //   notifyListeners();
      // }
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> convertOldItem(var data, var token) async {
    final url = Uri.parse('${baseUrl}invoice/coinage-metal-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 406) {
        var responseData = json.decode(response.body);
        Get.defaultDialog(
          title: 'Message',
          middleText: responseData['Message'] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }
      getConvertedOldItem(token);
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first,
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getConvertedOldItem(var token) async {
    final url = Uri.parse('${baseUrl}invoice/coinage-metal-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _convertedOldItemList = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first[0],
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendPurchaseInvoice(var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);

        return {
          'Status_Code': response.statusCode,
          'Id': responseData['Purchase_Id']
        };
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first,
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return {
        'Status_Code': response.statusCode,
      };
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePurchaseInvoice(
      var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-details/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);

        return {
          'Status_Code': response.statusCode,
          'Id': responseData['Purchase_Id']
        };
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first,
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return {
        'Status_Code': response.statusCode,
      };
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> sendPurchaseTemproryInvoice(var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/temp-purchase-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first[0],
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updatePurchaseTemproryInvoice(var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/temp-purchase-details/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first[0],
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> deletePurchaseTemproryInvoice(var id, var token) async {
    final url = Uri.parse('${baseUrl}purchase/temp-purchase-details/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first[0],
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getPurchaseInvoice(var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data)
      );
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _purchaseList = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first,
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getTemproryPurchaseInvoice(var token) async {
    final url = Uri.parse('${baseUrl}purchase/temp-purchase-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data)
      );
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _temproryPurchaseList = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first,
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTemproryIndividualPurchaseInvoice(
      var token, var id) async {
    final url = Uri.parse('${baseUrl}purchase/temp-purchase-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data)
      );
      if (response.statusCode == 403) {
        logOut();
      }
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData
        };
        // _purchaseList = responseData;

      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: responseData.keys.first,
          middleText: responseData.values.first[0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return {'Status_Code': response.statusCode};
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getSinglePurchaseInvoice(var id, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data)
      );
      print(response.statusCode);
      print('individual purchase invoice ${response.body}');
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _individualPurchaseInvoice = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateSinglePurchaseInvoiceDetails(
      var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-details/edit/$id/');
    try {
      final response = await http.patch(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateSinglePurchaseInvoiceAccountDetails(
      var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-details-edit/edit/$id/');
    try {
      final response = await http.patch(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateSinglePurchaseInvoiceItems(
      var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-details/$id/');
    try {
      final response = await http.patch(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateSingleSalesInvoice(var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}invoice/invoice-pure-items-edit/$id/');
    try {
      final response = await http.patch(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      // EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateSingleSalesInvoiceDetails(
      var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}invoice/invoice-details/$id/');
    try {
      final response = await http.patch(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> updateOldSingleSalesInvoice(var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}invoice/invoice-old-items-edit/$id/');
    try {
      final response = await http.patch(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getSalesReport(var data, var token) async {
    final url = Uri.parse('${baseUrl}invoice/sale-report-details/');
    print('date $data');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _salesReportList = responseData;

        // for (var data in responseData) {
        //   _totalSaleAmount = _totalSaleAmount +
        //       double.parse(data['Received_Amount'].toString());
        // }
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getPurchaseReport(var data, var token) async {
    final url = Uri.parse('${baseUrl}purchase/purchase-credit-report/');
    print('date $data');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      if (response.statusCode == 403) {
        logOut();
      }

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _purchaseReportList = responseData;

        // for (var data in responseData) {
        //   _totalPurchaseAmount =
        //       _totalPurchaseAmount + double.parse(data['Amount'].toString());
        // }
        notifyListeners();
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getProfileData(var token) async {
    // final url = Uri.parse('${baseUrl}purchase/profile-report-details/');
    final url = Uri.parse('${baseUrl}stock/stock-summery/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(data)
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _profileData = responseData;
        notifyListeners();
      }
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getBalanceSheet(var data, var token) async {
    // final url = Uri.parse('${baseUrl}invoice/balance-sheet-details/');
    final url = Uri.parse('${baseUrl}stock/balance-sheet-details/');
    try {
      final response = await http.post(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        Map<String, dynamic> temp = {};

        dynamic calculate(var data) {
          if (data == null) {
            return 0.0;
          } else {
            return double.parse(data.toString()).toPrecision(2);
          }
        }

        temp = {
          "Liabilities": {
            "Cash_In_Hand":
                calculate(responseData['Liabilities']['Cash_In_Hand']),
            "Cash_In_Bank":
                calculate(responseData['Liabilities']['Cash_In_Bank']),
            "Capital_Gold_Buliion_Amount": calculate(
                responseData['Liabilities']['Capital_Gold_Buliion_Amount']),
            "Capital_Gold_Ornament_Amount": calculate(
                responseData['Liabilities']['Capital_Gold_Ornament_Amount']),
            "Capital_Silver_Buliion_Amount": calculate(
                responseData['Liabilities']['Capital_Silver_Buliion_Amount']),
            "Capital_Silver_Ornament_Amount": calculate(
                responseData['Liabilities']['Capital_Silver_Ornament_Amount']),
            "Capital_Old_Gold_Amount": calculate(
                responseData['Liabilities']['Capital_Old_Gold_Amount']),
            "Capital_Old_Silver_Amount": calculate(
                responseData['Liabilities']['Capital_Old_Silver_Amount']),
            "Payable": calculate(responseData['Liabilities']['Payable']),
            "Profit": calculate(responseData['Liabilities']['Profit']),
            "Loss": calculate(responseData['Liabilities']['Loss']),
            "Liabilities":
                calculate(responseData['Liabilities']['Liabilities']),
          },
          "Asseets": {
            "Receivable": calculate(responseData['Asseets']['Receivable']),
            "advance_paid": calculate(responseData['Asseets']['advance_paid']),
            "Final_Closing_Cash":
                calculate(responseData['Asseets']['Final_Closing_Cash']),
            "Final_Closing_Stock":
                calculate(responseData['Asseets']['Final_Closing_Stock']),
            "Assets": calculate(responseData['Asseets']['Assets']),
          }
        };
        print(temp);
        _balanceSheet = temp;
        notifyListeners();
      }
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getProfitAndLossSheet(var data, var token) async {
    final url = Uri.parse('${baseUrl}stock/profitloss-details/');
    try {
      final response = await http.post(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _profitAndLossSheet = responseData;
        notifyListeners();
      }
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getDailyReport(var data, var token) async {
    final url = Uri.parse('${baseUrl}stock/stock-summery/');
    try {
      final response = await http.post(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _dailyReport = responseData;
        notifyListeners();
      }
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getCashBook(var data, var token) async {
    final url = Uri.parse('${baseUrl}business/cash-summery-list/');
    try {
      final response = await http.post(url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": 'Token $token',
          },
          body: json.encode(data));
      if (response.statusCode == 403) {
        logOut();
      }
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _cashReport = responseData;
        notifyListeners();
      }
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 404) {
        var responseData = json.decode(response.body);
        Get.defaultDialog(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: 'Alert',
            middleText: responseData['Message'],
            confirm: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Ok')));
      }
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> addAdvance(var id, var data, var token) async {
    final url = Uri.parse('${baseUrl}customer/customer-advance-list/$id/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      if (response.statusCode == 403) {
        logOut();
      }

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }

  Future<int> getcusPaymentSheet(var id, var token) async {
    final url = Uri.parse('${baseUrl}customer/customer-advance-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 403) {
        logOut();
      }
      // if (response.statusCode == 200) {
      //   var responseData = json.decode(response.body);
      //   List<CustomerAdvance> advanceDetails = [];
      //   for (var data in responseData) {
      //     advanceDetails.add(
      //       CustomerAdvance(
      //         advanceId: data['Advance_Id'].toString(),
      //         amount:
      //             data['Mode'] == '' ? '-${data['Amount']}' : data['Amount'],
      //         date: data['Date'],
      //         mode: data['Mode'],
      //       ),
      //     );
      //   }

      //   advanceDetailsData = advanceDetails;
      //   notifyListeners();
      // }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        // EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'),
          ),
        );
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.withOpacity(0.5),
        message: e.toString(),
        title: 'Failed',
      ));
      rethrow;
    }
  }
}
