class CustomerAdvance {
  final String advanceId;
  final String amount;
  final String date;
  final String mode;

  CustomerAdvance({
    required this.advanceId,
    required this.amount,
    required this.date,
    required this.mode,
  });
}

class CustomerInvoiceTotal {
  final String date;
  final double amount;

  CustomerInvoiceTotal({required this.date, required this.amount});
}

var dtafa = [
  {
    "Customer_Total_Advance_Payment_Id": 2,
    "Advance_Id": "advance-1",
    "Advance_Amount": "20000.000000",
    "Advance_Total_Amount": "20000.000000",
    "Mode": "Advance",
    "Date": "2022-07-30",
    "Created_Date": "2022-07-30",
    "Customer_Id": 2
  },
  {
    "Customer_Total_Advance_Payment_Id": 5,
    "Advance_Id": "advance-2",
    "Advance_Amount": "20000.000000",
    "Advance_Total_Amount": "40000.000000",
    "Mode": "Advance",
    "Date": "2022-08-01",
    "Created_Date": "2022-08-01",
    "Customer_Id": 2
  },
  {
    "Customer_Total_Advance_Payment_Id": 6,
    "Advance_Id": "credit-2",
    "Advance_Amount": "20000.000000",
    "Advance_Total_Amount": "20000.000000",
    "Mode": "",
    "Date": "2022-08-01",
    "Created_Date": "2022-08-01",
    "Customer_Id": 2
  }
];
