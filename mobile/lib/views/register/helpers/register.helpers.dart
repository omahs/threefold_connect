bool isValidUsername(String value) {
  Pattern pattern = r'^[a-zA-Z0-9]+$';
  RegExp regex = new RegExp(pattern.toString());

  if (!regex.hasMatch(value)) {
    return false;
  }

  return true;
}

bool validateMnemonicWords(String seed, String confirmationWords) {
  List<String> words = confirmationWords.split(" ");
  List<String> seedWords = seed.split(" ");

  if (words.length != 3) return false;

  for (final String word in words) {
    if (!seedWords.contains(word)) {
      return false;
    }
  }

  return true;
}
