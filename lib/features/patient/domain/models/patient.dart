import 'dart:convert';

class Patient {
  final String id;
  final String fullName;
  final String documentId; // Cédula o DNI
  final String email;
  final String phone;
  final DateTime birthDate;
  final String bloodType;
  final String allergiesNotes;

  const Patient({
    required this.id,
    required this.fullName,
    required this.documentId,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.bloodType,
    required this.allergiesNotes,
  });

  Patient copyWith({
    String? id,
    String? fullName,
    String? documentId,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? bloodType,
    String? allergiesNotes,
  }) {
    return Patient(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      documentId: documentId ?? this.documentId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      bloodType: bloodType ?? this.bloodType,
      allergiesNotes: allergiesNotes ?? this.allergiesNotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'documentId': documentId,
      'email': email,
      'phone': phone,
      'birthDate': birthDate.toIso8601String(),
      'bloodType': bloodType,
      'allergiesNotes': allergiesNotes,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String? ?? 'p-01',
      fullName: map['fullName'] as String? ?? '',
      documentId: map['documentId'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      birthDate: map['birthDate'] != null
          ? DateTime.tryParse(map['birthDate'] as String) ?? DateTime(1995, 5, 20)
          : DateTime(1995, 5, 20),
      bloodType: map['bloodType'] as String? ?? 'O+',
      allergiesNotes: map['allergiesNotes'] as String? ?? 'Ninguna conocida',
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) =>
      Patient.fromMap(json.decode(source) as Map<String, dynamic>);
}
