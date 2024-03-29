import 'package:flutter/material.dart';

// const kColorBlue = Color(0xff2e83f8);
// const kColorDarkBlue = Color(0xff1b3a5e);
// const kColorPink = Color(0xffff748d);
//yellow
//const kColorBlue = Color(0xff757575);

const kColorBlue = Color(0xff449ad5);
const kColorDarkBlue = Color(0xff757575);
const kColorPink = Color(0xff6f8bd9);

const kInputTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xffbcbcbc),
    fontWeight: FontWeight.w300,
    fontFamily: 'NunitoSans');

// const kColorPrimary = Color(0xff2e83f8);
// const kColorPrimaryDark = Color(0xff1b3a5e);
// const kColorSecondary = Color(0xffff748d);

const kColorPrimary = Color(0xff449ad5);
const kColorPrimaryDark = Color(0xff757575);
const kColorSecondary = Color(0xff50a4de);

const kTextStyleButton = TextStyle(
  color: kColorPrimary,
  fontSize: 18,
  fontWeight: FontWeight.w500,
  fontFamily: 'NunitoSans',
);

const kTextStyleSubtitle1 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  fontFamily: 'NunitoSans',
);

const kTextStyleSubtitle2 = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  fontFamily: 'NunitoSans',
);

const kTextStyleBody2 = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  fontFamily: 'NunitoSans',
);

const kTextStyleHeadline6 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  fontFamily: 'NunitoSans',
);
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.deepOrange,
  primary: Colors.black87,
  minimumSize: Size(88, 50),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);