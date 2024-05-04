import 'package:flutter/material.dart';

import '../../../config.dart';

class DwellAboutListView extends StatefulWidget {
  const DwellAboutListView({
    Key? key,
  }) : super(key: key);

  @override
  _DwellAboutListViewState createState() => _DwellAboutListViewState();
}

class _DwellAboutListViewState extends State<DwellAboutListView> {
  List<int> indexesOpen = <int>[];

  void change(int index) {
    if (indexesOpen.contains(index))
      indexesOpen.remove(index);
    else
      indexesOpen.add(index);
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
            color: DwellColors.background,
            border: Border(
                bottom: BorderSide(color: DwellColors.countIndicatorColor))),
        child: ExpansionTile(
            trailing: Icon(
              indexesOpen.contains(index)
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: DwellColors.textWhite,
            ),
            maintainState: true,
            onExpansionChanged: (value) => change(index),
            backgroundColor: DwellColors.backgroundDark,
            title: Text(
              DwellInfoScreenData.info[index].title,
              style: TextStyle(
                  color: DwellColors.textWhite, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  DwellInfoScreenData.info[index].text,
                  style: TextStyle(color: DwellColors.textWhite),
                ),
              )
            ]),
      ),
      itemCount: DwellInfoScreenData.info.length,
      cacheExtent: 2000,
    );
  }
}

abstract class DwellInfoScreenData {
  static final List<DwellInfo> info = [
    DwellInfo('Yleistä', '''
Kuluman tarkoituksena on tukea kestävämpää ja yhteisöllisempää opiskelija-arkea. Toiveena on, että sovelluksen avulla asukkaat pystyisivät myös vaikuttamaan enemmän talon asioihin, löytämään tietoa ja muita saman henkisiä ihmisiä, sekä luomaan keskenään uudenlaista yhteisöllisyyttä.

Kulumassa on mahdollista seurata omaa asuntokohtaista kulutusta, verrata sitä talon keskiarvoon sekä keskustella palstalla muiden talon asukkaiden ja vuokranantajan kanssa. Sovellusta testataan Kelon asukkailla ja DAS harkitsee sovelluksen kehittämistä pilotoinnin tulosten pohjalta.

Sovellusta on tehty Dwell - Älykäs taloyhteisö -hankkeen rahoituksella. Toteuttajana ovat Rovaniemen paikalliset korkeakoulut, NEVE, sekä toimeksiantaja DAS. Suunnittelun inspiraation lähteenä ovat olleet opiskelijoilta tulleet ideat ja tarpeet.

'''),
    DwellInfo('Kulutuksen seuranta', """
Kuinka paljon kulutat vettä ja sähköä? Voit seurata Koti-näkymän mittareista asuntosi viikottaista menekkiä ja verrata sitä talon keskiarvoon. Hahmon olemus heijastaa omaa kulutuskäyttäytymistä. Tarkempia lukuja voi tarkastella Kulutus-näkymästä.
"""),
    DwellInfo('Talon sisäinen keskustelupalsta', """
Voit edistää talon sisäisiä asioita kirjoittamalla muille asukkaille, kehitystiimille ja DAS:ille. Emme salli vihapuhetta, syrjintää tai muuta epäasiallista käyttäytymistä. Voit ilmiantaa muiden viestejä ja poistaa omiasi.

Käytä vikailmoituksissa ja muissa virallisissa asioista niille tarkoitettuja kanavia.

    """),
    DwellInfo("Pelisäännöt/Etiketti", """
Viesti rakentavalla ja kunnioittavalla tavalla. Emme hyväksy hyökkäävää, töykeää tai 
agressiivista käytöstä. Ethän esiinny toisena henkilönä tai loukkaa ketään tämän palstan yksilöitä, yhteisöjä, yrityksiä tai organisaatioita.

Lähetäthän vain sisältöä, joka liittyy asumiseen tai yhteisöllisyyttä tukevaan  toimintaa. Mainokset ja roskaposti eivät kuulu palstalle.  Kaikenlainen vihapuhe, syrjintä, uhkailu tai väärinkäyttö on kiellettyä. 

    """),
    DwellInfo("Kehitystiimi", """
Toteuttava kehitystiimi muodostuu insinööreistä ja muotoilijoista. Sovelluksen kehittäminen tapahtuu rinnakkain pilotoinnin kanssa, joten palautteeseen voidaan reagoida nopeasti. Seuraamme uteliaina keskustelua! Miltä tämä beta-versio sinusta vaikuttaa? Tekninen ja yksityiskohtainen palaute on hyödyllistä, mutta myös korkealentoinen ideointi on tervetullutta. Anna siis palaa!
    """)
  ];
}

class DwellInfo {
  final String title;
  final String text;

  DwellInfo(this.title, this.text);
}
