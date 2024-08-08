String parseDate(DateTime time) {
  var year = time.year;
  var month = time.month.toString();
  var date = time.day.toString();

  if (int.parse(month) < 10) {
    month = "0$month";
  }

  if (int.parse(date) < 10) {
    date = "0$date";
  }

  return "$year-$date-$month";
}
