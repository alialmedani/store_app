import 'package:intl/intl.dart';

class GetDateTime{

  static getDate({required DateTime dateTimeValue}){
   return  DateFormat('dd-MMM-yyyy').format(dateTimeValue);
  }

  static getDateFromString({required String dateTimeValue}){
    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ");
    DateTime dateTime = format.parse(dateTimeValue);
    return  DateFormat('dd-MMM-yyyy').format(dateTime);
  }

}