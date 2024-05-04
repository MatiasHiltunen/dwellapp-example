import 'package:flutter/cupertino.dart';

class OnboardingItem {
  final String title;
  final String text;
  final String asset;
  final Image img;
  bool bg;

  OnboardingItem(this.title, this.text, this.asset, this.img,
      {this.bg = false});
}

abstract class OnboardingItems {
  static final List<OnboardingItem> items = [
    OnboardingItem(
        "Tervetuloa Kuluma Betaan!",
        "Miten muodostetaan kestävämpää arkea? Voidaanko jotain tehdä yhdessä? Tässä Beta-versiossa asukkaat voivat seurata omaa kulutusta ja käyttää keskustelukanavaa niin talon sisäisiin asioihin kuin sovelluksen kehitykseen liittyen. Tervetuloa vaikuttamaan!",
        "assets/images/onboarding1.png",
        Image.asset(
          "assets/images/onboarding1.png",
          scale: 2,
        )),
    OnboardingItem(
        "Kulutus",
        "Kuinka paljon kulutat vettä ja sähköä? Voit seurata Koti-näkymän mittareista asuntosi viikottaista menekkiä ja verrata sitä talon keskiarvoon. Hahmon olemus heijastaa omaa kulutuskäyttäytymistä. Tarkempia lukuja voi tarkastella Kulutus-näkymästä.",
        "assets/images/onboarding2.png",
        Image.asset(
          "assets/images/onboarding2.png",
          scale: 2,
        )),
    OnboardingItem(
        "Palsta",
        """Palstalla voit edistää talon sisäisiä asioita kirjoittamalla muille asukkaille, kehitystiimille ja DAS:ille. 

Käytä vikailmoituksissa ja virallisissa asioista niille tarkoitettuja kanavia. 
""",
        "assets/images/onboarding3.png",
        Image.asset(
          "assets/images/onboarding3.png",
          scale: 2,
        )),
    OnboardingItem(
        "Ideoita?",
        """Sovellusta kehitetään palautteen pohjalta. Mikä siinä mättää? Kerro meille kehittäjille mielipiteesi. Tekninen ja yksityiskohtainen palaute on hyödyllistä, mutta myös korkealentoinen ideointi on tervetullutta. Anna siis palaa!""",
        "assets/images/onboarding2.png",
        Image.asset(
          "assets/images/onboarding2.png",
          scale: 2,
        ),
        bg: true)
  ];
}
