import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';
import '../styles.dart';

class ModularWidgets {
  static Row selectFromDateAndToDate(var startDatePicker, var endDatePicker,
      Size size, var fromDate, var toDate, var save) {
    return Row(
      children: [
        InkWell(
          onTap: startDatePicker,
          child: Container(
            width: size.width * 0.20,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'From Date:',
                    style: ProjectStyles.headingStyle()
                        .copyWith(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    fromDate ?? '',
                    style: ProjectStyles.headingStyle()
                        .copyWith(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  IconButton(
                      onPressed: startDatePicker,
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: ProjectColors.themeColor,
                      )),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            InkWell(
              onTap: endDatePicker,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                width: size.width * 0.18,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'To Date:',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black, fontSize: 18),
                      ),
                      Text(
                        toDate ?? '',
                        style: ProjectStyles.headingStyle()
                            .copyWith(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      IconButton(
                          onPressed: endDatePicker,
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: ProjectColors.themeColor,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 45,
        ),
        Row(
          children: [
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: save,
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  )),
            )
          ],
        ),
      ],
    );
  }

  static Padding globalAddDetailsDialog(Size size, var save) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: SizedBox(
              width: size.width * 0.1,
              height: 48,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(44, 96, 154, 1),
                    ),
                  ),
                  onPressed: save,
                  child: Text(
                    'Save Details',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color.fromRGBO(255, 254, 254, 1),
                      ),
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 42,
          ),
          InkWell(
            excludeFromSemantics: true,
            splashColor: ProjectColors.themeColor,
            enableFeedback: true,
            onTap: () => Get.back(),
            child: Container(
              width: size.width * 0.1,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(44, 96, 154, 1),
                ),
              ),
              child: Text(
                'Cancel',
                style: ProjectStyles.cancelStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Padding globalUpdateDetailsDialog(Size size, var save) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: SizedBox(
              width: size.width * 0.1,
              height: 48,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(44, 96, 154, 1),
                    ),
                  ),
                  onPressed: save,
                  child: Text(
                    'Update Details',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color.fromRGBO(255, 254, 254, 1),
                      ),
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 42,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: size.width * 0.1,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(44, 96, 154, 1),
                ),
              ),
              child: Text(
                'Cancel',
                style: ProjectStyles.cancelStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
