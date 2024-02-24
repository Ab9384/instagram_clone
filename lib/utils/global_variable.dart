import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TabController? tabController;
DateFormat dateFormat = DateFormat("dd MMM yyyy");
DateFormat timeFormat = DateFormat("hh:mm a");
DateFormat dateTimeFormat = DateFormat("dd MMM yyyy, hh:mm a");

// indian number format 1,00,000
NumberFormat numberFormat = NumberFormat.currency(
  locale: 'en_IN',
  decimalDigits: 0,
  symbol: '',
);

// compact indian number format 1L, 1Cr
NumberFormat compactNumberFormat = NumberFormat.compactCurrency(
  locale: 'en_IN',
  decimalDigits: 0,
  symbol: '',
);

String femaleAvatar =
    'https://khabarwani.com/wp-content/uploads/2022/10/Avneet-Kaur-cute.jpg';

String maleAvatar =
    'https://lh3.googleusercontent.com/a/ACg8ocKNS4Kv4p4oLY4fYtoo8uhoyt9CTDpCBbo7p8ly4cy2XjPr=s360-c-no';

List<String> northIndianNames = [
  // Male names
  'Aarav',
  'Vivaan',
  'Arjun',
  'Vihaan',
  'Aryan',
  'Advik',
  'Reyansh',
  'Shaurya',
  'Kabir',
  'Aadi',
  'Rudra',
  'Dhruv',
  'Ishaan',
  'Atharva',
  'Ayaan',
  'Pranav',
  'Aarush',
  'Vedant',
  'Veer',
  'Yuvaan',
  'Ansh',
  'Parth',
  'Shivansh',
  'Rohan',
  'Ranveer',

  // Female names
  'Aaradhya',
  'Ananya',
  'Avni',
  'Ishita',
  'Myra',
  'Siya',
  'Aarohi',
  'Anika',
  'Pari',
  'Kavya',
  'Navya',
  'Saanvi',
  'Kyra',
  'Avishi',
  'Amaira',
  'Tara',
  'Diya',
  'Riya',
  'Sara',
  'Anvi',
  'Aarna',
  'Ira',
  'Prisha',
  'Radha',
];

bool isMale(String name) {
  return northIndianNames.indexOf(name) < 25;
}
