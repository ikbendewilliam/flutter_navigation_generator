class CustomModel {
  final String name;
  final int age;

  const CustomModel(this.name, this.age);

  static const testDefault = CustomModel('test default inside class', 123);

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
