// ignore_for_file: omit_local_variable_types, unnecessary_this, unnecessary_new, prefer_collection_literals

class CardResponse {
  final String brand;
  final String card_holder_name;
  final String country;
  final int exp_month;
  final int exp_year;
  final String funding;
  final String id;
  final String last4;

  CardResponse({
    required this.brand,
    required this.card_holder_name,
    required this.country,
    required this.exp_month,
    required this.exp_year,
    required this.funding,
    required this.id,
    required this.last4,
  });

  factory CardResponse.fromJson(Map<String, dynamic> json) {
    return CardResponse(
      brand: json['brand'],
      card_holder_name: json['card_holder_name'],
      country: json['country'],
      exp_month: json['exp_month'],
      exp_year: json['exp_year'],
      funding: json['funding'],
      id: json['id'],
      last4: json['last4'],
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> data = new Map<String, Object?>();
    data['brand'] = this.brand;
    data['card_holder_name'] = this.card_holder_name;
    data['country'] = this.country;
    data['exp_month'] = this.exp_month;
    data['exp_year'] = this.exp_year;
    data['funding'] = this.funding;
    data['id'] = this.id;
    data['last4'] = this.last4;
    return data;
  }
}
