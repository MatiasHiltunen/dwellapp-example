# Kuluma

Artikkeli projektista:

https://pohjoisentekijat.fi/2023/03/15/kestavampaa-asumista-yhteisollisyyden-ja-teknologian-keinoin-dwell-alykas-taloyhteiso/

## Flutter

Asenna flutter ohjeiden mukaan: https://flutter.dev/docs/get-started/install
- Varmista että kaikki toimii ajamalla komento:
> flutter doctor
- Jos puutteita löytyy, seuraa flutter doctorin ohjeita.

## Android

Visual Studio code:
- Varmista että Android Studio on asennettuna tietokoneelle.
- Asenna lisäosat Flutter ja Flutter intl (generoi kieliversiot .arb tiedostoista) VSCode:n kaupasta.
- Käynnistä emulaattori tai yhdistä puhelin ADB:llä, voit myös käyttää selainta devauksessa näin halutessasi.
- Listaa laitteet joilla voit suorittaa sovelluksen: 
> flutter devices
- Käynnistä sovellus kehitystilassa:
> flutter run
- (VAIN PUHELIN, ei emulaattori) Käynnistä sovellus profilointitilassa (lähes release-buildin nopeus):
> flutter run --profile

Jos teet muutoksia modeleihin jotka käyttävät Hive tietokannan koodigenerointia, aja aina komento:
> flutter pub run build_runner build

Generoi splashscreen tiedostot uudelleen (konfiguraatio pubspec.yaml:ssa):
> flutter pub run flutter_native_splash:create

Generoi launcher ikonit:
> flutter pub run flutter_launcher_icons:main