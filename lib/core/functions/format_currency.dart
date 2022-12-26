import 'package:intl/intl.dart';

String formatCurrency(double money) {
  var formatCurrency = NumberFormat("#,##0.00", "en_US");
  final String format = 'S/. ${formatCurrency.format(money)}';
  return format;
}
