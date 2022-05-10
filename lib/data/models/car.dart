class Car  {
  final String id;
  String name;
  int kwh;

  Car({
    required this.id,
    required this.kwh,
    required this.name,
  });


  Car.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        kwh = json['kwh'];

  String get cars => this.name;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'kwh': kwh,
  };

}