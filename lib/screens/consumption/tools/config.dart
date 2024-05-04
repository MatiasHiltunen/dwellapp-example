import 'package:Kuluma/generated/l10n.dart';

enum Sensors { waterCold, waterWarm, energy }

extension SensorIds on Sensors {
  String get id {
    switch (this) {
      case Sensors.energy:
        return "5e566e6c982a83f03c0b850e";
      case Sensors.waterCold:
        return "5e5670b8982a83f03c0b8512";
      case Sensors.waterWarm:
        return "5e5670fb982a83f03c0b8513";
      default:
        return '';
    }
  }
}

class ConsumptionConfig {
  static Sensors initiallySelectedSensor = Sensors.waterWarm;

  final List<String> listItems;
  final List<String> weekdays;
  final List<String> unitsWater;
  final List<String> unitsEnergy;
  final List<String> months;
  final List<String> monthsFull;

  ConsumptionConfig(S s)
      : this.listItems = [
          s.consumptionListItemsDay,
          s.consumptionListItemsWeek,
          s.consumptionListItemsMonth,
          s.consumptionListItemsYear,
        ],
        this.weekdays = [
          s.consumptionListItemsMonday,
          s.consumptionListItemsTuesday,
          s.consumptionListItemsWednesday,
          s.consumptionListItemsThursday,
          s.consumptionListItemsFriday,
          s.consumptionListItemsSaturday,
          s.consumptionListItemsSunday,
        ],
        this.unitsWater = [
          s.consumptionWaterLitresPerHour,
          s.consumptionWaterLitresPerDay,
          s.consumptionWaterLitresPerDay,
          s.consumptionWaterLitresPerMonth,
        ],
        this.unitsEnergy = [
          s.consumptionEnergyWatsPerHour,
          s.consumptionEnergyWatsPerDay,
          s.consumptionEnergyWatsPerDay,
          s.consumptionEnergyKiloWatsPerMonth,
        ],
        this.months = [
          s.monthsShortenedJanuary,
          s.monthsShortenedFebruary,
          s.monthsShortenedMarch,
          s.monthsShortenedApril,
          s.monthsShortenedMay,
          s.monthsShortenedJune,
          s.monthsShortenedJuly,
          s.monthsShortenedAugust,
          s.monthsShortenedSeptember,
          s.monthsShortenedOctober,
          s.monthsShortenedNovember,
          s.monthsShortenedDecember,
        ],
        this.monthsFull = [
          s.monthsFullJanuary,
          s.monthsFullFebruary,
          s.monthsFullMarch,
          s.monthsFullApril,
          s.monthsFullMay,
          s.monthsFullJune,
          s.monthsFullJuly,
          s.monthsFullAugust,
          s.monthsFullSeptember,
          s.monthsFullOctober,
          s.monthsFullNovember,
          s.monthsFullDecember,
        ];
}
