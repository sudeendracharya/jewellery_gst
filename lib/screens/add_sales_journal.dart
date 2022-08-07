import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../widgets/modular.dart';
import 'add_billing_screen.dart';

class AddSalesJournal extends StatefulWidget {
  AddSalesJournal({
    Key? key,
    required this.reFresh,
    required this.editData,
    required this.customerType,
    required this.id,
    required this.name,
  }) : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;
  final String customerType;
  final String id;
  final String name;

  static const routeName = '/AddSalesJournal';
  @override
  State<AddSalesJournal> createState() => _AddSalesJournalState();
}

class _AddSalesJournalState extends State<AddSalesJournal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;
  var collectionStatusId;
  var IsClearedSelected;
  List batchPlanDetails = [];
  bool batchPlanValidation = true;
  String batchPlanValidationMessage = '';
  TextEditingController unitController = TextEditingController();
  TextEditingController purchaseCodeController = TextEditingController();
  bool saleCodeValidation = true;
  String saleCodeValidationMessage = '';
  TextEditingController customerNameController = TextEditingController();
  bool customerNameValidation = true;

  String customerNameValidationMessage = '';

  TextEditingController priceController = TextEditingController();

  bool rateValidation = true;

  String rateValidationMessage = '';

  TextEditingController itemController = TextEditingController();

  bool itemValidation = true;

  String itemValidationMessage = '';

  var itemCategoryId;

  bool itemCategoryValidation = true;

  String itemCategoryValidationMessage = '';

  List firmsList = [];
  List productTypes = [
    'Gold_Ornament',
    'Silver_Ornament',
    'Gold_Bullion',
    'Silver_Bullion',
    'Old_Gold_Ornament',
    'Old_Silver_Ornament'
  ];
  List plantList = [];
  var selectedProducType;
  var plantId;

  String firmIdValidationMessage = '';

  bool firmIdValidation = true;

  bool plantIdValidation = true;

  String plantIdValidationMessage = '';

  List itemSubCategory = [];
  var itemSubCategoryId;

  List productList = [];
  var productId;

  String itemSubCategoryValidationMessage = '';

  bool itemSubCategoryValidation = true;

  bool productValidation = true;

  String productValidationMessage = '';

  var unitId;

  List unitDetails = [];

  var cwUnitId = 'Kgs';

  var customerId;

  FocusNode customerNameFocus = FocusNode();

  bool customerFieldSelected = false;

  var selectedCustomerType;

  TextEditingController itemNameController = TextEditingController();

  TextEditingController grossWeightController = TextEditingController();

  TextEditingController meltController = TextEditingController();

  TextEditingController wastageController = TextEditingController();

  TextEditingController percentageController = TextEditingController();

  TextEditingController netWeightController = TextEditingController();

  TextEditingController rateController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  void _onCustomerFocusChange() {
    // if (customerNameFocus.hasFocus == false) {
    //   setState(() {
    //     customerFieldSelected = false;
    //   });
    // }
  }

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  late AnimationController controller;
  late Animation<Offset> offset;

  var itemId;
  var batchId;
  var wareHouseId;
  List wareHouseDetails = [];
  var breedName;
  List plantDetails = [];
  var plantName;
  List birdAgeGroup = [];
  var birdName;

  List breedInfo = [];
  List activityHeaderData = [];
  var ActivityId;
  List medicationHeaderData = [];
  var medicationId;
  List vaccinationHeaderData = [];
  var vaccinationId;
  List breedVersion = [];
  var breedVersionId;
  List itemCategoryDetails = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController shippingDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController cwQuantityController = TextEditingController();
  TextEditingController cwUnitController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> salesJournal = {};

  bool eggGradingCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool quantityValidation = true;
  bool cwQuantityValidation = true;
  bool wareHouseIdValidation = true;
  bool breedIdValidation = true;
  bool cwUnitValidation = true;
  bool unitValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool shippingDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String eggGradingCodeValidationMessage = '';
  String quantityValidationMessage = '';
  String cwQuantityValidationMessage = '';
  String wareHouseIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String cwUnitValidationMessage = '';
  String unitValidationMessage = '';
  String IsClearedValidationMessage = '';
  String vaccinationPlanIdValidationMessage = '';
  String shippingDateValidationMessage = '';

  String requiredDateOfDeliveryValidationMessage = '';

  bool validate() {
    // if (eggGradingCodeController.text == '') {
    //   eggGradingCodeValidationMessage = 'Grading code cannot be empty';
    //   eggGradingCodeValidation = false;
    // } else {
    //   eggGradingCodeValidation = true;
    // }
    // // if (requiredQuantityController.text == '') {
    //   requiredQuantityValidationMessage = 'Required quantity cannot be empty';
    //   requiredQuantityValidation = false;
    // } else {
    //   requiredQuantityValidation = true;
    // }

    if (purchaseCodeController.text == '') {
      saleCodeValidationMessage = 'Sale code cannot be Empty';
      saleCodeValidation = false;
    } else {
      saleCodeValidation = true;
    }
    if (customerNameController.text.length > 18) {
      customerNameValidationMessage =
          'Customer name cannot be Greater then 18 Characters';
      customerNameValidation = false;
    } else if (customerNameController.text == '') {
      customerNameValidationMessage = 'Customer name cannot be Empty';
      customerNameValidation = false;
    } else {
      customerNameValidation = true;
    }
    if (priceController.text.isNum != true) {
      rateValidationMessage = 'Enter a valid price';
      rateValidation = false;
    } else if (priceController.text == '') {
      rateValidationMessage = 'Price cannot be Empty';
      rateValidation = false;
    } else {
      rateValidation = true;
    }
    if (batchId == null) {
      batchPlanValidationMessage = 'Batch Code Cannot be empty';
      batchPlanValidation = false;
    } else {
      batchPlanValidation = true;
    }
    if (itemCategoryId == null) {
      itemCategoryValidationMessage = 'Select item category';
      itemCategoryValidation = false;
    } else {
      itemCategoryValidation = true;
    }
    if (selectedProducType == null) {
      firmIdValidationMessage = 'Select Firm';
      firmIdValidation = false;
    } else {
      firmIdValidation = true;
    }

    if (plantId == null) {
      plantIdValidationMessage = 'Select Plant';
      plantIdValidation = false;
    } else {
      plantIdValidation = true;
    }

    if (itemSubCategoryId == null) {
      itemSubCategoryValidationMessage = 'Select item sub category';
      itemSubCategoryValidation = false;
    } else {
      itemSubCategoryValidation = true;
    }
    if (productId == null) {
      itemValidationMessage = 'item name cannot be Empty';
      itemValidation = false;
    } else {
      itemValidation = true;
    }
    if (quantityController.text.isNum != true) {
      quantityValidationMessage = 'Enter a valid Quantity';
      quantityValidation = false;
    } else if (quantityController.text == '') {
      quantityValidationMessage = 'Quantity cannot be Empty';
      quantityValidation = false;
    } else {
      quantityValidation = true;
    }
    if (cwQuantityController.text == '') {
      cwQuantityValidationMessage = 'CW Quantity cannot be null';
      cwQuantityValidation = false;
    } else {
      cwQuantityValidation = true;
    }
    if (wareHouseId == null) {
      wareHouseIdValidationMessage = 'Select the warehouse';
      wareHouseIdValidation = false;
    } else {
      wareHouseIdValidation = true;
    }

    if (cwUnitId == '') {
      cwUnitValidationMessage = 'CW unit cannot be Empty';
      cwUnitValidation = false;
    } else {
      cwUnitValidation = true;
    }
    if (unitId == null) {
      unitValidationMessage = 'Unit cannot be Empty';
      unitValidation = false;
    } else {
      unitValidation = true;
    }
    // if (IsClearedSelected == null) {
    //   IsClearedValidationMessage = 'Select is cleared';
    //   IsClearedValidation = false;
    // } else {
    //   IsClearedValidation = true;
    // }

    if (shippingDateController.text == '') {
      shippingDateValidationMessage = 'Select Grading date';
      shippingDateValidation = false;
    } else {
      shippingDateValidation = true;
    }

    if (itemValidation == true &&
        itemCategoryValidation == true &&
        batchPlanValidation == true &&
        rateValidation == true &&
        customerNameValidation == true &&
        saleCodeValidation == true &&
        eggGradingCodeValidation == true &&
        quantityValidation == true &&
        cwQuantityValidation == true &&
        wareHouseIdValidation == true &&
        cwUnitValidation == true &&
        itemSubCategoryValidation == true &&
        unitValidation == true &&
        shippingDateValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getFirmList() async {
    // await Provider.of<Apicalls>(context, listen: false)
    //     .tryAutoLogin()
    //     .then((value) async {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   await Provider.of<InfrastructureApis>(context, listen: false)
    //       .getFirmDetails(token)
    //       .then((value1) {});
    // });
  }

  Future<void> getPlantList(var id) async {
    // await Provider.of<Apicalls>(context, listen: false)
    //     .tryAutoLogin()
    //     .then((value) async {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   await Provider.of<InfrastructureApis>(context, listen: false)
    //       .getPlantDetails(token, id)
    //       .then((value1) {
    //     // setState(() {
    //     //   firmSelected = true;
    //     //   selectedFirmName = e['Firm_Name'];
    //     //   selectedFirmId = e['Firm_Id'];
    //     // });
    //   });
    // });
  }

  Future<void> getWarehouseDetails(var id) async {
    // await Provider.of<Apicalls>(context, listen: false)
    //     .tryAutoLogin()
    //     .then((value) async {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<InfrastructureApis>(context, listen: false)
    //       .getWarehouseDetails(id, token)
    //       .then((value1) {});
    // });
  }

  void _datePicker() {
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
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // _startDate = pickedDate.millisecondsSinceEpoch;
      shippingDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      salesJournal['Despatch_Date'] =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

      setState(() {});
    });
  }

  // void _datePicker() {
  //   showDatePicker(
  //     builder: (context, child) {
  //       return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: ProjectColors.themecolor, // header background color
  //               onPrimary: Colors.black, // header text color
  //               onSurface: Colors.green, // body text color
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 primary: Colors.red, // button text color
  //               ),
  //             ),
  //           ),
  //           child: child!);
  //     },
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2021),
  //     lastDate: DateTime(2025),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     // _startDate = pickedDate.millisecondsSinceEpoch;
  //     dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
  //     eggGradingDetails['Required_Date_Of_Delivery'] =
  //         DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

  //     setState(() {});
  //   });
  // }

  Future<String> fetchCredientials() async {
    // bool data =
    //     await Provider.of<Apicalls>(context, listen: false).tryAutoLogin();

    // if (data != false) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;

    //   return token;
    // } else {
    //   return '';
    // }
    return "";
  }

  @override
  void initState() {
    super.initState();
    // customerNameFocus.addListener(_onCustomerFocusChange);
    if (widget.editData.isEmpty) {
      purchaseCodeController.text = 'inrv';
    }

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    //scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    offset = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
        .animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    if (widget.editData.isNotEmpty) {
      shippingDateController.text = widget.editData['Shipped_Date'];
      salesJournal['Shipped_Date'] = widget.editData['Shipped_Date'];
      quantityController.text = widget.editData['Quantity'].toString();
      salesJournal['Quantity'] = widget.editData['Quantity'];
      cwQuantityController.text = widget.editData['CW_Quantity'].toString();
      salesJournal['CW_Quantity'] = widget.editData['CW_Quantity'];
      cwUnitController.text = widget.editData['CW_Unit'];
      salesJournal['CW_Unit'] = widget.editData['CW_Unit'];
      unitController.text = widget.editData['Quantity_Unit'].toString();
      salesJournal['Quantity_Unit'] = widget.editData['Quantity_Unit'];
      itemController.text = widget.editData['Item'];
      salesJournal['Item'] = widget.editData['Item'];
      customerNameController.text = widget.editData['Customer_Name'];
      salesJournal['Customer_Name'] = widget.editData['Customer_Name'];
      purchaseCodeController.text = widget.editData['Sale_Code'];
      salesJournal['Sale_Code'] = widget.editData['Sale_Code'];
      priceController.text = widget.editData['Rate'].toString();
      salesJournal['Rate'] = widget.editData['Rate'];
    }

    selectedCustomerType = widget.customerType;
    customerNameController.text = widget.name;
    customerId = widget.id;

    // Provider.of<Apicalls>(context, listen: false)
    //     .tryAutoLogin()
    //     .then((value) async {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   // var platId = await fetchPlant();

    //   Provider.of<InventoryApi>(context, listen: false).getBatch(token);

    //   Provider.of<ItemApis>(context, listen: false)
    //       .getItemCategory(token)
    //       .then((value1) {});
    //   Provider.of<Apicalls>(context, listen: false)
    //       .getStandardUnitValues(token);
    // });
  }

  @override
  void dispose() {
    customerNameFocus.removeListener(_onCustomerFocusChange);
    customerNameFocus.dispose();
    super.dispose();
  }

  // void getItemSubCategory(var id) {
  //   Provider.of<Apicalls>(context, listen: false)
  //       .tryAutoLogin()
  //       .then((value) async {
  //     var token = Provider.of<Apicalls>(context, listen: false).token;

  //     Provider.of<ItemApis>(context, listen: false)
  //         .getItemSubCategory(token, id)
  //         .then((value1) {});
  //   });
  // }

  // void getProducts(var subCategoryId) {
  //   fetchCredientials().then((token) {
  //     Provider.of<ItemApis>(context, listen: false)
  //         .getproductlist(token, subCategoryId);
  //   });
  // }

  var isValid = true;
  List itemList = [];

  void edit(int index) {
    setState(() {
      itemNameController.text = itemList[index]['Item_Name'];
      grossWeightController.text = itemList[index]['Gross_Weight'];
      meltController.text = itemList[index]['Melt'];
      wastageController.text = itemList[index]['Wastage'];
      percentageController.text = itemList[index]['Percentage'];
      netWeightController.text = itemList[index]['Net_Weight'];
      rateController.text = itemList[index]['Rate'];
      amountController.text = itemList[index]['Amount'];

      itemList.removeAt(index);
    });
  }

  void delete(int index) {
    setState(() {
      itemList.removeAt(index);
    });
  }

  void addItems() {
    // isValid = validate();
    // if (!isValid) {
    //   setState(() {});
    //   return;
    // }
    // double quantityControllerData = double.parse(
    //     quantityController.text.isNum != true ? '0' : quantityController.text);
    // double pricecontrollerData = double.parse(
    //     priceController.text.isNum != true ? '0' : priceController.text);
    // String total =
    //     (quantityControllerData * pricecontrollerData).toStringAsFixed(2);
    itemList.add({
      'Item_Name': itemNameController.text,
      'Gross_Weight': grossWeightController.text,
      'Melt': meltController.text,
      'Wastage': wastageController.text,
      'Percentage': percentageController.text,
      'Net_Weight': netWeightController.text,
      'Rate': rateController.text,
      'Amount': amountController.text,
    });
    setState(() {
      itemNameController.text = '';
      grossWeightController.text = '';
      meltController.text = '';
      wastageController.text = '';
      percentageController.text = '';
      netWeightController.text = '';
      rateController.text = '';
      amountController.text = '';
    });
  }

  void save() {
    if (itemList.isEmpty) {
      Get.defaultDialog(
          titleStyle: const TextStyle(color: Colors.black),
          title: 'Alert',
          middleText: 'Please Add Items to the table..',
          confirm: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Ok')));
      return;
    }
    _formKey.currentState!.save();

    salesJournal['Customer_Type'] = selectedCustomerType;

    if (selectedCustomerType == 'Individual') {
      salesJournal['Customer_Id'] = customerId;
    } else {
      salesJournal['Customer_Id'] = customerId;
    }

    salesJournal['Item_Details'] = itemList;

    // if (widget.editData.isNotEmpty) {
    //   Provider.of<Apicalls>(context, listen: false)
    //       .tryAutoLogin()
    //       .then((value) {
    //     var token = Provider.of<Apicalls>(context, listen: false).token;
    //     Provider.of<JournalApi>(context, listen: false)
    //         .updateCustomerSalesJournalInfo(
    //             salesJournal, widget.editData['Sale_Id'], token)
    //         .then((value) {
    //       if (value == 202 || value == 201) {
    //         widget.reFresh(100);
    //         Get.back();
    //         successSnackbar('Successfully updated sales data');
    //       } else {
    //         failureSnackbar('Unable to update data something went wrong');
    //       }
    //     });
    //   });
    // } else {
    //   if (selectedCustomerType == 'Individual') {
    //     Provider.of<Apicalls>(context, listen: false)
    //         .tryAutoLogin()
    //         .then((value) {
    //       var token = Provider.of<Apicalls>(context, listen: false).token;
    //       Provider.of<JournalApi>(context, listen: false)
    //           .addCustomerSalesJournalInfo(salesJournal, token)
    //           .then((value) {
    //         if (value == 200 || value == 201) {
    //           widget.reFresh(100);
    //           Get.back();
    //           successSnackbar('Successfully added sales data');
    //         } else {
    //           failureSnackbar('Unable to add data something went wrong');
    //         }
    //       });
    //     });
    //   } else {
    //     Provider.of<Apicalls>(context, listen: false)
    //         .tryAutoLogin()
    //         .then((value) {
    //       var token = Provider.of<Apicalls>(context, listen: false).token;
    //       Provider.of<JournalApi>(context, listen: false)
    //           .addCustomerSalesJournalInfo(salesJournal, token)
    //           .then((value) {
    //         if (value == 200 || value == 201) {
    //           widget.reFresh(100);
    //           Get.back();
    //           successSnackbar('Successfully added sales data');
    //         } else {
    //           failureSnackbar('Unable to add data something went wrong');
    //         }
    //       });
    //     });
    //   }
    // }
  }

  Container headerContainer(String name) {
    return Container(
      width: 100,
      child: Text(
        name,
        style: headerStyle(),
      ),
    );
  }

  void searchCustomers(String name) {
    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<JournalApi>(context, listen: false)
    //       .searchCustomerInfo(name, token)
    //       .then((value) {
    //     if (value == 200 || value == 201) {
    //       // widget.reFresh(100);
    //       // Get.back();
    //       // successSnackbar('Successfully added sales data');
    //     } else {
    //       // failureSnackbar('Unable to add data something went wrong');
    //     }
    //   });
    // });
  }

  void searchCompany(String name) {
    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<JournalApi>(context, listen: false)
    //       .searchCompanyInfo(name, token)
    //       .then((value) {
    //     if (value == 200 || value == 201) {
    //       // widget.reFresh(100);
    //       // Get.back();
    //       // successSnackbar('Successfully added sales data');
    //     } else {
    //       // failureSnackbar('Unable to add data something went wrong');
    //     }
    //   });
    // });
  }

  double columnWidth = 40;

  TextStyle headerStyle() {
    return GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double formWidth = size.width * 0.1;
    double formGap = size.width * 0.02;

    // wareHouseDetails = Provider.of<InfrastructureApis>(
    //   context,
    // ).warehouseDetails;

    // batchPlanDetails = Provider.of<InventoryApi>(context).batchDetails;
    // itemCategoryDetails = Provider.of<ItemApis>(context).itemcategory;
    // firmsList = Provider.of<InfrastructureApis>(context).firmDetails;
    // plantList = Provider.of<InfrastructureApis>(context).plantDetails;
    // itemSubCategory = Provider.of<ItemApis>(context).itemSubCategory;
    // productList = Provider.of<ItemApis>(context).productList;
    // unitDetails = Provider.of<Apicalls>(context).standardUnitList;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Purchase Invoice'),
      ),
      body: Container(
        width: size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    customerFieldSelected = false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'Sales Invoice',
                    //       style: GoogleFonts.roboto(
                    //           textStyle: TextStyle(
                    //               color: Theme.of(context).backgroundColor,
                    //               fontWeight: FontWeight.w700,
                    //               fontSize: 36)),
                    //     )
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Add Purchase Journal',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Purchase Code'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Purchase code',
                                        border: InputBorder.none),
                                    controller: purchaseCodeController,
                                    onSaved: (value) {
                                      salesJournal['Purchase_Code'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Product Type'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: selectedProducType,
                                      items: productTypes
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          onTap: () {},
                                          child: Text(e),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedProducType = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   width: formGap,
                          // ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Container(
                          //       width: formWidth,
                          //       padding: const EdgeInsets.only(bottom: 12),
                          //       child: const Text('Customer Type'),
                          //     ),
                          //     Container(
                          //       width: formWidth,
                          //       height: 36,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(8),
                          //         color: Colors.white,
                          //         border: Border.all(color: Colors.black26),
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 12, vertical: 6),
                          //         child: DropdownButtonHideUnderline(
                          //           child: DropdownButton(
                          //             onTap: () {},
                          //             value: selectedCustomerType,
                          //             items: ['Individual', 'Company']
                          //                 .map<DropdownMenuItem<String>>((e) {
                          //               return DropdownMenuItem(
                          //                 enabled: false,
                          //                 value: e,
                          //                 child: Text(e),
                          //               );
                          //             }).toList(),
                          //             hint: const Text('Select'),
                          //             onChanged: (value) {
                          //               setState(() {
                          //                 selectedCustomerType =
                          //                     value as String;
                          //               });
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Customer Name'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
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
                                        customerFieldSelected = true;
                                      });
                                    },
                                    // focusNode: customerNameFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Customer name',
                                      border: InputBorder.none,
                                    ),
                                    controller: customerNameController,
                                    onChanged: (value) {
                                      if (value.length >= 2) {
                                        if (selectedCustomerType != null) {
                                          if (selectedCustomerType ==
                                              'Individual') {
                                            searchCustomers(value);
                                          } else {
                                            searchCompany(value);
                                          }
                                        } else {
                                          // alertSnackBar(
                                          //     'Select the customer type first');
                                        }
                                      }
                                    },
                                    onSaved: (value) {
                                      salesJournal['Customer_Name'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: formWidth,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Dispatch Date'),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: formWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        controller: shippingDateController,
                                        decoration: const InputDecoration(
                                            hintText: 'Choose Dispatch date',
                                            border: InputBorder.none),
                                        enabled: false,
                                        // onSaved: (value) {
                                        //   batchPlanDetails[
                                        //       'Required_Date_Of_Delivery'] = value!;
                                        // },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: _datePicker,
                                      icon: Icon(
                                        Icons.date_range_outlined,
                                        color: ProjectColors.themeColor,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        saleCodeValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : const SizedBox(),
                        // : ModularWidgets.salesValidationDesign(
                        //     size, saleCodeValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        customerNameValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : const SizedBox(),
                        // : ModularWidgets.salesValidationDesign(
                        //     size, customerNameValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        firmIdValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : const SizedBox(),
                        // : ModularWidgets.salesValidationDesign(
                        //     size, firmIdValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        plantIdValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : const SizedBox(),
                        // : ModularWidgets.salesValidationDesign(
                        //     size, plantIdValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        shippingDateValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : const SizedBox(),
                        // : ModularWidgets.salesValidationDesign(
                        //     size, shippingDateValidationMessage),
                      ],
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 24.0),
                    //   child: Column(
                    //     children: [
                    //       customerFieldSelected == true &&
                    //               selectedCustomerType == 'Individual'
                    //           ? Padding(
                    //               padding: const EdgeInsets.only(top: 8.0),
                    //               child: Container(
                    //                   width: formWidth,
                    //                   height: 300,
                    //                   child: Column(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.start,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Consumer<JournalApi>(
                    //                         builder: (context, value, child) {
                    //                           return Expanded(
                    //                             child: ListView.builder(
                    //                               itemCount: value
                    //                                   .customerSearchResult
                    //                                   .length,
                    //                               itemBuilder:
                    //                                   (BuildContext context,
                    //                                       int index) {
                    //                                 return ListTile(
                    //                                     onTap: () {
                    //                                       customerNameController
                    //                                           .text = value
                    //                                                   .customerSearchResult[
                    //                                               index]
                    //                                           ['Customer_Name'];
                    //                                       customerId =
                    //                                           value.customerSearchResult[
                    //                                                   index][
                    //                                               'Customer_Id'];
                    //                                       setState(() {
                    //                                         customerFieldSelected =
                    //                                             false;
                    //                                       });
                    //                                       // setState(() {});
                    //                                     },
                    //                                     title: Text(
                    //                                       value.customerSearchResult[
                    //                                               index]
                    //                                           ['Customer_Name'],
                    //                                     ));
                    //                               },
                    //                             ),
                    //                           );
                    //                         },
                    //                       ),
                    //                       Consumer<JournalApi>(
                    //                         builder: (context, value, child) {
                    //                           return Expanded(
                    //                             child: ListView.builder(
                    //                               itemCount: value
                    //                                   .companySearchResultData
                    //                                   .length,
                    //                               itemBuilder:
                    //                                   (BuildContext context,
                    //                                       int index) {
                    //                                 return ListTile(
                    //                                     onTap: () {
                    //                                       customerNameController
                    //                                               .text =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Name'];
                    //                                       customerId =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Id'];
                    //                                       setState(() {
                    //                                         customerFieldSelected =
                    //                                             false;
                    //                                       });
                    //                                       // setState(() {});
                    //                                     },
                    //                                     title: Text(
                    //                                       value.companySearchResultData[
                    //                                               index]
                    //                                           ['Company_Name'],
                    //                                     ));
                    //                               },
                    //                             ),
                    //                           );
                    //                         },
                    //                       ),
                    //                     ],
                    //                   )),
                    //             )
                    //           : customerFieldSelected == true &&
                    //                   selectedCustomerType == 'Company'
                    //               ? Padding(
                    //                   padding: const EdgeInsets.only(top: 8.0),
                    //                   child: Container(
                    //                       width: formWidth,
                    //                       height: 300,
                    //                       child: Consumer<JournalApi>(
                    //                         builder: (context, value, child) {
                    //                           return Expanded(
                    //                             child: ListView.builder(
                    //                               itemCount: value
                    //                                   .companySearchResultData
                    //                                   .length,
                    //                               itemBuilder:
                    //                                   (BuildContext context,
                    //                                       int index) {
                    //                                 return ListTile(
                    //                                     onTap: () {
                    //                                       customerNameController
                    //                                               .text =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Name'];
                    //                                       customerId =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Id'];
                    //                                       setState(() {
                    //                                         customerFieldSelected =
                    //                                             false;
                    //                                       });
                    //                                       // setState(() {});
                    //                                     },
                    //                                     title: Text(
                    //                                       value.companySearchResultData[
                    //                                               index]
                    //                                           ['Company_Name'],
                    //                                     ));
                    //                               },
                    //                             ),
                    //                           );
                    //                         },
                    //                       )),
                    //                 )
                    //               : const SizedBox(),
                    //     ],
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        width: size.width * 0.95,
                        height: size.height * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      'Item Name',
                                      style: headerStyle(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Gross Wt'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Melt'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Wastage'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  Container(
                                    width: 60,
                                    child: Text(
                                      '%',
                                      style: headerStyle(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Net Wt'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Rate'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  Container(
                                    width: 150,
                                    child: Text(
                                      'Total Amount',
                                      style: headerStyle(),
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: itemList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      key: UniqueKey(),
                                      children: [
                                        Container(
                                          width: 150,
                                          child: Text(
                                            itemList[index]['Item_Name'] ?? '',
                                            style: headerStyle(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(itemList[index]
                                                ['Gross_Weight'] ??
                                            ''),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                          itemList[index]['Melt'] ?? '',
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                          itemList[index]['Wastage'] ?? '',
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        Container(
                                          width: 60,
                                          child: Text(
                                            itemList[index]['Percentage'] ?? '',
                                            style: headerStyle(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                          itemList[index]['Net_Weight'] ?? '',
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                            itemList[index]['Rate'] ?? ''),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                            itemList[index]['Amount'] ?? ''),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton.icon(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        ProjectColors
                                                            .themeColor)),
                                            icon: const Icon(Icons.edit,
                                                color: Colors.white),
                                            onPressed: () {
                                              edit(index);
                                            },
                                            label: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton.icon(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        ProjectColors
                                                            .themeColor)),
                                            icon: const Icon(Icons.delete,
                                                color: Colors.white),
                                            onPressed: () {
                                              delete(index);
                                            },
                                            label: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Item Name'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Item Name',
                                        border: InputBorder.none),
                                    controller: itemNameController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.06,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Gross Weight'),
                              ),
                              Container(
                                width: size.width * 0.06,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Gross Weight',
                                        border: InputBorder.none),
                                    controller: grossWeightController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.06,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Melt'),
                              ),
                              Container(
                                width: size.width * 0.06,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Enter Melt',
                                        border: InputBorder.none),
                                    controller: meltController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.06,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Wastage'),
                              ),
                              Container(
                                width: size.width * 0.06,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Wastage',
                                        border: InputBorder.none),
                                    controller: wastageController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.06,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Percentage'),
                              ),
                              Container(
                                width: size.width * 0.06,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Percentage',
                                        border: InputBorder.none),
                                    controller: percentageController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.06,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Net Weight'),
                              ),
                              Container(
                                width: size.width * 0.06,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Net Weight',
                                        border: InputBorder.none),
                                    controller: netWeightController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.06,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Rate'),
                              ),
                              Container(
                                width: size.width * 0.06,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Rate',
                                        border: InputBorder.none),
                                    controller: rateController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.07,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Total Amount'),
                              ),
                              Container(
                                width: size.width * 0.07,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Amount',
                                        border: InputBorder.none),
                                    controller: amountController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const SizedBox()),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ProjectColors.themeColor),
                                    ),
                                    onPressed: addItems,
                                    child: const Text('Add')),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // wareHouseIdValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, wareHouseIdValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // itemCategoryValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, itemCategoryValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // itemSubCategoryValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, itemSubCategoryValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // itemValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, itemValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // batchPlanValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, batchPlanValidationMessage),
                      ],
                    ),

                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Container(
                    //       width: formWidth,
                    //       padding: const EdgeInsets.only(bottom: 12),
                    //       child: const Text('Product'),
                    //     ),
                    //     Container(
                    //       width: formWidth,
                    //       height: 36,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         color: Colors.white,
                    //         border: Border.all(color: Colors.black26),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 12, vertical: 6),
                    //         child: DropdownButtonHideUnderline(
                    //           child: DropdownButton(
                    //             value: productId,
                    //             items: productList
                    //                 .map<DropdownMenuItem<String>>((e) {
                    //               return DropdownMenuItem(
                    //                 child: Text(e['Product_Name']),
                    //                 value: e['Product_Name'],
                    //                 onTap: () {
                    //                   // firmId = e['Firm_Code'];
                    //                   salesJournal['Product_Id'] =
                    //                       e['Product_Id'];
                    //                   unitId = e['Unit_Of_Measure__Unit_Name'];
                    //                   salesJournal['Quantity_Unit'] =
                    //                       e['Unit_Of_Measure__Unit_Id'];
                    //                   //print(warehouseCategory);
                    //                 },
                    //               );
                    //             }).toList(),
                    //             hint: const Text('Select'),
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 productId = value as String;
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [],
                      ),
                    ),
                    Row(
                      children: [
                        // rateValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, rateValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // quantityValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, quantityValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // unitValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, unitValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // cwQuantityValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, cwQuantityValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        // cwUnitValidation == true
                        //     ? SizedBox(
                        //         width: size.width * 0.1,
                        //       )
                        //     : ModularWidgets.salesValidationDesign(
                        //         size, cwUnitValidationMessage),
                      ],
                    ),

                    // Consumer<JournalApi>(builder: (context, value, child) {
                    //   return ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: value.salesException.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return ModularWidgets.exceptionDesign(
                    //           MediaQuery.of(context).size,
                    //           value.salesException[index]);
                    //     },
                    //   );
                    // }),
                    widget.editData.isEmpty
                        ? ModularWidgets.globalAddDetailsDialog(size, save)
                        : ModularWidgets.globalUpdateDetailsDialog(size, save),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
