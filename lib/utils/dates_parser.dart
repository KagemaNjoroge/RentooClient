String parseDate(DateTime time) {
  var year = time.year;
  var month = time.month;
  var date = time.day;

  return "$year-$month-$date";
}
