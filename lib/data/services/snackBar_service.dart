import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:one_context/one_context.dart';

// import 'package:toasty_snackbar/toasty_snackbar.dart';

@lazySingleton
class SnackBarService {
  void showSnackBar1(String message) {
    // context.sh
    OneContext.instance.showSnackBar(
      builder: (context) => SnackBar(
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 5),
        content: Text(
          message,
          style: GoogleFonts.epilogue(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
