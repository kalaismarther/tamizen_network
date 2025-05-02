class CityModel {
  final String id;
  final String name;

  CityModel({required this.id, required this.name});

  factory CityModel.fromJson(Map<dynamic, dynamic> json) => CityModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
}
