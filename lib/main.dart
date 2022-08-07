import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'providers/api_calls.dart';
import 'providers/authenticate.dart';
import 'screens/add_billing_screen.dart';
import 'screens/add_sales_journal.dart';
import 'screens/balance_sheet_screen.dart';
import 'screens/cash_book_page.dart';
import 'screens/converted_list.dart';
import 'screens/customer_details_page.dart';
import 'screens/customer_individual_invoice_details_page.dart';
import 'screens/customerslist_screen.dart';
import 'screens/daily_report_screen.dart';
import 'screens/expenses_page.dart';
import 'screens/log_in_page.dart';
import 'screens/profile_section.dart';
import 'screens/profit_and_loss_screen.dart';
import 'screens/purchase_details_page.dart';
import 'screens/purchase_list_screen.dart';
import 'screens/purchase_report_screen.dart';
import 'screens/purchases_screen.dart';
import 'screens/report_screen.dart';
import 'screens/sales_report_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/supplier_list_screen.dart';
import 'screens/temprory_purchase_list.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  testWindowFunctions();
  runApp(MyApp());
}

Future testWindowFunctions() async {
  Size size = await DesktopWindow.getWindowSize();
  print(size);
  // await DesktopWindow.setWindowSize(Size(500, 500));

  // await DesktopWindow.setMinWindowSize(Size(400, 400));
  // await DesktopWindow.setMaxWindowSize(Size(800, 800));

  // await DesktopWindow.resetMaxWindowSize();
  await DesktopWindow.toggleFullScreen();
  bool isFullScreen = await DesktopWindow.getFullScreen();
  await DesktopWindow.setFullScreen(true);
  // await DesktopWindow.setFullScreen(false);
}

Future<void> loadAsset() async {
  Directory? _downloadsDirectory = await getDownloadsDirectory();
  String downloadPath = _downloadsDirectory!.path;
  final fileUriWindows = Uri.file(
    'assets/files/start.bat',
    windows: true,
  );
  await launchUrl(
    fileUriWindows,
    mode: LaunchMode.platformDefault,
  ).then((value) {
    print(value);
    print('loading assests');

    rootBundle.loadString('assets/files/start.bat').then((value) {
      print(value);
    });
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      print('closong');
      return await Get.defaultDialog(
          title: 'Alert',
          middleText: 'Are you sure want to exit',
          confirm: TextButton(
              onPressed: () {
                Get.back(result: true);
                // loadAsset().then((value) {});
              },
              child: const Text('Yes')),
          cancel: TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text('Cancel')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authenticate(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ApiCalls(),
        ),
      ],
      child: GetMaterialApp(
        getPages: [
          GetPage(
            name: '/',
            page: () => const MyHomePage(title: 'Prathibha Jewellers'),
          ),
          GetPage(
            name: AddBillingScreen.routeName,
            page: () => AddBillingScreen(editData: const {}),
          ),
          GetPage(
            name: SalesScreen.routeName,
            page: () => SalesScreen(),
          ),
          GetPage(
            name: PurchasesScreen.routeName,
            page: () => PurchasesScreen(tempData: const {}, editData: const {}),
          ),
          GetPage(
            name: ReportScreen.routeName,
            page: () => ReportScreen(),
          ),
          GetPage(
            name: ProfilePage.routeName,
            page: () => ProfilePage(),
          ),
          GetPage(
            name: BalanceSheetScreen.routeName,
            page: () => BalanceSheetScreen(),
          ),
          GetPage(
            name: CustomersListScreen.routeName,
            page: () => CustomersListScreen(),
          ),
          GetPage(
            name: PurchaseListScreen.routeName,
            page: () => PurchaseListScreen(),
          ),
          GetPage(
            name: PurchaseDetailsPage.routeName,
            page: () => PurchaseDetailsPage(),
          ),
          GetPage(
            name: SalesReportScreen.routeName,
            page: () => SalesReportScreen(),
          ),
          GetPage(
            name: PurchaseReportScreen.routeName,
            page: () => PurchaseReportScreen(),
          ),
          GetPage(
            name: DailyReportScreen.routeName,
            page: () => DailyReportScreen(),
          ),
          GetPage(
            name: CustomerDetailsPage.routeName,
            page: () => CustomerDetailsPage(),
          ),
          GetPage(
            name: ConvertedList.routeName,
            page: () => ConvertedList(),
          ),
          GetPage(
            name: SupplierListScreen.routeName,
            page: () => SupplierListScreen(),
          ),
          GetPage(
            name: ProfitAndLossPage.routeName,
            page: () => ProfitAndLossPage(),
          ),
          GetPage(
            name: ExpensesPage.routeName,
            page: () => ExpensesPage(),
          ),
          GetPage(
            name: CustomerIndividualInvoiceDetailsPage.routeName,
            page: () => CustomerIndividualInvoiceDetailsPage(),
          ),
          GetPage(
            name: CashBookPage.routeName,
            page: () => CashBookPage(),
          ),
          GetPage(
            name: TemproryPurchaseList.routeName,
            page: () => TemproryPurchaseList(),
          ),
          GetPage(
            name: AddSalesJournal.routeName,
            page: () => AddSalesJournal(
              customerType: '',
              editData: const {},
              id: '',
              name: '',
              reFresh: (int value) {},
            ),
          ),
        ],
        debugShowCheckedModeBanner: false,
        title: 'jewellery',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromRGBO(71, 0, 216, 1),
            secondary: const Color.fromRGBO(71, 0, 216, 1),
          ),
        ),
        home: LogInPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AddBillingScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: Drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [],
        ),
      ),
    );
  }
}

void successSnackbar(String message) {
  Get.showSnackbar(GetSnackBar(
    title: 'Success',
    message: message,
    duration: const Duration(seconds: 5),
  ));
}

void failureSnackbar(String message) {
  Get.showSnackbar(GetSnackBar(
    title: 'Failed',
    message: message,
    duration: const Duration(seconds: 5),
  ));
}
