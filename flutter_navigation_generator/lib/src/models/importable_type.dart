class ImportableType {
  final String? import;
  final String? name;
  final String className;
  final bool isRequired;
  final bool isEnum;
  final bool isNullable;
  final List<ImportableType> typeArguments;

  String get argumentName => name ?? className;

  bool get isCustomClass {
    if (isEnum) return false;
    return ![
      'int',
      'double',
      'bool',
      'num',
      'String',
      'dynamic',
      'List',
      'Map',
    ].contains(className);
  }

  const ImportableType({
    required this.className,
    this.name,
    this.import,
    this.isRequired = false,
    this.isNullable = false,
    this.isEnum = false,
    this.typeArguments = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'import': import,
      'className': className,
      'name': name,
      'isRequired': isRequired,
      'isNullable': isNullable,
      'isEnum': isEnum,
      'typeArguments': typeArguments.map((x) => x.toMap()).toList(),
    };
  }

  factory ImportableType.fromMap(Map<String, dynamic> map) {
    return ImportableType(
      import: map['import'] as String?,
      className: map['className'] as String? ?? '',
      name: map['name'] as String?,
      isRequired: map['isRequired'] == true,
      isNullable: map['isNullable'] == true,
      isEnum: map['isEnum'] == true,
      typeArguments: List<ImportableType>.from(
        map['typeArguments']?.map(
              (dynamic x) => ImportableType.fromMap(x as Map<String, dynamic>),
            )
            as Iterable,
      ),
    );
  }
}
