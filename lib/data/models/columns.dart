class JsonColumnModel {
  String? address;
  int? finalSoC;
  String? price;
  String? lon;
  String? id;
  String? lat;
  String? chargingState;

  JsonColumnModel(
      {this.address,
      this.finalSoC,
      this.price,
      this.lon,
      this.id,
      this.lat,
      this.chargingState});

  JsonColumnModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    finalSoC = json['finalSoC'];
    price = json['price'];
    lon = json['lon'];
    id = json['id'];
    lat = json['lat'];
    chargingState = json['chargingState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['finalSoC'] = finalSoC;
    data['price'] = price;
    data['lon'] = lon;
    data['id'] = id;
    data['lat'] = lat;
    data['chargingState'] = chargingState;
    return data;
  }
}
