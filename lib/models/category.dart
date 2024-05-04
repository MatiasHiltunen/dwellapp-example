class DwellCategory {
  String id;
  String name;
  String? sender;
  String fullDescription;
  String shortDescription;
  final DateTime? created;
  int messages;
  bool disabled;

  DwellCategory({
    required this.id,
    required this.name,
    this.sender,
    this.fullDescription = "",
    this.shortDescription = "",
    this.created,
    this.messages = 0,
    this.disabled = false,
  });
}
