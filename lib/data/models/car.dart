class Car {
  final String id;
  String name;
  int pMaxAC;
  int pMaxDC;
  int efficiency;

  Car({
    required this.id,
    required this.name,
    required this.pMaxAC,
    required this.pMaxDC,
    required this.efficiency,
  });

  Car.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        pMaxAC = json['pMaxAC'],
        pMaxDC = json['pMaxDC'],
        efficiency = json['efficiency'];

  String get cars => name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pMaxAC': pMaxAC,
        'pMaxDC': pMaxDC,
        'efficiency': efficiency,
  };
}
