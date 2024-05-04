class Apartment {
  final String id;
  final String name;

  Apartment.fromJson(json)
      : this.id = json['_id'],
        this.name = json['name'];
}
