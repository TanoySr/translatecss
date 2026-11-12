/// Minimal CSV encode/parse (RFC 4180 style) used for product
/// import/export. Handles quoted fields containing commas, quotes
/// and newlines. No external package needed.
class CsvCodec {
  const CsvCodec._();

  /// Encodes rows of string fields into CSV text (CRLF line ends).
  static String encode(List<List<String>> rows) {
    return rows.map((row) => row.map(_escape).join(',')).join('\r\n');
  }

  static String _escape(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  /// Parses CSV text into rows of fields. A trailing empty line is
  /// ignored. Throws [FormatException] on an unterminated quote.
  static List<List<String>> parse(String text) {
    final rows = <List<String>>[];
    var row = <String>[];
    final field = StringBuffer();
    var inQuotes = false;
    var i = 0;

    void endField() {
      row.add(field.toString());
      field.clear();
    }

    void endRow() {
      endField();
      rows.add(row);
      row = <String>[];
    }

    while (i < text.length) {
      final ch = text[i];
      if (inQuotes) {
        if (ch == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i += 2;
          } else {
            inQuotes = false;
            i++;
          }
        } else {
          field.write(ch);
          i++;
        }
        continue;
      }
      switch (ch) {
        case '"':
          inQuotes = true;
          i++;
        case ',':
          endField();
          i++;
        case '\r':
          i++;
        case '\n':
          endRow();
          i++;
        default:
          field.write(ch);
          i++;
      }
    }
    if (inQuotes) {
      throw const FormatException('Unterminated quoted field in CSV');
    }
    // Flush the final row when the file does not end with a newline.
    if (field.isNotEmpty || row.isNotEmpty) {
      endRow();
    }
    // Drop a fully-empty trailing row.
    if (rows.isNotEmpty && rows.last.every((c) => c.trim().isEmpty)) {
      rows.removeLast();
    }
    return rows;
  }
}
