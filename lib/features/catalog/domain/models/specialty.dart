class Specialty {
  final String id;
  final String name;
  final String iconKey; // Identificador para mapear a IconData de Flutter
  final String description;
  final int colorValue;

  const Specialty({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.description,
    required this.colorValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconKey': iconKey,
      'description': description,
      'colorValue': colorValue,
    };
  }

  factory Specialty.fromMap(Map<String, dynamic> map) {
    return Specialty(
      id: map['id'] as String,
      name: map['name'] as String,
      iconKey: map['iconKey'] as String,
      description: map['description'] as String,
      colorValue: map['colorValue'] as int,
    );
  }
}
