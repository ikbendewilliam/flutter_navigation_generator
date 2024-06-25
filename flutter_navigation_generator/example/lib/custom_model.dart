class CustomModel {
  final String name;
  final int age;

  CustomModel(this.name, this.age);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }

  factory CustomModel.fromJson(Map<String, dynamic> map) {
    return CustomModel(
      map['name'] ?? '',
      map['age']?.toInt() ?? 0,
    );
  }
}
