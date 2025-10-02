class TextFormatUtil {
  static String formatFieldValue(String value) {
    String formattedValue = "HATA";
    List<String> parts = value.split(' ');

    if (parts.length == 1) {
      formattedValue = value; // Tek kelimelik değerler olduğu gibi kalır
    } else if (parts.length % 2 == 0) {
      formattedValue =
          '${parts.sublist(0, (parts.length / 2).ceil()).join(' ')}\n${parts.sublist((parts.length / 2).ceil()).join(' ')}';
    } else if (parts.length % 2 == 1) {
      formattedValue =
          '${parts.sublist(0, (parts.length / 2).floor() + 1).join(' ')}\n${parts.sublist((parts.length / 2).floor() + 1).join(' ')}';
    }

    return formattedValue;
  }
}
