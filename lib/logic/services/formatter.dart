import 'package:intl/intl.dart';

class Formatter{
  static String formatPrice(num price){
    final numberFormat = NumberFormat("₹ #,##,###");
    return numberFormat.format(price);
  }
  static String formatDate(DateTime date){
    DateTime localdate = date.toLocal();
    final dateFormate= DateFormat("dd MMM-y, hh:mm a");
    return dateFormate.format(localdate);
  }

}