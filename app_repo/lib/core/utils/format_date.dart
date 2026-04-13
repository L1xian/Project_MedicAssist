import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime dateTime) {
  return DateFormat("DD, MM, yyyy").format(dateTime);
}
