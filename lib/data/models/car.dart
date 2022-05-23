class Car {
  final String id;
  String name;
  int pMaxAC;
  int pMaxDC;
  int efficiency;
  int kwh;

  Car({
    required this.id,
    required this.name,
    required this.kwh,
    required this.pMaxAC,
    required this.pMaxDC,
    required this.efficiency,
  });

  Car.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        kwh = json['kwh'],
        pMaxAC = json['pMaxAC'],
        pMaxDC = json['pMaxDC'],
        efficiency = json['efficiency'];

  String get cars => name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kwh': kwh,
        'pMaxAC': pMaxAC,
        'pMaxDC': pMaxDC,
        'efficiency': efficiency,
      };
}
