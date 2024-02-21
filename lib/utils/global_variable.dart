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

String femaleAvatar =
    'https://khabarwani.com/wp-content/uploads/2022/10/Avneet-Kaur-cute.jpg';

String maleAvatar =
    'https://khabarwani.com/wp-content/uploads/2022/10/Avneet-Kaur-cute.jpg';
