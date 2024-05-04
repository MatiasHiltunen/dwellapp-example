abstract class InputValidations {
  static bool validateStructure(String? value) {
    if (value == null) return false;

    String pattern = r'^(?=.*?[A-Z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static String testPwd(text1, text2) {
    if (text1 == null || text2 == null || text1.length < 6)
      return 'Salasanan tulee olla vähintään 6 merkkiä pitkä ja sen tulee sisältää vähintään yksi iso kirjain sekä numero';

    if (text1 != text2) return 'Salasanat eivät täsmää';
    if (text1 == text2 && validateStructure(text1))
      return 'Salasana täyttää vähimmäisvaatimukset, vahva salasana on tyypillisesti noin 10 merkkiä pitkä ja sisältää sekä isoja kirjaimia että erikoismerkkejä.';

    return 'Salasanan tulee olla vähintään 6 merkkiä pitkä ja sen tulee sisältää vähintään yksi iso kirjain sekä numero';
  }
}
