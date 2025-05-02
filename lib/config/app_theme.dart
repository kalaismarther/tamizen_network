import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color blue = Color(0xFF2B94FE);
  static const Color darkBlue = Color(0xFF6549FF);
  static const Color sandal = Color(0xFFFDE68A);
  static const Color red = Color(0xFFFF5A5F);
  static const Color pink = Color(0xFFCC2B52);
  static const Color lightPink = Color(0xFFffefef);
  static const Color grey = Color(0xFff9f9f9);
  static const Color darkgrey = Color(0xFF5B5B5B);
  static const Color inputBg = Color(0xFFF8F7F7);
  static ThemeData theme() => ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
            seedColor: blue, primary: blue, secondary: darkBlue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: grey,
          titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          labelMedium: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black),
          bodyLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black),
          bodyMedium: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputBg,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: darkgrey.withOpacity(0.6),
          ),
          prefixStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          errorStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.red.shade700,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        tabBarTheme: const TabBarTheme(
            labelStyle:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            unselectedLabelStyle:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        dividerTheme: DividerThemeData(color: Colors.grey.shade300),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            side: const BorderSide(color: blue),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: blue,
            textStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: blue),
          ),
        ),
      );
}
