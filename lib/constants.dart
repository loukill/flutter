import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Colors
const kBackgroundColor = Color.fromRGBO(241, 242, 240, 1);
const kTextFieldFill = Color(0xff1E1C24);
// TextStyles
const kHeadline = TextStyle(
  color: Color.fromRGBO(111, 53, 165, 1),
  fontSize: 34,
  fontWeight: FontWeight.bold,
);

const kBodyText = TextStyle(
  color: Color.fromRGBO(111, 53, 165, 1),
  fontSize: 15,
);

const kButtonText = TextStyle(
 color: Color.fromRGBO(111, 53, 165, 1),
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const kBodyText2 =
    TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Color.fromRGBO(111, 53, 165, 1));

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(111, 53, 165, 1)
    );

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: const Color.fromARGB(255, 52, 33, 33), height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: Color.fromRGBO(111, 53, 165, 1),
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Color.fromRGBO(111, 53, 165, 1));
const kPrimaryColor = Color.fromRGBO(111, 53, 165, 1);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;
