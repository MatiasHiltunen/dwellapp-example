import 'package:Kuluma/tools/utils.dart';

class ConsumptionCollection {
  final double _energyBuildingOrig;
  final double _energyTenantOrig;
  final double _waterColdBuildingOrig;
  final double _waterColdTenantOrig;
  final double _waterWarmBuildingOrig;
  final double _waterWarmTenantOrig;

  ConsumptionCollection.fromJson(Map<String, dynamic> json)
      : _energyBuildingOrig = json['energy_building'] / 1,
        _energyTenantOrig = json['energy_tenant'] / 1,
        _waterColdBuildingOrig = json['water_cold_building'] / 1,
        _waterColdTenantOrig = json['water_cold_tenant'] / 1,
        _waterWarmBuildingOrig = json['water_warm_building'] / 1,
        _waterWarmTenantOrig = json['water_warm_tenant'] / 1;

  ConsumptionCollection.createDummy()
      : _energyBuildingOrig = Utils.doubleInRange(60, 360) / 1000,
        _energyTenantOrig = Utils.doubleInRange(60, 360) / 1000,
        _waterColdBuildingOrig = Utils.doubleInRange(0, 120) / 1000,
        _waterColdTenantOrig = Utils.doubleInRange(0, 120) / 1000,
        _waterWarmBuildingOrig = Utils.doubleInRange(0, 120) / 1000,
        _waterWarmTenantOrig = Utils.doubleInRange(00, 120) / 1000;

  double get energyBuilding => _energyBuildingOrig * 1000;
  double get energyTenant => _energyTenantOrig * 1000;
  double get waterColdBuilding => _waterColdBuildingOrig * 1000;
  double get waterColdTenant => _waterColdTenantOrig * 1000;
  double get waterWarmBuilding => _waterWarmBuildingOrig * 1000;
  double get waterWarmTenant => _waterWarmTenantOrig * 1000;

  double get joinedWaterBuilding => waterColdBuilding + waterWarmBuilding;
  double get joinedWaterTenant => waterColdTenant + waterWarmTenant;

  String get petState {
    if (energyBuilding > energyTenant &&
        joinedWaterBuilding > joinedWaterTenant) {
      return 'GOOD';
    } else if (energyBuilding > energyTenant ||
        joinedWaterBuilding > joinedWaterTenant) {
      return 'NEUTRAL';
    } else {
      return 'BAD';
    }
  }
}
