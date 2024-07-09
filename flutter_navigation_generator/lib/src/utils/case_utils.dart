class CaseUtil {
  final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
  final RegExp _symbolRegex = RegExp(r'[ ./_\-:]');

  late String originalText;
  late List<String> _words;

  CaseUtil(String text,
      {String? alternativeText, List<String> removeSuffixes = const []}) {
    for (final removeSuffix in removeSuffixes) {
      if (text.toLowerCase().endsWith(removeSuffix.toLowerCase())) {
        text = text.substring(0, text.length - removeSuffix.length);
      }
      if (alternativeText != null &&
          alternativeText.toLowerCase().endsWith(removeSuffix.toLowerCase())) {
        alternativeText = alternativeText.substring(
            0, alternativeText.length - removeSuffix.length);
      }
    }
    originalText = text;
    _words = _groupIntoWords(text);
    if (_words.isEmpty) {
      originalText = alternativeText ?? '';
      _words = _groupIntoWords(alternativeText ?? '');
    }
  }

  List<String> _groupIntoWords(String text) {
    final sb = StringBuffer();
    final words = <String>[];
    final isAllCaps = !text.contains(RegExp('[a-z]'));

    for (var i = 0; i < text.length; i++) {
      final char = String.fromCharCode(text.codeUnitAt(i));
      final nextChar = i + 1 == text.length
          ? null
          : String.fromCharCode(text.codeUnitAt(i + 1));

      if (_symbolRegex.hasMatch(char)) {
        continue;
      }

      sb.write(char);

      final isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolRegex.hasMatch(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  String get snakeCase => _getSnakeCase();

  String get kebabCase => _getSnakeCase(separator: '-');

  String get camelCase => _getCamelCase();

  String get textWithoutSuffix => _getTextWithoutSuffix();

  String get upperCamelCase => _uppserCamelCase();

  String _getSnakeCase({String separator = '_'}) =>
      _words.map((word) => word.toLowerCase()).toList().join(separator);

  String _getCamelCase({String separator = ''}) {
    final words = _words.map(_upperCaseFirstLetter).toList();
    if (words.isNotEmpty) words[0] = words[0].toLowerCase();
    return words.join(separator);
  }

  String _uppserCamelCase({String separator = ''}) {
    final words = _words.map(_upperCaseFirstLetter).toList();
    return words.join(separator);
  }

  String _getTextWithoutSuffix() {
    final delimiters = [' ', '-', '_', '.', '/', ':'];
    if (delimiters.any(originalText.endsWith)) {
      return originalText.substring(0, originalText.length - 1);
    } else {
      return originalText;
    }
  }

  static String _upperCaseFirstLetter(String word) {
    if (word.isEmpty) return word;
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }
}
