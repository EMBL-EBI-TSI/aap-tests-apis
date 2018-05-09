function() {
  var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
  var sdf = new SimpleDateFormat('yyyyMMdd-HHmmssSSS');
  var date = new java.util.Date();
  return sdf.format(date);
}