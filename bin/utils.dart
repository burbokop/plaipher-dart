
List<String> groupedString(String str, int splitSize) {
  var result = List<String>.empty(growable: true);
  for(var i = 0; i < str.length; ++i) {
    if (i % splitSize == 0 && i + splitSize <= str.length) {
      result.add(str.substring(i, i + splitSize));
    }
  }
  return result;
}