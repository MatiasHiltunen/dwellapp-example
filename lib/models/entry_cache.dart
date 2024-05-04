import 'entry_avg.dart';

import 'package:hive/hive.dart';

part 'entry_cache.g.dart';

@HiveType(typeId: 2)
class EntryCache {
  @HiveField(0)
  final int hash;
  @HiveField(1)
  final List<Avg> data;
  @HiveField(2)
  final int minX;
  @HiveField(3)
  final int maxX;
  @HiveField(4)
  final double maxY;

  EntryCache({
    required this.hash,
    required this.data,
    required this.minX,
    required this.maxX,
    required this.maxY,
  });
}
