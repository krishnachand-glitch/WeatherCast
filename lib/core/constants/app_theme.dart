import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.skyBlue,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.light(
        primary: AppColors.skyBlue,
        secondary: AppColors.purpleAccent,
        surface: AppColors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.black87),
        displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black87),
        displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.black87),
        headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black87),
        headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87),
        headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black87),
        titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
        labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.deepOceanBlue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.deepOceanBlue,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.skyBlue,
        secondary: AppColors.purpleAccent,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.white),
        displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.white),
        displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.white),
        headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.white),
        headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.white),
        headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.white),
        titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.white),
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white),
        titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.white),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.white),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.white),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.white),
        labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.white),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.skyBlue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
