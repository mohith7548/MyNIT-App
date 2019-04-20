import "dart:math";

///A secure string generator.
class SecureString
{
  ///The [Random] generator used for this generator.
  final Random random;

  ///The list of hexadecimal characters to default for [generate].
  static const List<String> hexCharList =
  const ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "a", "b", "c", "d", "e", "f"];

  ///The list of alphanumeric characters to default for [generateNumeric].
  static const List<String> numericCharList =
  const ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

  ///The list of alphanumeric characters to default for [generateAlphaNumeric].
  static const List<String> alphaNumericCharList =
  const ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];

  ///The list of alphabetic characters to default for [generateAlphabetic].
  static const List<String> alphabeticCharList =
  const ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];


  ///Instantiates this class.
  ///[secure] determines whether it uses Random.secure or just Random.
  ///[seed] determines the seed if any for the random number generator (only applicable if [secure] is false).
  SecureString({bool secure: true, int seed: null})
      :   random    = (secure ? new Random.secure() : (seed == null ? new Random() : new Random(seed)));


  ///Generates a random string.
  ///The [length] determines the length of the resulting string.
  ///The [charList] determines the characters from which to construct the string.
  String generate({int length: 1024, List<String> charList: hexCharList})
  {
    List<String> builder = [];

    for (int point = 0; point < length; ++point)
      builder.add(charList[random.nextInt(charList.length - 1)]);

    String builder2 = "";

    for (String character in builder)
      builder2 = "${builder2}${character}";

    return builder2;
  }

  ///Generates a numeric string.
  ///The [length] determines the length of the resulting string.
  String generateNumeric({int length: 1024}) =>
      generate(length: length, charList: numericCharList);

  ///Generates an alphanumeric string.
  ///Pipe this through [toLower] or [toUpper] if you want a string that is solely lowercase or uppercase respectively.
  ///The [length] determines the length of the resulting string.
  String generateAlphaNumeric({int length: 1024}) =>
      generate(length: length, charList: alphaNumericCharList);

  ///Generates an alphabetic string.
  ///Pipe this through [toLower] or [toUpper] if you want a string that is solely lowercase or uppercase respectively.
  ///The [length] determines the length of the resulting string.
  String generateAlphabetic({int length: 1024}) =>
      generate(length: length, charList: alphabeticCharList);
}