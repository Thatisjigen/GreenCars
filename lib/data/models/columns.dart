class JsonColumnModel {
  String? address;
  int? finalSoC;
  String? price;
  String? lon;
  String? id;
  String? lat;

  JsonColumnModel(
      {this.address, this.finalSoC, this.price, this.lon, this.id, this.lat});

  JsonColumnModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    finalSoC = json['finalSoC'];
    price = json['price'];
    lon = json['lon'];
    id = json['id'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['finalSoC'] = finalSoC;
    data['price'] = price;
    data['lon'] = lon;
    data['id'] = id;
    data['lat'] = lat;
    return data;
  }
}
