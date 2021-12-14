String capitalize(String str) {
  if (str.isEmpty){
    return '';
  }
  if (str.isEmpty) {
    return str;
  }
  return str[0].toUpperCase() + str.toLowerCase().substring(1);
}